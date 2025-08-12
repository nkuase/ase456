#!/bin/bash
# Simple serve script for development

echo "🌐 Starting Dart WebDev Development Server..."
echo ""
echo "📍 Default server location: http://localhost:8080"
echo "🛑 Press Ctrl+C to stop the server"
echo ""

# Start the server with default settings
dart pub global run webdev serve

# Note: WebDev serve uses these defaults:
# - Host: localhost  
# - Port: 8080
# - Auto-reload: enabled
#
# If you need different settings, you can specify:
# dart pub global run webdev serve web:9090  (for port 9090)
