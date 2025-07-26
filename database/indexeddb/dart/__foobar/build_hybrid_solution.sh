#!/bin/bash

echo "🚀 Building Hybrid Solution: JavaScript Helpers + Dart"

# Clean previous builds
rm -f web/main.dart.js web/main.dart.js.map

# Get dependencies
dart pub get

# Compile the hybrid solution
echo "📦 Compiling Dart with JavaScript helper integration..."
dart compile js web/main.dart -o web/main.dart.js

if [ $? -eq 0 ]; then
    echo "✅ Hybrid solution compiled successfully!"
    echo ""
    echo "🔧 What this solution does:"
    echo "  ✅ JavaScript helpers proven to work (from debug_indexeddb.html)"
    echo "  ✅ Dart code calls these reliable JavaScript functions"
    echo "  ✅ Multiple fallback methods for maximum compatibility"
    echo "  ✅ Detailed logging to track conversion success"
    echo ""
    echo "🎯 This should fix the empty data issue because:"
    echo "  - Uses the same JS methods that work in debug_indexeddb.html"
    echo "  - Eliminates dart:js_util compatibility issues"
    echo "  - Provides multiple conversion strategies"
    echo ""
    echo "🧪 Test it now:"
    echo "  1. Open http://localhost:8000"
    echo "  2. Check console (F12) for helper loading confirmation"
    echo "  3. Try: Initialize → Add Sample Data → Show All Records"
    echo "  4. Data should now display correctly!"
    echo ""
    
    if command -v python3 &> /dev/null; then
        read -p "🌐 Start the server to test the fix? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "🚀 Starting server - the fix should work now!"
            echo "📊 Look for 'JavaScript helper conversion successful' in console"
            cd web && python3 -m http.server 8000
        fi
    fi
else
    echo "❌ Compilation failed!"
    echo "Check for syntax errors in the Dart files"
    exit 1
fi
