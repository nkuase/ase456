import 'student_api.dart';
import 'memory_database.dart';
import 'file_database.dart';

/// EXERCISE SOLUTIONS
/// For instructors and students who need help
/// 
/// NOTE: Try the exercises yourself first!
/// Learning happens when you struggle a bit and figure things out.

/// SOLUTION 1: Basic CRUD Operations
Future<void> solution1_BasicCRUD() async {
  print('✅ SOLUTION 1: Basic CRUD Operations');
  print('====================================');
  
  StudentAPI api = StudentAPI();
  await api.initialize();
  
  print('TASK 1: Add a student');
  await api.addStudent(name: "Alice Johnson", age: 18, major: "Computer Science");
  
  print('\nTASK 2: Find and display the student');
  var student = await api.findByName("Alice Johnson");
  print("Found: $student");
  
  print('\nTASK 3: Update age to 19');
  await api.updateAge("Alice Johnson", 19);
  
  print('\nTASK 4: Remove the student');
  await api.removeStudent("Alice Johnson");
  
  print('\nTASK 5: Try to find the student again');
  var deletedStudent = await api.findByName("Alice Johnson");
  if (deletedStudent == null) {
    print("✅ Student successfully deleted!");
  }
  
  await api.close();
  print('✅ Solution 1 completed!\n');
}

/// SOLUTION 2: Working with Multiple Students
Future<void> solution2_MultipleStudents() async {
  print('✅ SOLUTION 2: Working with Multiple Students');
  print('==============================================');
  
  StudentAPI api = StudentAPI();
  await api.initialize();
  
  print('TASK 1: Add 5 students');
  await api.addStudent(name: "Amy", age: 19, major: "Computer Science");
  await api.addStudent(name: "Ben", age: 20, major: "Computer Science");
  await api.addStudent(name: "Carla", age: 18, major: "Mathematics");
  await api.addStudent(name: "David", age: 21, major: "Mathematics");
  await api.addStudent(name: "Eva", age: 19, major: "Physics");
  
  print('\nTASK 2: Find all Computer Science students');
  var csStudents = await api.findByMajor("Computer Science");
  print('Computer Science students: ${csStudents.length}');
  for (var student in csStudents) {
    print('  $student');
  }
  
  print('\nTASK 3: Count students in each major');
  var allStudents = await api.getAllStudents();
  Map<String, int> majorCounts = {};
  for (var student in allStudents) {
    majorCounts[student.major] = (majorCounts[student.major] ?? 0) + 1;
  }
  majorCounts.forEach((major, count) {
    print('  $major: $count students');
  });
  
  print('\nTASK 4: Find the youngest student');
  int youngestAge = allStudents.map((s) => s.age).reduce((a, b) => a < b ? a : b);
  var youngestStudents = allStudents.where((s) => s.age == youngestAge).toList();
  print('Youngest student(s) (age $youngestAge):');
  for (var student in youngestStudents) {
    print('  ${student.name}');
  }
  
  await api.close();
  print('✅ Solution 2 completed!\n');
}

/// SOLUTION 3: Database Persistence Challenge
Future<void> solution3_PersistenceChallenge() async {
  print('✅ SOLUTION 3: Database Persistence Challenge');
  print('==============================================');
  
  print('TASK 1: Create API with FileDatabase');
  StudentAPI api = StudentAPI(database: FileDatabase(filename: 'persistence_test.json'));
  await api.initialize();
  
  print('\nTASK 2: Add 3 students and save them');
  await api.addStudent(name: "Persistent Alice", age: 20, major: "Data Science");
  await api.addStudent(name: "Persistent Bob", age: 21, major: "Engineering");
  await api.addStudent(name: "Persistent Carol", age: 19, major: "Physics");
  
  print('\nTASK 3: Close the API');
  await api.close();
  
  print('\nTASK 4: Create NEW API instance and load saved data');
  StudentAPI newApi = StudentAPI(database: FileDatabase(filename: 'persistence_test.json'));
  await newApi.initialize();
  
  print('\nTASK 5: Show that the data persisted');
  await newApi.showSummary();
  
  await newApi.close();
  print('✅ Solution 3 completed!\n');
}

/// SOLUTION 4: Database Switching Challenge
Future<void> solution4_SwitchingChallenge() async {
  print('✅ SOLUTION 4: Database Switching Challenge');
  print('============================================');
  
  StudentAPI api = StudentAPI();
  await api.initialize();
  
  print('TASK 1: Add students to Memory Database');
  await api.addStudent(name: "Memory Student 1", age: 20, major: "Testing");
  await api.addStudent(name: "Memory Student 2", age: 21, major: "Quality Assurance");
  
  print('\nTASK 2: Switch to File Database');
  await api.switchDatabase(FileDatabase(filename: 'switching_test.json'));
  
  print('\nTASK 3: Add more students to File Database');
  await api.addStudent(name: "File Student 1", age: 22, major: "Data Storage");
  await api.addStudent(name: "File Student 2", age: 23, major: "Persistence");
  
  print('\nTASK 4: Switch back to Memory Database');
  await api.switchDatabase(MemoryDatabase());
  
  print('\nTASK 5: Verify all 4 students are present');
  await api.showSummary();
  
  await api.close();
  print('✅ Solution 4 completed!\n');
}

/// SOLUTION 5: Build Your Own School System
Future<void> solution5_SchoolSystem() async {
  print('✅ SOLUTION 5: Build Your Own School System');
  print('============================================');
  
  StudentAPI api = StudentAPI(database: FileDatabase(filename: 'school_system.json'));
  await api.initialize();
  
  // Clear existing data
  await api.clearAll();
  
  print('🏫 School Management System Starting...\n');
  
  // Enroll students
  print('📝 Enrolling students...');
  await api.addStudent(name: "Alice Cooper", age: 19, major: "Computer Science");
  await api.addStudent(name: "Bob Dylan", age: 20, major: "Computer Science");
  await api.addStudent(name: "Carol King", age: 18, major: "Mathematics");
  await api.addStudent(name: "David Bowie", age: 21, major: "Mathematics");
  await api.addStudent(name: "Eva Green", age: 19, major: "Physics");
  await api.addStudent(name: "Frank Sinatra", age: 20, major: "Physics");
  
  // Show initial statistics
  print('\n📊 Initial Statistics:');
  await showStatistics(api);
  
  // Semester end - some students graduate
  print('\n🎓 Semester End - Some students graduated:');
  await api.removeStudent("Bob Dylan");
  await api.removeStudent("David Bowie");
  
  // Handle duplicate attempt
  print('\n🚫 Testing duplicate student handling:');
  bool duplicateResult = await api.addStudent(name: "Alice Cooper", age: 20, major: "Duplicate Major");
  if (!duplicateResult) {
    print('✅ Correctly rejected duplicate student');
  }
  
  // Final statistics
  print('\n📊 Final Statistics:');
  await showStatistics(api);
  
  await api.close();
  print('✅ School System completed!\n');
}

/// Helper function for school system statistics
Future<void> showStatistics(StudentAPI api) async {
  var allStudents = await api.getAllStudents();
  
  print('   Total Students: ${allStudents.length}');
  
  // Count by major
  Map<String, int> majorCounts = {};
  int totalAge = 0;
  for (var student in allStudents) {
    majorCounts[student.major] = (majorCounts[student.major] ?? 0) + 1;
    totalAge += student.age;
  }
  
  print('   Students by Major:');
  majorCounts.forEach((major, count) {
    print('     $major: $count students');
  });
  
  if (allStudents.isNotEmpty) {
    double averageAge = totalAge / allStudents.length;
    print('   Average Age: ${averageAge.toStringAsFixed(1)} years');
  }
}

/// BONUS SOLUTION: Error Handling
Future<void> bonusSolution_ErrorHandling() async {
  print('✅ BONUS SOLUTION: Error Handling');
  print('==================================');
  
  StudentAPI api = StudentAPI();
  await api.initialize();
  
  print('TASK 1: Try to add the same student twice');
  await api.addStudent(name: "Duplicate Dan", age: 20, major: "Testing");
  bool secondAdd = await api.addStudent(name: "Duplicate Dan", age: 20, major: "Testing");
  if (!secondAdd) {
    print('✅ Correctly handled duplicate student attempt');
  }
  
  print('\nTASK 2: Try to update a non-existent student');
  bool updateResult = await api.updateAge("Non Existent", 25);
  if (!updateResult) {
    print('✅ Correctly handled non-existent student update');
  }
  
  print('\nTASK 3: Try to delete a non-existent student');
  bool deleteResult = await api.removeStudent("Non Existent");
  if (!deleteResult) {
    print('✅ Correctly handled non-existent student deletion');
  }
  
  print('\nTASK 4: Handle the errors gracefully in your code');
  print('Example of good error handling:');
  
  if (await api.addStudent(name: "Safe Student", age: 22, major: "Safety")) {
    print('✅ Successfully added Safe Student');
  } else {
    print('❌ Failed to add Safe Student');
  }
  
  var foundStudent = await api.findByName("Safe Student");
  if (foundStudent != null) {
    print('✅ Found Safe Student: $foundStudent');
  } else {
    print('❌ Could not find Safe Student');
  }
  
  await api.close();
  print('✅ Error Handling completed!\n');
}

/// MAIN FUNCTION: Run all solutions
Future<void> main() async {
  print('✅ EXERCISE SOLUTIONS');
  print('=====================');
  print('These are the complete solutions to all exercises.\n');
  print('💡 Remember: Learning happens when you try first!');
  print('   Only look at solutions after attempting the exercises.\n');
  
  await solution1_BasicCRUD();
  await solution2_MultipleStudents();
  await solution3_PersistenceChallenge();
  await solution4_SwitchingChallenge();
  await solution5_SchoolSystem();
  await bonusSolution_ErrorHandling();
  
  print('🎉 ALL SOLUTIONS COMPLETED!');
  print('===========================');
  print('🎓 Key Learning Points:');
  print('   ✅ APIs make database operations simple and consistent');
  print('   ✅ Database switching allows flexibility without code changes');
  print('   ✅ Error handling makes applications robust and user-friendly');
  print('   ✅ Good software design patterns scale from simple to complex');
  print('\n🚀 You now understand professional database API design!');
}
