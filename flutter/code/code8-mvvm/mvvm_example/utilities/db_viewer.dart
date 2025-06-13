import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;

class DatabaseViewer {
  final String _dbPath;
  Map<String, dynamic> _data = {};
  final bool debug;

  DatabaseViewer({this.debug = false}) : _dbPath = path.join(
    Platform.environment['HOME'] ?? '.',
    '.mvvm_example',
    'users.json'
  );

  Future<void> initialize() async {
    try {
      final dbDir = path.dirname(_dbPath);
      if (!await Directory(dbDir).exists()) {
        await Directory(dbDir).create(recursive: true);
      }

      if (await File(_dbPath).exists()) {
        final content = await File(_dbPath).readAsString();
        _data = json.decode(content);
      } else {
        _data = {'users': []};
        await _saveData();
      }

      if (debug) {
        print('Database initialized at: $_dbPath');
      }
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> _saveData() async {
    try {
      await File(_dbPath).writeAsString(json.encode(_data));
    } catch (e) {
      print('Error saving data: $e');
      rethrow;
    }
  }

  Future<void> createSampleUsers() async {
    try {
      await initialize();
      
      final sampleUsers = [
        {
          'id': 1,
          'name': 'John Doe',
          'email': 'john.doe@example.com',
          'address': '123 Main St, City',
          'profilePicture': 'https://picsum.photos/200/200?random=1',
          'posts': 15,
          'followers': 120,
          'following': 45
        },
        {
          'id': 2,
          'name': 'Jane Smith',
          'email': 'jane.smith@example.com',
          'address': '456 Oak Ave, Town',
          'profilePicture': 'https://picsum.photos/200/200?random=2',
          'posts': 28,
          'followers': 350,
          'following': 120
        },
        {
          'id': 3,
          'name': 'Bob Johnson',
          'email': 'bob.johnson@example.com',
          'address': '789 Pine Rd, Village',
          'profilePicture': 'https://picsum.photos/200/200?random=3',
          'posts': 42,
          'followers': 890,
          'following': 230
        }
      ];

      _data['users'] = sampleUsers;
      await _saveData();
      print('Sample users created successfully');
    } catch (e) {
      print('Error creating sample users: $e');
      rethrow;
    }
  }

  Future<void> displayAllUsers() async {
    try {
      await initialize();
      final users = _data['users'] as List;
      
      if (users.isEmpty) {
        print('No users found in the database.');
        return;
      }

      print('\n=== Users in Database ===\n');
      for (var user in users) {
        print('User:');
        print('  ID: ${user['id']}');
        print('  Name: ${user['name']}');
        print('  Email: ${user['email']}');
        print('  Address: ${user['address']}');
        print('  Profile Picture: ${user['profilePicture'] ?? 'Not set'}');
        print('  Posts: ${user['posts']}');
        print('  Followers: ${user['followers']}');
        print('  Following: ${user['following']}');
        print('------------------------');
      }
    } catch (e) {
      print('Error displaying users: $e');
      rethrow;
    }
  }

  Future<void> exportDatabase(String exportPath) async {
    try {
      await initialize();
      await File(exportPath).writeAsString(json.encode(_data));
      print('Database exported successfully to: $exportPath');
    } catch (e) {
      print('Error exporting database: $e');
      rethrow;
    }
  }

  Future<void> importDatabase(String importPath) async {
    try {
      final file = File(importPath);
      if (!file.existsSync()) {
        throw Exception('Import file not found: $importPath');
      }

      final content = await file.readAsString();
      _data = json.decode(content);
      await _saveData();
      print('Database imported successfully from: $importPath');
    } catch (e) {
      print('Error importing database: $e');
      rethrow;
    }
  }

  void close() {
    // No need to close anything for file-based storage
  }
}

void main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: dart db_viewer.dart <command> [options]');
    print('Commands:');
    print('  view              - Display all users');
    print('  create-sample     - Create sample users');
    print('  export <path>     - Export database to JSON file');
    print('  import <path>     - Import database from JSON file');
    exit(1);
  }

  final viewer = DatabaseViewer(debug: args.contains('--debug'));

  try {
    switch (args[0]) {
      case 'view':
        await viewer.displayAllUsers();
        break;
      case 'create-sample':
        await viewer.createSampleUsers();
        break;
      case 'export':
        if (args.length < 2) {
          print('Error: Export path not specified');
          exit(1);
        }
        await viewer.exportDatabase(args[1]);
        break;
      case 'import':
        if (args.length < 2) {
          print('Error: Import path not specified');
          exit(1);
        }
        await viewer.importDatabase(args[1]);
        break;
      default:
        print('Unknown command: ${args[0]}');
        exit(1);
    }
  } catch (e) {
    print('Error: $e');
    exit(1);
  } finally {
    viewer.close();
  }
} 