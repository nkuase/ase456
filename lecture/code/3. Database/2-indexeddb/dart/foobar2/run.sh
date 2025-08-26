#!/bin/bash
# Development script for Dart webdev project
# This script demonstrates the proper webdev workflow for students

set -e  # Exit on any error

echo "=== Dart WebDev Development Workflow ==="
echo ""

# Step 1: Get dependencies
echo "📦 Step 1: Getting dependencies..."
dart pub get

# Step 2: Check if webdev is activated globally
echo "🔧 Step 2: Checking webdev activation..."
if ! dart pub global list | grep -q webdev; then
    echo "⚠️  WebDev not found globally. Activating..."
    dart pub global activate webdev
else
    echo "✅ WebDev is already activated"
fi

# Step 3: Clean any previous builds
echo "🧹 Step 3: Cleaning previous builds..."
if [ -d "build" ]; then
    rm -rf build
fi

# Step 4: Build the project
echo "🏗️  Step 4: Building project..."
dart pub global run webdev build

# Step 5: Check if build was successful
if [ -f "build/main.dart.js" ]; then
    echo "✅ Build successful! Generated files:"
    ls -la build/
    echo ""
    echo "🚀 Step 5: Starting development server..."
    echo "📍 Server will be available at: http://localhost:8080 (default)"
    echo "🛑 Press Ctrl+C to stop the server"
    echo ""
    
    # Start the development server
    dart pub global run webdev serve
else
    echo "❌ Build failed! Check the error messages above."
    exit 1
fi
