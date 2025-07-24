import 'student_api.dart';
import 'memory_database.dart';
import 'file_database.dart';

/// DEMO 1: Basic API Usage for Beginners
/// This shows how easy it is to work with students using our API
Future<void> basicDemo() async {
  print('🎓 DEMO 1: Basic Student API Usage');
  print('===================================');
  
  // Step 1: Create the API
  StudentAPI api = StudentAPI();
  await api.initialize();
  
  // Step 2: Add some students
  print('\n📝 Adding Students...');
  await api.addStudent(name: "Alice Johnson", age: 19, major: "Computer Science");
  await api.addStudent(name: "Bob Smith", age: 20, major: "Mathematics");
  await api.addStudent(name: "Charlie Brown", age: 18, major: "Computer Science");
  await api.addStudent(name: "Diana Prince", age: 21, major: "Physics");
  
  // Step 3: Show all students
  await api.showSummary();
  
  // Step 4: Find students by major
  print('🔍 Finding Computer Science students...');
  var csStudents = await api.findByMajor("Computer Science");
  for (var student in csStudents) {
    print('  Found: $student');
  }
  
  // Step 5: Update a student
  print('\n📝 Alice had a birthday!');
  await api.updateAge("Alice Johnson", 20);
  
  // Step 6: Find a specific student
  print('\n🔍 Looking for Bob...');
  var bob = await api.findByName("Bob Smith");
  if (bob != null) {
    print('  Found Bob: $bob');
  }
  
  // Step 7: Remove a student (graduated!)
  print('\n🎓 Diana graduated!');
  await api.removeStudent("Diana Prince");
  
  // Step 8: Final summary
  await api.showSummary();
  
  // Step 9: Clean up
  await api.close();
  
  print('✅ Basic demo completed!\n');
}

/// DEMO 2: Database Switching Magic
/// This shows the POWER of our API - same commands, different storage!
Future<void> databaseSwitchingDemo() async {
  print('🔄 DEMO 2: Database Switching Magic');
  print('====================================');
  
  // Start with memory database
  print('Starting with Memory Database...');
  StudentAPI api = StudentAPI(database: MemoryDatabase());
  await api.initialize();
  
  // Add some students
  await api.addStudent(name: "Memory Student 1", age: 19, major: "Computer Science");
  await api.addStudent(name: "Memory Student 2", age: 20, major: "Mathematics");
  await api.showSummary();
  
  // Switch to file database - SAME API METHODS!
  print('🔄 Switching to File Database...');
  await api.switchDatabase(FileDatabase(filename: 'demo_students.json'));
  await api.showSummary();
  
  // Add more students with file database
  await api.addStudent(name: "File Student 1", age: 21, major: "Physics");
  await api.addStudent(name: "File Student 2", age: 22, major: "Chemistry");
  await api.showSummary();
  
  // Switch back to memory database
  print('🔄 Switching back to Memory Database...');
  await api.switchDatabase(MemoryDatabase());
  await api.showSummary();
  
  print('🎯 KEY POINT: Same API methods worked with both databases!');
  print('   - api.addStudent() worked with memory AND file storage');
  print('   - api.showSummary() worked with both databases');
  print('   - Your code doesn\'t change when you switch databases!');
  
  await api.close();
  print('✅ Database switching demo completed!\n');
}

/// DEMO 3: Real-World Scenario
/// This shows how you might use this in a real application
Future<void> realWorldDemo() async {
  print('🌍 DEMO 3: Real-World Scenario');
  print('===============================');
  print('Imagine you\'re building a school management app...\n');
  
  // Phase 1: Development (use simple memory storage)
  print('🛠️ PHASE 1: Development');
  print('Using memory database for quick testing...');
  StudentAPI api = StudentAPI(database: MemoryDatabase());
  await api.initialize();
  
  // Add test data
  await api.addStudent(name: "Test Student 1", age: 20, major: "Testing");
  await api.addStudent(name: "Test Student 2", age: 21, major: "Quality Assurance");
  print('Added test students for development');
  
  // Phase 2: Production (switch to file storage for persistence)
  print('\n🚀 PHASE 2: Production');
  print('Switching to file database for real data...');
  await api.switchDatabase(FileDatabase(filename: 'school_students.json'));
  
  // Add real students
  await api.addStudent(name: "John Doe", age: 19, major: "Computer Science");
  await api.addStudent(name: "Jane Smith", age: 20, major: "Engineering");
  await api.addStudent(name: "Mike Johnson", age: 18, major: "Mathematics");
  
  await api.showSummary();
  
  // Show some real operations
  print('📋 Getting all Computer Science students...');
  var csStudents = await api.findByMajor("Computer Science");
  print('Found ${csStudents.length} CS students');
  
  print('\n🎓 End of semester - some students graduated...');
  await api.removeStudent("John Doe");
  
  await api.showSummary();
  await api.close();
  
  print('🎯 REAL-WORLD BENEFITS:');
  print('   ✅ Started simple (memory) for development');
  print('   ✅ Upgraded to persistent storage (file) for production');
  print('   ✅ Same code worked in both phases!');
  print('   ✅ Easy to switch to cloud database later (Firebase, etc.)');
  
  print('✅ Real-world demo completed!\n');
}

/// MAIN FUNCTION: Run all demos
Future<void> main() async {
  print('🎓 STUDENT API DEMONSTRATIONS');
  print('===============================');
  print('These demos show how easy database APIs make programming!\n');
  
  // Run all demos
  await basicDemo();
  await databaseSwitchingDemo();
  await realWorldDemo();
  
  print('🎉 ALL DEMOS COMPLETED!');
  print('======================');
  print('You\'ve seen how:');
  print('✅ APIs make database operations simple');
  print('✅ Same code works with different databases');
  print('✅ You can start simple and upgrade later');
  print('✅ This is how professional software is built!');
  print('\n🚀 Ready to build your own APIs?');
}
