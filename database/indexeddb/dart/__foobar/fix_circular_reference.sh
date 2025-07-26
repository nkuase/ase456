#!/bin/bash

echo "🔧 Building Circular Reference Fix"

# Clean previous builds
rm -f web/main.dart.js web/main.dart.js.map

# Get dependencies
dart pub get

# Compile the fixed solution
echo "📦 Compiling circular reference safe solution..."
dart compile js web/main.dart -o web/main.dart.js

if [ $? -eq 0 ]; then
    echo "✅ Circular reference fix compiled successfully!"
    echo ""
    echo "🔧 What this fix does:"
    echo "  ✅ Removes JSON.stringify (which caused circular reference error)"
    echo "  ✅ Uses safe property extraction only"
    echo "  ✅ Extracts only the data properties we need (id, foo, bar)"
    echo "  ✅ Avoids internal LinkedHashMapCell properties"
    echo ""
    echo "🎯 The error was caused by:"
    echo "  ❌ LinkedHashMapCell has _next/_previous circular references"
    echo "  ❌ JSON.stringify can't handle circular structures"
    echo "  ✅ Now we extract properties directly without serialization"
    echo ""
    echo "🧪 Test the fix:"
    echo "  1. Open http://localhost:8000"
    echo "  2. Watch console for 'Property extraction successful'"
    echo "  3. Try: Initialize → Add Sample Data → Show All Records"
    echo "  4. Should see real data instead of null/empty values"
    echo ""
    
    if command -v python3 &> /dev/null; then
        read -p "🌐 Start server to test the circular reference fix? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "🚀 Starting server - circular reference issue should be fixed!"
            echo "📊 Look for 'Property extraction successful' in console"
            cd web && python3 -m http.server 8000
        fi
    fi
else
    echo "❌ Compilation failed!"
    echo "Check for syntax errors in the Dart files"
    exit 1
fi
