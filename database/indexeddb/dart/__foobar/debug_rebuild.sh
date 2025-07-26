#!/bin/bash

echo "🔧 Rebuilding with Enhanced Debugging..."

# Get dependencies
dart pub get

# Clean and rebuild
rm -f web/main.dart.js
echo "🗑️ Removed old JavaScript file"

# Compile with more verbose output  
dart compile js web/main.dart -o web/main.dart.js

if [ $? -eq 0 ]; then
    echo "✅ Compilation successful!"
    echo ""
    echo "🧪 Enhanced debugging features added:"
    echo "  - Detailed JavaScript object type logging"
    echo "  - Multiple conversion method attempts"
    echo "  - Step-by-step property access logging"
    echo "  - Fallback error handling"
    echo ""
    echo "🔍 To debug the empty data issue:"
    echo "  1. Open http://localhost:8000"
    echo "  2. Open browser Developer Tools (F12)"
    echo "  3. Watch Console tab for detailed logs"
    echo "  4. Try: Initialize → Add Sample Data → Show All Records"
    echo "  5. Also test: http://localhost:8000/debug_indexeddb.html"
    echo ""
    
    # Auto-start server if Python available
    if command -v python3 &> /dev/null; then
        read -p "🌐 Start debugging server now? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "🚀 Starting server at http://localhost:8000"
            echo "📊 Check browser console for detailed conversion logs!"
            cd web && python3 -m http.server 8000
        fi
    fi
else
    echo "❌ Compilation failed!"
    exit 1
fi
