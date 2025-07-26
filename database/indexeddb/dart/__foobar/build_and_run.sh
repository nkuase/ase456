#!/bin/bash

# Build and Run Script for FooBar IndexedDB Demo
# This script compiles Dart to JavaScript and opens the demo in a browser

echo "🚀 Building FooBar IndexedDB Demo..."

# Check if dart is installed
if ! command -v dart &> /dev/null; then
    echo "❌ Dart is not installed. Please install Dart first."
    echo "Visit: https://dart.dev/get-dart"
    exit 1
fi

# Get dependencies first
echo "📦 Getting dependencies..."
dart pub get

# Create web directory if it doesn't exist
mkdir -p web

# Compile Dart to JavaScript
echo "📦 Compiling Dart to JavaScript..."
dart compile js web/main.dart -o web/main.dart.js

# Check if compilation was successful
if [ $? -eq 0 ]; then
    echo "✅ Compilation successful!"
    echo ""
    echo "📋 Files created:"
    echo "  - web/main.dart.js (compiled JavaScript)"
    echo "  - web/index.html (demo page)"
    echo ""
    echo "🌐 To run the demo:"
    echo "  1. Start a local web server:"
    echo "     cd web && python3 -m http.server 8000"
    echo "  2. Open browser to: http://localhost:8000"
    echo ""
    echo "⚠️  IMPORTANT: IndexedDB requires a web server - direct file access will NOT work!"
    echo "💡 Or use VS Code Live Server extension to serve the web folder"
    echo ""
    echo "🔍 Debugging tips:"
    echo "  - Open browser Developer Tools (F12) to see console logs"
    echo "  - Check Application tab > IndexedDB to see stored data"
    echo "  - Use web/debug_indexeddb.html for detailed IndexedDB testing"
    echo "  - If you see JSNull errors, the type conversion fixes should help"
    
    # Optionally try to start a simple server
    if command -v python3 &> /dev/null; then
        echo ""
        read -p "🤔 Start a local server now? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "🌍 Starting server at http://localhost:8000"
            echo "Press Ctrl+C to stop the server"
            cd web && python3 -m http.server 8000
        fi
    fi
else
    echo "❌ Compilation failed!"
    echo "Common issues:"
    echo "  - Check import paths in web/main.dart (use ../lib/)"
    echo "  - Ensure all dependencies are in pubspec.yaml"
    echo "  - Run 'dart pub get' first"
    exit 1
fi
