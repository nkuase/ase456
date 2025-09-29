#!/bin/bash

# Flutter Testing Example - Run Script
# This script helps students run different types of tests

echo "🧪 Flutter Testing Examples - MVVM Todo App"
echo "============================================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -n 1)"
echo ""

# Function to run tests with nice output
run_test() {
    local test_type=$1
    local test_path=$2
    local description=$3
    
    echo "🔍 Running $test_type Tests"
    echo "   Description: $description"
    echo "   Path: $test_path"
    echo "   Command: flutter test $test_path"
    echo ""
    
    flutter test "$test_path"
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        echo "✅ $test_type tests passed!"
    else
        echo "❌ $test_type tests failed!"
    fi
    echo ""
    return $exit_code
}

# Show available options
echo "Available test commands:"
echo "1. All tests (recommended)"
echo "2. Unit tests only"
echo "3. View tests only"
echo "4. Integration tests only"
echo "5. Test with coverage"
echo "6. Run app"
echo ""

read -p "Enter your choice (1-6): " choice

case $choice in
    1)
        echo "Running all tests..."
        echo ""
        run_test "Unit" "test/unit/" "Testing Todo model and ViewModel business logic"
        run_test "View" "test/view/" "Testing TodoView UI components and interactions"
        run_test "Integration" "integration_test/" "Testing complete user flows end-to-end"
        echo "🎉 All tests completed!"
        ;;
    2)
        run_test "Unit" "test/unit/" "Testing Todo model and ViewModel business logic"
        ;;
    3)
        run_test "View" "test/view/" "Testing TodoView UI components and interactions"
        ;;
    4)
        run_test "Integration" "integration_test/" "Testing complete user flows end-to-end"
        ;;
    5)
        echo "🔍 Running all tests with coverage..."
        echo ""
        flutter test --coverage
        echo ""
        echo "📊 Coverage report generated in coverage/lcov.info"
        echo "   To view HTML report, run: genhtml coverage/lcov.info -o coverage/html"
        ;;
    6)
        echo "🚀 Running the Todo app..."
        echo "   Press Ctrl+C to stop"
        echo ""
        flutter run
        ;;
    *)
        echo "❌ Invalid choice. Please run the script again and choose 1-6."
        exit 1
        ;;
esac