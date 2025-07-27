class SQLiteStudentService {
  static Database? _database;
  static const String _databaseName = 'students.db';
  static const String _tableName = 'students';

  /// Get database instance (singleton pattern)
  static Database get database {
    if (_database != null) return _database!;
    _database = _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)',
        );
      },
    );
  }

  static void _createTable(Database db) {
    db.execute('''
    CREATE TABLE IF NOT EXISTS $_tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      foo TEXT NOT NULL,
      bar INTEGER NOT NULL,
    )
  ''');
  }

  /// Insert a new student
  static Future<void> insertStudent(Student student) async {
    final db = database;
    await db.insert(
      _tableName,
      student.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieve all students
  static Future<List<Student>> getStudents() async {
    final db = database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Student.fromMap(maps[i]);
    });
  }

  /// Update a student
  static Future<void> updateStudent(Student student) async {
    final db = database;
    await db.update(
      _tableName,
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  /// Delete a student
  static Future<void> deleteStudent(int id) async {
    final db = database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
