import 'package:firedart/firedart.dart';
import 'dart:math';

Map<String, dynamic> generateRandomData() {
  final random = Random();
  
  // Random strings for "foo"
  final fooOptions = ['abc', 'xyz', 'hello', 'world', 'dart', 'firebase'];
  final randomFoo = fooOptions[random.nextInt(fooOptions.length)];
  
  // Random number for "bar" (1-100)
  final randomBar = random.nextInt(100) + 1;
  
  return {
    "foo": randomFoo,
    "bar": randomBar
  };
}

Future<void> main() async {
  // Initialize Firestore with your project ID (not Firebase app)
  Firestore.initialize("foobar-a1317"); // Your project ID only
  
  // Get Firestore instance
  final firestore = Firestore.instance;
  
  try {
    // Step 1: Add document
    print("Adding document...");
    Document addedDoc = await firestore
        .collection('foo')
        .add(generateRandomData());
    
    print("Document added with ID: ${addedDoc.id}");
    
    // Step 2: Get document (already have it from add operation)
    print("Getting document data...");
    Map<String, dynamic> data = addedDoc.map;
    
    print("Retrieved data: $data");
    print("foo: ${data['foo']}");
    print("bar: ${data['bar']}");
    
    // Alternative: Get document by ID if needed
    print("\nAlternative - Get by ID:");
    Document retrievedDoc = await firestore
        .collection('foo')
        .document(addedDoc.id)
        .get();
    
    print("Retrieved by ID: ${retrievedDoc.map}");
  } catch (e) {
    print("Error: $e");
  } finally {
    // Close the Firestore connection to allow program to exit
    print("\nClosing connection...");
    Firestore.instance.close();
    print("Program finished!");
  }
}