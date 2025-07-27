#!/bin/bash
set -e

# Install dependencies
dart pub get

# Activate webdev if not already
dart pub global activate webdev

# Generate build files (Dart 2.6+; webdev builds main.dart.js)
dart pub global run webdev build

# Serve (for development, starts a localhost server)
dart pub global run webdev serve

# Clean
#dart run build_runner clean
#rm -rf .dart_tool
#dart pub get