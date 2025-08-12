#!/bin/bash

echo "🔐 Getting authentication token..."
TOKEN=$(curl -s -X POST "http://127.0.0.1:8090/api/collections/_superusers/auth-with-password" \
  -H "Content-Type: application/json" \
  -d '{"identity": "admin@example.com", "password": "admin123456"}' | \
  grep -o '"token":"[^"]*' | cut -d'"' -f4)
echo "✅ Token received!"

# Check if students collection exists
echo "🔍 Checking if students collection exists..."
COLLECTION_EXISTS=$(curl -s -H "Authorization: Bearer $TOKEN" \
  "http://127.0.0.1:8090/api/collections/students" | grep -c '"name":"students"')

if [ $COLLECTION_EXISTS -eq 1 ]; then
    echo "⚠️  Students collection already exists!"
    read -p "Do you want to delete and recreate it? (y/n): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Operation cancelled."
        exit 0
    fi
    
    echo "🗑️  Deleting existing students collection..."
    curl -X DELETE "http://127.0.0.1:8090/api/collections/students" \
      -H "Authorization: Bearer $TOKEN"
    echo -e "\n✅ Collection deleted!"
fi

echo "📝 Creating students collection with fields..."
curl -X POST "http://127.0.0.1:8090/api/collections" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "students",
    "type": "base",      
    "fields": [
      {
        "name": "id",
        "type": "text",
        "required": true,
        "primaryKey": true,
        "autogeneratePattern": "[a-z0-9]{15}",
        "system": true
      },
      {
        "name": "name",
        "type": "text",
        "required": true,
        "min": 1,
        "max": 100
      },
      {
        "name": "age",
        "type": "number",
        "required": true,
        "min": 0,
        "max": 150
      },
      {
        "name": "major",
        "type": "text",
        "required": true,
        "min": 1,
        "max": 100
      },
      {
        "name": "createdAt",
        "type": "date",
        "required": true
      }
    ]
  }'
echo -e "\n✅ Collection created!"

echo "🔍 Verifying collection structure..."
curl -H "Authorization: Bearer $TOKEN" \
  "http://127.0.0.1:8090/api/collections/students"