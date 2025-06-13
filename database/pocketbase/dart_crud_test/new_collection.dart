import 'package:pocketbase/pocketbase.dart';

// PocketBase client configuration
const String superuserEmail = 'hello@gmail.com';
const String superuserPassword = '12345678';

// Initialize PocketBase client
final pb = PocketBase('http://127.0.0.1:8090');

Future<void> createNewCollection() async {
  try {
    print('📋 Creating "records" collection...');

    final collection = await pb.collections.create(
      body: {
        'name': 'records',
        'type': 'base',
        'fields': [
          {
            'name': 'data',
            'type': 'json',
            'required': true,
            'options': {}, // For JSON, usually empty
          },
        ],
        'createRule': '@request.auth.id != ""',
        'updateRule': '@request.auth.id != ""',
        'deleteRule': '@request.auth.id != ""',
        'listRule': '',
        'viewRule': '',
      },
    );

    print('   Name: ${collection.name}');
    print('   Type: ${collection.type}');
    print('   ID: ${collection.id}');
  } catch (e) {
    print('❌ Failed to create collection: $e');
  }
}

/// Check if a collection exists before creating it
Future<bool> collectionExists(String collectionName) async {
  try {
    await pb.collections.getOne(collectionName);
    return true;
  } catch (e) {
    return false;
  }
}

Future<void> main() async {
  print('=== Dart PocketBase Collection Creation ===');

  try {
    // Authenticate as a superuser (replace with your credentials)
    await pb
        .collection('_superusers')
        .authWithPassword(superuserEmail, superuserPassword);
    print('✅ Authenticated as superuser successfully');

    // Check if collection exists first
    final exists = await collectionExists('records');
    print('Collection exists: $exists');

    if (!exists) {
      // Create new collection only if it doesn't exist
      print('\n--- CREATING NEW COLLECTION ---');
      await createNewCollection();
    }
  } catch (e) {
    print('❌ Error: $e');
  }
}
