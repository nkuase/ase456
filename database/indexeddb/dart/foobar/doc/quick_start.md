# Quick Start Guide - IndexedDB with Dart

## 1. Installation

```bash
cd /Users/smcho/github/nkuase/ase456/database/indexeddb/dart/foobar
dart pub get
```

## 2. Running the Application

### Development Mode (with hot reload)
```bash
./dev_server.sh
# Or manually:
dart run build_runner serve web:8080
```

### Production Build
```bash
./build.sh
# Or manually:
dart run build_runner build --release -o web:build
```

## 3. Testing the Application

1. Open http://localhost:8080 in your browser
2. Try creating some FooBar records
3. Test search functionality
4. Export data to JSON
5. Clear database and import from JSON

## 4. Code Structure

### Model (lib/foobar.dart)
```dart
class FooBar {
  String? id;
  String foo;
  int bar;
}
```

### CRUD Service (lib/foobar_crud.dart)
- `create()` - Add new record
- `getById()` - Get single record
- `getAll()` - Get all records
- `update()` - Update existing record
- `delete()` - Delete record
- `searchByFoo()` - Search by foo value

### Utility Service (lib/foobar_utility.dart)
- `importFromJsonFile()` - Import from file
- `exportToJsonFile()` - Export to file
- `count()` - Count total records
- `exists()` - Check if record exists

## 5. Key Differences from PocketBase Version

| Feature | PocketBase | IndexedDB |
|---------|------------|-----------|
| Storage | Server database | Browser storage |
| Network | Required | Not required |
| Offline | Limited | Full support |
| File I/O | Direct file system | Browser File API |
| IDs | String UUIDs | Auto-increment numbers |

## 6. Common Tasks

### Create a Record
```dart
final foobar = FooBar(foo: 'Hello', bar: 42);
final created = await crudService.create(foobar);
print('Created with ID: ${created.id}');
```

### Search Records
```dart
final results = await crudService.searchByFoo('Hello');
print('Found ${results.length} records');
```

### Export/Import
```dart
// Export
await utility.exportToJsonFile('backup.json');

// Import
await utility.importFromJsonFile(); // Opens file picker
```

## 7. Troubleshooting

### Build Errors
- Make sure Dart SDK >= 2.17.0
- Run `dart pub get` to install dependencies
- Check for syntax errors in code

### IndexedDB Errors
- Check browser console (F12)
- Ensure browser supports IndexedDB
- Try clearing browser data if database is corrupted

### Can't See Data
- Check Application tab in browser DevTools
- Look under IndexedDB → foobar_database → foobar

## 8. Next Steps

1. Modify the model to add more fields
2. Add validation to the forms
3. Implement sorting functionality
4. Add data visualization
5. Create a PWA (Progressive Web App)
