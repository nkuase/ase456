#!/bin/bash

# IndexedDB Student Example Runner
# This script helps students run the IndexedDB examples easily

echo "🌐 IndexedDB Student Management Example"
echo "========================================"

# Check if Dart is installed
if ! command -v dart &> /dev/null; then
    echo "❌ Error: Dart is not installed or not in PATH"
    echo "Please install Dart from https://dart.dev/get-dart"
    exit 1
fi

echo "✅ Dart found: $(dart --version)"

# Check if webdev is available for serving web content
if ! dart pub global list | grep -q webdev; then
    echo "📦 Installing webdev for serving web content..."
    dart pub global activate webdev
    
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install webdev"
        exit 1
    fi
    
    echo "✅ webdev installed successfully"
else
    echo "✅ webdev is available"
fi

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
dart pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed successfully"

# Build for web platform
echo ""
echo "🔨 Building for web platform..."
dart compile js example_usage.dart -o web/main.dart.js

if [ $? -ne 0 ]; then
    echo "⚠️  Compilation warning, but continuing..."
fi

# Check for web directory and create basic HTML if needed
if [ ! -d "web" ]; then
    echo "📁 Creating web directory..."
    mkdir -p web
fi

if [ ! -f "web/index.html" ]; then
    echo "📄 Creating basic HTML file..."
    cat > web/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IndexedDB Example</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .container {
            background: #f5f5f5;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
        }
        .log {
            background: #000;
            color: #0f0;
            padding: 10px;
            border-radius: 4px;
            font-family: monospace;
            min-height: 200px;
            overflow-y: auto;
        }
    </style>
</head>
<body>
    <h1>🌐 IndexedDB Student Management Example</h1>
    <div class="container">
        <h2>📊 Database Operations Log</h2>
        <div id="log" class="log">Initializing IndexedDB example...<br></div>
    </div>
    
    <div class="container">
        <h2>🎯 What This Example Demonstrates</h2>
        <ul>
            <li>Creating and opening IndexedDB databases</li>
            <li>Creating object stores (similar to tables)</li>
            <li>Adding, reading, updating, and deleting records</li>
            <li>Using indexes for efficient queries</li>
            <li>Handling asynchronous database operations</li>
        </ul>
    </div>

    <script defer src="main.dart.js"></script>
</body>
</html>
EOF
fi

# Run tests
echo ""
echo "🧪 Running tests..."
dart test

if [ $? -ne 0 ]; then
    echo "⚠️  Some tests failed, but continuing with examples..."
fi

# Start web server and run example
echo ""
echo "🚀 Starting web server for IndexedDB examples..."
echo ""
echo "📍 The example will be available at: http://localhost:8080"
echo ""

# Check if port 8080 is available
if lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null; then
    echo "⚠️  Port 8080 is already in use. Trying port 8081..."
    PORT=8081
else
    PORT=8080
fi

echo "🌐 Opening browser automatically..."
echo "   If browser doesn't open, visit: http://localhost:$PORT"
echo ""

# Function to open browser based on OS
open_browser() {
    if command -v open > /dev/null; then
        # macOS
        open "http://localhost:$PORT"
    elif command -v xdg-open > /dev/null; then
        # Linux
        xdg-open "http://localhost:$PORT"
    elif command -v start > /dev/null; then
        # Windows
        start "http://localhost:$PORT"
    else
        echo "Please open http://localhost:$PORT in your browser manually"
    fi
}

# Start server in background and open browser
if command -v python3 > /dev/null; then
    echo "Using Python's built-in server..."
    cd web
    python3 -m http.server $PORT &
    SERVER_PID=$!
    cd ..
elif command -v python > /dev/null; then
    echo "Using Python's built-in server..."
    cd web
    python -m http.server $PORT &
    SERVER_PID=$!
    cd ..
elif command -v dart > /dev/null && dart pub global list | grep -q webdev; then
    echo "Using Dart webdev server..."
    webdev serve --hostname localhost --port $PORT &
    SERVER_PID=$!
else
    echo "❌ No suitable web server found!"
    echo "Please install Python or activate webdev:"
    echo "  dart pub global activate webdev"
    exit 1
fi

# Wait a moment for server to start
sleep 2

# Open browser
open_browser

echo ""
echo "🎯 IndexedDB Learning Instructions:"
echo "=================================="
echo ""
echo "1. 👀 Watch the browser console for database operations"
echo "2. 🔍 Open Browser DevTools (F12) > Application > Storage > IndexedDB"
echo "3. 📊 Observe how data is stored in the browser's IndexedDB"
echo "4. 🛠️  Try modifying the example_usage.dart file and refresh"
echo ""
echo "📚 Key Learning Points:"
echo "   • IndexedDB is asynchronous and transaction-based"
echo "   • Data persists in the browser until explicitly deleted"
echo "   • Each origin (domain) has its own IndexedDB namespace"
echo "   • Object stores are like tables in relational databases"
echo "   • Indexes allow efficient querying of non-key fields"
echo ""
echo "🔧 To stop the server, press Ctrl+C"
echo ""

# Wait for user to stop the server
trap "echo ''; echo '🛑 Stopping web server...'; kill $SERVER_PID 2>/dev/null; echo '✅ Server stopped'; exit 0" INT

# Keep script running
while kill -0 $SERVER_PID 2>/dev/null; do
    sleep 1
done

echo ""
echo "✅ Examples completed!"
echo ""
echo "📚 To learn more:"
echo "   - Read the README.md file"
echo "   - Explore the browser's DevTools > Application > IndexedDB"
echo "   - Modify example_usage.dart to practice"
echo "   - Compare with SQLite examples in ../sqlite/"
echo "   - Try the PocketBase examples in ../pocketbase/"
echo ""
echo "🎯 Next steps:"
echo "   - Learn about IndexedDB transactions and cursors"
echo "   - Experiment with complex queries and indexes"
echo "   - Try building a complete web application"
echo "   - Compare performance with other web storage options"
