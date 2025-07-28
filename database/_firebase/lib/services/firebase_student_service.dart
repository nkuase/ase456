import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student.dart';
import 'database_service.dart';

/// Firebase Student Service
/// Provides CRUD operations for Student data in Firestore
/// Demonstrates Firebase patterns and best practices
class FirebaseStudentService implements DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'students';
  
  /// Get reference to students collection
  CollectionReference get _studentsRef =>
      _firestore.collection(_collection);

  /// Generate new student ID
  @override
  String generateId() {
    return _studentsRef.doc().id;
  }

  /// Initialize service (can be used for setup)
  @override
  Future<void> initialize() async {
    try {
      // Test connection
      await _firestore.enableNetwork();
      print('✅ Firebase Firestore connected successfully');
    } catch (e) {
      print('❌ Firebase connection failed: $e');
      rethrow;
    }
  }

  // ===============================
  // CREATE Operations
  // ===============================

  /// CREATE: Add new student to Firestore with auto-generated ID
  static Future<String> createStudent(Student student) async {
    try {
      // Method 1: Auto-generate ID
      DocumentReference docRef = await _studentsRef.add(student.toMap());
      
      print('✅ CREATE: Student added with ID: ${docRef.id}');
      return docRef.id;
      
    } catch (e) {
      print('❌ CREATE Error: $e');
      throw Exception('Failed to create student: $e');
    }
  }

  /// CREATE: Add student with specific ID
  static Future<void> createStudentWithId(Student student) async {
    try {
      await _studentsRef.doc(student.id).set(student.toMap());
      
      print('✅ CREATE: Student created with ID: ${student.id}');
      
    } catch (e) {
      print('❌ CREATE Error: $e');
      throw Exception('Failed to create student with ID: $e');
    }
  }

  // ===============================
  // READ Operations
  // ===============================

  /// READ: Get all students (one-time fetch)
  static Future<List<Student>> getAllStudents() async {
    try {
      QuerySnapshot querySnapshot = await _studentsRef
          .orderBy('createdAt', descending: false)
          .get();
      
      List<Student> students = querySnapshot.docs
          .map((doc) => Student.fromFirestore(doc))
          .toList();
      
      print('✅ READ: Retrieved ${students.length} students');
      return students;
      
    } catch (e) {
      print('❌ READ Error: $e');
      throw Exception('Failed to get students: $e');
    }
  }

  /// READ: Stream of students (real-time updates)
  static Stream<List<Student>> getStudentsStream() {
    return _studentsRef
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Student.fromFirestore(doc))
            .toList());
  }

  /// READ: Get specific student by ID
  static Future<Student?> getStudentById(String id) async {
    try {
      DocumentSnapshot doc = await _studentsRef.doc(id).get();
      
      if (doc.exists) {
        Student student = Student.fromFirestore(doc);
        print('✅ READ: Found student with ID $id');
        return student;
      } else {
        print('❌ READ: No student found with ID $id');
        return null;
      }
    } catch (e) {
      print('❌ READ Error: $e');
      throw Exception('Failed to get student: $e');
    }
  }

  /// READ: Get students by major
  static Future<List<Student>> getStudentsByMajor(String major) async {
    try {
      QuerySnapshot querySnapshot = await _studentsRef
          .where('major', isEqualTo: major)
          .orderBy('createdAt')
          .get();
      
      List<Student> students = querySnapshot.docs
          .map((doc) => Student.fromFirestore(doc))
          .toList();
      
      print('✅ READ: Retrieved ${students.length} students with major: $major');
      return students;
      
    } catch (e) {
      print('❌ READ Error: $e');
      throw Exception('Failed to get students by major: $e');
    }
  }

  /// READ: Get students by age range
  static Future<List<Student>> getStudentsByAgeRange(int minAge, int maxAge) async {
    try {
      QuerySnapshot querySnapshot = await _studentsRef
          .where('age', isGreaterThanOrEqualTo: minAge)
          .where('age', isLessThanOrEqualTo: maxAge)
          .orderBy('age')
          .get();
      
      List<Student> students = querySnapshot.docs
          .map((doc) => Student.fromFirestore(doc))
          .toList();
      
      print('✅ READ: Retrieved ${students.length} students aged $minAge-$maxAge');
      return students;
      
    } catch (e) {
      print('❌ READ Error: $e');
      throw Exception('Failed to get students by age range: $e');
    }
  }

  // ===============================
  // UPDATE Operations
  // ===============================

  /// UPDATE: Update specific fields of a student
  static Future<void> updateStudent(String id, Map<String, dynamic> updates) async {
    try {
      await _studentsRef.doc(id).update(updates);
      print('✅ UPDATE: Student $id updated successfully');
      
    } catch (e) {
      print('❌ UPDATE Error: $e');
      throw Exception('Failed to update student: $e');
    }
  }

  /// UPDATE: Update entire student document
  static Future<void> updateEntireStudent(Student student) async {
    try {
      await _studentsRef.doc(student.id).set(student.toMap());
      print('✅ UPDATE: Student ${student.id} replaced successfully');
      
    } catch (e) {
      print('❌ UPDATE Error: $e');
      throw Exception('Failed to update student: $e');
    }
  }

  /// UPDATE: Increment student age
  static Future<void> incrementStudentAge(String id) async {
    try {
      await _studentsRef.doc(id).update({
        'age': FieldValue.increment(1),
      });
      print('✅ UPDATE: Student $id age incremented');
      
    } catch (e) {
      print('❌ UPDATE Error: $e');
      throw Exception('Failed to increment student age: $e');
    }
  }

  // ===============================
  // DELETE Operations
  // ===============================

  /// DELETE: Remove student by ID
  static Future<void> deleteStudent(String id) async {
    try {
      await _studentsRef.doc(id).delete();
      print('✅ DELETE: Student $id deleted successfully');
      
    } catch (e) {
      print('❌ DELETE Error: $e');
      throw Exception('Failed to delete student: $e');
    }
  }

  /// DELETE: Remove all students (batch operation)
  static Future<void> deleteAllStudents() async {
    try {
      WriteBatch batch = _firestore.batch();
      QuerySnapshot snapshot = await _studentsRef.get();
      
      for (DocumentSnapshot doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
      print('✅ DELETE: All students deleted successfully');
      
    } catch (e) {
      print('❌ DELETE Error: $e');
      throw Exception('Failed to delete all students: $e');
    }
  }

  /// DELETE: Remove students by major
  static Future<int> deleteStudentsByMajor(String major) async {
    try {
      WriteBatch batch = _firestore.batch();
      QuerySnapshot snapshot = await _studentsRef
          .where('major', isEqualTo: major)
          .get();
      
      for (DocumentSnapshot doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
      print('✅ DELETE: ${snapshot.docs.length} students with major $major deleted');
      return snapshot.docs.length;
      
    } catch (e) {
      print('❌ DELETE Error: $e');
      throw Exception('Failed to delete students by major: $e');
    }
  }

  // ===============================
  // Utility Operations
  // ===============================

  /// COUNT: Get total number of students
  static Future<int> getStudentCount() async {
    try {
      QuerySnapshot snapshot = await _studentsRef.get();
      int count = snapshot.docs.length;
      print('✅ COUNT: Total students: $count');
      return count;
      
    } catch (e) {
      print('❌ COUNT Error: $e');
      throw Exception('Failed to count students: $e');
    }
  }

  /// SEARCH: Search students by name (partial match)
  static Future<List<Student>> searchStudentsByName(String nameQuery) async {
    try {
      String searchEnd = nameQuery + '\uf8ff';
      QuerySnapshot querySnapshot = await _studentsRef
          .where('name', isGreaterThanOrEqualTo: nameQuery)
          .where('name', isLessThan: searchEnd)
          .orderBy('name')
          .get();
      
      List<Student> students = querySnapshot.docs
          .map((doc) => Student.fromFirestore(doc))
          .toList();
      
      print('✅ SEARCH: Found ${students.length} students matching "$nameQuery"');
      return students;
      
    } catch (e) {
      print('❌ SEARCH Error: $e');
      throw Exception('Failed to search students: $e');
    }
  }

  // ===============================
  // Advanced Operations
  // ===============================

  /// BATCH: Create multiple students at once
  static Future<void> createMultipleStudents(List<Student> students) async {
    try {
      WriteBatch batch = _firestore.batch();
      
      for (Student student in students) {
        DocumentReference docRef = _studentsRef.doc();
        batch.set(docRef, student.toMap());
      }
      
      await batch.commit();
      print('✅ BATCH CREATE: ${students.length} students created successfully');
      
    } catch (e) {
      print('❌ BATCH CREATE Error: $e');
      throw Exception('Failed to create multiple students: $e');
    }
  }

  /// TRANSACTION: Transfer student between majors
  static Future<void> transferStudentMajor(String studentId, String newMajor) async {
    try {
      await _firestore.runTransaction((transaction) async {
        DocumentReference studentRef = _studentsRef.doc(studentId);
        DocumentSnapshot snapshot = await transaction.get(studentRef);
        
        if (!snapshot.exists) {
          throw Exception('Student not found');
        }
        
        transaction.update(studentRef, {'major': newMajor});
      });
      
      print('✅ TRANSACTION: Student $studentId transferred to $newMajor');
      
    } catch (e) {
      print('❌ TRANSACTION Error: $e');
      throw Exception('Failed to transfer student: $e');
    }
  }
}
