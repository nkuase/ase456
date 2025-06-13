import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/firebase_result.dart';

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

  // READ - Get a single document by ID
  Future<FirebaseResult<T?>> read(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      
      if (!doc.exists) {
        return FirebaseResult.success(null);
      }
      
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      
      final item = fromMap(data);
      return FirebaseResult.success(item);
    } catch (e) {
      return FirebaseResult.error('Failed to read document: ${e.toString()}');
    }
  }

  // READ - Get all documents
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

  // READ - Get documents with conditions
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
      
      // Apply where condition
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
      return FirebaseResult.error('Failed to read documents with condition: ${e.toString()}');
    }
  }

  // UPDATE - Update an existing document
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

  // UPDATE - Update specific fields
  Future<FirebaseResult<void>> updateFields(String id, Map<String, dynamic> fields) async {
    try {
      fields['updatedAt'] = FieldValue.serverTimestamp();
      await _collection.doc(id).update(fields);
      return FirebaseResult.success(null);
    } catch (e) {
      return FirebaseResult.error('Failed to update document fields: ${e.toString()}');
    }
  }

  // DELETE - Delete a document by ID
  Future<FirebaseResult<void>> delete(String id) async {
    try {
      await _collection.doc(id).delete();
      return FirebaseResult.success(null);
    } catch (e) {
      return FirebaseResult.error('Failed to delete document: ${e.toString()}');
    }
  }

  // DELETE - Delete multiple documents with condition
  Future<FirebaseResult<int>> deleteWhere({
    required String field,
    required dynamic value,
    String operator = '==',
  }) async {
    try {
      Query query = _collection;
      
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

  // STREAM - Listen to real-time updates for all documents
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

  // STREAM - Listen to real-time updates for a single document
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

  // STREAM - Listen to real-time updates with conditions
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
      return Stream.error('Failed to stream documents with condition: ${e.toString()}');
    }
  }

  // BATCH OPERATIONS
  Future<FirebaseResult<List<String>>> createBatch(List<T> items) async {
    try {
      final batch = _firestore.batch();
      final ids = <String>[];
      
      for (final item in items) {
        final docRef = _collection.doc();
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

  // COUNT - Get document count
  Future<FirebaseResult<int>> count() async {
    try {
      final snapshot = await _collection.count().get();
      return FirebaseResult.success(snapshot.count ?? 0);
    } catch (e) {
      return FirebaseResult.error('Failed to count documents: ${e.toString()}');
    }
  }

  // EXISTS - Check if document exists
  Future<FirebaseResult<bool>> exists(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      return FirebaseResult.success(doc.exists);
    } catch (e) {
      return FirebaseResult.error('Failed to check document existence: ${e.toString()}');
    }
  }
}