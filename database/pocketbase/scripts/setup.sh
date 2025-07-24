#!/bin/bash

POCKET_BASE_PATH=$HOME/pocketbase
POCKET_BASE=$POCKET_BASE_PATH/pocketbase

echo "🔍 PocketBase Admin Diagnostics"
echo "=============================="

echo "1. Checking PocketBase version..."
$POCKET_BASE --version

echo "\n2. Checking data directory..."
ls -la $POCKET_BASE_PATH/pb_data/ 2>/dev/null || echo "No pb_data directory found"

echo "\n3. Testing admin endpoints..."
echo "Testing GET /api/admins:"
curl -s http://127.0.0.1:8090/api/admins

echo "\nTesting auth endpoint:"
curl -s -X POST http://127.0.0.1:8090/api/admins/auth-with-password \
  -H "Content-Type: application/json" \
  -d '{"identity": "admin@example.com", "password": "admin123456"}'

echo "\n4. Checking collections (should fail without auth):"
curl -s http://127.0.0.1:8090/api/collections