#!/bin/bash

echo "🔧 Rebuilding with dart:js (more reliable JavaScript interop)..."

# Clean previous build
rm -f web/main.dart.js web/main.dart.js.map

# Get dependencies
dart pub get

# Compile with dart:js instead of dart:js_util
dart compile js web/main.dart -o web/main.dart.js

if [ $? -eq 0 ]; then
    echo "✅ Compilation successful with dart:js!"
    echo ""
    echo "🔄 Key changes made:"
    echo "  - Switched from dart:js_util to dart:js (more reliable)"
    echo "  - Using js.context['JSON'].callMethod() for JSON conversion"
    echo "  - Using js.JsObject.fromBrowserObject() for property access"
    echo "  - Added direct Map casting as fallback"
    echo ""
    echo "🧪 Test steps:"
    echo "  1. Open http://localhost:8000"
    echo "  2. Open Developer Tools (F12) → Console"
    echo "  3. Try: Initialize → Add Sample Data → Show All Records"
    echo "  4. Look for detailed conversion logs in console"
    echo ""
    
    if command -v python3 &> /dev/null; then
        read -p "🚀 Start test server now? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "🌐 Server starting at http://localhost:8000"
            echo "📊 The dart:js conversion should now work correctly!"
            cd web && python3 -m http.server 8000
        fi
    fi
else
    echo "❌ Compilation failed!"
    echo "Check for any missing dependencies or syntax errors"
    exit 1
fi
