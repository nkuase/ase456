import 'package:idb_shim/idb.dart' as idb;
import 'package:web/web.dart' hide Request, Event;
import 'dart:js_interop';
import '../lib/student.dart';
import '../lib/student_crud.dart';

// Global database instance
late idb.Database database;

void main() async {
  print('🚀 Starting Student Management System...');

  database = await initializeDatabase();
  setupEventListeners();

  print('✅ Application ready!');

  // Show initial students after a brief delay
  await Future.delayed(Duration(seconds: 1));
  await showAllStudents();
}

void setupEventListeners() {
  final addBtn =
      document.querySelector('#add-student-btn') as HTMLButtonElement?;
  final getAllBtn =
      document.querySelector('#get-all-students-btn') as HTMLButtonElement?;
  final getBtn =
      document.querySelector('#get-student-btn') as HTMLButtonElement?;
  final updateBtn =
      document.querySelector('#update-student-btn') as HTMLButtonElement?;
  final deleteBtn =
      document.querySelector('#delete-student-btn') as HTMLButtonElement?;
  final clearBtn =
      document.querySelector('#clear-all-btn') as HTMLButtonElement?;

  // CREATE: Add new student
  void handleAddStudent() async {
    final idInput = document.querySelector('#student-id') as HTMLInputElement?;
    final nameInput =
        document.querySelector('#student-name') as HTMLInputElement?;
    final ageInput =
        document.querySelector('#student-age') as HTMLInputElement?;
    final majorInput =
        document.querySelector('#student-major') as HTMLInputElement?;

    if (idInput == null ||
        nameInput == null ||
        ageInput == null ||
        majorInput == null) {
      showOutput('❌ Form elements not found');
      return;
    }

    final id = idInput.value.trim();
    final name = nameInput.value.trim();
    final ageText = ageInput.value.trim();
    final major = majorInput.value.trim();

    if (id.isEmpty || name.isEmpty || ageText.isEmpty || major.isEmpty) {
      showOutput('❌ Please fill in all fields to add a student');
      return;
    }

    final age = int.tryParse(ageText);
    if (age == null || age <= 0) {
      showOutput('❌ Please enter a valid age');
      return;
    }

    try {
      final student = Student(id: id, name: name, age: age, major: major);
      await createStudent(database, student);
      clearAddForm();
      showOutput('✅ Student ${student.name} added successfully!');
      await showAllStudents();
    } catch (error) {
      showOutput('❌ Error adding student: $error');
    }
  }

  // READ: Get all students
  void handleGetAllStudents() async {
    print('🔄 Get All Students button clicked');
    await showAllStudents();
  }

  // READ: Get specific student
  void handleGetStudent() async {
    final searchInput =
        document.querySelector('#search-id') as HTMLInputElement?;

    if (searchInput == null) {
      showOutput('❌ Search input not found');
      return;
    }

    final searchId = searchInput.value.trim();

    if (searchId.isEmpty) {
      showOutput('❌ Please enter a student ID to search');
      return;
    }

    try {
      final student = await readStudent(database, searchId);
      if (student != null) {
        showOutput('''
📋 STUDENT FOUND:

🆔 ID: ${student.id}
👤 Name: ${student.name}
📅 Age: ${student.age} years old
🎓 Major: ${student.major}
        ''');
      } else {
        showOutput('❌ No student found with ID: $searchId');
      }
    } catch (error) {
      showOutput('❌ Error searching for student: $error');
    }

    searchInput.value = '';
  }

  // UPDATE: Modify student
  void handleUpdateStudent() async {
    final idInput = document.querySelector('#update-id') as HTMLInputElement?;
    final nameInput =
        document.querySelector('#update-name') as HTMLInputElement?;
    final ageInput = document.querySelector('#update-age') as HTMLInputElement?;
    final majorInput =
        document.querySelector('#update-major') as HTMLInputElement?;

    if (idInput == null ||
        nameInput == null ||
        ageInput == null ||
        majorInput == null) {
      showOutput('❌ Update form elements not found');
      return;
    }

    final id = idInput.value.trim();
    final name = nameInput.value.trim();
    final ageText = ageInput.value.trim();
    final major = majorInput.value.trim();

    if (id.isEmpty) {
      showOutput('❌ Please enter a student ID to update');
      return;
    }

    int? age;
    if (ageText.isNotEmpty) {
      age = int.tryParse(ageText);
      if (age == null || age <= 0) {
        showOutput('❌ Please enter a valid age');
        return;
      }
    }

    try {
      final success = await updateStudent(
        database,
        id,
        name: name.isNotEmpty ? name : null,
        age: age,
        major: major.isNotEmpty ? major : null,
      );

      if (success) {
        clearUpdateForm();
        showOutput('✅ Student updated successfully!');
        await showAllStudents();
      }
    } catch (error) {
      showOutput('❌ Error updating student: $error');
    }
  }

  // DELETE: Remove specific student
  void handleDeleteStudent() async {
    final deleteInput =
        document.querySelector('#delete-id') as HTMLInputElement?;

    if (deleteInput == null) {
      showOutput('❌ Delete input not found');
      return;
    }

    final deleteId = deleteInput.value.trim();

    if (deleteId.isEmpty) {
      showOutput('❌ Please enter a student ID to delete');
      return;
    }

    try {
      final success = await deleteStudent(database, deleteId);
      if (success) {
        deleteInput.value = '';
        showOutput('✅ Student deleted successfully!');
        await showAllStudents();
      }
    } catch (error) {
      showOutput('❌ Error deleting student: $error');
    }
  }

  // DELETE: Clear all students
  void handleClearAll() async {
    if (window.confirm('Are you sure you want to delete all students?')) {
      try {
        await clearAllStudents(database);
        showOutput('✅ All students cleared!');
        await showAllStudents();
      } catch (error) {
        showOutput('❌ Error clearing all students: $error');
      }
    }
  }

  // Attach event listeners using modern syntax
  addBtn?.onclick = handleAddStudent.toJS;
  getAllBtn?.onclick = handleGetAllStudents.toJS;
  getBtn?.onclick = handleGetStudent.toJS;
  updateBtn?.onclick = handleUpdateStudent.toJS;
  deleteBtn?.onclick = handleDeleteStudent.toJS;
  clearBtn?.onclick = handleClearAll.toJS;
}

/// Show all students in output
Future<void> showAllStudents() async {
  print('📋 showAllStudents() called');

  try {
    showOutput('🔍 Loading students from database...');

    final students = await readAllStudents(database);
    print('📊 Got ${students.length} students from database');

    if (students.isEmpty) {
      showOutput('''
📋 NO STUDENTS IN DATABASE

The database is currently empty.
Add some students using the CREATE section above.

Sample data should have been loaded automatically.
If not, try refreshing the page.
      ''');
      return;
    }

    // Build the output string
    final output = StringBuffer();
    output.writeln('📋 ALL STUDENTS (${students.length} total)');
    output.writeln('=' * 50);

    for (int i = 0; i < students.length; i++) {
      final student = students[i];
      output.writeln('');
      output.writeln('${i + 1}. ${student.name}');
      output.writeln('   ID: ${student.id}');
      output.writeln('   Age: ${student.age}');
      output.writeln('   Major: ${student.major}');
      output.writeln('-' * 30);
    }

    output.writeln('');
    output
        .writeln('Last updated: ${DateTime.now().toString().substring(0, 19)}');

    showOutput(output.toString());
    print('✅ Successfully displayed ${students.length} students');
  } catch (error) {
    final errorMsg = '❌ Error loading students: $error';
    showOutput(errorMsg);
    print(errorMsg);
  }
}

/// Show text in output area
void showOutput(String text) {
  final outputElement = document.querySelector('#output') as HTMLElement?;
  if (outputElement != null) {
    outputElement.textContent = text;
    print('📺 Output updated: ${text.length} characters');
  } else {
    print('❌ Output element not found!');
  }
}

void clearAddForm() {
  final idInput = document.querySelector('#student-id') as HTMLInputElement?;
  final nameInput =
      document.querySelector('#student-name') as HTMLInputElement?;
  final ageInput = document.querySelector('#student-age') as HTMLInputElement?;
  final majorInput =
      document.querySelector('#student-major') as HTMLInputElement?;

  idInput?.value = '';
  nameInput?.value = '';
  ageInput?.value = '';
  majorInput?.value = '';
}

void clearUpdateForm() {
  final idInput = document.querySelector('#update-id') as HTMLInputElement?;
  final nameInput = document.querySelector('#update-name') as HTMLInputElement?;
  final ageInput = document.querySelector('#update-age') as HTMLInputElement?;
  final majorInput =
      document.querySelector('#update-major') as HTMLInputElement?;

  idInput?.value = '';
  nameInput?.value = '';
  ageInput?.value = '';
  majorInput?.value = '';
}
