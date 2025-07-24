#!/bin/bash

# SQLite Student Example Runner
# This script helps students run the SQLite examples easily

echo "🗄️  SQLite Student Management Example"
echo "======================================="

# Check if Dart is installed
if ! command -v dart &> /dev/null; then
    echo "❌ Error: Dart is not installed or not in PATH"
    echo "Please install Dart from https://dart.dev/get-dart"
    exit 1
fi

echo "✅ Dart found: $(dart --version)"

# Check if SQLite is installed (optional but helpful for students)
echo ""
echo "🔍 Checking SQLite installation..."

if command -v sqlite3 &> /dev/null; then
    echo "✅ SQLite3 found: $(sqlite3 --version)"
    SQLITE_AVAILABLE=true
else
    echo "⚠️  SQLite3 command-line tool not found"
    echo "   This is optional - the Dart example includes its own SQLite library"
    echo ""
    echo "To install SQLite3 (recommended for learning):"
    echo "   macOS: brew install sqlite"
    echo "   Ubuntu: sudo apt-get install sqlite3"
    echo "   Windows: Download from https://sqlite.org/download.html"
    SQLITE_AVAILABLE=false
fi

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
dart pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed successfully"

# Create data directory if it doesn't exist
if [ ! -d "data" ]; then
    echo "📁 Creating data directory for SQLite databases..."
    mkdir -p data
fi

# Run tests
echo ""
echo "🧪 Running tests..."
dart test

if [ $? -ne 0 ]; then
    echo "⚠️  Some tests failed, but continuing with examples..."
fi

# Run the main example
echo ""
echo "🚀 Running SQLite examples..."
echo ""

dart run example_usage.dart

echo ""
echo "✅ Examples completed!"

# Show database file information if SQLite is available
if [ "$SQLITE_AVAILABLE" = true ] && [ -f "data/students.db" ]; then
    echo ""
    echo "📊 Database Information:"
    echo "========================"
    echo ""
    echo "📁 Database file: data/students.db"
    echo "📏 File size: $(ls -lh data/students.db | awk '{print $5}')"
    echo ""
    echo "🗂️  Tables in database:"
    sqlite3 data/students.db ".tables"
    echo ""
    echo "📋 Students table schema:"
    sqlite3 data/students.db ".schema students"
    echo ""
    echo "📊 Record count:"
    sqlite3 data/students.db "SELECT COUNT(*) as total_students FROM students;"
    echo ""
    echo "🔍 Sample data (first 5 records):"
    sqlite3 data/students.db -header -column "SELECT * FROM students LIMIT 5;"
fi

echo ""
echo "📚 To learn more:"
echo "   - Read the README.md file"
echo "   - Explore the data/ directory for generated database files"
echo "   - Modify example_usage.dart to practice"
echo "   - Use sqlite3 command-line tool to inspect the database"
echo "   - Compare with IndexedDB examples in ../indexeddb/"
echo "   - Try the PocketBase examples in ../pocketbase/"
echo ""

if [ "$SQLITE_AVAILABLE" = true ]; then
    echo "🎯 Interactive SQLite Session:"
    echo "   sqlite3 data/students.db"
    echo ""
    echo "📖 Useful SQLite Commands:"
    echo "   .help              - Show all commands"
    echo "   .tables            - List all tables"
    echo "   .schema [table]    - Show table structure"
    echo "   .headers on        - Show column headers"
    echo "   .mode column       - Pretty column output"
    echo "   SELECT * FROM students;  - View all student records"
    echo "   .quit              - Exit SQLite"
    echo ""
fi

echo "🎯 Next steps:"
echo "   - Learn about SQL joins, indexes, and triggers"
echo "   - Experiment with complex queries and aggregations"
echo "   - Try building a complete desktop application"
echo "   - Compare performance with other database systems"
echo "   - Practice database design and normalization"

# Ask if user wants to open interactive SQLite session
if [ "$SQLITE_AVAILABLE" = true ] && [ -f "data/students.db" ]; then
    echo ""
    read -p "🤔 Would you like to open an interactive SQLite session? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🚀 Opening SQLite interactive session..."
        echo "   Type .quit to exit when you're done exploring"
        echo ""
        sqlite3 data/students.db
    fi
fi
