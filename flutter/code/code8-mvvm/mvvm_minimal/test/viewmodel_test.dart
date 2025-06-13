// test/viewmodel_test.dart  
// This is the main test file - runs all test categories
import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'models/counter_test.dart' as counter_tests;
import 'viewmodels/counter_viewmodel_test.dart' as viewmodel_tests;
import 'widgets/counter_view_test.dart' as widget_tests;
import 'integration/mvvm_integration_test.dart' as integration_tests;

void main() {
  print('🧪 Running Mini MVVM Test Suite');
  print('=====================================');
  
  group('📦 Model Layer Tests', () {
    counter_tests.main();
  });
  
  group('🧠 ViewModel Layer Tests', () {
    viewmodel_tests.main();
  });
  
  group('🎨 View Layer Tests', () {
    widget_tests.main();
  });
  
  group('🔄 MVVM Integration Tests', () {
    integration_tests.main();
  });
  
  print('✅ All MVVM layers tested successfully!');
}