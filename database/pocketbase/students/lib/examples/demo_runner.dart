import '../../../../advanced/advanced/database_abstraction_demo.dart';
import '../../../../advanced/pocketbase/database_crud.dart';

/// Main demo runner to show database abstraction in action
/// This file demonstrates how to run the database abstraction examples
void main() async {
  print('🚀 Starting Database Abstraction Demo');
  print('=====================================\n');

  try {
    // Run the comprehensive demo that includes all examples
    await runComprehensiveDemo();

  } catch (e, stackTrace) {
    print('\n❌ Demo failed with error: $e');
    print('📍 Stack trace: $stackTrace');
  }
}

/// Example of how to run individual demo components
Future<void> runIndividualDemos() async {
  print('🔧 Individual Demo Examples');
  print('============================\n');

  try {
    // Create a mock database for testing
    DatabaseCrudService mockDb = createMockDatabase();

    // Run individual demos
    await runDatabaseDemo(mockDb, 'Mock');
    await demonstrateBusinessLogic(mockDb);
    await demonstrateAdvancedOperations(mockDb);

    print('\n✅ Individual demos completed!');

  } catch (e, stackTrace) {
    print('\n❌ Individual demos failed: $e');
    print('📍 Stack trace: $stackTrace');
  }
}
