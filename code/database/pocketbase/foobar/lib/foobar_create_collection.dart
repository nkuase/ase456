import 'package:pocketbase/pocketbase.dart';

void main() async {
  // Initialize PocketBase client
  final pb = PocketBase('http://127.0.0.1:8090');

  // Authenticate as admin (required to create collections)
  await pb
      .collection('_superusers')
      .authWithPassword('admin@example.com', 'admin123456');

  // Create a collection with separate fields for foo and bar
  final collection = await pb.collections.create(body: {
    'name': 'foobar',
    'type': 'base',
    'fields': [
      {'name': 'foo', 'type': 'text', 'required': true},
      {'name': 'bar', 'type': 'number', 'required': true},
    ],
    'createRule':
        '@request.auth.id != ""', // Only authenticated users can create
    'updateRule':
        '@request.auth.id != ""', // Only authenticated users can update
    'deleteRule':
        '@request.auth.id != ""', // Only authenticated users can delete
    'listRule': '', // Anyone can list records
    'viewRule': '', // Anyone can view records
  });

  print('Collection created with ID: ${collection.id}');

  // Example: Create a record with direct field access
  final record =
      await pb.collection('foobar').create(body: {'foo': 'val1', 'bar': 323});

  // Access fields directly
  print('foo value: ${record.data['foo']}'); // Output: val1
  print('bar value: ${record.data['bar']}'); // Output: 323
  print('id value: ${record.data['id']}'); // Output: <record_id>
}
