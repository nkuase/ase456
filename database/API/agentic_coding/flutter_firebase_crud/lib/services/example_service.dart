import '../models/example_model.dart';
import 'firebase_crud_service.dart';

class ExampleService extends FirebaseCrudService<ExampleModel> {
  ExampleService()
      : super(
          collectionName: 'examples', // Your Firestore collection name
          fromMap: ExampleModel.fromMap,
          toMap: (model) => model.toMap(),
        );

  // Additional custom methods specific to ExampleModel can be added here
  
  // Example: Get all items where bar is greater than a certain value
  Future<List<ExampleModel>> getByBarGreaterThan(int value) async {
    final result = await readWhere(
      field: 'bar',
      value: value,
      operator: '>',
      orderBy: 'bar',
      descending: false,
    );
    
    return result.fold(
      onSuccess: (items) => items,
      onError: (error) {
        print('Error getting items by bar > $value: $error');
        return [];
      },
    );
  }

  // Example: Get all items where foo contains a certain string
  Future<List<ExampleModel>> getByFooContaining(String searchText) async {
    final result = await readAll(orderBy: 'foo');
    
    return result.fold(
      onSuccess: (items) {
        return items.where((item) => 
          item.foo.toLowerCase().contains(searchText.toLowerCase())
        ).toList();
      },
      onError: (error) {
        print('Error searching items: $error');
        return [];
      },
    );
  }

  // Example: Stream items where bar is in a specific range
  Stream<List<ExampleModel>> streamByBarRange(int min, int max) {
    return streamWhere(
      field: 'bar',
      value: min,
      operator: '>=',
      orderBy: 'bar',
    ).asyncMap((items) async {
      return items.where((item) => item.bar <= max).toList();
    });
  }

  // Example: Update only the bar field
  Future<bool> updateBar(String id, int newBar) async {
    final result = await updateFields(id, {'bar': newBar});
    
    return result.fold(
      onSuccess: (_) => true,
      onError: (error) {
        print('Error updating bar: $error');
        return false;
      },
    );
  }

  // Example: Delete all items with bar less than a value
  Future<int> deleteByBarLessThan(int value) async {
    final result = await deleteWhere(
      field: 'bar',
      value: value,
      operator: '<',
    );
    
    return result.fold(
      onSuccess: (count) => count,
      onError: (error) {
        print('Error deleting items: $error');
        return 0;
      },
    );
  }
}