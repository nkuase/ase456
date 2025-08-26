import 'package:firedart/firedart.dart';
import '../models/foobar.dart';

/// Simple CRUD service for FooBar documents in Firebase
/// 
/// This service demonstrates:
/// - Firebase initialization
/// - Create, Read, Update, Delete operations
/// - Error handling
/// - Collection management
class FooBarCrudFirebase {
  late Firestore _firestore;
  final String _collectionName = 'foobars';

  /// Initialize Firebase connection
  /// Call this before using any other methods
  Future<void> initialize({String projectId = 'foobar-a1317'}) async {
    try {
      print('🔥 Initializing Firebase...');
      Firestore.initialize(projectId);
      _firestore = Firestore.instance;
      print('✅ Firebase initialized successfully');
    } catch (e) {
      print('❌ Firebase initialization failed: $e');
      rethrow;
    }
  }

  /// CREATE: Add a new FooBar document
  /// Returns the created document with its ID
  Future<FooBar?> create(FooBar foobar) async {
    try {
      print('📝 Creating new FooBar: ${foobar.foo}');
      
      // Add document to collection
      Document doc = await _firestore
          .collection(_collectionName)
          .add(foobar.toMap());
      
      print('✅ FooBar created with ID: ${doc.id}');
      
      // Return the FooBar with the new ID
      return foobar.copyWith(id: doc.id);
    } catch (e) {
      print('❌ Error creating FooBar: $e');
      return null;
    }
  }

  /// READ: Get a single FooBar by ID
  Future<FooBar?> read(String id) async {
    try {
      print('📖 Reading FooBar with ID: $id');
      
      // Get document by ID
      Document doc = await _firestore
          .collection(_collectionName)
          .document(id)
          .get();
      
      // Convert to FooBar object
      FooBar foobar = FooBar.fromMap(doc.map, doc.id);
      print('✅ FooBar retrieved: $foobar');
      
      return foobar;
    } catch (e) {
      print('❌ Error reading FooBar: $e');
      return null;
    }
  }

  /// READ: Get all FooBar documents
  Future<List<FooBar>> readAll() async {
    try {
      print('📚 Reading all FooBar documents...');
      
      // Get all documents from collection
      List<Document> docs = await _firestore
          .collection(_collectionName)
          .get();
      
      // Convert to FooBar objects
      List<FooBar> foobars = docs
          .map((doc) => FooBar.fromMap(doc.map, doc.id))
          .toList();
      
      print('✅ Retrieved ${foobars.length} FooBar documents');
      return foobars;
    } catch (e) {
      print('❌ Error reading all FooBars: $e');
      return [];
    }
  }

  /// READ: Query FooBar documents where bar value equals the given number
  Future<List<FooBar>> readByBar(int barValue) async {
    try {
      print('🔍 Querying FooBars where bar = $barValue');
      
      // Query documents with filter
      List<Document> docs = await _firestore
          .collection(_collectionName)
          .where('bar', isEqualTo: barValue)
          .get();
      
      // Convert to FooBar objects
      List<FooBar> foobars = docs
          .map((doc) => FooBar.fromMap(doc.map, doc.id))
          .toList();
      
      print('✅ Found ${foobars.length} FooBars with bar = $barValue');
      return foobars;
    } catch (e) {
      print('❌ Error querying FooBars: $e');
      return [];
    }
  }

  /// UPDATE: Modify an existing FooBar document
  Future<bool> update(String id, FooBar updatedFoobar) async {
    try {
      print('✏️ Updating FooBar with ID: $id');
      print('   New data: $updatedFoobar');
      
      // Update document
      await _firestore
          .collection(_collectionName)
          .document(id)
          .update(updatedFoobar.toMap());
      
      print('✅ FooBar updated successfully');
      return true;
    } catch (e) {
      print('❌ Error updating FooBar: $e');
      return false;
    }
  }

  /// UPDATE: Partially update specific fields
  Future<bool> updateFields(String id, Map<String, dynamic> updates) async {
    try {
      print('✏️ Updating FooBar fields for ID: $id');
      print('   Updates: $updates');
      
      // Update specific fields
      await _firestore
          .collection(_collectionName)
          .document(id)
          .update(updates);
      
      print('✅ FooBar fields updated successfully');
      return true;
    } catch (e) {
      print('❌ Error updating FooBar fields: $e');
      return false;
    }
  }

  /// DELETE: Remove a FooBar document
  Future<bool> delete(String id) async {
    try {
      print('🗑️ Deleting FooBar with ID: $id');
      
      // Delete document
      await _firestore
          .collection(_collectionName)
          .document(id)
          .delete();
      
      print('✅ FooBar deleted successfully');
      return true;
    } catch (e) {
      print('❌ Error deleting FooBar: $e');
      return false;
    }
  }

  /// Get the count of all documents (utility method)
  Future<int> count() async {
    try {
      List<Document> docs = await _firestore
          .collection(_collectionName)
          .get();
      return docs.length;
    } catch (e) {
      print('❌ Error counting documents: $e');
      return 0;
    }
  }

  /// Close Firebase connection
  /// Call this when you're done with Firebase operations
  void close() {
    print('🔒 Closing Firebase connection...');
    _firestore.close();
    print('✅ Firebase connection closed');
  }
}
