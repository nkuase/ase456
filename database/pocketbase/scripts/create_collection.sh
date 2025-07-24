#!/bin/bash

echo "🔐 Getting authentication token..."
TOKEN=$(curl -s -X POST "http://127.0.0.1:8090/api/collections/_superusers/auth-with-password" \
  -H "Content-Type: application/json" \
  -d '{"identity": "admin@example.com", "password": "admin123456"}' | \
  grep -o '"token":"[^"]*' | cut -d'"' -f4)

echo "✅ Token received!"

echo "📝 Updating students collection with fields..."

# Update the collection with proper field schema
curl -X PATCH "http://127.0.0.1:8090/api/collections/students" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
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

echo -e "\n✅ Collection updated!"

echo "🔍 Verifying collection structure..."
curl -H "Authorization: Bearer $TOKEN" \
  "http://127.0.0.1:8090/api/collections/students"