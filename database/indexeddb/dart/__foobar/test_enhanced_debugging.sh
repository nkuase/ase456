#!/bin/bash

echo "🔬 Building Enhanced Debugging Version"

# Clean and rebuild
rm -f web/main.dart.js web/main.dart.js.map
dart pub get
dart compile js web/main.dart -o web/main.dart.js

if [ $? -eq 0 ]; then
    echo "✅ Enhanced debugging version compiled!"
    echo ""
    echo "🔍 This version will show detailed property access attempts:"
    echo "  - Direct property access (jsObject.id)"
    echo "  - Bracket notation (jsObject['id'])" 
    echo "  - Object.keys() iteration"
    echo "  - for...in loop"
    echo "  - Constructor and type information"
    echo ""
    echo "🎯 One of these methods should successfully extract the data!"
    echo ""
    
    if command -v python3 &> /dev/null; then
        read -p "🚀 Start server to see detailed property access logs? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "🌐 Starting server - watch console for detailed property access attempts!"
            cd web && python3 -m http.server 8000
        fi
    fi
else
    echo "❌ Compilation failed!"
    exit 1
fi
