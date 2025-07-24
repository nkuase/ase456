#!/bin/bash

# Examine the compiled JavaScript to find where main() is called
echo "🔍 Finding where main() gets called in compiled JavaScript"
echo "========================================================"

# Compile the Dart to JavaScript
echo "📝 Compiling Dart to JavaScript..."
dart compile js web/main.dart -o examine_main.js

if [ $? -eq 0 ]; then
    echo "✅ Compilation successful!"
    
    echo ""
    echo "📊 File statistics:"
    echo "  Total lines: $(wc -l < examine_main.js)"
    echo "  File size: $(ls -lh examine_main.js | awk '{print $5}')"
    
    echo ""
    echo "🎯 Last 10 lines of compiled JavaScript (where main() gets called):"
    echo "================================================================="
    tail -10 examine_main.js | nl -v $(( $(wc -l < examine_main.js) - 9 ))
    
    echo ""
    echo "🔍 Searching for main() function calls:"
    echo "======================================="
    grep -n "main(" examine_main.js | head -5
    
    echo ""
    echo "🔍 Searching for the actual execution call:"
    echo "==========================================="
    grep -n -A2 -B2 "\.main(" examine_main.js | tail -10
    
    echo ""
    echo "📱 This is the JavaScript code that your index.html loads!"
    echo "   When the browser executes this JS file, it calls main() automatically."
    
    # Clean up
    rm -f examine_main.js*
    
else
    echo "❌ Compilation failed"
fi
