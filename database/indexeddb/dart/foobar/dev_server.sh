#!/bin/bash

# Development server script for FooBar IndexedDB application

echo "Starting development server for FooBar IndexedDB application..."

# Get dependencies if not already installed
if [ ! -d ".dart_tool" ]; then
    echo "Getting dependencies..."
    dart pub get
fi

# Start development server with hot reload
echo "Starting server on http://localhost:8080"
echo "Press Ctrl+C to stop the server"
dart run build_runner serve web:8080
