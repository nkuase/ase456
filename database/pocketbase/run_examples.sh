#!/bin/bash

# PocketBase Student Example Runner
# This script helps students run the PocketBase examples easily

echo "📦 PocketBase Student Management Example"
echo "========================================"

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

# Check for PocketBase server
echo ""
echo "🔍 Checking PocketBase server..."

# Check if PocketBase is running
if curl -s http://127.0.0.1:8090/api/health > /dev/null 2>&1; then
    echo "✅ PocketBase server is running"
else
    echo "⚠️  Warning: PocketBase server not detected"
    echo "   The example will run in offline mode with mock data."
    echo ""
    echo "To enable PocketBase features:"
    echo "1. Download PocketBase from https://pocketbase.io/"
    echo "2. Extract the executable: unzip pocketbase_*.zip"
    echo "3. Make executable: chmod +x pocketbase"
    echo "4. Run server: ./pocketbase serve"
    echo "5. Access admin panel: http://127.0.0.1:8090/_/"
    echo ""
    echo "Quick setup commands:"
    echo "  wget https://github.com/pocketbase/pocketbase/releases/download/v0.20.0/pocketbase_0.20.0_linux_amd64.zip"
    echo "  unzip pocketbase_0.20.0_linux_amd64.zip"
    echo "  chmod +x pocketbase"
    echo "  ./pocketbase serve"
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
echo "🚀 Running PocketBase examples..."
echo ""

dart run lib/main.dart

echo ""
echo "✅ Examples completed!"
echo ""
echo "📚 To learn more:"
echo "   - Read the README.md file"
echo "   - Explore the lib/ directory"
echo "   - Modify the examples to practice"
echo "   - Set up PocketBase server for full functionality"
echo "   - Compare with Firebase examples in ../firebase/"
echo ""
echo "🎯 Next steps:"
echo "   - Try running: ./pocketbase serve"
echo "   - Access admin panel: http://127.0.0.1:8090/_/"
echo "   - Create custom collections and fields"
echo "   - Experiment with real-time subscriptions"
