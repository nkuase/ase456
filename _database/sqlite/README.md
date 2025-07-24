# SQLite CRUD Demo in Pure Dart

A simple educational example demonstrating **CRUD operations** (Create, Read, Update, Delete) using SQLite database in pure Dart (no Flutter dependencies).

## 🎯 Learning Objectives

By studying this code, students will learn:

1. **What is CRUD?** - The four basic database operations
2. **Database Design** - How to create tables and define relationships
3. **Data Models** - How to represent real-world entities in code
4. **SQLite Operations** - How to interact with SQLite using pure Dart
5. **SQL Fundamentals** - Writing SQL queries and prepared statements
6. **Best Practices** - Proper error handling and resource management

## 🏗️ Project Structure

```
sqlite_crud_demo/
├── pubspec.yaml          # Project dependencies (sqlite3, path, test)
├── main.dart            # Main application with CRUD examples
├── README.md           # This documentation
├── run_demo.sh         # Convenience script to run everything
└── test/
    └── crud_test.dart  # Unit tests for CRUD operations
```

## 🔧 Setup Instructions

1. **Install Dependencies**
   ```bash
   dart pub get
   ```

2. **Run the Application**
   ```bash
   dart run main.dart
   ```

3. **Run Tests**
   ```bash
   dart test
   ```

4. **Use Convenience Script**
   ```bash
   chmod +x run_demo.sh
   ./run_demo.sh
   ```

## 📚 CRUD Operations Explained

### **C**REATE - Adding New Data
```dart
// Insert a new student
Student alice = Student(name: 'Alice Johnson', age: 20, major: 'Computer Science');
int id = dbHelper.insertStudent(alice);
```

**SQL Generated:**
```sql
INSERT INTO students (name, age, major) VALUES (?, ?, ?)
```

### **R**EAD - Retrieving Data
```dart
// Get all students
List<Student> students = dbHelper.getAllStudents();

// Get specific student by ID
Student? student = dbHelper.getStudentById(1);
```

**SQL Generated:**
```sql
SELECT * FROM students ORDER BY id
SELECT * FROM students WHERE id = ?
```

### **U**PDATE - Modifying Existing Data
```dart
// Update student information
alice.age = 21;
alice.major = 'Computer Engineering';
dbHelper.updateStudent(alice);
```

**SQL Generated:**
```sql
UPDATE students SET name = ?, age = ?, major = ? WHERE id = ?
```

### **D**ELETE - Removing Data
```dart
// Delete a student by ID
dbHelper.deleteStudent(studentId);
```

**SQL Generated:**
```sql
DELETE FROM students WHERE id = ?
```

## 🔑 Key Differences: sqlite3 vs sqflite

| Feature | sqlite3 (Pure Dart) | sqflite (Flutter) |
|---------|-------------------|-------------------|
| **Environment** | Pure Dart console apps | Flutter mobile apps |
| **Operations** | Synchronous | Asynchronous |
| **Dependencies** | No Flutter required | Requires Flutter SDK |
| **Performance** | Direct SQLite access | Platform channel overhead |
| **Use Case** | CLI tools, servers, desktop | Mobile applications |

## 🎓 Key Concepts Demonstrated

### 1. **Data Model (Student Class)**
- Represents a real-world entity (university student)
- Contains properties (id, name, age, major)
- Methods for database conversion (`toMap()`, `fromRow()`)
- Demonstrates object-relational mapping concepts

### 2. **Database Helper Class**
- Singleton pattern for database access
- Encapsulates all database operations
- Proper resource management (prepared statements)
- Error handling and cleanup

### 3. **SQL Operations**
- Table creation with proper data types
- Primary key and auto-increment
- Parameterized queries (prevents SQL injection)
- Prepared statements for better performance

### 4. **Resource Management**
- Proper disposal of prepared statements
- Database connection cleanup
- Memory-efficient query execution

## 🔍 What Happens When You Run This?

1. **Database Initialization**: Creates `students.db` file in current directory
2. **Table Creation**: Creates `students` table with proper schema
3. **CREATE Demo**: Adds 3 sample students to the database
4. **READ Demo**: Retrieves and displays all students, then searches by ID
5. **UPDATE Demo**: Modifies Alice's age and major
6. **DELETE Demo**: Removes Charlie from the database
7. **Cleanup**: Closes database connection and disposes resources

## 📋 Sample Output

```
🎓 SQLite CRUD Demo - Student Management System
==================================================
✅ Database initialized at: /path/to/students.db
✅ Students table created successfully

📝 DEMO: CREATE Operations
------------------------------
✅ CREATE: Student inserted with ID: 1
✅ CREATE: Student inserted with ID: 2
✅ CREATE: Student inserted with ID: 3

📖 DEMO: READ Operations
------------------------------
✅ READ: Retrieved 3 students
All students in database:
  Student{id: 1, name: Alice Johnson, age: 20, major: Computer Science}
  Student{id: 2, name: Bob Smith, age: 22, major: Mathematics}
  Student{id: 3, name: Charlie Brown, age: 19, major: Physics}

Searching for student with ID 2:
✅ READ: Found student with ID 2
  Found: Student{id: 2, name: Bob Smith, age: 22, major: Mathematics}

✏️  DEMO: UPDATE Operations
------------------------------
✅ UPDATE: Student with ID 1 updated successfully
Updated Alice: Student{id: 1, name: Alice Johnson, age: 21, major: Computer Engineering}

🗑️  DEMO: DELETE Operations
------------------------------
✅ DELETE: Student with ID 3 deleted successfully

Remaining students after deletion:
✅ READ: Retrieved 2 students
  Student{id: 1, name: Alice Johnson, age: 21, major: Computer Engineering}
  Student{id: 2, name: Bob Smith, age: 22, major: Mathematics}

🎯 Summary of CRUD Operations:
------------------------------
✅ CREATE: Added 3 students to database
✅ READ: Retrieved all students and searched by ID
✅ UPDATE: Modified Alice's age and major
✅ DELETE: Removed Charlie from database

🎓 CRUD Demo completed successfully!
🔒 Database connection closed
```

## 🧪 Try These Exercises

### **Beginner Level:**
1. **Add more fields** to the Student model (email, phone number, GPA)
2. **Create search functions** (find students by major, age range)
3. **Add validation** (ensure age is positive, name is not empty)

### **Intermediate Level:**
4. **Implement batch operations** (insert multiple students at once)
5. **Add database migrations** (modify table structure safely)
6. **Create indexes** for better query performance

### **Advanced Level:**
7. **Add a Course table** and create relationships between students and courses
8. **Implement transactions** for data consistency
9. **Add a web API** layer using shelf package

## 🛠️ Technical Details

### **Dependencies Used:**
- **sqlite3**: Pure Dart SQLite interface
- **path**: Cross-platform path manipulation
- **test**: Unit testing framework

### **SQL Schema:**
```sql
CREATE TABLE students (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  age INTEGER NOT NULL,
  major TEXT NOT NULL
);
```

### **Security Features:**
- Parameterized queries prevent SQL injection
- Prepared statements for efficient execution
- Input validation in Student model

## 📖 Further Reading

- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [sqlite3 Dart Package](https://pub.dev/packages/sqlite3)
- [Database Design Principles](https://en.wikipedia.org/wiki/Database_design)
- [SQL Injection Prevention](https://owasp.org/www-community/attacks/SQL_Injection)

## 🚨 Common Issues and Solutions

### **Issue: "sqlite3 library not found"**
**Solution:** Install SQLite on your system:
- **macOS:** `brew install sqlite3`
- **Ubuntu:** `sudo apt-get install sqlite3 libsqlite3-dev`
- **Windows:** Download from [SQLite website](https://www.sqlite.org/download.html)

### **Issue: Permission denied when creating database**
**Solution:** Ensure write permissions in the current directory or specify a different path.

### **Issue: Tests interfering with each other**
**Solution:** Fixed! Each test now creates its own unique database file with microsecond timestamp:
```dart
// Each test gets a unique database
testDbPath = 'test_students_${DateTime.now().microsecondsSinceEpoch}.db';
dbHelper = DatabaseHelper(customDbPath: testDbPath);
```

### **Issue: "Expected 3 but got 8" in tests**
**Solution:** This was caused by tests sharing the same database. Now fixed with proper test isolation.

## 🧪 **Test Design Principles Demonstrated:**
1. **Test Isolation** - Each test runs independently
2. **Clean Setup/Teardown** - Fresh database for each test
3. **Resource Cleanup** - Proper disposal of database connections
4. **Unique Test Data** - No data conflicts between tests
