#!/bin/bash

# Firebase Student Example Runner
# This script helps students run the Firebase examples easily

echo "🔥 Firebase Student Management Example"
echo "====================================="

# Check if Dart is installed
if ! command -v dart &> /dev/null; then
    echo "❌ Error: Dart is not installed or not in PATH"
    echo "Please install Dart from https://dart.dev/get-dart"
    exit 1
fi

echo "✅ Dart found: $(dart --version)"

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
dart pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed successfully"

# Check for Firebase configuration
if [ ! -f "lib/firebase_options.dart" ]; then
    echo ""
    echo "⚠️  Warning: Firebase not configured"
    echo "   The example will run in offline mode with mock data."
    echo ""
    echo "To enable Firebase features:"
    echo "1. Create a Firebase project at https://console.firebase.google.com"
    echo "2. Install Firebase CLI: npm install -g firebase-tools"
    echo "3. Install FlutterFire CLI: dart pub global activate flutterfire_cli"
    echo "4. Run: flutterfire configure"
    echo "5. Follow the prompts to generate firebase_options.dart"
fi

# Run tests
echo ""
echo "🧪 Running tests..."
dart test

if [ $? -ne 0 ]; then
    echo "⚠️  Some tests failed, but continuing with examples..."
fi

# Run the main example
echo ""
echo "🚀 Running Firebase examples..."
echo ""

dart run lib/main.dart

echo ""
echo "✅ Examples completed!"
echo ""
echo "📚 To learn more:"
echo "   - Read the README.md file"
echo "   - Explore the lib/ directory"
echo "   - Modify the examples to practice"
echo "   - Set up Firebase for full functionality"
