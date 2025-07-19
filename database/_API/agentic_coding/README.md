# Firebase Manager for Flutter Development

A GUI application that simplifies Firebase management for Flutter developers. This tool provides an easy-to-use interface for managing Firebase projects, Firestore collections, authentication, and Flutter integration.

## Features

- **Firebase Configuration**: Easy connection to Firebase projects using service account keys
- **Firestore Management**: Create, read, update, and delete collections and documents
- **Authentication Management**: Create and manage Firebase users
- **Flutter Integration**: Automate Firebase setup in Flutter projects
- **User-Friendly GUI**: Intuitive tabbed interface for all operations

## Installation

1. Install Python dependencies:
```bash
pip install -r requirements.txt
```

2. Run the application:
```bash
python firebase_manager_qt.py
```

## Setup

### Firebase Configuration

1. **Get Service Account Key**:
   - Go to Firebase Console → Project Settings → Service Accounts
   - Click "Generate new private key"
   - Download the JSON file

2. **Connect to Firebase**:
   - Open the "Configuration" tab
   - Browse and select your service account key file
   - Enter your Firebase Project ID
   - Click "Connect to Firebase"

## Usage

### Firestore Management

1. **Create Collections**:
   - Enter collection name
   - Click "Create Collection"

2. **Manage Documents**:
   - Enter collection name and document ID
   - Add JSON data in the text area
   - Use buttons to Add, Get, Update, or Delete documents

### Authentication

1. **Create Users**:
   - Enter email and password
   - Click "Create User"

2. **Manage Users**:
   - List all users
   - Delete users by email

### Flutter Integration

1. **Setup Firebase in Flutter**:
   - Select your Flutter project directory
   - Click "Initialize Firebase in Flutter"
   - Follow the log output for manual steps

2. **Generate Config**:
   - Generate Firebase configuration files
   - Export settings for Flutter integration

## Requirements

- Python 3.7+
- Firebase Admin SDK
- Valid Firebase project with service account access

## Tabs Overview

- **Configuration**: Connect to Firebase project
- **Firestore**: Manage collections and documents
- **Authentication**: Handle user management
- **Flutter Integration**: Automate Flutter Firebase setup