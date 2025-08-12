import 'dart:math';
import 'models/foobar.dart';
import 'services/foobar_crud_firebase.dart';

/// Generate random FooBar data for testing
FooBar generateRandomFooBar() {
  final random = Random();
  
  // Random strings for "foo"
  final fooOptions = ['abc', 'xyz', 'hello', 'world', 'dart', 'firebase'];
  final randomFoo = fooOptions[random.nextInt(fooOptions.length)];
  
  // Random number for "bar" (1-100)
  final randomBar = random.nextInt(100) + 1;
  
  return FooBar(foo: randomFoo, bar: randomBar);
}

/// Main demonstration of Firebase CRUD operations
Future<void> main() async {
  print('🚀 Starting Firebase FooBar CRUD Demo');
  print('====================================');
  
  // Create service instance
  final crudService = FooBarCrudFirebase();
  
  try {
    // Initialize Firebase
    await crudService.initialize();
    
    // DEMO: CREATE operations
    print('\n🔸 STEP 1: CREATE Operations');
    print('-----------------------------');
    
    // Create some sample FooBar documents
    List<FooBar> createdFooBars = [];
    
    for (int i = 0; i < 3; i++) {
      FooBar newFooBar = generateRandomFooBar();
      FooBar? created = await crudService.create(newFooBar);
      if (created != null) {
        createdFooBars.add(created);
        print('   Created: $created');
      }
    }
    
    // DEMO: READ operations
    print('\n🔸 STEP 2: READ Operations');
    print('--------------------------');
    
    // Read all documents
    List<FooBar> allFooBars = await crudService.readAll();
    print('📋 All FooBar documents:');
    for (int i = 0; i < allFooBars.length; i++) {
      print('   ${i + 1}. ${allFooBars[i]}');
    }
    
    // Read a specific document
    if (createdFooBars.isNotEmpty) {
      String idToRead = createdFooBars.first.id!;
      FooBar? readFooBar = await crudService.read(idToRead);
      print('🔍 Read specific document: $readFooBar');
    }
    
    // Query documents by bar value
    if (allFooBars.isNotEmpty) {
      int barToQuery = allFooBars.first.bar;
      List<FooBar> queriedFooBars = await crudService.readByBar(barToQuery);
      print('🔍 FooBars with bar = $barToQuery: ${queriedFooBars.length} found');
    }
    
    // DEMO: UPDATE operations
    print('\n🔸 STEP 3: UPDATE Operations');
    print('----------------------------');
    
    if (createdFooBars.isNotEmpty) {
      // Full update
      FooBar toUpdate = createdFooBars.first;
      FooBar updatedFooBar = FooBar(
        id: toUpdate.id,
        foo: 'updated_${toUpdate.foo}',
        bar: toUpdate.bar + 100,
      );
      
      bool updateSuccess = await crudService.update(toUpdate.id!, updatedFooBar);
      if (updateSuccess) {
        print('📝 Updated FooBar: $updatedFooBar');
        
        // Verify the update
        FooBar? verified = await crudService.read(toUpdate.id!);
        print('✅ Verified update: $verified');
      }
      
      // Partial update
      if (createdFooBars.length > 1) {
        FooBar toPartialUpdate = createdFooBars[1];
        Map<String, dynamic> partialUpdates = {
          'foo': 'partial_update',
        };
        
        bool partialSuccess = await crudService.updateFields(
          toPartialUpdate.id!, 
          partialUpdates
        );
        if (partialSuccess) {
          FooBar? partialVerified = await crudService.read(toPartialUpdate.id!);
          print('📝 Partial update result: $partialVerified');
        }
      }
    }
    
    // DEMO: DELETE operations
    print('\n🔸 STEP 4: DELETE Operations');
    print('----------------------------');
    
    if (createdFooBars.length > 2) {
      // Delete one document
      FooBar toDelete = createdFooBars.last;
      bool deleteSuccess = await crudService.delete(toDelete.id!);
      
      if (deleteSuccess) {
        print('🗑️ Deleted FooBar: $toDelete');
        
        // Try to read deleted document (should return null)
        FooBar? deletedCheck = await crudService.read(toDelete.id!);
        if (deletedCheck == null) {
          print('✅ Verified: Document was successfully deleted');
        }
      }
    }
    
    // DEMO: Final summary
    print('\n🔸 FINAL SUMMARY');
    print('----------------');
    
    int finalCount = await crudService.count();
    print('📊 Total FooBar documents: $finalCount');
    
    List<FooBar> finalFooBars = await crudService.readAll();
    print('📋 Final inventory:');
    for (FooBar fb in finalFooBars) {
      print('   • $fb');
    }
    
  } catch (e) {
    print('💥 Demo failed with error: $e');
  } finally {
    // Always close the connection
    crudService.close();
  }
  
  print('\n🎉 Demo completed!');
  print('\n📚 What we learned:');
  print('   ✓ How to create documents in Firebase');
  print('   ✓ How to read documents (single and all)');
  print('   ✓ How to query documents with filters');
  print('   ✓ How to update documents (full and partial)');
  print('   ✓ How to delete documents');
  print('   ✓ How to handle errors in database operations');
  print('   ✓ How to model data with Dart classes');
  print('   ✓ How to serialize/deserialize data for Firebase');
}
