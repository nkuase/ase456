import 'dart:io';
import 'dart:convert';

/// Simple test script to verify JSON file reading works correctly
/// This helps debug path and file reading issues
Future<void> main() async {
  print('🧪 === JSON File Reading Test ===\n');
  
  try {
    // Show current working directory
    final currentDir = Directory.current;
    print('📁 Current working directory: ${currentDir.path}');
    
    // List files in current directory
    print('\n📋 Files in current directory:');
    await for (final entity in currentDir.list()) {
      if (entity is File) {
        print('   📄 ${entity.path.split('/').last}');
      } else if (entity is Directory) {
        print('   📁 ${entity.path.split('/').last}/');
      }
    }
    
    // Try different paths for data.json
    final possiblePaths = [
      'data.json',
      './data.json', 
      'prosseek/experiment/2025/DB_API/test/pocketbase/dart_crud_test/data.json',
      '/Users/smcho/GitHub/prosseek/experiment/2025/DB_API/test/pocketbase/dart_crud_test/data.json',
    ];
    
    print('\n🔍 Testing JSON file paths:');
    
    File? foundFile;
    String? foundPath;
    
    for (final path in possiblePaths) {
      final file = File(path);
      final exists = await file.exists();
      print('   ${exists ? "✅" : "❌"} $path');
      
      if (exists && foundFile == null) {
        foundFile = file;
        foundPath = path;
      }
    }
    
    if (foundFile == null) {
      print('\n❌ No data.json file found in any location!');
      return;
    }
    
    print('\n📖 Reading JSON file from: $foundPath');
    
    // Read and parse the JSON file
    final content = await foundFile.readAsString();
    print('   File size: ${content.length} characters');
    
    // Parse JSON
    final data = jsonDecode(content);
    print('   JSON type: ${data.runtimeType}');
    
    if (data is List) {
      print('   Record count: ${data.length}');
      
      if (data.isNotEmpty) {
        print('   First record: ${data[0]}');
        print('   First record type: ${data[0].runtimeType}');
        
        // Check if it's the expected structure
        final firstRecord = data[0];
        if (firstRecord is Map<String, dynamic> && firstRecord.containsKey('data')) {
          final nestedData = firstRecord['data'];
          print('   ✅ Structure is correct: has "data" field');
          print('   Nested data: $nestedData');
        } else {
          print('   ⚠️  Unexpected structure: missing "data" field');
        }
      }
    } else {
      print('   ⚠️  Expected List but got: ${data.runtimeType}');
    }
    
    print('\n🎉 JSON reading test completed successfully!');
    
  } catch (e, stackTrace) {
    print('\n❌ Error during JSON test: $e');
    print('Stack trace: $stackTrace');
  }
}
