#!/bin/bash

# Simple Test Runner Script for FooBar Tests
# This script demonstrates how to run unit tests for educational purposes

echo "=== FooBar Unit Tests Runner ==="
echo ""

# Check if Dart is installed
if ! command -v dart &> /dev/null; then
    echo "❌ Dart is not installed. Please install Dart SDK first."
    exit 1
fi

echo "✓ Dart SDK found"

# Check if we're in the right directory
if [ ! -f "foobar_test.dart" ]; then
    echo "❌ Test file not found. Please run this script from the foobar directory."
    exit 1
fi

echo "✓ Test files found"

# Install dependencies (if pubspec.yaml exists)
if [ -f "pubspec.yaml" ]; then
    echo ""
    echo "📦 Installing dependencies..."
    dart pub get
else
    echo "⚠️  No pubspec.yaml found. Using built-in test framework."
fi

# Run tests
echo ""
echo "🧪 Running tests..."
echo "----------------------------------------"

# Run all tests with verbose output
dart test foobar_test.dart --reporter=expanded

# Check test results
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ All tests passed successfully!"
    echo ""
    echo "📊 Test Results Summary:"
    echo "• FooBar Model Tests: ✓ Passed"
    echo "• JSON Serialization Tests: ✓ Passed" 
    echo "• File Operations Tests: ✓ Passed"
    echo "• Edge Cases Tests: ✓ Passed"
    echo "• Integration Tests: ✓ Passed"
else
    echo ""
    echo "❌ Some tests failed. Please check the output above."
fi

echo ""
echo "=== Test Categories Explained ==="
echo "• Model Tests: Basic FooBar functionality and equality"
echo "• JSON Tests: Serialization and deserialization"
echo "• File Operations: Import/export and file handling"
echo "• Edge Cases: Unicode, large values, error conditions"
echo "• Integration: End-to-end workflow testing"
echo ""
echo "💡 Tips:"
echo "  - Run 'dart test --help' for more testing options"
echo "  - Use 'dart test --name \"Model\"' to run specific test groups"
echo "  - Add '--coverage' flag to generate coverage reports"
