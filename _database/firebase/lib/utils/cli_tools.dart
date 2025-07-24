import 'dart:io';
import 'dart:convert';
import '../models/student.dart';
import '../services/student_service.dart';
import '../services/secure_student_service.dart';
import '../migration/database_migration.dart';
import '../utils/performance_monitor.dart';

/// Command-line interface for Firebase Student Management System
/// Usage: dart cli_tools.dart <command> [options]
class FirebaseCLI {
  final StudentService _studentService = StudentService();
  final SecureStudentService _secureStudentService = SecureStudentService();
  final FirebasePerformanceTester _performanceTester = FirebasePerformanceTester();

  /// Main CLI entry point
  Future<void> run(List<String> args) async {
    if (args.isEmpty) {
      _printHelp();
      return;
    }

    final command = args[0].toLowerCase();

    try {
      switch (command) {
        case 'help':
          _printHelp();
          break;
        case 'create':
          await _handleCreate(args.skip(1).toList());
          break;
        case 'list':
          await _handleList(args.skip(1).toList());
          break;
        case 'get':
          await _handleGet(args.skip(1).toList());
          break;
        case 'update':
          await _handleUpdate(args.skip(1).toList());
          break;
        case 'delete':
          await _handleDelete(args.skip(1).toList());
          break;
        case 'import':
          await _handleImport(args.skip(1).toList());
          break;
        case 'export':
          await _handleExport(args.skip(1).toList());
          break;
        case 'backup':
          await _handleBackup(args.skip(1).toList());
          break;
        case 'stats':
          await _handleStats(args.skip(1).toList());
          break;
        case 'test':
          await _handleTest(args.skip(1).toList());
          break;
        case 'clean':
          await _handleClean(args.skip(1).toList());
          break;
        case 'migrate':
          await _handleMigrate(args.skip(1).toList());
          break;
        case 'interactive':
          await _runInteractiveMode();
          break;
        default:
          print('❌ Unknown command: $command');
          _printHelp();
      }
    } catch (e) {
      print('❌ Error executing command: $e');
      exit(1);
    }
  }

  /// Print help information
  void _printHelp() {
    print('''
🔥 Firebase Student Management CLI

USAGE:
  dart cli_tools.dart <command> [options]

COMMANDS:
  help                    Show this help message
  create <name> <age> <major>  Create a new student
  list [--major=<major>] [--limit=<n>]  List students
  get <id>               Get student by ID
  update <id> <field> <value>  Update student field
  delete <id>            Delete student by ID
  import <file>          Import students from JSON file
  export [file]          Export students to JSON file
  backup [file]          Create backup of all data
  stats                  Show database statistics
  test                   Run performance tests
  clean                  Clean up test data
  migrate <from> <to>    Migrate data between databases
  interactive            Start interactive mode

EXAMPLES:
  dart cli_tools.dart create "John Doe" 20 "Computer Science"
  dart cli_tools.dart list --major="Computer Science" --limit=10
  dart cli_tools.dart get abc123
  dart cli_tools.dart update abc123 age 21
  dart cli_tools.dart delete abc123
  dart cli_tools.dart import students.json
  dart cli_tools.dart export backup.json
  dart cli_tools.dart stats
  dart cli_tools.dart test
  dart cli_tools.dart interactive

For more information, visit: https://github.com/your-repo/firebase-student-app
''');
  }

  /// Handle create command
  Future<void> _handleCreate(List<String> args) async {
    if (args.length < 3) {
      print('❌ Usage: create <name> <age> <major>');
      return;
    }

    final name = args[0];
    final ageText = args[1];
    final major = args.skip(2).join(' '); // Handle majors with spaces

    print('📝 Creating student: $name, age $ageText, major: $major');

    final result = await _secureStudentService.createFromFormData(
      name: name,
      ageText: ageText,
      major: major,
    );

    result.fold(
      onSuccess: (id) {
        print('✅ Student created successfully!');
        print('   ID: $id');
        print('   Name: $name');
        print('   Age: $ageText');
        print('   Major: $major');
      },
      onError: (error) {
        print('❌ Failed to create student: $error');
      },
    );
  }

  /// Handle list command
  Future<void> _handleList(List<String> args) async {
    String? major;
    int? limit;

    // Parse options
    for (final arg in args) {
      if (arg.startsWith('--major=')) {
        major = arg.substring(8);
      } else if (arg.startsWith('--limit=')) {
        limit = int.tryParse(arg.substring(8));
      }
    }

    print('📋 Listing students${major != null ? ' (major: $major)' : ''}${limit != null ? ' (limit: $limit)' : ''}...');

    try {
      final result = major != null
          ? await _studentService.getStudentsByMajor(major)
          : await _studentService.readAll(limit: limit, orderBy: 'name');

      result.fold(
        onSuccess: (students) {
          if (students.isEmpty) {
            print('📭 No students found');
            return;
          }

          print('✅ Found ${students.length} students:');
          print('');
          print('${'ID'.padRight(20)} ${'Name'.padRight(25)} ${'Age'.padRight(5)} Major');
          print('-' * 80);

          for (final student in students) {
            final id = (student.id ?? 'unknown').padRight(20);
            final name = student.name.padRight(25);
            final age = student.age.toString().padRight(5);
            print('$id $name $age ${student.major}');
          }
        },
        onError: (error) {
          print('❌ Failed to list students: $error');
        },
      );
    } catch (e) {
      print('❌ Error: $e');
    }
  }

  /// Handle get command
  Future<void> _handleGet(List<String> args) async {
    if (args.isEmpty) {
      print('❌ Usage: get <id>');
      return;
    }

    final id = args[0];
    print('🔍 Getting student with ID: $id');

    final result = await _studentService.read(id);

    result.fold(
      onSuccess: (student) {
        if (student == null) {
          print('❌ Student not found');
          return;
        }

        print('✅ Student found:');
        print('   ID: ${student.id}');
        print('   Name: ${student.name}');
        print('   Age: ${student.age}');
        print('   Major: ${student.major}');
        print('   Created: ${student.createdAt ?? 'Unknown'}');
        print('   Updated: ${student.updatedAt ?? 'Unknown'}');
      },
      onError: (error) {
        print('❌ Failed to get student: $error');
      },
    );
  }

  /// Handle update command
  Future<void> _handleUpdate(List<String> args) async {
    if (args.length < 3) {
      print('❌ Usage: update <id> <field> <value>');
      print('   Fields: name, age, major');
      return;
    }

    final id = args[0];
    final field = args[1].toLowerCase();
    final value = args.skip(2).join(' ');

    print('✏️  Updating student $id: $field = $value');

    try {
      switch (field) {
        case 'name':
          final result = await _secureStudentService.updateNameSecurely(id, value);
          _handleUpdateResult(result, 'name');
          break;
        case 'age':
          final age = int.tryParse(value);
          if (age == null) {
            print('❌ Invalid age: $value');
            return;
          }
          final result = await _secureStudentService.updateAgeSecurely(id, age);
          _handleUpdateResult(result, 'age');
          break;
        case 'major':
          final result = await _secureStudentService.updateMajorSecurely(id, value);
          _handleUpdateResult(result, 'major');
          break;
        default:
          print('❌ Unknown field: $field');
          print('   Available fields: name, age, major');
      }
    } catch (e) {
      print('❌ Update failed: $e');
    }
  }

  void _handleUpdateResult(result, String field) {
    result.fold(
      onSuccess: (_) {
        print('✅ Student $field updated successfully');
      },
      onError: (error) {
        print('❌ Failed to update $field: $error');
      },
    );
  }

  /// Handle delete command
  Future<void> _handleDelete(List<String> args) async {
    if (args.isEmpty) {
      print('❌ Usage: delete <id>');
      return;
    }

    final id = args[0];
    
    // Confirm deletion
    print('⚠️  Are you sure you want to delete student $id? (y/N)');
    final confirmation = stdin.readLineSync()?.toLowerCase();
    
    if (confirmation != 'y' && confirmation != 'yes') {
      print('❌ Deletion cancelled');
      return;
    }

    print('🗑️  Deleting student $id...');

    final result = await _secureStudentService.deleteSecurely(id);

    result.fold(
      onSuccess: (_) {
        print('✅ Student deleted successfully');
      },
      onError: (error) {
        print('❌ Failed to delete student: $error');
      },
    );
  }

  /// Handle import command
  Future<void> _handleImport(List<String> args) async {
    if (args.isEmpty) {
      print('❌ Usage: import <file>');
      return;
    }

    final filename = args[0];
    print('📥 Importing students from $filename...');

    try {
      final file = File(filename);
      if (!file.existsSync()) {
        print('❌ File not found: $filename');
        return;
      }

      final content = await file.readAsString();
      final data = jsonDecode(content);

      if (data is! List) {
        print('❌ Invalid file format. Expected JSON array.');
        return;
      }

      final students = <Student>[];
      for (final item in data) {
        if (item is Map<String, dynamic>) {
          try {
            final student = Student(
              name: item['name'] ?? '',
              age: item['age'] ?? 0,
              major: item['major'] ?? '',
            );
            students.add(student);
          } catch (e) {
            print('⚠️  Skipping invalid student: $item');
          }
        }
      }

      if (students.isEmpty) {
        print('❌ No valid students found in file');
        return;
      }

      final result = await _secureStudentService.bulkCreateSecurely(students);

      result.fold(
        onSuccess: (ids) {
          print('✅ Successfully imported ${ids.length} students');
        },
        onError: (error) {
          print('❌ Import failed: $error');
        },
      );
    } catch (e) {
      print('❌ Import error: $e');
    }
  }

  /// Handle export command
  Future<void> _handleExport(List<String> args) async {
    final filename = args.isNotEmpty ? args[0] : 'students_export.json';
    print('📤 Exporting students to $filename...');

    final result = await _studentService.readAll();

    result.fold(
      onSuccess: (students) async {
        try {
          final data = students.map((s) => {
            'id': s.id,
            'name': s.name,
            'age': s.age,
            'major': s.major,
            'createdAt': s.createdAt?.toIso8601String(),
            'updatedAt': s.updatedAt?.toIso8601String(),
          }).toList();

          final file = File(filename);
          await file.writeAsString(jsonEncode(data));

          print('✅ Exported ${students.length} students to $filename');
        } catch (e) {
          print('❌ Export failed: $e');
        }
      },
      onError: (error) {
        print('❌ Failed to read students: $error');
      },
    );
  }

  /// Handle backup command
  Future<void> _handleBackup(List<String> args) async {
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final filename = args.isNotEmpty ? args[0] : 'backup_$timestamp.json';
    
    print('💾 Creating backup...');

    try {
      final migration = FirebaseToSQLiteMigration();
      await migration.backupToJson();
      print('✅ Backup completed: $filename');
    } catch (e) {
      print('❌ Backup failed: $e');
    }
  }

  /// Handle stats command
  Future<void> _handleStats(List<String> args) async {
    print('📊 Gathering statistics...');

    try {
      final stats = await _studentService.getStudentStatistics();

      if (stats.containsKey('error')) {
        print('❌ Failed to get statistics: ${stats['error']}');
        return;
      }

      print('✅ Database Statistics:');
      print('');
      print('📈 General:');
      print('   Total Students: ${stats['totalStudents']}');
      print('   Average Age: ${(stats['averageAge'] as double).toStringAsFixed(2)}');

      if (stats['majorCounts'] != null) {
        print('');
        print('🎓 Students by Major:');
        final majorCounts = stats['majorCounts'] as Map<String, int>;
        for (final entry in majorCounts.entries) {
          print('   ${entry.key.padRight(25)}: ${entry.value}');
        }
      }

      if (stats['ageDistribution'] != null) {
        print('');
        print('👥 Age Distribution:');
        final ageDistribution = stats['ageDistribution'] as Map<String, int>;
        for (final entry in ageDistribution.entries) {
          print('   ${entry.key.padRight(15)}: ${entry.value}');
        }
      }

      if (stats['oldestStudent'] != null) {
        final oldest = stats['oldestStudent'] as Student;
        print('');
        print('👴 Oldest Student: ${oldest.name} (${oldest.age} years)');
      }

      if (stats['youngestStudent'] != null) {
        final youngest = stats['youngestStudent'] as Student;
        print('👶 Youngest Student: ${youngest.name} (${youngest.age} years)');
      }
    } catch (e) {
      print('❌ Error getting statistics: $e');
    }
  }

  /// Handle test command
  Future<void> _handleTest(List<String> args) async {
    print('🧪 Running performance tests...');

    try {
      final results = await _performanceTester.runPerformanceTests();

      print('✅ Performance Test Results:');
      print('');

      for (final entry in results.entries) {
        final testName = entry.key;
        final result = entry.value;

        if (result is Map<String, dynamic>) {
          print('📊 $testName:');
          if (result.containsKey('error')) {
            print('   ❌ ${result['error']}');
          } else {
            print('   Iterations: ${result['iterations'] ?? 'N/A'}');
            print('   Total Time: ${result['totalTime'] ?? 'N/A'}ms');
            print('   Average Time: ${(result['averageTime'] ?? 0).toStringAsFixed(2)}ms');
          }
          print('');
        }
      }

      // Clean up test data
      await _performanceTester.cleanupTestData();
    } catch (e) {
      print('❌ Performance test failed: $e');
    }
  }

  /// Handle clean command
  Future<void> _handleClean(List<String> args) async {
    print('⚠️  This will delete ALL test data. Are you sure? (y/N)');
    final confirmation = stdin.readLineSync()?.toLowerCase();
    
    if (confirmation != 'y' && confirmation != 'yes') {
      print('❌ Cleanup cancelled');
      return;
    }

    print('🧹 Cleaning up test data...');

    try {
      await _performanceTester.cleanupTestData();
      print('✅ Test data cleaned up successfully');
    } catch (e) {
      print('❌ Cleanup failed: $e');
    }
  }

  /// Handle migrate command
  Future<void> _handleMigrate(List<String> args) async {
    if (args.length < 2) {
      print('❌ Usage: migrate <from> <to>');
      print('   Options: firebase, sqlite, pocketbase');
      return;
    }

    final from = args[0].toLowerCase();
    final to = args[1].toLowerCase();

    print('🔄 Migrating data from $from to $to...');

    try {
      if (from == 'firebase' && to == 'sqlite') {
        final migration = FirebaseToSQLiteMigration();
        await migration.exportFromFirebase();
      } else if (from == 'sqlite' && to == 'firebase') {
        final migration = FirebaseToSQLiteMigration();
        await migration.importToFirebase();
      } else if (from == 'pocketbase' && to == 'firebase') {
        final migration = PocketBaseToFirebaseMigration();
        await migration.migrate();
      } else {
        print('❌ Unsupported migration: $from -> $to');
        print('   Supported migrations:');
        print('   • firebase -> sqlite');
        print('   • sqlite -> firebase');
        print('   • pocketbase -> firebase');
      }
    } catch (e) {
      print('❌ Migration failed: $e');
    }
  }

  /// Run interactive mode
  Future<void> _runInteractiveMode() async {
    print('🎮 Firebase CLI Interactive Mode');
    print('Type "help" for commands or "exit" to quit');
    print('');

    while (true) {
      stdout.write('firebase> ');
      final input = stdin.readLineSync();
      
      if (input == null || input.toLowerCase() == 'exit') {
        print('Goodbye! 👋');
        break;
      }

      if (input.trim().isEmpty) continue;

      final args = input.split(' ');
      await run(args);
      print('');
    }
  }
}

/// Main entry point for CLI
void main(List<String> args) async {
  final cli = FirebaseCLI();
  await cli.run(args);
}
