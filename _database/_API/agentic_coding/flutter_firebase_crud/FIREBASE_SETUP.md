# Firebase Configuration Setup Guide

This guide shows you how to integrate the Firebase config file generated from the Firebase Manager app into your Flutter project.

## Step 1: Get Your Firebase Configuration

### Using Firebase Manager App:
1. Open the Firebase Manager Qt app
2. Connect to your Firebase project
3. Go to "Flutter Integration" tab
4. Click "Generate Firebase Config"
5. Save the JSON file

### Using Firebase Console (Alternative):
1. Go to Firebase Console → Project Settings
2. Click "Add app" → Choose your platform (iOS/Android/Web)
3. Download the configuration files:
   - **Android**: `google-services.json`
   - **iOS**: `GoogleService-Info.plist`
   - **Web**: Copy the config object

## Step 2: Configure Your Flutter Project

### Option A: Using FlutterFire CLI (Recommended)

1. **Install FlutterFire CLI:**
```bash
dart pub global activate flutterfire_cli
```

2. **Configure Firebase:**
```bash
flutterfire configure
```

3. **Follow the prompts:**
   - Select your Firebase project
   - Choose platforms (iOS, Android, Web, macOS)
   - This automatically generates `firebase_options.dart`

### Option B: Manual Configuration

#### For Android:
1. Place `google-services.json` in `android/app/` directory
2. Add to `android/build.gradle`:
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```

3. Add to `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'
```

#### For iOS:
1. Place `GoogleService-Info.plist` in `ios/Runner/` directory
2. Add it to your Xcode project

#### For Web:
1. Update `web/index.html`:
```html
<script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-firestore.js"></script>
<script>
  // Your web app's Firebase configuration
  const firebaseConfig = {
    apiKey: "your-api-key",
    authDomain: "your-project.firebaseapp.com",
    projectId: "your-project-id",
    storageBucket: "your-project.appspot.com",
    messagingSenderId: "123456789",
    appId: "your-app-id"
  };
  
  // Initialize Firebase
  firebase.initializeApp(firebaseConfig);
</script>
```

## Step 3: Update firebase_options.dart

If you have a config JSON from Firebase Manager, update `lib/firebase_options.dart`:

```dart
// Replace these values with your actual Firebase config
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'your-actual-api-key',
  appId: 'your-actual-app-id',
  messagingSenderId: 'your-actual-sender-id',
  projectId: 'your-actual-project-id',
  authDomain: 'your-project-id.firebaseapp.com',
  storageBucket: 'your-project-id.appspot.com',
  measurementId: 'your-measurement-id', // Optional for web
);

static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'your-android-api-key',
  appId: 'your-android-app-id',
  messagingSenderId: 'your-sender-id',
  projectId: 'your-project-id',
  storageBucket: 'your-project-id.appspot.com',
);

static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'your-ios-api-key',
  appId: 'your-ios-app-id',
  messagingSenderId: 'your-sender-id',
  projectId: 'your-project-id',
  storageBucket: 'your-project-id.appspot.com',
  iosBundleId: 'com.example.yourapp', // Your actual bundle ID
);
```

## Step 4: Update main.dart

Your main.dart should look like this:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:your_app/firebase_crud.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
```

## Step 5: Firestore Security Rules

Update your Firestore security rules in Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read/write access for authenticated users
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
    
    // For development only - allow all access
    // REMOVE THIS IN PRODUCTION!
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

## Step 6: Test Your Configuration

Run this simple test in your Flutter app:

```dart
Future<void> testFirebaseConnection() async {
  try {
    // Test Firestore connection
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('test').doc('test').set({
      'message': 'Firebase is working!',
      'timestamp': FieldValue.serverTimestamp(),
    });
    
    print('✅ Firebase connected successfully!');
  } catch (e) {
    print('❌ Firebase connection failed: $e');
  }
}
```

## Troubleshooting

### Common Issues:

1. **"Firebase not initialized" error:**
   - Make sure `Firebase.initializeApp()` is called before `runApp()`
   - Ensure `WidgetsFlutterBinding.ensureInitialized()` is called first

2. **Platform-specific errors:**
   - Android: Check `google-services.json` is in correct location
   - iOS: Ensure `GoogleService-Info.plist` is added to Xcode project
   - Web: Verify Firebase script tags in `index.html`

3. **Permission denied errors:**
   - Check Firestore security rules
   - For testing, temporarily allow all access
   - For production, implement proper authentication rules

4. **Project ID mismatch:**
   - Ensure project ID in config matches Firebase Console
   - Double-check all configuration values

### Getting Help:

1. **Check Firebase Console logs**
2. **Review Flutter debug console**
3. **Verify all configuration files are in correct locations**
4. **Test with a simple write operation first**

## Example Complete Setup

Here's what your file structure should look like:

```
your_flutter_app/
├── lib/
│   ├── firebase_options.dart     # Generated config
│   ├── main.dart                 # App entry point
│   └── firebase_crud.dart        # CRUD library
├── android/
│   └── app/
│       └── google-services.json  # Android config
├── ios/
│   └── Runner/
│       └── GoogleService-Info.plist  # iOS config
└── web/
    └── index.html                # Contains Firebase scripts
```

Once configured, you can use the CRUD library immediately:

```dart
final service = ExampleService();
await service.create(ExampleModel(foo: "test", bar: 123));
```