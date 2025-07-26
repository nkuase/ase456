#!/bin/bash
set -e

# Ensure Dart is installed and webdev is available
if ! command -v dart &> /dev/null; then
    echo "Dart SDK is not installed. Please install it first."
    exit 1
fi

# Get dependencies
dart pub get

# Compile Dart to JavaScript
dart compile js indexeddb_crud.dart -o main.dart.js

# Run web server
# Serve using Python simple HTTP server
#echo "Serving at http://localhost:8000"
#python3 -m http.server