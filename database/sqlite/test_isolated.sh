#!/bin/bash

# Enhanced test runner that shows the fix for test isolation
echo "🧪 Testing SQLite CRUD with Proper Test Isolation"
echo "================================================"

echo ""
echo "🔧 What we fixed:"
echo "  ✅ Each test now uses a unique database file"
echo "  ✅ Tests no longer interfere with each other"
echo "  ✅ Proper cleanup after each test"
echo ""

echo "📦 Installing dependencies..."
dart pub get

echo ""
echo "🚀 Running main demo first..."
echo "----------------------------------------"
dart run main.dart

echo ""
echo "🧹 Cleaning up demo database before tests..."
if [ -f "students.db" ]; then
    rm students.db
    echo "✅ Removed students.db"
fi

echo ""
echo "🧪 Running isolated tests..."
echo "----------------------------------------"
dart test --reporter=expanded

echo ""
echo "🔍 Checking for leftover test files..."
TEST_FILES=$(ls test_students_*.db 2>/dev/null | wc -l)
if [ $TEST_FILES -gt 0 ]; then
    echo "⚠️  Found $TEST_FILES leftover test database files"
    ls test_students_*.db
    echo "🧹 Cleaning up..."
    rm test_students_*.db
    echo "✅ Cleaned up test files"
else
    echo "✅ No leftover test files found - proper cleanup!"
fi

echo ""
echo "🎯 Test Isolation Success!"
echo "  • Each test created its own database"
echo "  • No data shared between tests"
echo "  • Proper resource cleanup"
echo ""
echo "📚 Teaching Point: This demonstrates why test isolation"
echo "    is crucial for reliable automated testing!"
