import 'package:test/test.dart';
import 'package:pocketbase/pocketbase.dart';

/// Unit tests for PocketBase connection
/// Demonstrates testing external service connections
void main() {
  group('Initialize Tests', () {
    test('should connect to pocketbase', () async {
      // Connect to PocketBase server
      final pb = PocketBase('http://127.0.0.1:8090');
      
      try {
        // Test authentication
        await pb.collection('users').authWithPassword(
          'user@example.com', 
          'password'
        );
        print('✅ Authentication successful');
        
        // Test health check
        await pb.health.check();
        print('✅ PocketBase server is running');
        
      } catch (e) {
        print('❌ PocketBase connection failed: $e');
        // Re-throw the error so the test fails properly
        rethrow;
      }
    });
  });
}
