# Dart IndexedDB CRUD Example with WebDev

This project demonstrates how to build a web application using Dart with IndexedDB for data persistence. It showcases the **webdev development workflow** and **separation of concerns** by splitting code into multiple files.

## 🎯 Learning Objectives

1. **Understanding WebDev Workflow**: Learn the modern Dart web development process
2. **Code Organization**: See how to split functionality across multiple Dart files
3. **IndexedDB Operations**: Implement Create, Read, Update, Delete operations
4. **Modern Web APIs**: Use the latest `web` package instead of deprecated `dart:html`

## 📁 Project Structure

```
foobar2/
├── lib/
│   └── foo_crud.dart      # Database operations (business logic)
├── web/
│   ├── main.dart          # Entry point and UI event handlers
│   └── index.html         # HTML UI
├── pubspec.yaml           # Dependencies and project configuration
├── build.yaml             # WebDev build configuration
├── analysis_options.yaml  # Code quality and linting rules
└── run.sh                 # Development workflow script
```

## 🔧 Dependencies Explained

- **`web`**: Modern replacement for `dart:html` - provides web APIs
- **`idb_shim`**: IndexedDB wrapper that works across different platforms
- **`build_runner`**: Dart build system for web applications
- **`build_web_compilers`**: Compiles Dart to JavaScript for browsers
- **`lints`**: Provides recommended linting rules for code quality

## 🚀 Development Workflow

### Option 1: Use the Automated Script (Recommended for Beginners)
```bash
chmod +x run.sh
./run.sh
```

### Option 2: Manual Commands (Better for Understanding)
```bash
# 1. Install dependencies
dart pub get

# 2. Activate webdev globally (one-time setup)
dart pub global activate webdev

# 3. Build the project
dart pub global run webdev build

# 4. Serve for development
dart pub global run webdev serve
```

## 🏗️ How WebDev Works

1. **`dart pub get`**: Downloads all dependencies listed in `pubspec.yaml`
2. **`webdev build`**: 
   - Compiles Dart code to JavaScript
   - Optimizes the code for production
   - Generates `main.dart.js` in the `build/web/` directory
3. **`webdev serve`**:
   - Starts a development server
   - Enables hot reload for faster development
   - Serves files at `http://localhost:8080`

## 📚 Key Concepts Demonstrated

### 1. **Modern Dart Web APIs**
```dart
// Old way (deprecated)
import 'dart:html';

// New way (recommended)
import 'package:web/web.dart';
```

### 2. **Code Separation**
- **`main.dart`**: UI logic and event handlers
- **`lib/foo_crud.dart`**: Database operations and business logic  
- **`index.html`**: User interface markup

**Modern Package Import:**
```dart
// In main.dart
import 'package:foobar/foo_crud.dart';  // Package import (preferred)
```

### 3. **IndexedDB Operations**
```dart
// Create
final key = await create({'foo': 'value', 'bar': 123});

// Read
final data = await read(key);

// Update
await update(key, {'foo': 'new value', 'bar': 456});

// Delete
await deleteRecord(key);
```

### 4. **Async Programming**
All database operations return `Future` objects, demonstrating proper async/await usage.

## 🎓 For Students: Understanding the Build Process

1. **Source Code**: You write Dart code in the `web/` directory
2. **Compilation**: WebDev compiles your Dart code to JavaScript
3. **Optimization**: The compiler optimizes the code for web browsers
4. **Serving**: The development server serves your files with live reload

## 🔍 Troubleshooting

### If `webdev serve` fails:
1. Check that all dependencies are installed: `dart pub get`
2. Ensure webdev is activated: `dart pub global activate webdev`
3. Verify your `pubspec.yaml` is correctly formatted
4. Check for syntax errors in your Dart files

### If the build fails:
1. Run `dart analyze` to check for code issues
2. Check that all imports are correct
3. Ensure your `main.dart` has a proper `main()` function

## 🆚 Comparison with Simple Compilation

**FooBar1 (Simple)**:
- Single file approach
- Manual compilation: `dart compile js`
- Basic HTTP server
- Good for learning basics

**FooBar2 (WebDev)**:
- Multi-file project structure
- Automated build process
- Development server with hot reload
- Better for real-world development

## 📖 Next Steps

1. Try adding validation to the input fields
2. Implement error handling for database operations
3. Add more complex IndexedDB features (indexes, cursors)
4. Explore testing with the `test` package

---

**Note for Instructors**: This example teaches modern Dart web development practices while maintaining simplicity for educational purposes.
