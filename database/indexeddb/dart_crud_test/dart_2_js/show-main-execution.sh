#!/bin/bash

# Show that main() actually executes by examining the compiled JS
echo "🔍 Examining how main() is called in compiled JavaScript"
echo "====================================================="

# Compile the Dart to see the output
dart compile js web/main.dart -o temp_main.js

echo ""
echo "🎯 Looking for main() calls in compiled JavaScript:"
echo "------------------------------------------------"

# Search for main function calls
grep -n "main(" temp_main.js | head -3

echo ""
echo "📄 Last few lines of compiled JavaScript (where main gets called):"
echo "----------------------------------------------------------------"

# Show the end of the file where main() typically gets invoked
tail -10 temp_main.js

# Clean up
rm -f temp_main.js*

echo ""
echo "💡 The main() function IS called - it's how your Dart web app starts!"
