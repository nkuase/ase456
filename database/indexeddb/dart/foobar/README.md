# FooBar IndexedDB Application

A Dart web application demonstrating how to use IndexedDB for client-side data storage in the browser.

## Features

- **CRUD Operations**: Create, Read, Update, and Delete FooBar records
- **Search**: Search records by foo value
- **Import/Export**: Import and export data as JSON files
- **Backup**: Create timestamped backups of your database
- **Browser Storage**: All data is stored locally in IndexedDB

## Prerequisites

- Dart SDK (>= 2.17.0)
- Modern web browser with IndexedDB support

## Installation

1. Install dependencies:
```bash
dart pub get
```

2. Build the web application:
```bash
dart run build_runner build --release -o web:build
```

## Development

For development with hot reload:
```bash
dart run build_runner serve web:8080
```

Then open http://localhost:8080 in your browser.

## Running Tests

```bash
dart test
```

Note: Some tests require a browser environment. For browser tests:
```bash
dart test -p chrome
```

## Project Structure

```
foobar/
├── lib/
│   ├── foobar.dart              # FooBar model class
│   ├── foobar_crud.dart         # CRUD operations using IndexedDB
│   ├── foobar_utility.dart      # Import/export utilities
│   └── indexeddb_js.dart        # JavaScript interop for IndexedDB
├── web/
│   ├── index.html               # Main HTML page
│   └── main.dart                # Web application entry point
├── test/
│   └── foobar_test.dart         # Unit tests
├── pubspec.yaml                 # Dart package configuration
└── README.md                    # This file
```

## Usage

1. **Create Records**: Enter foo (text) and bar (number) values, then click "Create FooBar"
2. **Search**: Type in the search box to filter records by foo value
3. **Edit**: Click the "Edit" button on any record to modify it
4. **Delete**: Click the "Delete" button to remove a record
5. **Export**: Click "Export to JSON" to download all records
6. **Import**: Click "Import from JSON" to load records from a file
7. **Sample Data**: Click "Create Sample File" to download a sample JSON file
8. **Backup**: Click "Backup Database" to create a timestamped backup

## Data Format

The JSON format for import/export:
```json
[
  {"foo": "Hello World", "bar": 42},
  {"foo": "Dart Programming", "bar": 100}
]
```

## Browser Compatibility

This application requires a modern browser with IndexedDB support:
- Chrome/Edge: Version 24+
- Firefox: Version 16+
- Safari: Version 10+

## Differences from PocketBase Version

- **Client-side only**: All data is stored in the browser (IndexedDB)
- **No server required**: Runs entirely in the browser
- **File operations**: Uses browser File API for import/export
- **Auto-incrementing IDs**: IndexedDB generates numeric IDs automatically

## License

This project is for educational purposes.
