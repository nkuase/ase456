#!/bin/bash

# Simple script to run the CRUD demo and tests
# This makes it easy for students to execute the examples

echo "🎓 SQLite CRUD Demo - Educational Example"
echo "========================================"

# Check if Dart is installed
if ! command -v dart &> /dev/null; then
    echo "❌ Error: Dart is not installed or not in PATH"
    echo "   Please install Dart SDK from: https://dart.dev/get-dart"
    exit 1
fi

echo ""
echo "📦 Installing dependencies..."
if dart pub get; then
    echo "✅ Dependencies installed successfully"
else
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo ""
echo "🚀 Running CRUD Demo..."
echo "----------------------------------------"
if dart run main.dart; then
    echo "✅ Demo completed successfully"
else
    echo "❌ Demo failed to run"
    exit 1
fi

echo ""
echo "🧪 Running Tests..."
echo "----------------------------------------"
if dart test; then
    echo "✅ All tests passed"
else
    echo "❌ Some tests failed"
    exit 1
fi

echo ""
echo "🎯 All done! Key files created:"
echo "  - students.db (SQLite database file)"
echo ""
echo "📚 Next steps for students:"
echo "  1. Examine the students.db file with a SQLite viewer"
echo "  2. Modify the Student model to add new fields"
echo "  3. Try the exercises in README.md"
echo "  4. Experiment with different SQL queries"
echo ""
echo "✅ SQLite CRUD demo completed successfully!"
