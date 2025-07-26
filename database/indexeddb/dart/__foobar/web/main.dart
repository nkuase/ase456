import 'dart:html' as html;
import '../lib/foobar.dart';
import '../lib/foobar_crud.dart';
import '../lib/foobar_utility.dart';

/// Main entry point for the FooBar IndexedDB demo application
/// This demonstrates all CRUD operations and utility functions
void main() async {
  print('🚀 Starting FooBar IndexedDB Demo');
  
  // Initialize the UI
  setupUI();
}

/// Setup the user interface with buttons for different operations
void setupUI() {
  final body = html.document.body!;
  
  // Create title
  final title = html.HeadingElement.h1()
    ..text = 'FooBar IndexedDB Demo'
    ..style.color = 'blue'
    ..style.fontFamily = 'Arial, sans-serif';
  
  // Create status div with proper CSS for line breaks
  final statusDiv = html.DivElement()
    ..id = 'status'
    ..style.padding = '10px'
    ..style.border = '1px solid #ccc'
    ..style.margin = '10px 0'
    ..style.backgroundColor = '#f9f9f9'
    ..style.fontFamily = 'monospace'
    ..style.fontSize = '12px'
    ..style.height = '300px'
    ..style.overflowY = 'auto'
    ..style.whiteSpace = 'pre-wrap'  // This preserves whitespace and line breaks
    ..style.lineHeight = '1.4';

  // Add initial message
  addStatus('Ready to start...');

  // Create buttons container
  final buttonsDiv = html.DivElement()
    ..style.margin = '10px 0';

  // Add all buttons
  buttonsDiv.children.addAll([
    createButton('Initialize Database', initializeDatabase),
    createButton('Add Sample Data', addSampleData),
    createButton('Show All Records', showAllRecords),
    createButton('Search Records', searchRecords),
    createButton('Update Record', updateRecord),
    createButton('Delete Record', deleteRecord),
    createButton('Export to JSON', exportToJson),
    createButton('Import from JSON', importFromJson),
    createButton('Clear Database', clearDatabase),
    createButton('Show Statistics', showStatistics),
  ]);

  // Add elements to page
  body.children.addAll([title, buttonsDiv, statusDiv]);
}

/// Create a styled button with click handler
html.ButtonElement createButton(String text, Function() onClick) {
  return html.ButtonElement()
    ..text = text
    ..style.padding = '8px 12px'
    ..style.margin = '5px'
    ..style.backgroundColor = '#4CAF50'
    ..style.color = 'white'
    ..style.border = 'none'
    ..style.borderRadius = '4px'
    ..style.cursor = 'pointer'
    ..onClick.listen((_) => onClick());
}

/// Add message to status area with proper line breaks
void addStatus(String message) {
  final statusDiv = html.document.getElementById('status');
  final timestamp = DateTime.now().toString().substring(11, 19);
  
  // Get current content and add new line
  final currentText = statusDiv?.text ?? '';
  final newText = currentText + '[$timestamp] $message\n';
  
  if (statusDiv != null) {
    statusDiv.text = newText;
    statusDiv.scrollTop = statusDiv.scrollHeight;
  }
  
  print(message);
}

// Global variables for demo
FooBarCrudService? crudService;
FooBarUtility? utility;

/// Initialize the IndexedDB database
Future<void> initializeDatabase() async {
  try {
    addStatus('Initializing IndexedDB...');
    
    crudService = FooBarCrudService();
    await crudService!.initialize();
    
    utility = FooBarUtility(crudService!);
    
    addStatus('✅ Database initialized successfully');
  } catch (e) {
    addStatus('❌ Failed to initialize database: $e');
  }
}

/// Add some sample data to the database
Future<void> addSampleData() async {
  try {
    if (utility == null) {
      addStatus('❌ Please initialize database first');
      return;
    }
    
    addStatus('Adding sample data...');
    final count = await utility!.importSampleData();
    addStatus('✅ Added $count sample records');
  } catch (e) {
    addStatus('❌ Failed to add sample data: $e');
  }
}

/// Show all records in the database
Future<void> showAllRecords() async {
  try {
    if (crudService == null) {
      addStatus('❌ Please initialize database first');
      return;
    }
    
    addStatus('Fetching all records...');
    final records = await crudService!.getAll();
    
    if (records.isEmpty) {
      addStatus('📭 No records found');
    } else {
      addStatus('📋 Found ${records.length} records:');
      for (int i = 0; i < records.length; i++) {
        final record = records[i];
        addStatus('  ${i + 1}. ID: ${record.id}, foo: "${record.foo}", bar: ${record.bar}');
      }
    }
  } catch (e) {
    addStatus('❌ Failed to fetch records: $e');
  }
}

/// Search for records containing "Hello"
Future<void> searchRecords() async {
  try {
    if (crudService == null) {
      addStatus('❌ Please initialize database first');
      return;
    }
    
    const searchTerm = 'Hello';
    addStatus('Searching for records containing "$searchTerm"...');
    
    final records = await crudService!.searchByFoo(searchTerm);
    
    if (records.isEmpty) {
      addStatus('🔍 No records found containing "$searchTerm"');
    } else {
      addStatus('🔍 Found ${records.length} records:');
      for (final record in records) {
        addStatus('  - ID: ${record.id}, foo: "${record.foo}", bar: ${record.bar}');
      }
    }
  } catch (e) {
    addStatus('❌ Failed to search records: $e');
  }
}

/// Update the first record found
Future<void> updateRecord() async {
  try {
    if (crudService == null) {
      addStatus('❌ Please initialize database first');
      return;
    }
    
    addStatus('Looking for record to update...');
    final records = await crudService!.getAll();
    
    if (records.isEmpty) {
      addStatus('❌ No records found to update');
      return;
    }
    
    final firstRecord = records.first;
    addStatus('Updating record with ID: ${firstRecord.id}');
    
    // Create updated version
    final updatedRecord = FooBar(
      foo: '${firstRecord.foo} (UPDATED)',
      bar: firstRecord.bar + 1,
    );
    
    await crudService!.update(firstRecord.id!, updatedRecord);
    addStatus('✅ Record updated successfully');
  } catch (e) {
    addStatus('❌ Failed to update record: $e');
  }
}

/// Delete the last record found
Future<void> deleteRecord() async {
  try {
    if (crudService == null) {
      addStatus('❌ Please initialize database first');
      return;
    }
    
    addStatus('Looking for record to delete...');
    final records = await crudService!.getAll();
    
    if (records.isEmpty) {
      addStatus('❌ No records found to delete');
      return;
    }
    
    final lastRecord = records.last;
    addStatus('Deleting record with ID: ${lastRecord.id}');
    
    await crudService!.delete(lastRecord.id!);
    addStatus('✅ Record deleted successfully');
  } catch (e) {
    addStatus('❌ Failed to delete record: $e');
  }
}

/// Export all data to JSON file
Future<void> exportToJson() async {
  try {
    if (utility == null) {
      addStatus('❌ Please initialize database first');
      return;
    }
    
    addStatus('Exporting data to JSON...');
    final count = await utility!.exportToJsonFile();
    addStatus('✅ Exported $count records to JSON file');
  } catch (e) {
    addStatus('❌ Failed to export to JSON: $e');
  }
}

/// Import data from JSON file
Future<void> importFromJson() async {
  try {
    if (utility == null) {
      addStatus('❌ Please initialize database first');
      return;
    }
    
    addStatus('Opening file dialog for JSON import...');
    final count = await utility!.importFromJsonFile();
    addStatus('✅ Imported $count records from JSON file');
  } catch (e) {
    addStatus('❌ Failed to import from JSON: $e');
  }
}

/// Clear all data from database
Future<void> clearDatabase() async {
  try {
    if (utility == null) {
      addStatus('❌ Please initialize database first');
      return;
    }
    
    addStatus('⚠️  Clearing all data from database...');
    final count = await utility!.clearDatabase();
    addStatus('✅ Cleared $count records from database');
  } catch (e) {
    addStatus('❌ Failed to clear database: $e');
  }
}

/// Show database statistics
Future<void> showStatistics() async {
  try {
    if (utility == null) {
      addStatus('❌ Please initialize database first');
      return;
    }
    
    addStatus('Calculating database statistics...');
    final stats = await utility!.getStatistics();
    
    addStatus('📊 Database Statistics:');
    addStatus('  - Total Records: ${stats['totalRecords']}');
    addStatus('  - Average Bar Value: ${stats['averageBar']}');
    addStatus('  - Min Bar Value: ${stats['minBar']}');
    addStatus('  - Max Bar Value: ${stats['maxBar']}');
    addStatus('  - Unique Foo Values: ${stats['uniqueFooValues']}');
  } catch (e) {
    addStatus('❌ Failed to get statistics: $e');
  }
}
