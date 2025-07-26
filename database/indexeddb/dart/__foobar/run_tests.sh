#!/bin/bash

# Test Runner for FooBar IndexedDB Project
# Runs unit tests for the Dart code

echo "🧪 Running FooBar IndexedDB Tests..."

# Check if dart is installed
if ! command -v dart &> /dev/null; then
    echo "❌ Dart is not installed. Please install Dart first."
    echo "Visit: https://dart.dev/get-dart"
    exit 1
fi

# Get dependencies first
echo "📦 Getting dependencies..."
dart pub get

# Run tests
echo "🏃 Running tests..."
dart test

# Check test results
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ All tests passed!"
    echo ""
    echo "📋 Test Summary:"
    echo "  - FooBar model tests: ✅"
    echo "  - CRUD service structure tests: ✅"
    echo "  - Utility class tests: ✅"
    echo "  - Edge case tests: ✅"
    echo ""
    echo "💡 Note: These tests verify code structure and interfaces."
    echo "   For full functionality testing, run the web demo in a browser."
else
    echo ""
    echo "❌ Some tests failed!"
    echo "Please check the test output above for details."
    exit 1
fi
