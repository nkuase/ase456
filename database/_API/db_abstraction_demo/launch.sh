#!/bin/bash

# Database Abstraction Demo - Launch Script

echo "🎓 Database Abstraction Demo - Setup & Launch"
echo "=============================================="

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "   Please install Flutter from https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check Flutter doctor
echo "📋 Checking Flutter installation..."
flutter doctor

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
flutter pub get

# Check for any analysis issues
echo ""
echo "🔍 Checking code analysis..."
flutter analyze

# Run tests
echo ""
echo "🧪 Running tests..."
flutter test

echo ""
echo "🎉 Setup complete! You can now run the app with:"
echo ""
echo "   For web (IndexedDB + PocketBase):"
echo "   flutter run -d chrome"
echo ""
echo "   For mobile/desktop (SQLite + PocketBase):"
echo "   flutter run"
echo ""
echo "📚 Learning Resources:"
echo "   README.md       - Project overview"
echo "   QUICKSTART.md   - Quick setup guide"
echo "   CONCEPTS.md     - Detailed technical concepts"
echo "   INSTRUCTOR_GUIDE.md - Teaching guide"
echo ""
echo "💡 Happy learning! 🎓"
