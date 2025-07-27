## Build Scripts Features

The included build scripts (`build_and_run.sh` for macOS/Linux and `build_and_run.bat` for Windows) provide:

### ✅ **Automated Setup**
- Automatic dependency installation
- Prerequisites checking (Dart SDK)
- Port availability checking
- Colorized output for better visibility

### 🔧 **Development Features**
- Hot reload development server
- Automatic port detection (if 8080 is busy)
- Clean error messages for troubleshooting
- Graceful shutdown handling

### 🏭 **Production Features**
- Optimized production builds
- Build size reporting
- Production server for testing
- Clean build artifacts management

### 📚 **Educational Benefits**
- Clear step-by-step output
- Explains what each step does
- Shows best practices for project automation
- Demonstrates different build workflows

### 🚀 **Quick Commands**
```bash
# Development (most common)
./build_and_run.sh dev

# Production workflow
./build_and_run.sh build
./build_and_run.sh serve

# Maintenance
./build_and_run.sh clean
```

# Student Management System - IndexedDB Tutorial

A simple web-based student management system built with Dart and IndexedDB for teaching database concepts.

## Features

This system demonstrates all basic CRUD (Create, Read, Update, Delete) operations:

- **CREATE**: Add new students with ID, name, age, and major
- **READ**: View all students or search for specific students by ID
- **UPDATE**: Modify existing student information
- **DELETE**: Remove individual students or clear all data

## Project Structure

```
student/
├── lib/
│   ├── student.dart          # Student data model class
│   └── student_crud.dart     # Database operations (CRUD functions)
├── web/
│   ├── index.html           # User interface
│   └── main.dart            # Application entry point and UI event handlers
├── pubspec.yaml             # Dependencies and project configuration
└── build.yaml              # Build configuration
```

## Files Overview

### 1. student.dart
- Defines the `Student` class with properties: id, name, age, major
- Includes methods to convert between Dart objects and Map for database storage
- Simple and clear data model for educational purposes

### 2. student_crud.dart
- Contains all IndexedDB database operations
- Functions for CREATE, READ, UPDATE, DELETE operations
- Includes logging and status updates for educational feedback
- Uses `idb_shim` package for cross-browser IndexedDB support

### 3. main.dart
- Application entry point
- Sets up event listeners for all UI buttons
- Connects HTML interface with Dart backend functions
- Handles form validation and user feedback

### 4. index.html
- Clean, educational-focused user interface
- Separate sections for each CRUD operation
- Real-time output display for learning
- Responsive design with clear visual feedback

## How to Run

### Option 1: Using Build Scripts (Recommended for beginners)

**On macOS/Linux:**
```bash
# Make script executable (first time only)
chmod +x build_and_run.sh

# Start development server with hot reload
./build_and_run.sh dev

# Build for production
./build_and_run.sh build

# Serve production build
./build_and_run.sh serve

# Clean build artifacts
./build_and_run.sh clean

# Show help
./build_and_run.sh help
```

**On Windows:**
```cmd
# Start development server
build_and_run.bat dev

# Build for production
build_and_run.bat build

# Serve production build
build_and_run.bat serve

# Clean build artifacts
build_and_run.bat clean
```

### Option 2: Manual Commands

1. **Install Dependencies**:
   ```bash
   dart pub get
   ```

2. **Development Mode (with hot reload)**:
   ```bash
   dart run build_runner serve
   ```

3. **Production Build**:
   ```bash
   dart pub global activate webdev
   dart pub global run webdev build --release
   ```

4. **Open in Browser**:
   Navigate to `http://localhost:8080` to use the application

## Educational Features

- **Clear Logging**: Every database operation is logged with timestamps
- **Visual Feedback**: Color-coded status messages (success, error, info)
- **Sample Data**: Automatically loads sample students for demonstration
- **Error Handling**: Comprehensive error messages for learning
- **Input Validation**: Teaches proper data validation practices

## Key Learning Concepts

1. **IndexedDB Basics**: How to create databases and object stores
2. **CRUD Operations**: All four fundamental database operations
3. **Async Programming**: Using Future/async-await patterns
4. **Data Modeling**: Converting between different data representations
5. **Error Handling**: Proper exception handling in web applications
6. **UI Integration**: Connecting database operations with user interface

## Sample Usage

1. **Add Students**: Use the CREATE section to add new students
2. **View Data**: Click "Get All Students" to see all records
3. **Search**: Enter a student ID to find specific records
4. **Update**: Modify existing student information
5. **Delete**: Remove students individually or clear all data

## Dependencies

- `web: ^1.1.1` - Modern web package for DOM manipulation
- `idb_shim: ^2.6.7` - IndexedDB support for web browsers
- `build_web_compilers: ^4.2.0` - Dart-to-JavaScript compilation

This project is designed to be as simple and educational as possible, making it perfect for teaching database concepts and web development with Dart.
