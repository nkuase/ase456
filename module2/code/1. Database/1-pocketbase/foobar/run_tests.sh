#!/bin/bash

# Enhanced Test Runner Script for FooBar Tests
# This script demonstrates efficient shell scripting using loops and arrays
# Educational example for university students

echo "=== FooBar Unit Tests Runner ==="
echo ""

# Check if Dart is installed
if ! command -v dart &> /dev/null; then
    echo "❌ Dart is not installed. Please install Dart SDK first."
    exit 1
fi

echo "✓ Dart SDK found"

# Install dependencies first
echo ""
echo "📦 Installing dependencies..."
dart pub get

# Check if dart pub get was successful
if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies. Exiting."
    exit 1
fi

echo "✓ Dependencies installed successfully"

# Define test files in an array (educational: demonstrates array usage)
test_files=(
    "test/foobar_json_test.dart"
    "test/foobar_crud_test.dart" 
    "test/foobar_utility_test.dart"
)

echo ""
echo "🧪 Running individual test files..."
echo "----------------------------------------"

# Track test results
total_tests=${#test_files[@]}
passed_tests=0

# Loop through each test file (educational: demonstrates for loop with arrays)
for test_file in "${test_files[@]}"; do
    echo ""
    echo "▶️  Running: $test_file"
    
    # Check if test file exists before running
    if [ ! -f "$test_file" ]; then
        echo "⚠️  Test file not found: $test_file"
        continue
    fi
    
    # Run the test
    dart test "$test_file"
    
    # Check if test passed
    if [ $? -eq 0 ]; then
        echo "✅ $test_file - PASSED"
        ((passed_tests++))
    else
        echo "❌ $test_file - FAILED"
    fi
done

# Display final results
echo ""
echo "========================================="
echo "📊 Test Results Summary:"
echo "• Total test files: $total_tests"
echo "• Passed: $passed_tests"
echo "• Failed: $((total_tests - passed_tests))"

if [ $passed_tests -eq $total_tests ]; then
    echo ""
    echo "🎉 All tests passed successfully!"
    exit 0
else
    echo ""
    echo "⚠️  Some tests failed. Please review the output above."
    exit 1
fi

# Educational notes (commented for students):
# - Arrays in bash: variable_name=(item1 item2 item3)
# - Array iteration: for item in "${array[@]}"
# - Array length: ${#array[@]}
# - Arithmetic operations: $((expression))
# - Exit codes: 0 = success, non-zero = error
