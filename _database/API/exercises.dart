import 'student_api.dart';
import 'memory_database.dart';
import 'file_database.dart';

/// PRACTICE EXERCISES for College Freshmen
/// Complete these exercises to master database APIs!
/// 
/// Instructions:
/// 1. Read each exercise carefully
/// 2. Write the code where it says "YOUR CODE HERE"
/// 3. Run the exercise to see if it works
/// 4. Don't peek at the solution until you try!

/// EXERCISE 1: Basic CRUD Operations
/// CRUD = Create, Read, Update, Delete
Future<void> exercise1_BasicCRUD() async {
  print('💪 EXERCISE 1: Basic CRUD Operations');
  print('====================================');
  print('Complete the following tasks:\n');
  
  StudentAPI api = StudentAPI();
  await api.initialize();
  
  print('TASK 1: Add a student named "Your Name", age 18, major "Your Major"');
  // YOUR CODE HERE:
  // await api.addStudent(name: "???", age: ???, major: "???");
  
  print('\nTASK 2: Find and display the student you just added');
  // YOUR CODE HERE:
  // var student = await api.findByName("???");
  // print("Found: $student");
  
  print('\nTASK 3: Update your age to 19');
  // YOUR CODE HERE:
  // await api.updateAge("???", 19);
  
  print('\nTASK 4: Remove the student');
  // YOUR CODE HERE:
  // await api.removeStudent("???");
  
  print('\nTASK 5: Try to find the student again (should not be found)');
  // YOUR CODE HERE:
  // var deletedStudent = await api.findByName("???");
  // if (deletedStudent == null) {
  //   print("✅ Student successfully deleted!");
  // }
  
  await api.close();
  print('\n🎯 Check: Did all your tasks work correctly?\n');
}

/// EXERCISE 2: Working with Multiple Students
Future<void> exercise2_MultipleStudents() async {
  print('💪 EXERCISE 2: Working with Multiple Students');
  print('==============================================');
  
  StudentAPI api = StudentAPI();
  await api.initialize();
  
  print('TASK 1: Add these 5 students:');
  print('  - Amy, 19, Computer Science');
  print('  - Ben, 20, Computer Science');
  print('  - Carla, 18, Mathematics');
  print('  - David, 21, Mathematics');
  print('  - Eva, 19, Physics');
  
  // YOUR CODE HERE: Add all 5 students
  
  print('\nTASK 2: Find all Computer Science students');
  // YOUR CODE HERE: Use findByMajor()
  
  print('\nTASK 3: Count how many students are in each major');
  // YOUR CODE HERE: 
  // HINT: Use findByMajor() for each major and count the results
  
  print('\nTASK 4: Find the youngest student');
  // YOUR CODE HERE:
  // HINT: Get all students and loop through to find minimum age
  
  await api.close();
  print('\n🎯 Did you complete all tasks?\n');
}

/// EXERCISE 3: Database Persistence Challenge
Future<void> exercise3_PersistenceChallenge() async {
  print('💪 EXERCISE 3: Database Persistence Challenge');
  print('==============================================');
  print('Goal: Make data survive between program runs!\n');
  
  print('TASK 1: Create API with FileDatabase');
  // YOUR CODE HERE: Create StudentAPI with FileDatabase
  // StudentAPI api = StudentAPI(database: ???);
  
  print('\nTASK 2: Add 3 students and save them');
  // YOUR CODE HERE: Add students that will be saved to file
  
  print('\nTASK 3: Close the API');
  // YOUR CODE HERE: Close the API to save data
  
  print('\nTASK 4: Create NEW API instance and load saved data');
  // YOUR CODE HERE: Create a new API with same filename
  
  print('\nTASK 5: Show that the data persisted');
  // YOUR CODE HERE: Display all students to prove they were saved
  
  print('\n🎯 If you see the students from Task 2, you succeeded!\n');
}

/// EXERCISE 4: Database Switching Challenge
Future<void> exercise4_SwitchingChallenge() async {
  print('💪 EXERCISE 4: Database Switching Challenge');
  print('============================================');
  print('Master the art of database switching!\n');
  
  StudentAPI api = StudentAPI();
  await api.initialize();
  
  print('TASK 1: Add students to Memory Database');
  // YOUR CODE HERE: Add 2 students
  
  print('\nTASK 2: Switch to File Database');
  // YOUR CODE HERE: Use switchDatabase() with FileDatabase
  
  print('\nTASK 3: Add more students to File Database');
  // YOUR CODE HERE: Add 2 more students
  
  print('\nTASK 4: Switch back to Memory Database');
  // YOUR CODE HERE: Switch back to MemoryDatabase
  
  print('\nTASK 5: Verify all 4 students are present');
  // YOUR CODE HERE: Show summary to prove switching worked
  
  await api.close();
  print('\n🎯 Did the switching preserve all students?\n');
}

/// EXERCISE 5: Build Your Own School System
Future<void> exercise5_SchoolSystem() async {
  print('💪 EXERCISE 5: Build Your Own School System');
  print('============================================');
  print('Create a complete school management system!\n');
  
  print('REQUIREMENTS:');
  print('✅ Use File Database for persistence');
  print('✅ Add at least 6 students across 3 different majors');
  print('✅ Implement a "semester end" feature that removes graduated students');
  print('✅ Show statistics (count by major, average age)');
  print('✅ Handle errors gracefully (try to add duplicate students)');
  
  // YOUR CODE HERE: Build the entire system!
  // This is your chance to be creative and show what you've learned!
  
  print('\n🎯 Features to implement:');
  print('   - enrollStudent() function');
  print('   - semesterEnd() function (removes some students)');
  print('   - showStatistics() function');
  print('   - handleDuplicates() test');
  
  print('\n🌟 Make it your own! Add creative features!');
}

/// BONUS EXERCISE: Error Handling
Future<void> bonusExercise_ErrorHandling() async {
  print('🌟 BONUS EXERCISE: Error Handling');
  print('==================================');
  print('Learn to handle things that go wrong!\n');
  
  StudentAPI api = StudentAPI();
  await api.initialize();
  
  print('TASK 1: Try to add the same student twice');
  await api.addStudent(name: "Duplicate Dan", age: 20, major: "Testing");
  // YOUR CODE HERE: Try to add Duplicate Dan again
  // What happens? Does the API handle it gracefully?
  
  print('\nTASK 2: Try to update a non-existent student');
  // YOUR CODE HERE: Try to update someone who doesn\'t exist
  
  print('\nTASK 3: Try to delete a non-existent student');
  // YOUR CODE HERE: Try to delete someone who doesn\'t exist
  
  print('\nTASK 4: Handle the errors gracefully in your code');
  // YOUR CODE HERE: Use if statements to check return values
  // Example: if (await api.addStudent(...)) { success! } else { handle error }
  
  await api.close();
  print('\n🎯 Good error handling makes programs reliable!\n');
}

/// MAIN FUNCTION: Choose your exercise
Future<void> main() async {
  print('💪 STUDENT API PRACTICE EXERCISES');
  print('===================================');
  print('Choose which exercise to practice:\n');
  
  print('Available exercises:');
  print('1. Basic CRUD Operations');
  print('2. Working with Multiple Students');
  print('3. Database Persistence Challenge');
  print('4. Database Switching Challenge');
  print('5. Build Your Own School System');
  print('6. Bonus: Error Handling');
  
  print('\n🎯 To run an exercise, uncomment it below:');
  
  // Uncomment the exercise you want to practice:
  
  // await exercise1_BasicCRUD();
  // await exercise2_MultipleStudents();
  // await exercise3_PersistenceChallenge();
  // await exercise4_SwitchingChallenge();
  // await exercise5_SchoolSystem();
  // await bonusExercise_ErrorHandling();
  
  print('\n💡 TIPS FOR SUCCESS:');
  print('   ✅ Start with Exercise 1 and work your way up');
  print('   ✅ Read the error messages - they help you learn!');
  print('   ✅ Don\'t be afraid to experiment');
  print('   ✅ Ask for help if you get stuck');
  print('   ✅ Celebrate small victories!');
  
  print('\n🚀 Happy coding, future programmers!');
}
