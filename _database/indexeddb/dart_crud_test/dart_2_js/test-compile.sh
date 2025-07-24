#!/bin/bash

# Quick Compilation Test
echo "🔧 Testing Dart compilation..."

# Test compilation
dart compile js web/main.dart -o test_output.js

if [ $? -eq 0 ]; then
    echo "✅ Compilation successful!"
    rm -f test_output.js test_output.js.deps test_output.js.map 2>/dev/null
    echo "🚀 Ready to run with webdev serve!"
else
    echo "❌ Compilation failed - check errors above"
fi
