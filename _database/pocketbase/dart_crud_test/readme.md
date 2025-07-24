# Dart PocketBase CRUD Tests

This directory contains Dart equivalents of the JavaScript PocketBase CRUD tests, using the official **PocketBase Dart SDK** to interact with PocketBase.

```
dart pub add pocketbase
dart pub get
```


## Files

- `index.dart` - Main CRUD operations (equivalent to `index.js`)
- `new_collection.dart` - Collection creation (equivalent to `new_collection.js`)
- `data.json` - Test data for bulk import
- `README.md` - This file
- `runme.sh` - Convenient script to run the tests

## Prerequisites

1. **Install Dart** - Make sure you have Dart SDK installed
2. **Install PocketBase** - Download from https://pocketbase.io/
3. **Install Dependencies** - Run `dart pub get` in the main project directory

## Dependencies

The Dart code uses the official PocketBase Dart SDK:
```yaml
dependencies:
  pocketbase: ^0.18.0
```

## Setup

### 1. Create Super User
Navigate to your PocketBase directory and create a superuser:

```bash
pocketbase --dir="../db" superuser upsert hello@gmail.com 12345678
```

Expected output:
```
Successfully saved superuser "hello@gmail.com"!
```

### 2. Start PocketBase Server
```bash
pocketbase serve --dir="../db"
```

Expected output:
```
2025/06/07 19:11:48 Server started at http://127.0.0.1:8090
├─ REST API:  http://127.0.0.1:8090/api/
└─ Dashboard: http://127.0.0.1:8090/_/
```

### 3. Create a Regular User
1. Open your browser and go to: `http://localhost:8090/_/#/login`
2. Login with your superuser credentials: `hello@gmail.com` / `12345678`
3. Go to "users" collection in the left sidebar
4. Click "+ New record"
5. Create a user with email: `goodbye@gmail.com` and password: `12345678`

### 4. Create Collection Programmatically

Run the collection creation script:
```bash
dart new_collection.dart
```

This will create a "records" collection with:
- A `data` field of type JSON
- API rules requiring authentication for create/update/delete operations
- Public read access (empty listRule and viewRule)

## Running the Tests

### Run Main CRUD Operations
```bash
dart index.dart
```

This will perform the following operations:
1. **Authenticate** with `goodbye@gmail.com`
2. **Create** a single record with random data
3. **Upload** multiple records from `data.json`
4. **Read** records from the collection
5. **Update** a record (adds "P-" prefix to foo field)
6. **Delete** a specific record
7. **Delete all** remaining records

### Use the Convenient Run Script
```bash
chmod +x runme.sh
./runme.sh
```

The script offers options to:
1. Create collection only
2. Run CRUD tests only
3. Run both operations
4. Exit

## Expected Output

```
=== Dart PocketBase CRUD Test ===
✅ Authenticated successfully

--- CREATE OPERATIONS ---
Record uploaded: RecordModel(id: abc123, data: {data: {foo: xyz789, bar: 456}}, ...)
Created record: RecordModel(id: def456, data: {data: {foo: bar1}}, ...)
Created record: RecordModel(id: ghi789, data: {data: {foo: bar2}}, ...)
...
All records imported successfully.

--- READ OPERATIONS ---

--- UPDATE OPERATIONS ---
RecordModel(id: abc123, data: {data: {foo: P-xyz789}}, ...)

--- DELETE OPERATIONS ---
Deleted record: def456
Deleted record: abc123
...
All records deleted.
```

## PocketBase Dart SDK Usage

The Dart code uses the official PocketBase SDK methods:

### Authentication
```dart
// Regular user authentication
await pb.collection('users').authWithPassword(email, password);

// Superuser authentication  
await pb.collection('_superusers').authWithPassword(email, password);
```

### Collection Management
```dart
// Create collection
await pb.collections.create(body: {
  'name': 'records',
  'type': 'base',
  'schema': [...],
  // API rules
});
```

### Record Operations
```dart
// Create record
final record = await pb.collection('records').create(body: data);

// Read records with pagination
final result = await pb.collection('records').getList(
  page: 1,
  perPage: 10,
);

// Update record
await pb.collection('records').update(id, body: data);

// Delete record
await pb.collection('records').delete(id);
```

## Configuration Details

### Collection Setup
The "records" collection is created with these API rules:

```
createRule: '@request.auth.id != ""'  // Authenticated users can create
updateRule: '@request.auth.id != ""'  // Authenticated users can update  
deleteRule: '@request.auth.id != ""'  // Authenticated users can delete
listRule: ''                          // Anyone can list records
viewRule: ''                          // Anyone can view records
```

### Data Structure
Records are stored with this structure:
```json
{
  "id": "generated_id",
  "data": {
    "foo": "random_string_or_value",
    "bar": 123
  },
  "created": "2025-06-07 12:34:56.789Z",
  "updated": "2025-06-07 12:34:56.789Z"
}
```

## Troubleshooting

### Authentication Issues
- Ensure the user `goodbye@gmail.com` exists in your PocketBase
- Check that the password is exactly `12345678`
- Verify PocketBase is running on `http://127.0.0.1:8090`

### Collection Issues
- Run `new_collection.dart` first to create the "records" collection
- Check that the superuser `hello@gmail.com` exists and has correct permissions

### Permission Issues
- Verify API rules are set correctly
- Check that the authenticated user has the required permissions
- Ensure the collection exists before running CRUD operations

### SDK Issues
- Make sure you've run `dart pub get` to install the PocketBase SDK
- Verify the SDK version is compatible (using ^0.18.0)

## Differences from JavaScript Version

1. **SDK Usage**: Uses official PocketBase Dart SDK instead of PocketBase JS SDK
2. **Type Safety**: Dart provides compile-time type checking
3. **RecordModel**: Returns `RecordModel` objects instead of plain JavaScript objects
4. **Error Handling**: Uses Dart's try/catch patterns
5. **File I/O**: Uses Dart's `File` class for reading JSON data
6. **Random Generation**: Custom implementation equivalent to JavaScript's random functions

The functionality and API calls are equivalent between JavaScript and Dart versions, both using their respective official PocketBase SDKs.

## Key SDK Methods Used

| Operation | JavaScript SDK | Dart SDK |
|-----------|---------------|----------|
| **Auth** | `pb.collection('users').authWithPassword()` | `pb.collection('users').authWithPassword()` |
| **Create** | `pb.collection('records').create()` | `pb.collection('records').create(body: data)` |
| **Read** | `pb.collection('records').getList()` | `pb.collection('records').getList(page: n, perPage: n)` |
| **Update** | `pb.collection('records').update()` | `pb.collection('records').update(id, body: data)` |
| **Delete** | `pb.collection('records').delete()` | `pb.collection('records').delete(id)` |
| **Collection** | `pb.collections.create()` | `pb.collections.create(body: schema)` |

Both implementations provide the same functionality with their respective language idioms and SDK patterns.
