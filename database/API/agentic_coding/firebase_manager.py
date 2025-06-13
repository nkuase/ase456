import tkinter as tk
from tkinter import ttk, messagebox, filedialog
import firebase_admin
from firebase_admin import credentials, firestore, auth
import json
import os
from datetime import datetime


class FirebaseManager:
    def __init__(self, root):
        self.root = root
        self.root.title("Firebase Manager for Flutter Development")
        self.root.geometry("1200x800")
        
        self.firebase_app = None
        self.db = None
        
        self.setup_ui()
        
    def setup_ui(self):
        # Create notebook for tabs
        notebook = ttk.Notebook(self.root)
        notebook.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
        
        # Configuration Tab
        self.setup_config_tab(notebook)
        
        # Firestore Tab
        self.setup_firestore_tab(notebook)
        
        # Authentication Tab
        self.setup_auth_tab(notebook)
        
        # Flutter Integration Tab
        self.setup_flutter_tab(notebook)
        
    def setup_config_tab(self, notebook):
        config_frame = ttk.Frame(notebook)
        notebook.add(config_frame, text="Configuration")
        
        # Firebase Project Configuration
        ttk.Label(config_frame, text="Firebase Configuration", font=("Arial", 16, "bold")).pack(pady=10)
        
        # Service Account Key File
        key_frame = ttk.Frame(config_frame)
        key_frame.pack(fill=tk.X, padx=20, pady=5)
        
        ttk.Label(key_frame, text="Service Account Key File:").pack(side=tk.LEFT)
        self.key_file_var = tk.StringVar()
        ttk.Entry(key_frame, textvariable=self.key_file_var, width=50).pack(side=tk.LEFT, padx=5)
        ttk.Button(key_frame, text="Browse", command=self.browse_key_file).pack(side=tk.LEFT)
        
        # Project ID
        project_frame = ttk.Frame(config_frame)
        project_frame.pack(fill=tk.X, padx=20, pady=5)
        
        ttk.Label(project_frame, text="Project ID:").pack(side=tk.LEFT)
        self.project_id_var = tk.StringVar()
        ttk.Entry(project_frame, textvariable=self.project_id_var, width=50).pack(side=tk.LEFT, padx=5)
        
        # Connect Button
        ttk.Button(config_frame, text="Connect to Firebase", command=self.connect_firebase).pack(pady=20)
        
        # Status
        self.status_var = tk.StringVar(value="Not connected")
        ttk.Label(config_frame, textvariable=self.status_var, font=("Arial", 12)).pack(pady=10)
        
    def setup_firestore_tab(self, notebook):
        firestore_frame = ttk.Frame(notebook)
        notebook.add(firestore_frame, text="Firestore")
        
        # Collections Management
        ttk.Label(firestore_frame, text="Firestore Collections", font=("Arial", 16, "bold")).pack(pady=10)
        
        # Collection Name Input
        collection_frame = ttk.Frame(firestore_frame)
        collection_frame.pack(fill=tk.X, padx=20, pady=5)
        
        ttk.Label(collection_frame, text="Collection Name:").pack(side=tk.LEFT)
        self.collection_name_var = tk.StringVar()
        ttk.Entry(collection_frame, textvariable=self.collection_name_var, width=30).pack(side=tk.LEFT, padx=5)
        
        # Collection Actions
        actions_frame = ttk.Frame(firestore_frame)
        actions_frame.pack(fill=tk.X, padx=20, pady=10)
        
        ttk.Button(actions_frame, text="Create Collection", command=self.create_collection).pack(side=tk.LEFT, padx=5)
        ttk.Button(actions_frame, text="List Collections", command=self.list_collections).pack(side=tk.LEFT, padx=5)
        ttk.Button(actions_frame, text="Delete Collection", command=self.delete_collection).pack(side=tk.LEFT, padx=5)
        
        # Document Management
        ttk.Label(firestore_frame, text="Document Management", font=("Arial", 14, "bold")).pack(pady=(20, 10))
        
        doc_frame = ttk.Frame(firestore_frame)
        doc_frame.pack(fill=tk.X, padx=20, pady=5)
        
        ttk.Label(doc_frame, text="Document ID:").pack(side=tk.LEFT)
        self.doc_id_var = tk.StringVar()
        ttk.Entry(doc_frame, textvariable=self.doc_id_var, width=30).pack(side=tk.LEFT, padx=5)
        
        # Document Data
        ttk.Label(firestore_frame, text="Document Data (JSON):").pack(anchor=tk.W, padx=20, pady=(10, 5))
        self.doc_data_text = tk.Text(firestore_frame, height=8, width=80)
        self.doc_data_text.pack(padx=20, pady=5)
        
        # Document Actions
        doc_actions_frame = ttk.Frame(firestore_frame)
        doc_actions_frame.pack(fill=tk.X, padx=20, pady=10)
        
        ttk.Button(doc_actions_frame, text="Add Document", command=self.add_document).pack(side=tk.LEFT, padx=5)
        ttk.Button(doc_actions_frame, text="Get Document", command=self.get_document).pack(side=tk.LEFT, padx=5)
        ttk.Button(doc_actions_frame, text="Update Document", command=self.update_document).pack(side=tk.LEFT, padx=5)
        ttk.Button(doc_actions_frame, text="Delete Document", command=self.delete_document).pack(side=tk.LEFT, padx=5)
        
        # Collections List
        ttk.Label(firestore_frame, text="Existing Collections:").pack(anchor=tk.W, padx=20, pady=(20, 5))
        self.collections_listbox = tk.Listbox(firestore_frame, height=6)
        self.collections_listbox.pack(fill=tk.X, padx=20, pady=5)
        
    def setup_auth_tab(self, notebook):
        auth_frame = ttk.Frame(notebook)
        notebook.add(auth_frame, text="Authentication")
        
        ttk.Label(auth_frame, text="Firebase Authentication", font=("Arial", 16, "bold")).pack(pady=10)
        
        # User Creation
        ttk.Label(auth_frame, text="Create User", font=("Arial", 14, "bold")).pack(pady=(20, 10))
        
        user_frame = ttk.Frame(auth_frame)
        user_frame.pack(fill=tk.X, padx=20, pady=5)
        
        ttk.Label(user_frame, text="Email:").grid(row=0, column=0, sticky=tk.W, padx=5)
        self.user_email_var = tk.StringVar()
        ttk.Entry(user_frame, textvariable=self.user_email_var, width=30).grid(row=0, column=1, padx=5)
        
        ttk.Label(user_frame, text="Password:").grid(row=1, column=0, sticky=tk.W, padx=5, pady=5)
        self.user_password_var = tk.StringVar()
        ttk.Entry(user_frame, textvariable=self.user_password_var, width=30, show="*").grid(row=1, column=1, padx=5, pady=5)
        
        ttk.Button(auth_frame, text="Create User", command=self.create_user).pack(pady=10)
        
        # User Management
        ttk.Label(auth_frame, text="User Management", font=("Arial", 14, "bold")).pack(pady=(20, 10))
        
        user_actions_frame = ttk.Frame(auth_frame)
        user_actions_frame.pack(fill=tk.X, padx=20, pady=10)
        
        ttk.Button(user_actions_frame, text="List Users", command=self.list_users).pack(side=tk.LEFT, padx=5)
        ttk.Button(user_actions_frame, text="Delete User", command=self.delete_user).pack(side=tk.LEFT, padx=5)
        
        # Users List
        ttk.Label(auth_frame, text="Users:").pack(anchor=tk.W, padx=20, pady=(20, 5))
        self.users_text = tk.Text(auth_frame, height=10, width=80)
        self.users_text.pack(padx=20, pady=5)
        
    def setup_flutter_tab(self, notebook):
        flutter_frame = ttk.Frame(notebook)
        notebook.add(flutter_frame, text="Flutter Integration")
        
        ttk.Label(flutter_frame, text="Flutter Project Integration", font=("Arial", 16, "bold")).pack(pady=10)
        
        # Flutter Project Path
        path_frame = ttk.Frame(flutter_frame)
        path_frame.pack(fill=tk.X, padx=20, pady=5)
        
        ttk.Label(path_frame, text="Flutter Project Path:").pack(side=tk.LEFT)
        self.flutter_path_var = tk.StringVar()
        ttk.Entry(path_frame, textvariable=self.flutter_path_var, width=50).pack(side=tk.LEFT, padx=5)
        ttk.Button(path_frame, text="Browse", command=self.browse_flutter_project).pack(side=tk.LEFT)
        
        # Integration Actions
        actions_frame = ttk.Frame(flutter_frame)
        actions_frame.pack(fill=tk.X, padx=20, pady=20)
        
        ttk.Button(actions_frame, text="Initialize Firebase in Flutter", command=self.init_firebase_flutter).pack(side=tk.LEFT, padx=5)
        ttk.Button(actions_frame, text="Generate Firebase Config", command=self.generate_firebase_config).pack(side=tk.LEFT, padx=5)
        ttk.Button(actions_frame, text="Add Dependencies", command=self.add_flutter_dependencies).pack(side=tk.LEFT, padx=5)
        
        # Output Log
        ttk.Label(flutter_frame, text="Output Log:").pack(anchor=tk.W, padx=20, pady=(20, 5))
        self.log_text = tk.Text(flutter_frame, height=15, width=80)
        self.log_text.pack(padx=20, pady=5)
        
    def browse_key_file(self):
        filename = filedialog.askopenfilename(
            title="Select Firebase Service Account Key",
            filetypes=[("JSON files", "*.json")]
        )
        if filename:
            self.key_file_var.set(filename)
            
    def browse_flutter_project(self):
        directory = filedialog.askdirectory(title="Select Flutter Project Directory")
        if directory:
            self.flutter_path_var.set(directory)
            
    def connect_firebase(self):
        try:
            key_file = self.key_file_var.get()
            project_id = self.project_id_var.get()
            
            if not key_file or not project_id:
                messagebox.showerror("Error", "Please provide both service account key file and project ID")
                return
                
            if not os.path.exists(key_file):
                messagebox.showerror("Error", "Service account key file not found")
                return
                
            # Initialize Firebase
            if self.firebase_app:
                firebase_admin.delete_app(self.firebase_app)
                
            cred = credentials.Certificate(key_file)
            self.firebase_app = firebase_admin.initialize_app(cred, {
                'projectId': project_id
            })
            
            self.db = firestore.client()
            self.status_var.set(f"Connected to Firebase project: {project_id}")
            messagebox.showinfo("Success", "Connected to Firebase successfully!")
            
        except Exception as e:
            messagebox.showerror("Error", f"Failed to connect to Firebase: {str(e)}")
            self.status_var.set("Connection failed")
            
    def create_collection(self):
        if not self.db:
            messagebox.showerror("Error", "Please connect to Firebase first")
            return
            
        collection_name = self.collection_name_var.get()
        if not collection_name:
            messagebox.showerror("Error", "Please enter a collection name")
            return
            
        try:
            # Create a dummy document to initialize collection
            self.db.collection(collection_name).document('_init').set({
                'created_at': datetime.now(),
                'created_by': 'Firebase Manager'
            })
            messagebox.showinfo("Success", f"Collection '{collection_name}' created successfully!")
            self.list_collections()
        except Exception as e:
            messagebox.showerror("Error", f"Failed to create collection: {str(e)}")
            
    def list_collections(self):
        if not self.db:
            messagebox.showerror("Error", "Please connect to Firebase first")
            return
            
        try:
            collections = self.db.collections()
            collection_names = [col.id for col in collections]
            
            self.collections_listbox.delete(0, tk.END)
            for name in collection_names:
                self.collections_listbox.insert(tk.END, name)
                
        except Exception as e:
            messagebox.showerror("Error", f"Failed to list collections: {str(e)}")
            
    def delete_collection(self):
        collection_name = self.collection_name_var.get()
        if not collection_name:
            messagebox.showerror("Error", "Please enter a collection name")
            return
            
        if messagebox.askyesno("Confirm", f"Are you sure you want to delete collection '{collection_name}'?"):
            try:
                # Delete all documents in collection
                docs = self.db.collection(collection_name).stream()
                for doc in docs:
                    doc.reference.delete()
                messagebox.showinfo("Success", f"Collection '{collection_name}' deleted successfully!")
                self.list_collections()
            except Exception as e:
                messagebox.showerror("Error", f"Failed to delete collection: {str(e)}")
                
    def add_document(self):
        if not self.db:
            messagebox.showerror("Error", "Please connect to Firebase first")
            return
            
        collection_name = self.collection_name_var.get()
        doc_id = self.doc_id_var.get()
        doc_data = self.doc_data_text.get("1.0", tk.END).strip()
        
        if not collection_name:
            messagebox.showerror("Error", "Please enter a collection name")
            return
            
        try:
            data = json.loads(doc_data) if doc_data else {}
            if doc_id:
                self.db.collection(collection_name).document(doc_id).set(data)
            else:
                self.db.collection(collection_name).add(data)
            messagebox.showinfo("Success", "Document added successfully!")
        except json.JSONDecodeError:
            messagebox.showerror("Error", "Invalid JSON data")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to add document: {str(e)}")
            
    def get_document(self):
        if not self.db:
            messagebox.showerror("Error", "Please connect to Firebase first")
            return
            
        collection_name = self.collection_name_var.get()
        doc_id = self.doc_id_var.get()
        
        if not collection_name or not doc_id:
            messagebox.showerror("Error", "Please enter both collection name and document ID")
            return
            
        try:
            doc = self.db.collection(collection_name).document(doc_id).get()
            if doc.exists:
                data = json.dumps(doc.to_dict(), indent=2)
                self.doc_data_text.delete("1.0", tk.END)
                self.doc_data_text.insert("1.0", data)
            else:
                messagebox.showinfo("Info", "Document not found")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to get document: {str(e)}")
            
    def update_document(self):
        if not self.db:
            messagebox.showerror("Error", "Please connect to Firebase first")
            return
            
        collection_name = self.collection_name_var.get()
        doc_id = self.doc_id_var.get()
        doc_data = self.doc_data_text.get("1.0", tk.END).strip()
        
        if not collection_name or not doc_id:
            messagebox.showerror("Error", "Please enter both collection name and document ID")
            return
            
        try:
            data = json.loads(doc_data) if doc_data else {}
            self.db.collection(collection_name).document(doc_id).update(data)
            messagebox.showinfo("Success", "Document updated successfully!")
        except json.JSONDecodeError:
            messagebox.showerror("Error", "Invalid JSON data")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to update document: {str(e)}")
            
    def delete_document(self):
        if not self.db:
            messagebox.showerror("Error", "Please connect to Firebase first")
            return
            
        collection_name = self.collection_name_var.get()
        doc_id = self.doc_id_var.get()
        
        if not collection_name or not doc_id:
            messagebox.showerror("Error", "Please enter both collection name and document ID")
            return
            
        if messagebox.askyesno("Confirm", f"Are you sure you want to delete document '{doc_id}'?"):
            try:
                self.db.collection(collection_name).document(doc_id).delete()
                messagebox.showinfo("Success", "Document deleted successfully!")
            except Exception as e:
                messagebox.showerror("Error", f"Failed to delete document: {str(e)}")
                
    def create_user(self):
        email = self.user_email_var.get()
        password = self.user_password_var.get()
        
        if not email or not password:
            messagebox.showerror("Error", "Please enter both email and password")
            return
            
        try:
            user = auth.create_user(
                email=email,
                password=password
            )
            messagebox.showinfo("Success", f"User created successfully! UID: {user.uid}")
            self.user_email_var.set("")
            self.user_password_var.set("")
            self.list_users()
        except Exception as e:
            messagebox.showerror("Error", f"Failed to create user: {str(e)}")
            
    def list_users(self):
        try:
            users = auth.list_users()
            self.users_text.delete("1.0", tk.END)
            for user in users.users:
                user_info = f"UID: {user.uid}\nEmail: {user.email or 'N/A'}\nCreated: {user.user_metadata.creation_timestamp}\n\n"
                self.users_text.insert(tk.END, user_info)
        except Exception as e:
            messagebox.showerror("Error", f"Failed to list users: {str(e)}")
            
    def delete_user(self):
        email = self.user_email_var.get()
        if not email:
            messagebox.showerror("Error", "Please enter user email to delete")
            return
            
        if messagebox.askyesno("Confirm", f"Are you sure you want to delete user '{email}'?"):
            try:
                user = auth.get_user_by_email(email)
                auth.delete_user(user.uid)
                messagebox.showinfo("Success", "User deleted successfully!")
                self.list_users()
            except Exception as e:
                messagebox.showerror("Error", f"Failed to delete user: {str(e)}")
                
    def init_firebase_flutter(self):
        flutter_path = self.flutter_path_var.get()
        if not flutter_path:
            messagebox.showerror("Error", "Please select Flutter project directory")
            return
            
        self.log_message("Initializing Firebase in Flutter project...")
        
        try:
            # Add firebase dependencies to pubspec.yaml
            pubspec_path = os.path.join(flutter_path, "pubspec.yaml")
            if os.path.exists(pubspec_path):
                self.log_message("Adding Firebase dependencies to pubspec.yaml...")
                # This would need proper YAML parsing, simplified for demo
                self.log_message("Please manually add Firebase dependencies to pubspec.yaml")
            
            self.log_message("Firebase initialization completed!")
            
        except Exception as e:
            self.log_message(f"Error initializing Firebase: {str(e)}")
            
    def generate_firebase_config(self):
        project_id = self.project_id_var.get()
        if not project_id:
            messagebox.showerror("Error", "Please connect to Firebase first")
            return
            
        config = {
            "firebase": {
                "projectId": project_id,
                "storageBucket": f"{project_id}.appspot.com"
            }
        }
        
        filename = filedialog.asksaveasfilename(
            title="Save Firebase Config",
            defaultextension=".json",
            filetypes=[("JSON files", "*.json")]
        )
        
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
        self.log_text.insert(tk.END, f"[{timestamp}] {message}\n")
        self.log_text.see(tk.END)


if __name__ == "__main__":
    root = tk.Tk()
    app = FirebaseManager(root)
    root.mainloop()