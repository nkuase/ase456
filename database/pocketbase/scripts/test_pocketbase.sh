#!/bin/bash

# =============================================================================
# PocketBase Connection Test Script for Students
# =============================================================================
# This script helps verify that PocketBase is working correctly
# =============================================================================

echo "🧪 Testing PocketBase Connection..."
echo "================================="

POCKETBASE_URL="http://127.0.0.1:8090"

# Test 1: Health Check
echo "1️⃣ Testing PocketBase health..."
if curl -s "$POCKETBASE_URL/api/health" > /dev/null 2>&1; then
    echo "   ✅ PocketBase server is running"
else
    echo "   ❌ PocketBase server is NOT running"
    echo "   💡 Run your create_users.sh script first!"
    exit 1
fi

# Test 2: Admin Panel Access
echo ""
echo "2️⃣ Testing admin panel access..."
if curl -s "$POCKETBASE_URL/_/" > /dev/null 2>&1; then
    echo "   ✅ Admin panel is accessible"
    echo "   🌐 Access it at: $POCKETBASE_URL/_/"
    echo "   🔑 Login with: admin@example.com / admin123456"
else
    echo "   ❌ Admin panel is not accessible"
fi

# Test 3: API Access
echo ""
echo "3️⃣ Testing API access..."
if curl -s "$POCKETBASE_URL/api/" > /dev/null 2>&1; then
    echo "   ✅ API is accessible"
    echo "   📡 API endpoint: $POCKETBASE_URL/api/"
else
    echo "   ❌ API is not accessible"
fi

# Test 4: Check if users exist
echo ""
echo "4️⃣ Testing user authentication..."
AUTH_RESPONSE=$(curl -s -X POST "$POCKETBASE_URL/api/collections/users/auth-with-password" \
    -H "Content-Type: application/json" \
    -d '{"identity":"user@example.com","password":"password"}')

if echo "$AUTH_RESPONSE" | grep -q "token"; then
    echo "   ✅ User authentication works"
    echo "   👤 Test user: user@example.com / password"
else
    echo "   ⚠️  User authentication failed (user might not exist yet)"
    echo "   💡 This is normal if you haven't run create_users.sh yet"
fi

echo ""
echo "================================="
echo "🎯 Next Steps for Students:"
echo "================================="
echo "1. If all tests pass, run your Dart script:"
echo "   dart run /Users/chos5/github/nkuase/ase456/database/pocketbase/lib/main.dart"
echo ""
echo "2. If tests fail, run the setup script first:"
echo "   ./create_users.sh"
echo ""
echo "3. Monitor the PocketBase logs:"
echo "   tail -f ~/pocketbase/pocketbase.log"
echo ""
echo "4. Access the admin panel to see collections:"
echo "   $POCKETBASE_URL/_/"
echo "================================="
