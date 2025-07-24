import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service_notifier.dart';
import '../models/student.dart';
import 'student_form_widget.dart';
import 'student_list_widget.dart';
import 'database_widgets.dart';

/// Main screen of the database abstraction demo app
///
/// This simplified screen demonstrates all CRUD operations using separate widgets
/// Students can easily understand each component's responsibility
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Student> _students = [];
  bool _isLoading = false;
  String? _errorMessage;
  Student? _editingStudent;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  /// Load all students from the current database
  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dbServiceNotifier =
          Provider.of<DatabaseServiceNotifier>(context, listen: false);
      final students = await dbServiceNotifier.getAllStudents();

      setState(() {
        _students = students;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load students: $e';
        _isLoading = false;
      });
    }
  }

  /// Handle when a student is saved (created or updated)
  void _onStudentSaved() {
    setState(() {
      _editingStudent = null; // Clear editing mode
    });
    _loadStudents(); // Refresh the list
  }

  /// Handle when edit is cancelled
  void _onCancelEdit() {
    setState(() {
      _editingStudent = null;
      _errorMessage = null;
    });
  }

  /// Handle when a student is selected for editing
  void _onEditStudent(Student student) {
    setState(() {
      _editingStudent = student;
      _errorMessage = null;
    });
  }

  /// Handle when a student is deleted
  Future<void> _onDeleteStudent(String studentId) async {
    try {
      final dbServiceNotifier =
          Provider.of<DatabaseServiceNotifier>(context, listen: false);
      await dbServiceNotifier.deleteStudent(studentId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student deleted successfully!'),
          backgroundColor: Colors.orange,
        ),
      );

      _loadStudents(); // Refresh the list

      // If we were editing this student, clear the editing state
      if (_editingStudent?.id == studentId) {
        setState(() {
          _editingStudent = null;
        });
      }
    } catch (e) {
      _showError('Failed to delete student: $e');
    }
  }

  /// Show error message
  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Abstraction Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showDatabaseSelector(),
            tooltip: 'Database Settings',
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(),
            tooltip: 'Help',
          ),
        ],
      ),
      body: Column(
        children: [
          // Database status indicator
          const DatabaseStatusWidget(),

          // Error message
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.red.shade100,
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red.shade800),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade800),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _errorMessage = null),
                    color: Colors.red.shade800,
                  ),
                ],
              ),
            ),

          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Student form (left side)
                  Expanded(
                    flex: 2,
                    child: StudentFormWidget(
                      editingStudent: _editingStudent,
                      onStudentSaved: _onStudentSaved,
                      onCancelEdit: _onCancelEdit,
                      onError: _showError,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Student list (right side)
                  Expanded(
                    flex: 3,
                    child: StudentListWidget(
                      students: _students,
                      isLoading: _isLoading,
                      onRefresh: _loadStudents,
                      onEditStudent: _onEditStudent,
                      onDeleteStudent: _onDeleteStudent,
                      onError: _showError,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDatabaseSelector() {
    showDialog(
      context: context,
      builder: (context) => const DatabaseSelectorDialog(),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Use This App'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🎓 Learning Goals:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('• Understand interface-based programming'),
              Text('• See the Strategy pattern in action'),
              Text('• Learn about different database types'),
              Text('• Practice CRUD operations'),
              SizedBox(height: 16),
              Text(
                '🚀 How to Use:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('1. Add students using the form on the left'),
              Text('2. View and manage students in the list on the right'),
              Text('3. Click the edit button to modify a student'),
              Text('4. Switch databases to see the same data work everywhere'),
              Text('5. Try different operations and see how they work'),
              SizedBox(height: 16),
              Text(
                '💡 Key Concept:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                  'The app uses interfaces and the Strategy pattern to switch between different database implementations while keeping the same functionality.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}
