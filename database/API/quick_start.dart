import 'student_api.dart';

/// QUICK START EXAMPLE
/// This is the simplest possible example to get you started!
/// Perfect for your very first try with the database API.

Future<void> main() async {
  print('🎓 Your First Database API Experience!');
  print('======================================');
  print('Let\'s add a student and find them again!\n');
  
  // Step 1: Create the API (it uses memory database by default)
  print('🔧 Creating Student API...');
  StudentAPI api = StudentAPI();
  await api.initialize();
  print('✅ API ready!\n');
  
  // Step 2: Add your first student
  print('📝 Adding your first student...');
  await api.addStudent(
    name: "Alex Smith", 
    age: 19, 
    major: "Computer Science"
  );
  print('✅ Student added!\n');
  
  // Step 3: Find the student you just added
  print('🔍 Looking for Alex Smith...');
  var alex = await api.findByName("Alex Smith");
  if (alex != null) {
    print('✅ Found them! $alex\n');
  } else {
    print('❌ Hmm, something went wrong...\n');
  }
  
  // Step 4: Show all students in the database
  print('📋 All students in the database:');
  await api.showSummary();
  
  // Step 5: Clean up
  await api.close();
  
  print('🎉 CONGRATULATIONS!');
  print('==================');
  print('You just:');
  print('✅ Created your first database API');
  print('✅ Added your first student');
  print('✅ Retrieved data from the database');
  print('✅ Displayed a summary of all data');
  print('\n🚀 You\'re ready for more complex examples!');
  print('💡 Try running: dart run demo.dart');
  print('📚 Or try the tutorial: dart run tutorial.dart');
}
