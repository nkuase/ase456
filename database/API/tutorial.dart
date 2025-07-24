import 'student_api.dart';
import 'memory_database.dart';
import 'file_database.dart';

/// STEP-BY-STEP TUTORIAL for College Freshmen
/// Follow this guide to learn how database APIs work!
/// 
/// Each step builds on the previous one, so don't skip ahead!

/// STEP 1: Your First API Call
/// Let's start with the simplest possible example
Future<void> step1_FirstApiCall() async {
  print('📚 STEP 1: Your First API Call');
  print('===============================');
  print('Goal: Create the API and add one student\n');
  
  // Create the API (it starts with memory database automatically)
  StudentAPI api = StudentAPI();
  await api.initialize();
  
  print('🎯 YOUR TASK: Add a student named "Alex" who is 19 and studies "Art"');
  
  // YOUR CODE HERE: Use api.addStudent() to add Alex
  await api.addStudent(name: "Alex", age: 19, major: "Art");
  
  // Check if it worked
  var alex = await api.findByName("Alex");
  if (alex != null) {
    print('✅ SUCCESS! You added: $alex');
  } else {
    print('❌ Hmm, Alex wasn\'t found. Check your addStudent() call.');
  }
  
  await api.close();
  print('Step 1 completed! 🎉\n');
}

/// STEP 2: Adding Multiple Students
/// Now let's add several students and see them all
Future<void> step2_MultipleStudents() async {
  print('📚 STEP 2: Adding Multiple Students');
  print('====================================');
  print('Goal: Add 3 students and display them all\n');
  
  StudentAPI api = StudentAPI();
  await api.initialize();
  
  print('🎯 YOUR TASK: Add these 3 students:');
  print('   1. Emma, age 20, studies Biology');
  print('   2. Jack, age 18, studies Physics');  
  print('   3. Sophia, age 21, studies Biology');
  
  // YOUR CODE HERE: Add all three students
  await api.addStudent(name: "Emma", age: 20, major: "Biology");
  await api.addStudent(name: "Jack", age: 18, major: "Physics");
  await api.addStudent(name: "Sophia", age: 21, major: "Biology");
  
  // Show all students
  print('\n📋 All students in the database:');
  await api.showSummary();
  
  await api.close();
  print('Step 2 completed! 🎉\n');
}

/// STEP 3: Finding Students by Major
/// Learn how to search for specific groups of students
Future<void> step3_FindByMajor() async {
  print('📚 STEP 3: Finding Students by Major');
  print('=====================================');
  print('Goal: Find all Biology students\n');
  
  StudentAPI api = StudentAPI();
  await api.initialize();
  
  // Add some test students first
  await api.addStudent(name: "Bio Student 1", age: 19, major: "Biology");
  await api.addStudent(name: "Math Student 1", age: 20, major: "Mathematics");
  await api.addStudent(name: "Bio Student 2", age: 21, major: "Biology");
  await api.addStudent(name: "CS Student 1", age: 18, major: "Computer Science");
  
  print('🎯 YOUR TASK: Find all Biology students');
  
  // YOUR CODE HERE: Use api.findByMajor() to find Biology students
  var biologyStudents = await api.findByMajor("Biology");
  
  print('\n🔍 Biology students found:');
  for (var student in biologyStudents) {
    print('   $student');
  }
  
  print('\n✅ Found ${biologyStudents.length} Biology students');
  
  await api.close();
  print('Step 3 completed! 🎉\n');
}

/// STEP 4: Updating Student Information
/// Learn how to modify existing data
Future<void> step4_UpdateStudent() async {
  print('📚 STEP 4: Updating Student Information');
  print('========================================');
  print('Goal: Update a student\'s age\n');
  
  StudentAPI api = StudentAPI();
  await api.initialize();
  
  // Add a student
  await api.addStudent(name: "Birthday Girl", age: 19, major: "Party Planning");
  
  print('🎂 It\'s Birthday Girl\'s birthday! She\'s turning 20.');
  print('🎯 YOUR TASK: Update her age from 19 to 20');
  
  // YOUR CODE HERE: Use api.updateAge() to change her age
  await api.updateAge("Birthday Girl", 20);
  
  // Check if it worked
  var student = await api.findByName("Birthday Girl");
  if (student != null && student.age == 20) {
    print('✅ SUCCESS! Birthday Girl is now 20 years old');
  } else {
    print('❌ Something went wrong. Check your updateAge() call.');
  }
  
  await api.close();
  print('Step 4 completed! 🎉\n');
}

/// STEP 5: Database Switching Magic
/// This is the coolest part - same code, different storage!
Future<void> step5_DatabaseSwitching() async {
  print('📚 STEP 5: Database Switching Magic');
  print('====================================');
  print('Goal: See how the same API works with different databases\n');
  
  print('🧠 Starting with Memory Database...');
  StudentAPI api = StudentAPI(database: MemoryDatabase());
  await api.initialize();
  
  // Add a student
  await api.addStudent(name: "Memory Student", age: 20, major: "Computer Science");
  await api.showSummary();
  
  print('🎯 YOUR TASK: Switch to File Database');
  print('HINT: Use api.switchDatabase() with FileDatabase()');
  
  // YOUR CODE HERE: Switch to file database
  await api.switchDatabase(FileDatabase(filename: 'tutorial_students.json'));
  
  await api.showSummary();
  
  // Add another student (this one will be saved to file!)
  await api.addStudent(name: "File Student", age: 21, major: "Data Science");
  await api.showSummary();
  
  print('🎯 AMAZING! The same API methods worked with both databases!');
  print('   - api.addStudent() worked with memory AND file storage');
  print('   - The student data automatically transferred when switching!');
  
  await api.close();
  print('Step 5 completed! 🎉\n');
}

/// STEP 6: Build Your Own Mini-App
/// Put it all together in a simple student management app
Future<void> step6_MiniApp() async {
  print('📚 STEP 6: Build Your Own Mini-App');
  print('===================================');
  print('Goal: Create a complete student management system\n');
  
  StudentAPI api = StudentAPI(database: FileDatabase(filename: 'my_students.json'));
  await api.initialize();
  
  print('🏫 Welcome to Your Student Management System!');
  print('🎯 YOUR TASKS:');
  print('   1. Add at least 3 students');
  print('   2. Find students by a specific major');
  print('   3. Update one student\'s age');
  print('   4. Remove one student');
  print('   5. Show final summary');
  
  print('\n--- TASK 1: Add Students ---');
  // YOUR CODE HERE: Add at least 3 students
  await api.addStudent(name: "Alice Cooper", age: 19, major: "Music");
  await api.addStudent(name: "Bob Builder", age: 20, major: "Engineering");
  await api.addStudent(name: "Carol Singer", age: 21, major: "Music");
  await api.addStudent(name: "Dave Code", age: 18, major: "Computer Science");
  
  print('\n--- TASK 2: Find by Major ---');
  // YOUR CODE HERE: Find all Music students
  var musicStudents = await api.findByMajor("Music");
  print('Found ${musicStudents.length} Music students');
  
  print('\n--- TASK 3: Update Age ---');
  // YOUR CODE HERE: Update someone's age
  await api.updateAge("Alice Cooper", 20);
  
  print('\n--- TASK 4: Remove Student ---');
  // YOUR CODE HERE: Remove a student
  await api.removeStudent("Bob Builder");
  
  print('\n--- TASK 5: Final Summary ---');
  await api.showSummary();
  
  await api.close();
  print('Step 6 completed! 🎉');
  print('🌟 CONGRATULATIONS! You built a complete student management system!');
}

/// MAIN TUTORIAL RUNNER
Future<void> main() async {
  print('🎓 STUDENT API TUTORIAL FOR FRESHMEN');
  print('======================================');
  print('Welcome to your journey of learning database APIs!');
  print('We\'ll go step by step, building your knowledge.\n');
  
  print('💡 TIP: Read each step carefully and try to understand');
  print('   what each line of code does before moving on.\n');
  
  // Run all tutorial steps
  await step1_FirstApiCall();
  await step2_MultipleStudents();
  await step3_FindByMajor();
  await step4_UpdateStudent();
  await step5_DatabaseSwitching();
  await step6_MiniApp();
  
  print('\n🎉 TUTORIAL COMPLETED!');
  print('======================');
  print('🌟 You\'ve learned:');
  print('   ✅ How to use database APIs');
  print('   ✅ How to add, find, update, and delete data');
  print('   ✅ How database switching works');
  print('   ✅ How to build a complete application');
  print('\n🚀 You\'re now ready to build amazing database applications!');
  print('💼 These skills are used by professional developers every day.');
  print('🎓 Keep practicing and you\'ll become an expert programmer!');
}
