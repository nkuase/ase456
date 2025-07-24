#!/bin/bash

# Dart PocketBase CRUD Test Runner (using official PocketBase Dart SDK)
echo "🚀 Dart PocketBase CRUD Test Runner"
echo "Using PocketBase Dart SDK"
echo "=================================="

# Check if dart is installed
if ! command -v dart &> /dev/null; then
    echo "❌ Dart is not installed. Please install Dart SDK first."
    echo "   Visit: https://dart.dev/get-dart"
    exit 1
fi

echo "✅ Dart is available: $(dart --version 2>&1 | head -n1)"

# Check if we're in the right directory
if [ ! -f "index.dart" ] || [ ! -f "new_collection.dart" ]; then
    echo "❌ Please run this script from the dart_crud_test directory"
    exit 1
fi

# Check if dependencies are installed
echo "🔍 Checking dependencies..."
if [ ! -d "../../../.dart_tool" ]; then
    echo "⚠️  Dependencies not installed. Running 'dart pub get'..."
    cd ../../../
    dart pub get
    cd test/pocketbase/dart_crud_test/
    echo "✅ Dependencies installed"
else
    echo "✅ Dependencies are available"
fi

# Check if PocketBase is running
echo "🔍 Checking if PocketBase is running..."
if curl -s "http://127.0.0.1:8090/api/health" > /dev/null 2>&1; then
    echo "✅ PocketBase server is running"
else
    echo "❌ PocketBase server is not running on http://127.0.0.1:8090"
    echo "   Please start PocketBase with: pocketbase serve --dir=\"../db\""
    echo "   Make sure you have created the superuser and regular user first:"
    echo "   1. pocketbase --dir=\"../db\" superuser upsert hello@gmail.com 12345678"
    echo "   2. Create user goodbye@gmail.com with password 12345678 via web interface"
    exit 1
fi

# Menu for user choice
echo ""
echo "What would you like to do?"
echo "1. Create collection (run new_collection.dart)"
echo "2. Run CRUD tests (run index.dart)"
echo "3. Run both (create collection then CRUD tests)"
echo "4. Show PocketBase SDK info"
echo "5. Exit"

read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        echo "📋 Creating collection using PocketBase Dart SDK..."
        dart new_collection.dart
        ;;
    2)
        echo "🧪 Running CRUD tests using PocketBase Dart SDK..."
        dart index.dart
        ;;
    3)
        echo "📋 Creating collection using PocketBase Dart SDK..."
        dart new_collection.dart
        echo ""
        echo "🧪 Running CRUD tests using PocketBase Dart SDK..."
        dart index.dart
        ;;
    4)
        echo "📚 PocketBase Dart SDK Information:"
        echo "   - Package: pocketbase ^0.18.0"
        echo "   - Repository: https://github.com/pocketbase/dart-sdk"
        echo "   - Documentation: https://pub.dev/packages/pocketbase"
        echo ""
        echo "🔧 Key SDK Methods Used:"
        echo "   - pb.collection('users').authWithPassword()"
        echo "   - pb.collection('records').create(body: data)"
        echo "   - pb.collection('records').getList(page: n, perPage: n)"
        echo "   - pb.collection('records').update(id, body: data)"
        echo "   - pb.collection('records').delete(id)"
        echo "   - pb.collections.create(body: schema)"
        ;;
    5)
        echo "👋 Goodbye!"
        exit 0
        ;;
    *)
        echo "❌ Invalid choice. Please select 1-5."
        exit 1
        ;;
esac

echo ""
echo "✅ Script completed!"
echo "💡 Tip: Check the README.md for detailed documentation"
