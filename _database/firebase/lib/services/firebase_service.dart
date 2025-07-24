import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student.dart';
import 'database_service.dart';
import 'student_service.dart';

/// Firebase implementation of the abstract DatabaseService
class FirebaseService implements DatabaseService {
  final StudentService _studentService = StudentService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'students';

  @override
  Future<String> create(Map<String, dynamic> data) async {
    try {
      final student = Student(
        name: data['name'] ?? '',
        age: data['age'] ?? 0,
        major: data['major'] ?? '',
      );
      
      final result = await _studentService.create(student);
      return result.fold(
        onSuccess: (id) => id,
        onError: (error) => throw Exception(error),
      );
    } catch (e) {
      throw Exception('Failed to create: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>?> read(String id) async {
    try {
      final result = await _studentService.read(id);
      return result.fold(
        onSuccess: (student) {
          if (student == null) return null;
          final map = student.toMap();
          map['id'] = student.id;
          return map;
        },
        onError: (error) => throw Exception(error),
      );
    } catch (e) {
      throw Exception('Failed to read: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> readAll({
    int? limit,
    String? orderBy,
    bool descending = false,
  }) async {
    try {
      final result = await _studentService.readAll(
        limit: limit,
        orderBy: orderBy,
        descending: descending,
      );
      
      return result.fold(
        onSuccess: (students) {
          return students.map((s) {
            final map = s.toMap();
            map['id'] = s.id;
            return map;
          }).toList();
        },
        onError: (error) => throw Exception(error),
      );
    } catch (e) {
      throw Exception('Failed to read all: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> readWhere({
    required String field,
    required dynamic value,
    String operator = '==',
    int? limit,
    String? orderBy,
    bool descending = false,
  }) async {
    try {
      final result = await _studentService.readWhere(
        field: field,
        value: value,
        operator: operator,
        limit: limit,
        orderBy: orderBy,
        descending: descending,
      );
      
      return result.fold(
        onSuccess: (students) {
          return students.map((s) {
            final map = s.toMap();
            map['id'] = s.id;
            return map;
          }).toList();
        },
        onError: (error) => throw Exception(error),
      );
    } catch (e) {
      throw Exception('Failed to read where: ${e.toString()}');
    }
  }

  @override
  Future<bool> update(String id, Map<String, dynamic> data) async {
    try {
      final student = Student(
        name: data['name'] ?? '',
        age: data['age'] ?? 0,
        major: data['major'] ?? '',
      );
      
      final result = await _studentService.update(id, student);
      return result.fold(
        onSuccess: (_) => true,
        onError: (error) => throw Exception(error),
      );
    } catch (e) {
      throw Exception('Failed to update: ${e.toString()}');
    }
  }

  @override
  Future<bool> updateFields(String id, Map<String, dynamic> fields) async {
    try {
      final result = await _studentService.updateFields(id, fields);
      return result.fold(
        onSuccess: (_) => true,
        onError: (error) => throw Exception(error),
      );
    } catch (e) {
      throw Exception('Failed to update fields: ${e.toString()}');
    }
  }

  @override
  Future<bool> delete(String id) async {
    try {
      final result = await _studentService.delete(id);
      return result.fold(
        onSuccess: (_) => true,
        onError: (error) => throw Exception(error),
      );
    } catch (e) {
      throw Exception('Failed to delete: ${e.toString()}');
    }
  }

  @override
  Future<int> deleteWhere({
    required String field,
    required dynamic value,
    String operator = '==',
  }) async {
    try {
      final result = await _studentService.deleteWhere(
        field: field,
        value: value,
        operator: operator,
      );
      
      return result.fold(
        onSuccess: (count) => count,
        onError: (error) => throw Exception(error),
      );
    } catch (e) {
      throw Exception('Failed to delete where: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> createBatch(List<Map<String, dynamic>> dataList) async {
    try {
      final students = dataList.map((data) => Student(
        name: data['name'] ?? '',
        age: data['age'] ?? 0,
        major: data['major'] ?? '',
      )).toList();
      
      final result = await _studentService.createBatch(students);
      return result.fold(
        onSuccess: (ids) => ids,
        onError: (error) => throw Exception(error),
      );
    } catch (e) {
      throw Exception('Failed to create batch: ${e.toString()}');
    }
  }

  @override
  Stream<List<Map<String, dynamic>>> streamAll({
    int? limit,
    String? orderBy,
    bool descending = false,
  }) {
    return _studentService.streamAll(
      limit: limit,
      orderBy: orderBy,
      descending: descending,
    ).map((students) {
      return students.map((s) {
        final map = s.toMap();
        map['id'] = s.id;
        return map;
      }).toList();
    });
  }

  @override
  Stream<Map<String, dynamic>?> streamDocument(String id) {
    return _studentService.streamDocument(id).map((student) {
      if (student == null) return null;
      final map = student.toMap();
      map['id'] = student.id;
      return map;
    });
  }

  @override
  Stream<List<Map<String, dynamic>>> streamWhere({
    required String field,
    required dynamic value,
    String operator = '==',
    int? limit,
    String? orderBy,
    bool descending = false,
  }) {
    return _studentService.streamWhere(
      field: field,
      value: value,
      operator: operator,
      limit: limit,
      orderBy: orderBy,
      descending: descending,
    ).map((students) {
      return students.map((s) {
        final map = s.toMap();
        map['id'] = s.id;
        return map;
      }).toList();
    });
  }

  @override
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      return await _studentService.getStudentStatistics();
    } catch (e) {
      throw Exception('Failed to get statistics: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchByText(
    String query, {
    List<String>? searchFields,
    int? limit,
  }) async {
    try {
      // Firebase doesn't have built-in text search, so we'll search by name
      final students = await _studentService.searchStudentsByName(query);
      
      var results = students.map((s) {
        final map = s.toMap();
        map['id'] = s.id;
        return map;
      }).toList();
      
      if (limit != null && results.length > limit) {
        results = results.take(limit).toList();
      }
      
      return results;
    } catch (e) {
      throw Exception('Failed to search: ${e.toString()}');
    }
  }

  @override
  Future<int> count() async {
    try {
      final result = await _studentService.readAll();
      return result.fold(
        onSuccess: (students) => students.length,
        onError: (error) => throw Exception(error),
      );
    } catch (e) {
      throw Exception('Failed to count: ${e.toString()}');
    }
  }

  @override
  Future<int> countWhere({
    required String field,
    required dynamic value,
    String operator = '==',
  }) async {
    try {
      final result = await _studentService.readWhere(
        field: field,
        value: value,
        operator: operator,
      );
      
      return result.fold(
        onSuccess: (students) => students.length,
        onError: (error) => throw Exception(error),
      );
    } catch (e) {
      throw Exception('Failed to count where: ${e.toString()}');
    }
  }

  @override
  Future<bool> exists(String id) async {
    try {
      final result = await _studentService.read(id);
      return result.fold(
        onSuccess: (student) => student != null,
        onError: (error) => false,
      );
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPaginated({
    int limit = 20,
    String? orderBy,
    bool descending = false,
    String? startAfter,
  }) async {
    try {
      final result = await _studentService.getDocumentsPaginated(
        limit: limit,
        orderBy: orderBy,
        descending: descending,
      );
      
      return result.fold(
        onSuccess: (students) {
          return students.map((s) {
            final map = s.toMap();
            map['id'] = s.id;
            return map;
          }).toList();
        },
        onError: (error) => throw Exception(error),
      );
    } catch (e) {
      throw Exception('Failed to get paginated: ${e.toString()}');
    }
  }

  @override
  Future<bool> clearAll() async {
    try {
      // Get all documents and delete them in batches
      final snapshot = await _firestore.collection(_collectionName).get();
      final batch = _firestore.batch();
      
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
      return true;
    } catch (e) {
      throw Exception('Failed to clear all: ${e.toString()}');
    }
  }

  @override
  Future<void> close() async {
    // Firebase doesn't require explicit closing
    // But we can clear any internal state if needed
    _studentService.resetPagination();
  }

  @override
  String get implementationName => 'Firebase Firestore';

  @override
  bool get supportsRealTime => true;

  @override
  bool get supportsTransactions => true;

  @override
  bool get supportsOffline => true;

  /// Additional Firebase-specific methods

  /// Enable offline persistence
  Future<void> enableOfflinePersistence() async {
    try {
      await FirebaseFirestore.instance.enablePersistence();
      print('✅ Offline persistence enabled');
    } catch (e) {
      print('⚠️ Could not enable offline persistence: $e');
    }
  }

  /// Monitor network status
  Stream<bool> get networkStatusStream {
    return _firestore.snapshotsInSync().map((_) => true);
  }

  /// Check if data is from cache
  bool isFromCache(DocumentSnapshot doc) {
    return doc.metadata.isFromCache;
  }

  /// Get Firestore settings
  Map<String, dynamic> get firestoreSettings {
    return {
      'host': _firestore.settings.host,
      'sslEnabled': _firestore.settings.sslEnabled,
      'persistenceEnabled': _firestore.settings.persistenceEnabled,
      'cacheSizeBytes': _firestore.settings.cacheSizeBytes,
    };
  }

  /// Print Firebase configuration
  void printConfiguration() {
    print('=== Firebase Service Configuration ===');
    print('Implementation: $implementationName');
    print('Collection: $_collectionName');
    print('Real-time support: $supportsRealTime');
    print('Transaction support: $supportsTransactions');
    print('Offline support: $supportsOffline');
    print('Firestore settings: $firestoreSettings');
    print('=====================================');
  }
}
