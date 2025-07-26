#!/bin/bash

# Build script for FooBar IndexedDB application

echo "Building FooBar IndexedDB application..."

# Get dependencies
echo "Getting dependencies..."
dart pub get

# Build for production
echo "Building for production..."
dart run build_runner build --release -o web:build

echo "Build complete! Output is in the 'build' directory."
echo "To serve the application locally, run:"
echo "  cd build && python3 -m http.server 8080"
echo "Then open http://localhost:8080 in your browser."
