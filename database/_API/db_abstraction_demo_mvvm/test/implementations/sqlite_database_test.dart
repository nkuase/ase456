import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:db_abstraction_demo_mvvm/interfaces/database_interface.dart';
import 'package:db_abstraction_demo_mvvm/implementations/sqlite_database.dart';
import '../interfaces/database_interface_test.dart';

/// Simple SQLite implementation test
///
/// Demonstrates how to test specific implementations while verifying
/// they follow the interface contract
class SQLiteDatabaseTest extends DatabaseInterfaceTest {
  @override
  DatabaseInterface createDatabase() {
    return SQLiteDatabase(
        databaseName: 'test_${DateTime.now().millisecondsSinceEpoch}.db');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  final sqliteTest = SQLiteDatabaseTest();

  group('Database Interface Tests', () {
    sqliteTest.runDatabaseInterfaceTests();
  });

  group('SQLite Specific Tests', () {
    late DatabaseInterface db;

    setUp(() async {
      db = sqliteTest.createDatabase();
      await db.initialize();
    });

    tearDown(() async {
      await db.clear();
      await db.close();
    });

    test('should identify as SQLite database', () async {
      expect(db.databaseName, equals('SQLite'));
    });
  });
}
