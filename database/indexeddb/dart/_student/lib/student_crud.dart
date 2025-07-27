
/// Initialize IndexedDB database and object store
Future<void> initializeDatabase() async {
  try {
    updateStatus('🔧 Initializing database...', 'info');

    final factory = idb.IdbFactory();

    // Delete existing database for clean start (useful for development)
    factory.deleteDatabase(dbName);
    log('🗑️ Cleaned up existing database');

    // Create database with object store
    final result = await factory.openCreate(dbName, storeName);
    database = result.database;

    updateStatus('✅ Database initialized successfully!', 'success');
    log('🏗️ Created database: $dbName with store: $storeName');

    // Add some sample data for demonstration
    await addSampleData();
    
  } catch (error) {
    updateStatus('❌ Failed to initialize database: $error', 'error');
    log('💥 Database initialization failed: $error');
    rethrow;
  }
}

/// Add sample student data for demonstration
Future<void> addSampleData() async {
  final sampleStudents = [
    Student(
      id: 'S001',
      name: 'Alice Johnson',
      age: 20,
      major: 'Computer Science',
    ),
    Student(
      id: 'S002', 
      name: 'Bob Smith', 
      age: 22, 
      major: 'Mathematics'
    ),
    Student(
      id: 'S003', 
      name: 'Carol Davis', 
      age: 21, 
      major: 'Physics'
    ),
  ];

  for (final student in sampleStudents) {
    await createStudent(student);
  }

  log('📊 Added ${sampleStudents.length} sample students');
}



/// CREATE: Add a new student to the database
Future<void> createStudent(Student student) async {
  try {
    // Create a read-write transaction
    final transaction = database.transactionList([storeName], 'readwrite');
    final store = transaction.objectStore(storeName);

    // Convert Dart Map to JavaScript object for IndexedDB
    final jsData = jsify(student.toMap());
    
    // Store the student data using student ID as key
    store.put(jsData, student.id);

    // Wait for transaction to complete
    await transaction.completed;

    log('✅ CREATE: Added student ${student.id} - ${student.name}');
    
  } catch (error) {
    log('❌ CREATE ERROR: Failed to add student: $error');
    rethrow;
  }
}

/// READ: Get a specific student by ID
Future<Student?> readStudent(String studentId) async {
  try {
    // Create a read-only transaction
    final transaction = database.transactionList([storeName], 'readonly');
    final store = transaction.objectStore(storeName);

    // Get the student data
    final result = await store.getObject(studentId);

    if (result != null) {
      // Convert JavaScript object back to Dart Map
      final dartData = dartify(result);
      final studentMap = Map<String, dynamic>.from(dartData as Map);
      final student = Student.fromMap(studentMap);
      log('✅ READ: Found student ${student.id} - ${student.name}');
      return student;
    } else {
      log('⚠️ READ: Student with ID $studentId not found');
      return null;
    }
    
  } catch (error) {
    log('❌ READ ERROR: Failed to get student: $error');
    return null;
  }
}

/// READ: Get all students from the database
Future<List<Student>> readAllStudents() async {
  try {
    final transaction = database.transactionList([storeName], 'readonly');
    final store = transaction.objectStore(storeName);

    // Get all records using cursor
    final students = <Student>[];

    await for (final cursorWithValue in store.openCursor(autoAdvance: true)) {
      // Convert JavaScript object back to Dart Map
      final dartData = dartify(cursorWithValue.value);
      final studentData = Map<String, dynamic>.from(dartData as Map);
      students.add(Student.fromMap(studentData));
    }

    log('✅ READ ALL: Retrieved ${students.length} students');
    return students;
    
  } catch (error) {
    log('❌ READ ALL ERROR: Failed to get all students: $error');
    return [];
  }
}

/// UPDATE: Modify an existing student's information
Future<bool> updateStudent(
  String studentId, {
  String? name,
  int? age,
  String? major,
}) async {
  try {
    // First, check if student exists
    final existingStudent = await readStudent(studentId);
    if (existingStudent == null) {
      log('⚠️ UPDATE: Student with ID $studentId not found');
      return false;
    }

    // Create updated student with new values or keep existing ones
    final updatedStudent = Student(
      id: studentId,
      name: name ?? existingStudent.name,
      age: age ?? existingStudent.age,
      major: major ?? existingStudent.major,
    );

    // Update the record
    final transaction = database.transactionList([storeName], 'readwrite');
    final store = transaction.objectStore(storeName);

    // Convert Dart Map to JavaScript object for IndexedDB
    final jsData = jsify(updatedStudent.toMap());
    
    store.put(jsData, studentId);
    await transaction.completed;

    log('✅ UPDATE: Modified student ${updatedStudent.id} - ${updatedStudent.name}');
    return true;
    
  } catch (error) {
    log('❌ UPDATE ERROR: Failed to update student: $error');
    return false;
  }
}

/// DELETE: Remove a student from the database
Future<bool> deleteStudent(String studentId) async {
  try {
    // Check if student exists first
    final existingStudent = await readStudent(studentId);
    if (existingStudent == null) {
      log('⚠️ DELETE: Student with ID $studentId not found');
      return false;
    }

    // Delete the record
    final transaction = database.transactionList([storeName], 'readwrite');
    final store = transaction.objectStore(storeName);

    store.delete(studentId);
    await transaction.completed;

    log('✅ DELETE: Removed student $studentId');
    return true;
    
  } catch (error) {
    log('❌ DELETE ERROR: Failed to delete student: $error');
    return false;
  }
}

/// DELETE: Clear all students from the database
Future<void> clearAllStudents() async {
  try {
    final transaction = database.transactionList([storeName], 'readwrite');
    final store = transaction.objectStore(storeName);

    store.clear();
    await transaction.completed;

    log('✅ CLEAR ALL: Removed all students from database');
    
  } catch (error) {
    log('❌ CLEAR ERROR: Failed to clear all students: $error');
  }
}
