# FooBar Collection Setup

**File**: `lib/foobar_create_collection.dart`  
**Purpose**: Create and configure the PocketBase collection schema for FooBar records.

## 📋 Overview

This module contains a script that sets up the database collection with proper schema and access rules. **Run this once** before using other modules.

## 🔧 Features

- ✅ **Admin Authentication**: Connects as admin to create collections
- ✅ **Schema Definition**: Creates `foo` (text) and `bar` (number) fields
- ✅ **Access Rules**: Configures CRUD permissions
- ✅ **Example Record**: Creates a sample record to verify setup

## 💡 Usage Examples

### Running the Setup Script

```bash
# Navigate to your project directory
cd /path/to/foobar

# Run the collection creation script
dart run lib/foobar_create_collection.dart
```

### Expected Output

```
Collection created with ID: <collection_id>
foo value: val1
bar value: 323
id value: <record_id>
```

### Manual Collection Creation

```dart
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('http://127.0.0.1:8090');

// Authenticate as admin
await pb.collection('_superusers')
    .authWithPassword('admin@example.com', 'admin123456');

// Create collection
final collection = await pb.collections.create(body: {
  'name': 'foobar',
  'type': 'base',
  'fields': [
    {'name': 'foo', 'type': 'text', 'required': true},
    {'name': 'bar', 'type': 'number', 'required': true},
  ]
});
```

## 🎯 Collection Schema

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | text | auto | Auto-generated unique identifier |
| `foo` | text | ✅ | String field |
| `bar` | number | ✅ | Integer field |
| `created` | datetime | auto | Auto-generated creation timestamp |
| `updated` | datetime | auto | Auto-generated update timestamp |

## 🔐 Access Rules

| Operation | Rule | Description |
|-----------|------|-------------|
| **Create** | `@request.auth.id != ""` | Only authenticated users |
| **Update** | `@request.auth.id != ""` | Only authenticated users |
| **Delete** | `@request.auth.id != ""` | Only authenticated users |
| **List** | `""` (empty) | Anyone can list records |
| **View** | `""` (empty) | Anyone can view records |

## ⚠️ Prerequisites

1. **PocketBase Server Running**: Ensure PocketBase is running on `http://127.0.0.1:8090`
2. **Admin Account**: Default credentials are `admin@example.com` / `admin123456`
3. **Dependencies**: `pocketbase` package installed

## 🚨 Troubleshooting

### Common Issues

```dart
// Error: Failed to authenticate
// Solution: Check admin credentials
await pb.collection('_superusers')
    .authWithPassword('your_admin_email', 'your_admin_password');

// Error: Collection already exists
// Solution: Collection name must be unique
// Either delete existing collection or use different name
```

### Verification

```dart
// Verify collection exists
final collections = await pb.collections.getList();
print('Available collections: ${collections.items.map((c) => c.name)}');

// Test record creation
final record = await pb.collection('foobar')
    .create(body: {'foo': 'test', 'bar': 42});
print('Test record created: ${record.id}');
```

## 🔗 Related Modules

- **[foobar.dart](./foobar.md)**: Data model used in this collection
- **[foobar_crud.dart](./foobar_crud.md)**: Operations on this collection
- **[foobar_utility.dart](./foobar_utility.md)**: Advanced operations on this collection
