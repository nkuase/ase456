#!/bin/bash

# Shell script to run Dart unit tests for Cascade examples
# ASE456 - Advanced Software Engineering Course

echo "================================================"
echo "Running Dart Unit Tests for Cascade Examples"
echo "================================================"

# Check if Dart is installed
if ! command -v dart &> /dev/null; then
    echo "❌ Error: Dart is not installed or not in PATH"
    echo "Please install Dart SDK from https://dart.dev/get-dart"
    exit 1
fi

echo "✅ Dart SDK found: $(dart --version)"
echo ""

# Navigate to the project directory
PROJECT_DIR="$(dirname "$0")"
cd "$PROJECT_DIR" || exit 1

echo "📁 Current directory: $(pwd)"
echo ""

# Get dependencies
echo "📦 Getting dependencies..."
dart pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to get dependencies"
    exit 1
fi

echo "✅ Dependencies installed successfully"
echo ""

# Run the tests
echo "🧪 Running unit tests..."
echo "================================================"

dart test test/cascade_test.dart --reporter=expanded

TEST_EXIT_CODE=$?

echo ""
echo "================================================"

if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo "✅ All tests passed successfully!"
else
    echo "❌ Some tests failed. Please review the output above."
fi

echo "================================================"

# Optionally run with coverage (uncomment if needed)
# echo ""
# echo "📊 Running tests with coverage..."
# dart test --coverage=coverage test/cascade_test.dart
# dart pub global activate coverage
# dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.dart_tool/package_config.json --report-on=lib

exit $TEST_EXIT_CODE
