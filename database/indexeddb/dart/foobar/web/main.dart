import 'dart:html' as html;
import 'package:foobar_indexeddb/foobar.dart';
import 'package:foobar_indexeddb/foobar_crud.dart';
import 'package:foobar_indexeddb/foobar_utility.dart';

// Global instances
late FooBarCrudService crudService;
late FooBarUtility utility;

void main() async {
  print('FooBar IndexedDB Demo starting...');
  
  // Initialize services
  crudService = FooBarCrudService();
  await crudService.init();
  utility = FooBarUtility(crudService);
  
  // Set up event listeners
  setupEventListeners();
  
  // Initial data load
  await refreshRecordsList();
  
  print('Application initialized successfully!');
}

void setupEventListeners() {
  // Create button
  html.querySelector('#createBtn')?.onClick.listen((_) async {
    await createFooBar();
  });
  
  // Refresh button
  html.querySelector('#refreshBtn')?.onClick.listen((_) async {
    await refreshRecordsList();
  });
  
  // Search button
  html.querySelector('#searchBtn')?.onClick.listen((_) async {
    await searchRecords();
  });
  
  // Export button
  html.querySelector('#exportBtn')?.onClick.listen((_) async {
    await exportDatabase();
  });
  
  // Import button
  html.querySelector('#importBtn')?.onClick.listen((_) async {
    await importDatabase();
  });
  
  // Sample file button
  html.querySelector('#sampleBtn')?.onClick.listen((_) async {
    await createSampleFile();
  });
  
  // Backup button
  html.querySelector('#backupBtn')?.onClick.listen((_) async {
    await backupDatabase();
  });
  
  // Clear database button
  html.querySelector('#clearBtn')?.onClick.listen((_) async {
    await clearDatabase();
  });
  
  // Enter key in search box
  html.querySelector('#searchInput')?.onKeyPress.listen((event) {
    if (event is html.KeyboardEvent && event.keyCode == html.KeyCode.ENTER) {
      searchRecords();
    }
  });
}

Future<void> createFooBar() async {
  try {
    // Get input values
    final fooInput = html.querySelector('#fooInput') as html.InputElement;
    final barInput = html.querySelector('#barInput') as html.InputElement;
    
    final foo = fooInput.value?.trim() ?? '';
    final barText = barInput.value?.trim() ?? '';
    
    if (foo.isEmpty || barText.isEmpty) {
      showMessage('Please fill in both fields', isError: true);
      return;
    }
    
    final bar = int.tryParse(barText);
    if (bar == null) {
      showMessage('Bar must be a valid number', isError: true);
      return;
    }
    
    // Create new FooBar
    final fooBar = FooBar(foo: foo, bar: bar);
    final created = await crudService.create(fooBar);
    
    // Clear inputs
    fooInput.value = '';
    barInput.value = '';
    
    // Show success message
    showMessage('Created FooBar with ID: ${created.id}');
    
    // Refresh list
    await refreshRecordsList();
  } catch (e) {
    showMessage('Error creating FooBar: $e', isError: true);
  }
}

Future<void> refreshRecordsList() async {
  try {
    final records = await crudService.getAll();
    displayRecords(records);
    updateRecordCount();
  } catch (e) {
    showMessage('Error loading records: $e', isError: true);
  }
}

Future<void> searchRecords() async {
  try {
    final searchInput = html.querySelector('#searchInput') as html.InputElement;
    final searchTerm = searchInput.value?.trim() ?? '';
    
    List<FooBar> records;
    if (searchTerm.isEmpty) {
      records = await crudService.getAll();
    } else {
      records = await crudService.searchByFoo(searchTerm);
    }
    
    displayRecords(records);
    showMessage('Found ${records.length} records');
  } catch (e) {
    showMessage('Error searching records: $e', isError: true);
  }
}

void displayRecords(List<FooBar> records) {
  final recordsDiv = html.querySelector('#records')!;
  recordsDiv.children.clear();
  
  if (records.isEmpty) {
    recordsDiv.appendHtml('<p>No records found</p>');
    return;
  }
  
  for (final record in records) {
    final recordDiv = html.DivElement()
      ..className = 'record';
    
    final infoDiv = html.DivElement()
      ..className = 'record-info'
      ..appendHtml('''
        <strong>ID:</strong> ${record.id}<br>
        <strong>Foo:</strong> ${html.htmlEscape.convert(record.foo)}<br>
        <strong>Bar:</strong> ${record.bar}
      ''');
    
    final actionsDiv = html.DivElement()
      ..className = 'record-actions';
    
    final editBtn = html.ButtonElement()
      ..text = 'Edit'
      ..onClick.listen((_) => editRecord(record));
    
    final deleteBtn = html.ButtonElement()
      ..text = 'Delete'
      ..className = 'danger'
      ..onClick.listen((_) => deleteRecord(record.id!));
    
    actionsDiv.children.addAll([editBtn, deleteBtn]);
    recordDiv.children.addAll([infoDiv, actionsDiv]);
    
    recordsDiv.children.add(recordDiv);
  }
}

Future<void> editRecord(FooBar record) async {
  try {
    // Simple prompt for demo - in real app, use a modal dialog
    final newFoo = html.window.prompt('Enter new foo value:', record.foo);
    if (newFoo == null || newFoo.isEmpty) return;
    
    final newBarStr = html.window.prompt('Enter new bar value:', record.bar.toString());
    if (newBarStr == null || newBarStr.isEmpty) return;
    
    final newBar = int.tryParse(newBarStr);
    if (newBar == null) {
      showMessage('Bar must be a valid number', isError: true);
      return;
    }
    
    // Update record
    final updated = FooBar(foo: newFoo, bar: newBar);
    await crudService.update(record.id!, updated);
    
    showMessage('Record updated successfully');
    await refreshRecordsList();
  } catch (e) {
    showMessage('Error updating record: $e', isError: true);
  }
}

Future<void> deleteRecord(String id) async {
  try {
    final confirm = html.window.confirm('Are you sure you want to delete this record?');
    if (!confirm) return;
    
    await crudService.delete(id);
    showMessage('Record deleted successfully');
    await refreshRecordsList();
  } catch (e) {
    showMessage('Error deleting record: $e', isError: true);
  }
}

Future<void> exportDatabase() async {
  try {
    final count = await utility.exportToJsonFile();
    showMessage('Exported $count records to JSON file');
  } catch (e) {
    showMessage('Error exporting database: $e', isError: true);
  }
}

Future<void> importDatabase() async {
  try {
    final count = await utility.importFromJsonFile();
    showMessage('Imported $count records from JSON file');
    await refreshRecordsList();
  } catch (e) {
    showMessage('Error importing database: $e', isError: true);
  }
}

Future<void> createSampleFile() async {
  try {
    await utility.createSampleJsonFile();
    showMessage('Sample JSON file created and downloaded');
  } catch (e) {
    showMessage('Error creating sample file: $e', isError: true);
  }
}

Future<void> backupDatabase() async {
  try {
    final filename = await utility.backupDatabase();
    showMessage('Database backed up to: $filename');
  } catch (e) {
    showMessage('Error backing up database: $e', isError: true);
  }
}

Future<void> clearDatabase() async {
  try {
    final confirm = html.window.confirm(
      'WARNING: This will delete ALL records! Are you sure?'
    );
    if (!confirm) return;
    
    final count = await utility.clearDatabase();
    showMessage('Cleared $count records from database');
    await refreshRecordsList();
  } catch (e) {
    showMessage('Error clearing database: $e', isError: true);
  }
}

Future<void> updateRecordCount() async {
  try {
    final count = await utility.count();
    html.querySelector('#recordCount')?.text = count.toString();
  } catch (e) {
    html.querySelector('#recordCount')?.text = 'Error';
  }
}

void showMessage(String message, {bool isError = false}) {
  final messageDiv = html.querySelector('#message') as html.DivElement;
  messageDiv.text = message;
  messageDiv.style.display = 'block';
  messageDiv.className = isError ? 'error' : 'success';
  
  // Hide message after 5 seconds
  Future.delayed(Duration(seconds: 5), () {
    messageDiv.style.display = 'none';
  });
}
