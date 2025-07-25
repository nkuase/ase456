#!/bin/bash

# =============================================================================
# PocketBase User Creation Script for Students
# =============================================================================
# This script demonstrates how to:
# 1. Check and manage PocketBase server status
# 2. Initialize PocketBase database
# 3. Create users programmatically
# 4. Test the setup with HTML files
# =============================================================================

# Configuration - Change POCKET_BASE_PATH to your installation directory
POCKET_BASE_PATH=$HOME/pocketbase
POCKET_BASE=$POCKET_BASE_PATH/pocketbase
POCKETBASE_URL="http://127.0.0.1:8090"

echo "======================================"
echo "PocketBase User Creation Script"
echo "======================================"

# Check if PocketBase executable exists
if [ ! -f "$POCKET_BASE" ]; then
    echo "❌ Error: PocketBase not found at $POCKET_BASE"
    echo "Please install PocketBase first or update POCKET_BASE_PATH"
    exit 1
fi

# 1. Check PocketBase version
echo "📋 Checking PocketBase version..."
$POCKET_BASE --version
echo ""

# 2. Initialize PocketBase (delete existing data if requested)
read -p "🗑️  Do you want to initialize PocketBase (delete existing pb_data)? [y/N]: " init_choice
if [[ $init_choice =~ ^[Yy]$ ]]; then
    echo "🗑️  Initializing PocketBase by removing pb_data directory..."
    rm -rf "$POCKET_BASE_PATH/pb_data"
    echo "✅ pb_data directory removed"
fi

# 3. Check if PocketBase is already running
echo "🔍 Checking if PocketBase is running..."
if curl -s "$POCKETBASE_URL/api/health" > /dev/null 2>&1; then
    echo "✅ PocketBase is already running at $POCKETBASE_URL"
else
    echo "⚠️  PocketBase is not running. Starting PocketBase server..."
    echo "📁 Working directory: $POCKET_BASE_PATH"
    
    # Start PocketBase in background
    cd "$POCKET_BASE_PATH"
    nohup $POCKET_BASE serve > pocketbase.log 2>&1 &
    POCKETBASE_PID=$!
    
    echo "🚀 PocketBase started with PID: $POCKETBASE_PID"
    echo "📝 Logs are being written to: $POCKET_BASE_PATH/pocketbase.log"
    
    # Wait for PocketBase to start
    echo "⏳ Waiting for PocketBase to start..."
    for i in {1..10}; do
        if curl -s "$POCKETBASE_URL/api/health" > /dev/null 2>&1; then
            echo "✅ PocketBase is now running!"
            break
        fi
        echo "   Attempt $i/10: Still waiting..."
        sleep 2
    done
    
    # Check if it started successfully
    if ! curl -s "$POCKETBASE_URL/api/health" > /dev/null 2>&1; then
        echo "❌ Failed to start PocketBase. Check the logs at $POCKET_BASE_PATH/pocketbase.log"
        exit 1
    fi
fi

echo ""
echo "======================================"
echo "How to Stop PocketBase:"
echo "======================================"
echo "Method 1 - Find and kill the process:"
echo "  ps aux | grep pocketbase"
echo "  kill [PID_NUMBER]"
echo ""
echo "Method 2 - Kill all pocketbase processes:"
echo "  pkill -f pocketbase"
echo ""
echo "Method 3 - If you have the PID from this session:"
if [ ! -z "$POCKETBASE_PID" ]; then
    echo "  kill $POCKETBASE_PID"
fi
echo "======================================"
echo ""

# 4. Create superuser (admin)
echo "👤 Creating superuser admin..."
$POCKET_BASE superuser upsert admin@example.com admin123456

# Wait a moment for the superuser to be created
sleep 1

# 5. Create regular user via API
echo "👥 Creating regular user via API..."
curl -X POST $POCKETBASE_URL/api/collections/users/records \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password","passwordConfirm":"password"}'

echo ""
echo ""
echo "======================================"
echo "✅ Setup Complete!"
echo "======================================"
echo "PocketBase Admin Panel: $POCKETBASE_URL/_/"
echo "Login with: admin@example.com / admin123456"
echo ""
echo "API Endpoint: $POCKETBASE_URL/api/"
echo "Health Check: $POCKETBASE_URL/api/health"
echo ""
echo "📁 Log file location: $POCKET_BASE_PATH/pocketbase.log"
echo ""
echo "======================================"
echo "Testing with HTML Files:"
echo "======================================"
echo "To test if PocketBase is working correctly:"
echo "1. Run any HTML files in this directory"
echo "2. Open them in your web browser"
echo "3. Check browser console for API responses"
echo "4. Verify data operations work correctly"
echo ""
echo "Example HTML files you can create:"
echo "- test_connection.html (check API connectivity)"
echo "- test_auth.html (test user authentication)"
echo "- test_crud.html (test create, read, update, delete)"
echo ""
echo "💡 Tip: Use browser developer tools (F12) to monitor"
echo "   network requests and console logs while testing"
echo "======================================"
