import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_result.dart';

/// Generic CRUD service for Firebase Firestore operations
/// Provides type-safe database operations for any model type T
class FirebaseCrudService<T> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName;
  final T Function(Map<String, dynamic>) fromMap;
  final Map<String, dynamic> Function(T) toMap;

  FirebaseCrudService({
    required this.collectionName,
    required this.fromMap,
    required this.toMap,
  });

  /// Get reference to the Firestore collection
  CollectionReference get _collection => _firestore.collection(collectionName);

  // CREATE - Add a new document
  Future<FirebaseResult<String>> create(T item, {String? customId}) async {
    try {
      final data = toMap(item);
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();
      
      DocumentReference docRef;
      if (customId != null) {
        docRef = _collection.doc(customId);
        await docRef.set(data);
      } else {
        docRef = await _collection.add(data);
      }
      
      return FirebaseResult.success(docRef.id);
    } catch (e) {
      return FirebaseResult.error('Failed to create document: ${e.toString()}');
    }
  }

  // READ - Get specific document by ID
  Future<FirebaseResult<T?>> read(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      
      if (!doc.exists) {
        return FirebaseResult.success(null);
      }
      
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;  // Add document ID to data
      
      final item = fromMap(data);
      return FirebaseResult.success(item);
    } catch (e) {
      return FirebaseResult.error('Failed to read document: ${e.toString()}');
    }
  }

  // READ ALL - Get all documents with optional ordering and limiting
  Future<FirebaseResult<List<T>>> readAll({
    int? limit,
    String? orderBy,
    bool descending = false,
  }) async {
    try {
      Query query = _collection;
      
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      final snapshot = await query.get();
      final items = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return fromMap(data);
      }).toList();
      
      return FirebaseResult.success(items);
    } catch (e) {
      return FirebaseResult.error('Failed to read documents: ${e.toString()}');
    }
  }

  // READ WHERE - Get documents matching a condition
  Future<FirebaseResult<List<T>>> readWhere({
    required String field,
    required dynamic value,
    String operator = '==',
    int? limit,
    String? orderBy,
    bool descending = false,
  }) async {
    try {
      Query query = _collection;
      
      // Apply where condition based on operator
      switch (operator) {
        case '==':
          query = query.where(field, isEqualTo: value);
          break;
        case '!=':
          query = query.where(field, isNotEqualTo: value);
          break;
        case '>':
          query = query.where(field, isGreaterThan: value);
          break;
        case '>=':
          query = query.where(field, isGreaterThanOrEqualTo: value);
          break;
        case '<':
          query = query.where(field, isLessThan: value);
          break;
        case '<=':
          query = query.where(field, isLessThanOrEqualTo: value);
          break;
        case 'array-contains':
          query = query.where(field, arrayContains: value);
          break;
        case 'in':
          query = query.where(field, whereIn: value);
          break;
        default:
          return FirebaseResult.error('Unsupported operator: $operator');
      }
      
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      final snapshot = await query.get();
      final items = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return fromMap(data);
      }).toList();
      
      return FirebaseResult.success(items);
    } catch (e) {
      return FirebaseResult.error('Failed to read documents: ${e.toString()}');
    }
  }

  // UPDATE - Update entire document
  Future<FirebaseResult<void>> update(String id, T item) async {
    try {
      final data = toMap(item);
      data['updatedAt'] = FieldValue.serverTimestamp();
      
      await _collection.doc(id).update(data);
      return FirebaseResult.success(null);
    } catch (e) {
      return FirebaseResult.error('Failed to update document: ${e.toString()}');
    }
  }

  // UPDATE FIELDS - Update specific fields only
  Future<FirebaseResult<void>> updateFields(String id, Map<String, dynamic> fields) async {
    try {
      fields['updatedAt'] = FieldValue.serverTimestamp();
      await _collection.doc(id).update(fields);
      return FirebaseResult.success(null);
    } catch (e) {
      return FirebaseResult.error('Failed to update fields: ${e.toString()}');
    }
  }

  // DELETE - Remove a document
  Future<FirebaseResult<void>> delete(String id) async {
    try {
      await _collection.doc(id).delete();
      return FirebaseResult.success(null);
    } catch (e) {
      return FirebaseResult.error('Failed to delete document: ${e.toString()}');
    }
  }

  // DELETE WHERE - Remove documents matching a condition
  Future<FirebaseResult<int>> deleteWhere({
    required String field,
    required dynamic value,
    String operator = '==',
  }) async {
    try {
      Query query = _collection;
      
      // Apply where condition
      switch (operator) {
        case '==':
          query = query.where(field, isEqualTo: value);
          break;
        case '>':
          query = query.where(field, isGreaterThan: value);
          break;
        case '<':
          query = query.where(field, isLessThan: value);
          break;
        case '>=':
          query = query.where(field, isGreaterThanOrEqualTo: value);
          break;
        case '<=':
          query = query.where(field, isLessThanOrEqualTo: value);
          break;
        default:
          return FirebaseResult.error('Unsupported operator for delete: $operator');
      }
      
      final snapshot = await query.get();
      final batch = _firestore.batch();
      
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
      return FirebaseResult.success(snapshot.docs.length);
    } catch (e) {
      return FirebaseResult.error('Failed to delete documents: ${e.toString()}');
    }
  }

  // BATCH CREATE - Create multiple documents atomically
  Future<FirebaseResult<List<String>>> createBatch(List<T> items) async {
    try {
      final batch = _firestore.batch();
      final ids = <String>[];
      
      for (final item in items) {
        final docRef = _collection.doc();  // Auto-generate ID
        final data = toMap(item);
        data['createdAt'] = FieldValue.serverTimestamp();
        data['updatedAt'] = FieldValue.serverTimestamp();
        
        batch.set(docRef, data);
        ids.add(docRef.id);
      }
      
      await batch.commit();
      return FirebaseResult.success(ids);
    } catch (e) {
      return FirebaseResult.error('Failed to create batch: ${e.toString()}');
    }
  }

  // STREAM ALL - Real-time stream of all documents
  Stream<List<T>> streamAll({
    int? limit,
    String? orderBy,
    bool descending = false,
  }) {
    try {
      Query query = _collection;
      
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return fromMap(data);
        }).toList();
      });
    } catch (e) {
      return Stream.error('Failed to stream documents: ${e.toString()}');
    }
  }

  // STREAM DOCUMENT - Real-time stream of a single document
  Stream<T?> streamDocument(String id) {
    try {
      return _collection.doc(id).snapshots().map((doc) {
        if (!doc.exists) return null;
        
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return fromMap(data);
      });
    } catch (e) {
      return Stream.error('Failed to stream document: ${e.toString()}');
    }
  }

  // STREAM WHERE - Real-time stream of documents matching a condition
  Stream<List<T>> streamWhere({
    required String field,
    required dynamic value,
    String operator = '==',
    int? limit,
    String? orderBy,
    bool descending = false,
  }) {
    try {
      Query query = _collection;
      
      // Apply where condition
      switch (operator) {
        case '==':
          query = query.where(field, isEqualTo: value);
          break;
        case '>':
          query = query.where(field, isGreaterThan: value);
          break;
        case '<':
          query = query.where(field, isLessThan: value);
          break;
        case '>=':
          query = query.where(field, isGreaterThanOrEqualTo: value);
          break;
        case '<=':
          query = query.where(field, isLessThanOrEqualTo: value);
          break;
        case 'array-contains':
          query = query.where(field, arrayContains: value);
          break;
        case 'in':
          query = query.where(field, whereIn: value);
          break;
      }
      
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return fromMap(data);
        }).toList();
      });
    } catch (e) {
      return Stream.error('Failed to stream: ${e.toString()}');
    }
  }

  // PAGINATION - Get documents with pagination support
  DocumentSnapshot? _lastDocument;

  Future<FirebaseResult<List<T>>> getDocumentsPaginated({
    int limit = 20,
    String? orderBy,
    bool descending = false,
  }) async {
    try {
      Query query = _collection;
      
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }
      
      query = query.limit(limit);
      
      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }
      
      final snapshot = await query.get();
      
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      }
      
      final items = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return fromMap(data);
      }).toList();
      
      return FirebaseResult.success(items);
    } catch (e) {
      return FirebaseResult.error('Failed to get paginated documents: ${e.toString()}');
    }
  }

  /// Reset pagination to start from the beginning
  void resetPagination() {
    _lastDocument = null;
  }
}
