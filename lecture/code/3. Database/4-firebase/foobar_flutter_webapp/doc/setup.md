# Setup Guide - Foobar Flutter Firebase App

## Prerequisites

### System Requirements
- **Flutter SDK**: Version 3.8.1 or higher
- **Dart SDK**: Included with Flutter
- **Node.js**: Version 16+ (for Firebase CLI)
- **Web Browser**: Chrome (recommended for development)
- **Code Editor**: VS Code or Android Studio

### Development Tools
- **Firebase CLI**: For project configuration
- **FlutterFire CLI**: For Firebase integration
- **Git**: For version control

## Step-by-Step Setup

### 1. Flutter Environment Setup

#### Install Flutter
```bash
# Download Flutter SDK from https://flutter.dev
# Add Flutter to your PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

#### Check Flutter Status
```bash
flutter doctor -v
```
Ensure all checkmarks are green, especially:
- ✓ Flutter SDK
- ✓ Chrome (for web development)
- ✓ Connected device (Chrome)

### 2. Firebase Project Setup

#### Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create a project"
3. Name your project (e.g., "foobar-flutter-demo")
4. Enable Google Analytics (optional)
5. Complete project creation

#### Enable Firestore Database
1. In Firebase Console, navigate to "Firestore Database"
2. Click "Create database"
3. Start in **test mode** (for development)
4. Choose your preferred location
5. Click "Done"

#### Configure Firestore Security Rules
```javascript
// Firestore Security Rules (for development/testing)
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;  // WARNING: Only for development!
    }
  }
}
```

### 3. Firebase CLI Installation

#### Install Firebase CLI
```bash
# Using npm
npm install -g firebase-tools

# Verify installation
firebase --version
```

#### Login to Firebase
```bash
firebase login
```

### 4. FlutterFire CLI Setup

#### Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

#### Add to PATH (if needed)
```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### 5. Project Configuration

#### Clone/Create Project
```bash
# If cloning existing project
git clone <repository-url>
cd foobar_flutter

# Or create new Flutter project
flutter create foobar_flutter
cd foobar_flutter
```

#### Configure Firebase for Flutter
```bash
# Run in project root directory
flutterfire configure
```

This command will:
1. Select your Firebase project
2. Choose platforms (Web, iOS, Android)
3. Generate `firebase_options.dart`
4. Update configuration files

#### Update pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.2
  cloud_firestore: ^4.13.6
  firebase_core_web: ^2.10.0
  cloud_firestore_web: ^3.8.10
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

#### Install Dependencies
```bash
flutter pub get
```

### 6. Web Configuration (Additional Steps)

#### Update web/index.html
Add Firebase SDK scripts before closing `</body>` tag:

```html
<!DOCTYPE html>
<html>
<head>
  <base href="$FLUTTER_BASE_HREF">
  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="description" content="Foobar Flutter Firebase Demo">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="foobar_flutter">
  <link rel="apple-touch-icon" href="icons/Icon-192.png">
  <link rel="icon" type="image/png" href="favicon.png"/>
  <title>Foobar Flutter</title>
  <link rel="manifest" href="manifest.json">
</head>
<body>
  <script>
    window.addEventListener('load', function(ev) {
      _flutter.loader.loadEntrypoint({
        serviceWorker: {
          serviceWorkerVersion: serviceWorkerVersion,
        }
      }).then(function(engineInitializer) {
        return engineInitializer.initializeEngine();
      }).then(function(appRunner) {
        return appRunner.runApp();
      });
    });
  </script>
  
  <!-- Firebase SDKs -->
  <script src="https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js"></script>
  <script src="https://www.gstatic.com/firebasejs/10.7.0/firebase-firestore-compat.js"></script>
</body>
</html>
```

### 7. Code Implementation

#### Copy Main Application Code
Ensure your `lib/main.dart` contains the complete foobar application code.

#### Verify firebase_options.dart
Check that `lib/firebase_options.dart` exists and contains your project configuration.

### 8. Testing the Setup

#### Run the Application
```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Run on Chrome (Web)
flutter run -d chrome

# Or run on mobile device
flutter run
```

#### Verify Functionality
1. App should load without errors
2. Click "Generate Foobar" button
3. Check that data appears on screen
4. Verify data is saved in Firebase Console

#### Check Firebase Console
1. Go to Firebase Console → Firestore Database
2. Navigate to `foo_flutter_test` collection
3. Verify documents are being created with correct structure

### 9. Common Setup Issues & Solutions

#### Issue: "gRPC Error (code: 14)"
**Solution**: 
- Ensure web-specific Firebase packages are installed
- Check that `firebase_options.dart` is properly generated
- Verify Firebase project configuration

#### Issue: "DefaultFirebaseOptions not found"
**Solution**:
```bash
flutterfire configure
```

#### Issue: "Permission denied" in Firestore
**Solution**: Update Firestore security rules to allow read/write access

#### Issue: Build failures
**Solution**:
```bash
flutter clean
flutter pub get
flutter run
```

### 10. Development Workflow

#### Daily Development Setup
```bash
# Start development
cd foobar_flutter
flutter run -d chrome

# In another terminal (for logs)
flutter logs
```

#### Code Changes
1. Make changes to `lib/main.dart`
2. Save file (hot reload automatically applies changes)
3. Test functionality in browser
4. Check Firebase Console for data updates

#### Debugging
- Use Chrome DevTools for web debugging
- Check Flutter Inspector for widget issues
- Monitor console logs for Firebase operations
- Use Firebase Console for database verification

### 11. Production Considerations

#### Security Rules
Update Firestore security rules for production:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /foo_flutter_test/{document} {
      allow read, write: if request.auth != null;
    }
  }
}
```

#### Environment Configuration
- Set up separate Firebase projects for development/production
- Use environment variables for configuration
- Implement proper error handling for production

### 12. Troubleshooting Commands

```bash
# Flutter doctor (check environment)
flutter doctor -v

# Clean and rebuild
flutter clean && flutter pub get

# Check Firebase login
firebase projects:list

# Reconfigure Firebase
flutterfire configure

# Check package versions
flutter pub deps
```

## Next Steps

After successful setup:
1. **Explore the Code**: Understand the application structure
2. **Test Features**: Generate foobar data and verify storage
3. **Modify**: Try changing the random data options
4. **Extend**: Add new features like user authentication
5. **Deploy**: Learn about Flutter web deployment options

## Support Resources

- **Flutter Documentation**: https://flutter.dev/docs
- **Firebase Documentation**: https://firebase.google.com/docs
- **FlutterFire Documentation**: https://firebase.flutter.dev
- **Firestore Documentation**: https://firebase.google.com/docs/firestore

This setup guide ensures a smooth installation and configuration process for the Foobar Flutter Firebase application, suitable for educational environments and development purposes.
