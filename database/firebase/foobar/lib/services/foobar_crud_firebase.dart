import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/foobar.dart';

/// CRUD (Create, Read, Update, Delete) operations for FooBar entities using Firebase Firestore
/// This class demonstrates fundamental cloud database operations for teaching purposes
class FooBarCrudFirebase {
  final FirebaseFirestore _firestore;
  final String _collectionName = 'foobars';

  /// Constructor allows injection of FirebaseFirestore instance
  /// This enables testing with fake_cloud_firestore
  FooBarCrudFirebase({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Gets the collection reference for foobars
  CollectionReference get _collection => _firestore.collection(_collectionName);

  /// CREATE: Add a new FooBar document to Firestore
  /// Returns the document ID of the created record
  Future<String> create(FooBar foobar) async {
    try {
      // Add server timestamp automatically
      final data = foobar.toJson();
      data['createdAt'] = FieldValue.serverTimestamp();

      // Add document to collection
      final docRef = await _collection.add(data);
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create FooBar: $e');
    }
  }

  /// READ: Get all FooBar documents from Firestore
  /// Returns a list of all FooBar objects ordered by creation time
  Future<List<FooBar>> readAll() async {
    try {
      final querySnapshot = await _collection
          .orderBy('createdAt', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => FooBar.fromDocument(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to read all FooBars: $e');
    }
  }

  /// READ: Get a FooBar document by ID
  /// Returns null if document not found
  Future<FooBar?> read(String id) async {
    try {
      final docSnapshot = await _collection.doc(id).get();
      
      if (!docSnapshot.exists) {
        return null;
      }

      return FooBar.fromDocument(docSnapshot);
    } catch (e) {
      throw Exception('Failed to read FooBar with ID $id: $e');
    }
  }

  /// READ: Find FooBar documents by foo field (like a search)
  /// Uses Firestore queries to find matching documents
  /// Returns a list of matching FooBar objects
  Future<List<FooBar>> findByFoo(String foo) async {
    try {
      // Note: Firestore doesn't have a LIKE operator, so we use different approaches
      // Approach 1: Exact match
      final querySnapshot = await _collection
          .where('foo', isEqualTo: foo)
          .orderBy('createdAt')
          .get();

      return querySnapshot.docs
          .map((doc) => FooBar.fromDocument(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to find FooBars by foo: $e');
    }
  }

  /// READ: Find FooBar documents by foo field with text search simulation
  /// Since Firestore doesn't have full-text search, we implement a simple solution
  /// For production apps, consider using Algolia or Elasticsearch
  Future<List<FooBar>> findByFooContains(String searchText) async {
    try {
      // Get all documents and filter client-side
      // Note: This is not efficient for large datasets!
      final allFooBars = await readAll();
      
      return allFooBars
          .where((foobar) => 
              foobar.foo.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Failed to search FooBars: $e');
    }
  }

  /// READ: Find FooBar documents by bar value range
  /// Demonstrates Firestore range queries
  Future<List<FooBar>> findByBarRange(int minBar, int maxBar) async {
    try {
      final querySnapshot = await _collection
          .where('bar', isGreaterThanOrEqualTo: minBar)
          .where('bar', isLessThanOrEqualTo: maxBar)
          .orderBy('bar')
          .get();

      return querySnapshot.docs
          .map((doc) => FooBar.fromDocument(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to find FooBars by bar range: $e');
    }
  }

  /// UPDATE: Update an existing FooBar document
  /// Returns true if successful, false if document not found
  Future<bool> update(String id, FooBar foobar) async {
    try {
      final docRef = _collection.doc(id);
      
      // Check if document exists
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        return false;
      }

      // Update the document
      final data = foobar.toJson();
      data['updatedAt'] = FieldValue.serverTimestamp();
      
      await docRef.update(data);
      return true;
    } catch (e) {
      throw Exception('Failed to update FooBar with ID $id: $e');
    }
  }

  /// UPDATE: Update specific fields of a FooBar document
  /// More efficient than updating the entire document
  Future<bool> updateFields(String id, Map<String, dynamic> fields) async {
    try {
      final docRef = _collection.doc(id);
      
      // Check if document exists
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        return false;
      }

      // Add update timestamp
      fields['updatedAt'] = FieldValue.serverTimestamp();
      
      await docRef.update(fields);
      return true;
    } catch (e) {
      throw Exception('Failed to update FooBar fields for ID $id: $e');
    }
  }

  /// DELETE: Remove a FooBar document by ID
  /// Returns true if successful, false if document not found
  Future<bool> delete(String id) async {
    try {
      final docRef = _collection.doc(id);
      
      // Check if document exists
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        return false;
      }

      await docRef.delete();
      return true;
    } catch (e) {
      throw Exception('Failed to delete FooBar with ID $id: $e');
    }
  }

  /// DELETE: Remove all FooBar documents (use with extreme caution!)
  /// Returns the number of deleted documents
  /// Note: Firestore doesn't have a "delete all" operation, so we do it in batches
  Future<int> deleteAll() async {
    try {
      int deletedCount = 0;
      
      // Get all documents
      final querySnapshot = await _collection.get();
      
      // Delete in batches (Firestore batch limit is 500 operations)
      const batchSize = 500;
      final batch = _firestore.batch();
      
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        batch.delete(querySnapshot.docs[i].reference);
        deletedCount++;
        
        // Commit batch if we reach the limit
        if ((i + 1) % batchSize == 0) {
          await batch.commit();
          // Start a new batch
          final newBatch = _firestore.batch();
        }
      }
      
      // Commit any remaining operations
      await batch.commit();
      
      return deletedCount;
    } catch (e) {
      throw Exception('Failed to delete all FooBars: $e');
    }
  }

  /// Get count of all documents
  /// Useful for statistics and pagination
  /// Note: Firestore count() is only available in some SDKs, so we use aggregation
  Future<int> count() async {
    try {
      final querySnapshot = await _collection.count().get();
      return querySnapshot.count;
    } catch (e) {
      // Fallback: Count by getting all documents (not efficient for large collections)
      try {
        final allDocs = await _collection.get();
        return allDocs.docs.length;
      } catch (fallbackError) {
        throw Exception('Failed to count FooBars: $e');
      }
    }
  }

  /// Check if a document exists by ID
  /// Returns true if exists, false otherwise
  Future<bool> exists(String id) async {
    try {
      final docSnapshot = await _collection.doc(id).get();
      return docSnapshot.exists;
    } catch (e) {
      throw Exception('Failed to check if FooBar exists with ID $id: $e');
    }
  }

  /// READ: Get paginated results
  /// Useful for large datasets to avoid loading everything at once
  Future<List<FooBar>> readPaginated({
    int limit = 10,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query = _collection
          .orderBy('createdAt', descending: false)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => FooBar.fromDocument(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to read paginated FooBars: $e');
    }
  }

  /// Listen to real-time updates for all FooBar documents
  /// Returns a stream of FooBar lists that updates in real-time
  /// This is a powerful feature of Firestore - real-time synchronization!
  Stream<List<FooBar>> streamAll() {
    try {
      return _collection
          .orderBy('createdAt', descending: false)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs
              .map((doc) => FooBar.fromDocument(doc))
              .toList());
    } catch (e) {
      throw Exception('Failed to stream FooBars: $e');
    }
  }

  /// Listen to real-time updates for a specific FooBar document
  /// Returns a stream of FooBar that updates in real-time
  Stream<FooBar?> streamById(String id) {
    try {
      return _collection
          .doc(id)
          .snapshots()
          .map((docSnapshot) {
            if (!docSnapshot.exists) return null;
            return FooBar.fromDocument(docSnapshot);
          });
    } catch (e) {
      throw Exception('Failed to stream FooBar with ID $id: $e');
    }
  }

  /// Batch create multiple FooBar documents
  /// More efficient than creating one by one
  Future<List<String>> createBatch(List<FooBar> foobars) async {
    try {
      final batch = _firestore.batch();
      final docIds = <String>[];

      for (final foobar in foobars) {
        final docRef = _collection.doc(); // Auto-generate ID
        final data = foobar.toJson();
        data['createdAt'] = FieldValue.serverTimestamp();
        
        batch.set(docRef, data);
        docIds.add(docRef.id);
      }

      await batch.commit();
      return docIds;
    } catch (e) {
      throw Exception('Failed to create batch FooBars: $e');
    }
  }
}
