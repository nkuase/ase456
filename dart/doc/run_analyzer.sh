#!/bin/bash

# Dart Test Analyzer Runner Script
# Usage: ./run_analyzer.sh [project_directory]

echo "🔍 Dart Test Analyzer"
echo "===================="

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Error: Python 3 is not installed or not in PATH"
    echo "Please install Python 3.7+ to continue"
    exit 1
fi

# Check if Dart is available
if ! command -v dart &> /dev/null; then
    echo "❌ Error: Dart SDK is not installed or not in PATH"
    echo "Please install Dart SDK to continue"
    echo "macOS: brew install dart"
    echo "Ubuntu: sudo apt-get install dart"
    echo "Windows: choco install dart-sdk"
    exit 1
fi

# Determine project directory
if [ $# -eq 0 ]; then
    # Use default directory
    PROJECT_DIR="./1-Dart-for-Java-and-JavaScript"
else
    PROJECT_DIR="$1"
fi

echo "📁 Project Directory: $PROJECT_DIR"

# Check if project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Error: Project directory '$PROJECT_DIR' does not exist"
    echo ""
    echo "Usage: $0 [project_directory]"
    echo "Example: $0 ./1-Dart-for-Java-and-JavaScript"
    exit 1
fi

# Check if lib and test directories exist
if [ ! -d "$PROJECT_DIR/lib" ]; then
    echo "⚠️  Warning: 'lib' directory not found in $PROJECT_DIR"
fi

if [ ! -d "$PROJECT_DIR/test" ]; then
    echo "⚠️  Warning: 'test' directory not found in $PROJECT_DIR"
fi

echo ""
echo "🚀 Starting analysis..."
echo ""

# Run the analyzer
python3 dart_test_analyzer.py "$PROJECT_DIR"

# Check if the analyzer ran successfully
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Analysis completed successfully!"
    echo "📄 Check dart_test_analysis_report.txt for detailed results"
else
    echo ""
    echo "❌ Analysis failed. Check the error messages above."
    exit 1
fi
