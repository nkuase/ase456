import '../models/student.dart';
import '../services/student_service.dart';
import '../services/firebase_result.dart';

/// Migration utilities for moving data between Firebase and other databases
/// This demonstrates how to export/import data from Firebase to other systems

/// Example SQLite helper class (would be implemented separately)
class DatabaseHelper {
  // This would contain SQLite operations
  int insertStudent(Student student) {
    // SQLite implementation would go here
    print('SQLite: Inserting student ${student.name}');
    return DateTime.now().millisecondsSinceEpoch; // Mock ID
  }

  List<Student> getAllStudents() {
    // SQLite implementation would go here
    print('SQLite: Getting all students');
    return []; // Mock empty list
  }

  void close() {
    print('SQLite: Closing database connection');
  }
}

/// Example PocketBase class (would be implemented separately)
class PocketBase {
  final String url;
  
  PocketBase(this.url);
  
  PocketBaseCollection collection(String name) {
    return PocketBaseCollection(name);
  }
}

class PocketBaseCollection {
  final String name;
  
  PocketBaseCollection(this.name);
  
  Future<PocketBaseRecord> create({required Map<String, dynamic> body}) async {
    print('PocketBase: Creating record in $name');
    return PocketBaseRecord('mock_id', body);
  }
  
  Future<PocketBaseListResult> getList() async {
    print('PocketBase: Getting list from $name');
    return PocketBaseListResult([]);
  }
}

class PocketBaseRecord {
  final String id;
  final Map<String, dynamic> data;
  
  PocketBaseRecord(this.id, this.data);
}

class PocketBaseListResult {
  final List<PocketBaseRecord> items;
  
  PocketBaseListResult(this.items);
}

/// Firebase to SQLite migration
class FirebaseToSQLiteMigration {
  final StudentService _firebaseService = StudentService();
  final DatabaseHelper _sqliteHelper = DatabaseHelper();

  /// Export all students from Firebase to SQLite
  Future<void> exportFromFirebase() async {
    print('📤 Starting Firebase to SQLite migration...');
    
    try {
      final result = await _firebaseService.readAll();
      
      result.fold(
        onSuccess: (students) async {
          print('Found ${students.length} students to export');
          
          int successCount = 0;
          int errorCount = 0;
          
          for (final student in students) {
            try {
              // Convert to SQLite format and save
              final sqliteStudent = Student(
                name: student.name,
                age: student.age,
                major: student.major,
              );
              
              final id = _sqliteHelper.insertStudent(sqliteStudent);
              print('✅ Exported: ${student.name} (SQLite ID: $id)');
              successCount++;
            } catch (e) {
              print('❌ Failed to export ${student.name}: $e');
              errorCount++;
            }
          }
          
          print('📊 Migration Summary:');
          print('   • Successful: $successCount');
          print('   • Failed: $errorCount');
          print('   • Total: ${students.length}');
          print('✅ Firebase to SQLite migration completed');
        },
        onError: (error) {
          print('❌ Failed to read from Firebase: $error');
        },
      );
    } catch (e) {
      print('❌ Migration failed with unexpected error: $e');
    } finally {
      _sqliteHelper.close();
    }
  }

  /// Import students from SQLite to Firebase (reverse migration)
  Future<void> importToFirebase() async {
    print('📥 Starting SQLite to Firebase migration...');
    
    try {
      final sqliteStudents = _sqliteHelper.getAllStudents();
      print('Found ${sqliteStudents.length} students in SQLite');
      
      if (sqliteStudents.isEmpty) {
        print('⚠️ No students found in SQLite database');
        return;
      }

      int successCount = 0;
      int errorCount = 0;
      
      for (final student in sqliteStudents) {
        try {
          final result = await _firebaseService.create(student);
          
          result.fold(
            onSuccess: (id) {
              print('✅ Imported: ${student.name} (Firebase ID: $id)');
              successCount++;
            },
            onError: (error) {
              print('❌ Failed to import ${student.name}: $error');
              errorCount++;
            },
          );
        } catch (e) {
          print('❌ Failed to import ${student.name}: $e');
          errorCount++;
        }
      }
      
      print('📊 Migration Summary:');
      print('   • Successful: $successCount');
      print('   • Failed: $errorCount');
      print('   • Total: ${sqliteStudents.length}');
      print('✅ SQLite to Firebase migration completed');
    } catch (e) {
      print('❌ Migration failed with unexpected error: $e');
    } finally {
      _sqliteHelper.close();
    }
  }

  /// Backup Firebase data to JSON file
  Future<void> backupToJson() async {
    print('💾 Creating Firebase backup...');
    
    try {
      final result = await _firebaseService.readAll();
      
      result.fold(
        onSuccess: (students) {
          final backup = {
            'timestamp': DateTime.now().toIso8601String(),
            'source': 'Firebase Firestore',
            'collection': 'students',
            'count': students.length,
            'data': students.map((s) => {
              'id': s.id,
              'name': s.name,
              'age': s.age,
              'major': s.major,
              'createdAt': s.createdAt?.toIso8601String(),
              'updatedAt': s.updatedAt?.toIso8601String(),
            }).toList(),
          };
          
          print('✅ Backup created with ${students.length} students');
          print('📄 Backup data: ${backup.toString()}');
          // In a real implementation, you would write this to a file
        },
        onError: (error) {
          print('❌ Backup failed: $error');
        },
      );
    } catch (e) {
      print('❌ Backup failed with unexpected error: $e');
    }
  }
}

/// PocketBase to Firebase migration
class PocketBaseToFirebaseMigration {
  final StudentService _firebaseService = StudentService();
  
  /// Migrate data from PocketBase to Firebase
  Future<void> migrate() async {
    print('🔄 Starting PocketBase to Firebase migration...');
    
    try {
      final pb = PocketBase('http://127.0.0.1:8090');
      
      // Get data from PocketBase
      final pocketbaseData = await pb.collection('students').getList();
      print('Found ${pocketbaseData.items.length} students in PocketBase');
      
      if (pocketbaseData.items.isEmpty) {
        print('⚠️ No students found in PocketBase');
        return;
      }

      int successCount = 0;
      int errorCount = 0;
      
      // Convert and upload to Firebase
      for (final record in pocketbaseData.items) {
        try {
          final student = Student(
            name: record.data['name'] ?? '',
            age: record.data['age'] ?? 0,
            major: record.data['major'] ?? '',
          );
          
          final result = await _firebaseService.create(student);
          
          result.fold(
            onSuccess: (id) {
              print('✅ Migrated: ${student.name} (Firebase ID: $id)');
              successCount++;
            },
            onError: (error) {
              print('❌ Failed to migrate ${student.name}: $error');
              errorCount++;
            },
          );
        } catch (e) {
          print('❌ Failed to migrate record ${record.id}: $e');
          errorCount++;
        }
      }
      
      print('📊 Migration Summary:');
      print('   • Successful: $successCount');
      print('   • Failed: $errorCount');
      print('   • Total: ${pocketbaseData.items.length}');
      print('✅ PocketBase to Firebase migration completed');
    } catch (e) {
      print('❌ Migration failed with unexpected error: $e');
    }
  }
}

/// Bidirectional sync utility
class DatabaseSyncUtility {
  final StudentService _firebaseService = StudentService();
  final DatabaseHelper _sqliteHelper = DatabaseHelper();

  /// Sync data between Firebase and SQLite based on timestamps
  /// This is a simplified example - real sync is much more complex
  Future<void> syncData() async {
    print('🔄 Starting bidirectional sync...');
    
    try {
      // Get data from both sources
      final firebaseResult = await _firebaseService.readAll();
      final sqliteStudents = _sqliteHelper.getAllStudents();
      
      await firebaseResult.fold(
        onSuccess: (firebaseStudents) async {
          print('Firebase: ${firebaseStudents.length} students');
          print('SQLite: ${sqliteStudents.length} students');
          
          // In a real implementation, you would:
          // 1. Compare timestamps to determine which records are newer
          // 2. Handle conflicts (same record updated in both places)
          // 3. Sync only changed records to minimize data transfer
          // 4. Handle deletions
          // 5. Maintain sync state/last sync timestamp
          
          print('⚠️ Sync logic not fully implemented in this example');
          print('💡 Real sync would compare timestamps and handle conflicts');
        },
        onError: (error) async {
          print('❌ Failed to get Firebase data for sync: $error');
        },
      );
    } catch (e) {
      print('❌ Sync failed: $e');
    } finally {
      _sqliteHelper.close();
    }
  }

  /// Clean up resources
  void dispose() {
    _sqliteHelper.close();
  }
}

/// Data format conversion utilities
class DataFormatConverter {
  /// Convert Firebase document to SQL schema mapping
  static Map<String, String> get firebaseToSQLiteTypes => {
    'string': 'TEXT',
    'number': 'INTEGER', 
    'boolean': 'INTEGER',  // 0 or 1
    'timestamp': 'DATETIME',
    'array': 'TEXT',       // JSON string
    'map': 'TEXT',         // JSON string
  };

  /// Convert a Firebase student to SQL INSERT statement
  static String studentToSQLInsert(Student student) {
    return '''
INSERT INTO students (name, age, major, created_at, updated_at) 
VALUES (
  '${student.name.replaceAll("'", "''")}', 
  ${student.age}, 
  '${student.major.replaceAll("'", "''")}',
  '${student.createdAt?.toIso8601String() ?? DateTime.now().toIso8601String()}',
  '${student.updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String()}'
);
''';
  }

  /// Convert Firebase timestamp to SQLite datetime
  static String timestampToSQLiteDate(DateTime? timestamp) {
    return timestamp?.toIso8601String() ?? DateTime.now().toIso8601String();
  }

  /// Generate CREATE TABLE statement for SQLite
  static String generateStudentsTableSQL() {
    return '''
CREATE TABLE IF NOT EXISTS students (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  age INTEGER NOT NULL,
  major TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_students_name ON students(name);
CREATE INDEX idx_students_major ON students(major);
CREATE INDEX idx_students_age ON students(age);
''';
  }

  /// Generate PocketBase collection schema
  static Map<String, dynamic> generatePocketBaseSchema() {
    return {
      'name': 'students',
      'schema': [
        {
          'name': 'name',
          'type': 'text',
          'required': true,
          'options': {
            'min': 2,
            'max': 100,
            'pattern': r'^[a-zA-Z\s\-\.\']+$'
          }
        },
        {
          'name': 'age',
          'type': 'number',
          'required': true,
          'options': {
            'min': 16,
            'max': 120
          }
        },
        {
          'name': 'major',
          'type': 'select',
          'required': true,
          'options': {
            'values': [
              'Computer Science',
              'Mathematics', 
              'Physics',
              'Chemistry',
              'Biology',
              'Engineering'
            ]
          }
        }
      ]
    };
  }
}

/// Migration status and progress tracking
class MigrationStatus {
  final String operation;
  final int total;
  final int processed;
  final int successful;
  final int failed;
  final DateTime startTime;
  final List<String> errors;

  MigrationStatus({
    required this.operation,
    required this.total,
    required this.processed,
    required this.successful,
    required this.failed,
    required this.startTime,
    required this.errors,
  });

  double get progressPercentage => total > 0 ? (processed / total) * 100 : 0;
  
  Duration get elapsed => DateTime.now().difference(startTime);
  
  bool get isComplete => processed >= total;
  
  bool get hasErrors => errors.isNotEmpty;

  @override
  String toString() {
    return '''
Migration Status: $operation
Progress: $processed/$total (${progressPercentage.toStringAsFixed(1)}%)
Successful: $successful
Failed: $failed
Elapsed: ${elapsed.inSeconds}s
${hasErrors ? 'Errors: ${errors.length}' : 'No errors'}
''';
  }

  /// Print detailed status
  void printStatus() {
    print('=' * 50);
    print(toString());
    if (hasErrors && errors.length <= 5) {
      print('Recent errors:');
      for (final error in errors.take(5)) {
        print('  • $error');
      }
    }
    print('=' * 50);
  }
}
