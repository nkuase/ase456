import '../models/student.dart';
import 'firebase_crud_service.dart';
import 'firebase_result.dart';

/// Student-specific service extending generic CRUD operations
class StudentService extends FirebaseCrudService<Student> {
  StudentService()
      : super(
          collectionName: 'students',
          fromMap: Student.fromMap,
          toMap: (student) => student.toMap(),
        );

  /// Get students by major
  Future<FirebaseResult<List<Student>>> getStudentsByMajor(String major) async {
    return await readWhere(
      field: 'major',
      value: major,
      operator: '==',
      orderBy: 'name',
    );
  }

  /// Get students in age range
  Future<FirebaseResult<List<Student>>> getStudentsByAgeRange(int minAge, int maxAge) async {
    final result = await readWhere(
      field: 'age',
      value: minAge,
      operator: '>=',
    );
    
    return result.map((students) {
      return students.where((s) => s.age <= maxAge).toList();
    });
  }

  /// Get students by major and age range (complex query)
  Future<List<Student>> getByMajorAndAgeRange(
    String major, 
    int minAge, 
    int maxAge
  ) async {
    final result = await readWhere(
      field: 'major',
      value: major,
      operator: '==',
    );
    
    return result.fold(
      onSuccess: (students) {
        return students.where((s) => s.age >= minAge && s.age <= maxAge).toList();
      },
      onError: (error) {
        print('Error in complex query: $error');
        return [];
      },
    );
  }

  /// Get oldest students
  Future<FirebaseResult<List<Student>>> getOldestStudents({int limit = 10}) async {
    return await readAll(
      orderBy: 'age',
      descending: true,
      limit: limit,
    );
  }

  /// Get youngest students
  Future<FirebaseResult<List<Student>>> getYoungestStudents({int limit = 10}) async {
    return await readAll(
      orderBy: 'age',
      descending: false,
      limit: limit,
    );
  }

  /// Get newest students (by creation date)
  Future<FirebaseResult<List<Student>>> getNewestStudents({int limit = 10}) async {
    return await readAll(
      orderBy: 'createdAt',
      descending: true,
      limit: limit,
    );
  }

  /// Get students with names in a specific list
  Future<FirebaseResult<List<Student>>> getStudentsByNames(List<String> names) async {
    return await readWhere(
      field: 'name',
      value: names,
      operator: 'in',
    );
  }

  /// Search students by name (partial match)
  Future<List<Student>> searchStudentsByName(String searchTerm) async {
    final result = await readAll();
    
    return result.fold(
      onSuccess: (students) {
        return students.where((s) => 
          s.name.toLowerCase().contains(searchTerm.toLowerCase())
        ).toList();
      },
      onError: (error) {
        print('Error searching students: $error');
        return [];
      },
    );
  }

  /// Get students count by major
  Future<Map<String, int>> getStudentCountByMajor() async {
    final result = await readAll();
    
    return result.fold(
      onSuccess: (students) {
        final Map<String, int> counts = {};
        for (final student in students) {
          counts[student.major] = (counts[student.major] ?? 0) + 1;
        }
        return counts;
      },
      onError: (error) {
        print('Error getting student counts: $error');
        return {};
      },
    );
  }

  /// Get average age of students
  Future<double> getAverageAge() async {
    final result = await readAll();
    
    return result.fold(
      onSuccess: (students) {
        if (students.isEmpty) return 0.0;
        final totalAge = students.fold<int>(0, (sum, student) => sum + student.age);
        return totalAge / students.length;
      },
      onError: (error) {
        print('Error calculating average age: $error');
        return 0.0;
      },
    );
  }

  /// Update student age
  Future<FirebaseResult<void>> updateStudentAge(String studentId, int newAge) async {
    return await updateFields(studentId, {'age': newAge});
  }

  /// Update student major
  Future<FirebaseResult<void>> updateStudentMajor(String studentId, String newMajor) async {
    return await updateFields(studentId, {'major': newMajor});
  }

  /// Delete students by major
  Future<FirebaseResult<int>> deleteStudentsByMajor(String major) async {
    return await deleteWhere(
      field: 'major',
      value: major,
      operator: '==',
    );
  }

  /// Delete students under a certain age
  Future<FirebaseResult<int>> deleteStudentsUnderAge(int age) async {
    return await deleteWhere(
      field: 'age',
      value: age,
      operator: '<',
    );
  }

  /// Stream students by major in real-time
  Stream<List<Student>> streamStudentsByMajor(String major) {
    return streamWhere(
      field: 'major',
      value: major,
      operator: '==',
      orderBy: 'name',
    );
  }

  /// Stream students in age range in real-time
  Stream<List<Student>> streamStudentsByAgeRange(int minAge, int maxAge) {
    return streamWhere(
      field: 'age',
      value: minAge,
      operator: '>=',
    ).map((students) => students.where((s) => s.age <= maxAge).toList());
  }

  /// Bulk create students with validation
  Future<FirebaseResult<List<String>>> bulkCreateStudents(List<Student> students) async {
    // Filter out any invalid students
    final validStudents = students.where((s) => 
      s.name.isNotEmpty && 
      s.age > 0 && 
      s.major.isNotEmpty
    ).toList();
    
    if (validStudents.length != students.length) {
      return FirebaseResult.error(
        'Some students were invalid and excluded. Valid: ${validStudents.length}, Total: ${students.length}'
      );
    }
    
    return await createBatch(validStudents);
  }

  /// Get student statistics
  Future<Map<String, dynamic>> getStudentStatistics() async {
    final result = await readAll();
    
    return result.fold(
      onSuccess: (students) {
        if (students.isEmpty) {
          return {
            'totalStudents': 0,
            'averageAge': 0.0,
            'majorCounts': <String, int>{},
            'ageDistribution': <String, int>{},
          };
        }

        final majorCounts = <String, int>{};
        final ageDistribution = <String, int>{};
        int totalAge = 0;

        for (final student in students) {
          // Count by major
          majorCounts[student.major] = (majorCounts[student.major] ?? 0) + 1;
          
          // Age distribution by ranges
          String ageRange;
          if (student.age < 20) {
            ageRange = 'Under 20';
          } else if (student.age < 25) {
            ageRange = '20-24';
          } else if (student.age < 30) {
            ageRange = '25-29';
          } else {
            ageRange = '30+';
          }
          ageDistribution[ageRange] = (ageDistribution[ageRange] ?? 0) + 1;
          
          totalAge += student.age;
        }

        return {
          'totalStudents': students.length,
          'averageAge': totalAge / students.length,
          'majorCounts': majorCounts,
          'ageDistribution': ageDistribution,
          'oldestStudent': students.reduce((a, b) => a.age > b.age ? a : b),
          'youngestStudent': students.reduce((a, b) => a.age < b.age ? a : b),
        };
      },
      onError: (error) {
        print('Error getting statistics: $error');
        return {'error': error};
      },
    );
  }
}
