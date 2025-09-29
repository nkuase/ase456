#!/bin/bash

# Firebase macOS App Test Script
# This script helps test the Firebase configuration

echo "🔥 Firebase macOS App Configuration Test"
echo "========================================"

cd "/Users/chos5/github/nkuase/ase456/database/firebase/foobar_flutter_app"

echo ""
echo "📁 Checking project structure..."

# Check if entitlements files exist
if [ -f "macos/Runner/Release.entitlements" ]; then
    echo "✅ Release.entitlements found"
else
    echo "❌ Release.entitlements missing"
fi

if [ -f "macos/Runner/DebugProfile.entitlements" ]; then
    echo "✅ DebugProfile.entitlements found"
else
    echo "❌ DebugProfile.entitlements missing"
fi

if [ -f "macos/Runner/GoogleService-Info.plist" ]; then
    echo "✅ GoogleService-Info.plist found"
else
    echo "❌ GoogleService-Info.plist missing"
fi

if [ -f "lib/firebase_options.dart" ]; then
    echo "✅ firebase_options.dart found"
else
    echo "❌ firebase_options.dart missing"
fi

echo ""
echo "🔍 Checking entitlements permissions..."

# Check for network permissions in Release.entitlements
if grep -q "com.apple.security.network.client" "macos/Runner/Release.entitlements"; then
    echo "✅ Network client permission found in Release.entitlements"
else
    echo "❌ Network client permission missing in Release.entitlements"
fi

echo ""
echo "🧹 Cleaning project..."
flutter clean

echo ""
echo "📦 Getting dependencies..."
flutter pub get

echo ""
echo "🔨 Building macOS app..."
flutter build macos

echo ""
echo "🚀 Starting app..."
echo "   Check the console output for Firebase initialization messages"
echo "   Look for:"
echo "   - ✅ Firebase initialized successfully!"
echo "   - ✅ Firestore instance created successfully!"
echo ""

flutter run -d macos
