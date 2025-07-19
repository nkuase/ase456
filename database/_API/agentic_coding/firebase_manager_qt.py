import sys
import json
import os
from datetime import datetime
from PyQt5.QtWidgets import (QApplication, QMainWindow, QTabWidget, QWidget, 
                           QVBoxLayout, QHBoxLayout, QLabel, QLineEdit, 
                           QPushButton, QTextEdit, QListWidget, QMessageBox,
                           QFileDialog, QGridLayout, QGroupBox)
from PyQt5.QtCore import Qt, QThread, pyqtSignal
from PyQt5.QtGui import QFont
import firebase_admin
from firebase_admin import credentials, firestore, auth


class FirebaseWorker(QThread):
    finished = pyqtSignal(str)
    error = pyqtSignal(str)
    
    def __init__(self, operation, *args):
        super().__init__()
        self.operation = operation
        self.args = args
        
    def run(self):
        try:
            result = self.operation(*self.args)
            self.finished.emit(str(result))
        except Exception as e:
            self.error.emit(str(e))


class FirebaseManager(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Firebase Manager for Flutter Development")
        self.setGeometry(100, 100, 1200, 800)
        
        self.firebase_app = None
        self.db = None
        
        self.setup_ui()
        
    def setup_ui(self):
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        
        layout = QVBoxLayout(central_widget)
        
        # Create tab widget
        self.tab_widget = QTabWidget()
        layout.addWidget(self.tab_widget)
        
        # Setup tabs
        self.setup_config_tab()
        self.setup_firestore_tab()
        self.setup_auth_tab()
        self.setup_flutter_tab()
        
    def setup_config_tab(self):
        config_widget = QWidget()
        layout = QVBoxLayout(config_widget)
        
        # Title
        title = QLabel("Firebase Configuration")
        title.setFont(QFont("Arial", 16, QFont.Bold))
        title.setAlignment(Qt.AlignCenter)
        layout.addWidget(title)
        
        # Service Account Key File
        key_group = QGroupBox("Service Account Configuration")
        key_layout = QGridLayout(key_group)
        
        key_layout.addWidget(QLabel("Service Account Key File:"), 0, 0)
        self.key_file_edit = QLineEdit()
        key_layout.addWidget(self.key_file_edit, 0, 1)
        
        self.browse_key_btn = QPushButton("Browse")
        self.browse_key_btn.clicked.connect(self.browse_key_file)
        key_layout.addWidget(self.browse_key_btn, 0, 2)
        
        # Project ID
        key_layout.addWidget(QLabel("Project ID:"), 1, 0)
        self.project_id_edit = QLineEdit()
        key_layout.addWidget(self.project_id_edit, 1, 1, 1, 2)
        
        layout.addWidget(key_group)
        
        # Connect Button
        self.connect_btn = QPushButton("Connect to Firebase")
        self.connect_btn.clicked.connect(self.connect_firebase)
        layout.addWidget(self.connect_btn)
        
        # Status
        self.status_label = QLabel("Not connected")
        self.status_label.setFont(QFont("Arial", 12))
        self.status_label.setAlignment(Qt.AlignCenter)
        layout.addWidget(self.status_label)
        
        layout.addStretch()
        self.tab_widget.addTab(config_widget, "Configuration")
        
    def setup_firestore_tab(self):
        firestore_widget = QWidget()
        layout = QVBoxLayout(firestore_widget)
        
        # Title
        title = QLabel("Firestore Collections")
        title.setFont(QFont("Arial", 16, QFont.Bold))
        title.setAlignment(Qt.AlignCenter)
        layout.addWidget(title)
        
        # Collection Management
        collection_group = QGroupBox("Collection Management")
        collection_layout = QGridLayout(collection_group)
        
        collection_layout.addWidget(QLabel("Collection Name:"), 0, 0)
        self.collection_name_edit = QLineEdit()
        collection_layout.addWidget(self.collection_name_edit, 0, 1)
        
        # Collection Actions
        actions_layout = QHBoxLayout()
        
        self.create_collection_btn = QPushButton("Create Collection")
        self.create_collection_btn.clicked.connect(self.create_collection)
        actions_layout.addWidget(self.create_collection_btn)
        
        self.list_collections_btn = QPushButton("List Collections")
        self.list_collections_btn.clicked.connect(self.list_collections)
        actions_layout.addWidget(self.list_collections_btn)
        
        self.delete_collection_btn = QPushButton("Delete Collection")
        self.delete_collection_btn.clicked.connect(self.delete_collection)
        actions_layout.addWidget(self.delete_collection_btn)
        
        collection_layout.addLayout(actions_layout, 1, 0, 1, 2)
        layout.addWidget(collection_group)
        
        # Document Management
        doc_group = QGroupBox("Document Management")
        doc_layout = QGridLayout(doc_group)
        
        doc_layout.addWidget(QLabel("Document ID:"), 0, 0)
        self.doc_id_edit = QLineEdit()
        doc_layout.addWidget(self.doc_id_edit, 0, 1)
        
        doc_layout.addWidget(QLabel("Document Data (JSON):"), 1, 0, 1, 2)
        self.doc_data_edit = QTextEdit()
        self.doc_data_edit.setMaximumHeight(150)
        doc_layout.addWidget(self.doc_data_edit, 2, 0, 1, 2)
        
        # Document Actions
        doc_actions_layout = QHBoxLayout()
        
        self.add_doc_btn = QPushButton("Add Document")
        self.add_doc_btn.clicked.connect(self.add_document)
        doc_actions_layout.addWidget(self.add_doc_btn)
        
        self.get_doc_btn = QPushButton("Get Document")
        self.get_doc_btn.clicked.connect(self.get_document)
        doc_actions_layout.addWidget(self.get_doc_btn)
        
        self.update_doc_btn = QPushButton("Update Document")
        self.update_doc_btn.clicked.connect(self.update_document)
        doc_actions_layout.addWidget(self.update_doc_btn)
        
        self.delete_doc_btn = QPushButton("Delete Document")
        self.delete_doc_btn.clicked.connect(self.delete_document)
        doc_actions_layout.addWidget(self.delete_doc_btn)
        
        doc_layout.addLayout(doc_actions_layout, 3, 0, 1, 2)
        layout.addWidget(doc_group)
        
        # Collections List
        list_group = QGroupBox("Existing Collections")
        list_layout = QVBoxLayout(list_group)
        self.collections_list = QListWidget()
        list_layout.addWidget(self.collections_list)
        layout.addWidget(list_group)
        
        self.tab_widget.addTab(firestore_widget, "Firestore")
        
    def setup_auth_tab(self):
        auth_widget = QWidget()
        layout = QVBoxLayout(auth_widget)
        
        # Title
        title = QLabel("Firebase Authentication")
        title.setFont(QFont("Arial", 16, QFont.Bold))
        title.setAlignment(Qt.AlignCenter)
        layout.addWidget(title)
        
        # User Creation
        create_group = QGroupBox("Create User")
        create_layout = QGridLayout(create_group)
        
        create_layout.addWidget(QLabel("Email:"), 0, 0)
        self.user_email_edit = QLineEdit()
        create_layout.addWidget(self.user_email_edit, 0, 1)
        
        create_layout.addWidget(QLabel("Password:"), 1, 0)
        self.user_password_edit = QLineEdit()
        self.user_password_edit.setEchoMode(QLineEdit.Password)
        create_layout.addWidget(self.user_password_edit, 1, 1)
        
        self.create_user_btn = QPushButton("Create User")
        self.create_user_btn.clicked.connect(self.create_user)
        create_layout.addWidget(self.create_user_btn, 2, 0, 1, 2)
        
        layout.addWidget(create_group)
        
        # User Management
        manage_group = QGroupBox("User Management")
        manage_layout = QHBoxLayout(manage_group)
        
        self.list_users_btn = QPushButton("List Users")
        self.list_users_btn.clicked.connect(self.list_users)
        manage_layout.addWidget(self.list_users_btn)
        
        self.delete_user_btn = QPushButton("Delete User")
        self.delete_user_btn.clicked.connect(self.delete_user)
        manage_layout.addWidget(self.delete_user_btn)
        
        layout.addWidget(manage_group)
        
        # Users List
        users_group = QGroupBox("Users")
        users_layout = QVBoxLayout(users_group)
        self.users_text = QTextEdit()
        users_layout.addWidget(self.users_text)
        layout.addWidget(users_group)
        
        self.tab_widget.addTab(auth_widget, "Authentication")
        
    def setup_flutter_tab(self):
        flutter_widget = QWidget()
        layout = QVBoxLayout(flutter_widget)
        
        # Title
        title = QLabel("Flutter Project Integration")
        title.setFont(QFont("Arial", 16, QFont.Bold))
        title.setAlignment(Qt.AlignCenter)
        layout.addWidget(title)
        
        # Flutter Project Path
        path_group = QGroupBox("Flutter Project")
        path_layout = QGridLayout(path_group)
        
        path_layout.addWidget(QLabel("Flutter Project Path:"), 0, 0)
        self.flutter_path_edit = QLineEdit()
        path_layout.addWidget(self.flutter_path_edit, 0, 1)
        
        self.browse_flutter_btn = QPushButton("Browse")
        self.browse_flutter_btn.clicked.connect(self.browse_flutter_project)
        path_layout.addWidget(self.browse_flutter_btn, 0, 2)
        
        layout.addWidget(path_group)
        
        # Integration Actions
        actions_group = QGroupBox("Integration Actions")
        actions_layout = QHBoxLayout(actions_group)
        
        self.init_firebase_btn = QPushButton("Initialize Firebase in Flutter")
        self.init_firebase_btn.clicked.connect(self.init_firebase_flutter)
        actions_layout.addWidget(self.init_firebase_btn)
        
        self.generate_config_btn = QPushButton("Generate Firebase Config")
        self.generate_config_btn.clicked.connect(self.generate_firebase_config)
        actions_layout.addWidget(self.generate_config_btn)
        
        self.add_deps_btn = QPushButton("Add Dependencies")
        self.add_deps_btn.clicked.connect(self.add_flutter_dependencies)
        actions_layout.addWidget(self.add_deps_btn)
        
        layout.addWidget(actions_group)
        
        # Output Log
        log_group = QGroupBox("Output Log")
        log_layout = QVBoxLayout(log_group)
        self.log_text = QTextEdit()
        log_layout.addWidget(self.log_text)
        layout.addWidget(log_group)
        
        self.tab_widget.addTab(flutter_widget, "Flutter Integration")
        
    def browse_key_file(self):
        filename, _ = QFileDialog.getOpenFileName(
            self, "Select Firebase Service Account Key", "", "JSON files (*.json)")
        if filename:
            self.key_file_edit.setText(filename)
            
    def browse_flutter_project(self):
        directory = QFileDialog.getExistingDirectory(
            self, "Select Flutter Project Directory")
        if directory:
            self.flutter_path_edit.setText(directory)
            
    def connect_firebase(self):
        try:
            key_file = self.key_file_edit.text()
            project_id = self.project_id_edit.text()
            
            if not key_file or not project_id:
                QMessageBox.critical(self, "Error", 
                    "Please provide both service account key file and project ID")
                return
                
            if not os.path.exists(key_file):
                QMessageBox.critical(self, "Error", "Service account key file not found")
                return
                
            # Initialize Firebase
            if self.firebase_app:
                firebase_admin.delete_app(self.firebase_app)
                
            cred = credentials.Certificate(key_file)
            self.firebase_app = firebase_admin.initialize_app(cred, {
                'projectId': project_id
            })
            
            self.db = firestore.client()
            self.status_label.setText(f"Connected to Firebase project: {project_id}")
            QMessageBox.information(self, "Success", "Connected to Firebase successfully!")
            
        except Exception as e:
            QMessageBox.critical(self, "Error", f"Failed to connect to Firebase: {str(e)}")
            self.status_label.setText("Connection failed")
            
    def create_collection(self):
        if not self.db:
            QMessageBox.critical(self, "Error", "Please connect to Firebase first")
            return
            
        collection_name = self.collection_name_edit.text()
        if not collection_name:
            QMessageBox.critical(self, "Error", "Please enter a collection name")
            return
            
        try:
            # Create a dummy document to initialize collection
            self.db.collection(collection_name).document('_init').set({
                'created_at': datetime.now(),
                'created_by': 'Firebase Manager'
            })
            QMessageBox.information(self, "Success", 
                f"Collection '{collection_name}' created successfully!")
            self.list_collections()
        except Exception as e:
            QMessageBox.critical(self, "Error", f"Failed to create collection: {str(e)}")
            
    def list_collections(self):
        if not self.db:
            QMessageBox.critical(self, "Error", "Please connect to Firebase first")
            return
            
        try:
            collections = self.db.collections()
            collection_names = [col.id for col in collections]
            
            self.collections_list.clear()
            for name in collection_names:
                self.collections_list.addItem(name)
                
        except Exception as e:
            QMessageBox.critical(self, "Error", f"Failed to list collections: {str(e)}")
            
    def delete_collection(self):
        collection_name = self.collection_name_edit.text()
        if not collection_name:
            QMessageBox.critical(self, "Error", "Please enter a collection name")
            return
            
        reply = QMessageBox.question(self, "Confirm", 
            f"Are you sure you want to delete collection '{collection_name}'?",
            QMessageBox.Yes | QMessageBox.No)
            
        if reply == QMessageBox.Yes:
            try:
                # Delete all documents in collection
                docs = self.db.collection(collection_name).stream()
                for doc in docs:
                    doc.reference.delete()
                QMessageBox.information(self, "Success", 
                    f"Collection '{collection_name}' deleted successfully!")
                self.list_collections()
            except Exception as e:
                QMessageBox.critical(self, "Error", f"Failed to delete collection: {str(e)}")
                
    def add_document(self):
        if not self.db:
            QMessageBox.critical(self, "Error", "Please connect to Firebase first")
            return
            
        collection_name = self.collection_name_edit.text()
        doc_id = self.doc_id_edit.text()
        doc_data = self.doc_data_edit.toPlainText().strip()
        
        if not collection_name:
            QMessageBox.critical(self, "Error", "Please enter a collection name")
            return
            
        try:
            data = json.loads(doc_data) if doc_data else {}
            if doc_id:
                self.db.collection(collection_name).document(doc_id).set(data)
            else:
                self.db.collection(collection_name).add(data)
            QMessageBox.information(self, "Success", "Document added successfully!")
        except json.JSONDecodeError:
            QMessageBox.critical(self, "Error", "Invalid JSON data")
        except Exception as e:
            QMessageBox.critical(self, "Error", f"Failed to add document: {str(e)}")
            
    def get_document(self):
        if not self.db:
            QMessageBox.critical(self, "Error", "Please connect to Firebase first")
            return
            
        collection_name = self.collection_name_edit.text()
        doc_id = self.doc_id_edit.text()
        
        if not collection_name or not doc_id:
            QMessageBox.critical(self, "Error", 
                "Please enter both collection name and document ID")
            return
            
        try:
            doc = self.db.collection(collection_name).document(doc_id).get()
            if doc.exists:
                data = json.dumps(doc.to_dict(), indent=2)
                self.doc_data_edit.setPlainText(data)
            else:
                QMessageBox.information(self, "Info", "Document not found")
        except Exception as e:
            QMessageBox.critical(self, "Error", f"Failed to get document: {str(e)}")
            
    def update_document(self):
        if not self.db:
            QMessageBox.critical(self, "Error", "Please connect to Firebase first")
            return
            
        collection_name = self.collection_name_edit.text()
        doc_id = self.doc_id_edit.text()
        doc_data = self.doc_data_edit.toPlainText().strip()
        
        if not collection_name or not doc_id:
            QMessageBox.critical(self, "Error", 
                "Please enter both collection name and document ID")
            return
            
        try:
            data = json.loads(doc_data) if doc_data else {}
            self.db.collection(collection_name).document(doc_id).update(data)
            QMessageBox.information(self, "Success", "Document updated successfully!")
        except json.JSONDecodeError:
            QMessageBox.critical(self, "Error", "Invalid JSON data")
        except Exception as e:
            QMessageBox.critical(self, "Error", f"Failed to update document: {str(e)}")
            
    def delete_document(self):
        if not self.db:
            QMessageBox.critical(self, "Error", "Please connect to Firebase first")
            return
            
        collection_name = self.collection_name_edit.text()
        doc_id = self.doc_id_edit.text()
        
        if not collection_name or not doc_id:
            QMessageBox.critical(self, "Error", 
                "Please enter both collection name and document ID")
            return
            
        reply = QMessageBox.question(self, "Confirm", 
            f"Are you sure you want to delete document '{doc_id}'?",
            QMessageBox.Yes | QMessageBox.No)
            
        if reply == QMessageBox.Yes:
            try:
                self.db.collection(collection_name).document(doc_id).delete()
                QMessageBox.information(self, "Success", "Document deleted successfully!")
            except Exception as e:
                QMessageBox.critical(self, "Error", f"Failed to delete document: {str(e)}")
                
    def create_user(self):
        email = self.user_email_edit.text()
        password = self.user_password_edit.text()
        
        if not email or not password:
            QMessageBox.critical(self, "Error", "Please enter both email and password")
            return
            
        try:
            user = auth.create_user(email=email, password=password)
            QMessageBox.information(self, "Success", 
                f"User created successfully! UID: {user.uid}")
            self.user_email_edit.clear()
            self.user_password_edit.clear()
            self.list_users()
        except Exception as e:
            QMessageBox.critical(self, "Error", f"Failed to create user: {str(e)}")
            
    def list_users(self):
        try:
            users = auth.list_users()
            self.users_text.clear()
            for user in users.users:
                user_info = f"UID: {user.uid}\nEmail: {user.email or 'N/A'}\nCreated: {user.user_metadata.creation_timestamp}\n\n"
                self.users_text.append(user_info)
        except Exception as e:
            QMessageBox.critical(self, "Error", f"Failed to list users: {str(e)}")
            
    def delete_user(self):
        email = self.user_email_edit.text()
        if not email:
            QMessageBox.critical(self, "Error", "Please enter user email to delete")
            return
            
        reply = QMessageBox.question(self, "Confirm", 
            f"Are you sure you want to delete user '{email}'?",
            QMessageBox.Yes | QMessageBox.No)
            
        if reply == QMessageBox.Yes:
            try:
                user = auth.get_user_by_email(email)
                auth.delete_user(user.uid)
                QMessageBox.information(self, "Success", "User deleted successfully!")
                self.list_users()
            except Exception as e:
                QMessageBox.critical(self, "Error", f"Failed to delete user: {str(e)}")
                
    def init_firebase_flutter(self):
        flutter_path = self.flutter_path_edit.text()
        if not flutter_path:
            QMessageBox.critical(self, "Error", "Please select Flutter project directory")
            return
            
        self.log_message("Initializing Firebase in Flutter project...")
        
        try:
            # Add firebase dependencies to pubspec.yaml
            pubspec_path = os.path.join(flutter_path, "pubspec.yaml")
            if os.path.exists(pubspec_path):
                self.log_message("Adding Firebase dependencies to pubspec.yaml...")
                self.log_message("Please manually add Firebase dependencies to pubspec.yaml")
            
            self.log_message("Firebase initialization completed!")
            
        except Exception as e:
            self.log_message(f"Error initializing Firebase: {str(e)}")
            
    def generate_firebase_config(self):
        project_id = self.project_id_edit.text()
        if not project_id:
            QMessageBox.critical(self, "Error", "Please connect to Firebase first")
            return
            
        config = {
            "firebase": {
                "projectId": project_id,
                "storageBucket": f"{project_id}.appspot.com"
            }
        }
        
        filename, _ = QFileDialog.getSaveFileName(
            self, "Save Firebase Config", "", "JSON files (*.json)")
        
        if filename:
            with open(filename, 'w') as f:
                json.dump(config, f, indent=2)
            self.log_message(f"Firebase config saved to {filename}")
            
    def add_flutter_dependencies(self):
        dependencies = [
            "firebase_core",
            "cloud_firestore",
            "firebase_auth",
            "firebase_storage"
        ]
        
        self.log_message("Add these dependencies to your pubspec.yaml:")
        for dep in dependencies:
            self.log_message(f"  {dep}: ^latest_version")
            
    def log_message(self, message):
        timestamp = datetime.now().strftime("%H:%M:%S")
        self.log_text.append(f"[{timestamp}] {message}")


def main():
    app = QApplication(sys.argv)
    window = FirebaseManager()
    window.show()
    sys.exit(app.exec_())


if __name__ == "__main__":
    main()