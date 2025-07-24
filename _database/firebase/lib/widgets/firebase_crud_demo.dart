import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/secure_student_service.dart';
import '../utils/student_validator.dart';

/// Complete Flutter app demonstrating Firebase CRUD operations
class FirebaseCrudDemo extends StatefulWidget {
  const FirebaseCrudDemo({Key? key}) : super(key: key);

  @override
  State<FirebaseCrudDemo> createState() => _FirebaseCrudDemoState();
}

class _FirebaseCrudDemoState extends State<FirebaseCrudDemo> {
  final SecureStudentService _studentService = SecureStudentService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedMajor = 'Computer Science';
  String _status = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _createStudent() async {
    setState(() {
      _isLoading = true;
      _status = 'Creating student...';
    });

    try {
      final result = await _studentService.createFromFormData(
        name: _nameController.text,
        ageText: _ageController.text,
        major: _selectedMajor,
      );

      result.fold(
        onSuccess: (id) {
          setState(() {
            _status = '✅ Created student with ID: $id';
            _isLoading = false;
          });
          _clearForm();
        },
        onError: (error) {
          setState(() {
            _status = '❌ Error creating student: $error';
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _status = '❌ Unexpected error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateStudent(Student student) async {
    setState(() {
      _status = 'Updating student...';
    });

    try {
      final updatedStudent = student.copyWith(
        name: '${student.name} (Updated)',
        age: student.age + 1,
      );

      final result = await _studentService.updateSecurely(student.id!, updatedStudent);

      result.fold(
        onSuccess: (_) {
          setState(() {
            _status = '✅ Updated student: ${student.name}';
          });
        },
        onError: (error) {
          setState(() {
            _status = '❌ Error updating: $error';
          });
        },
      );
    } catch (e) {
      setState(() {
        _status = '❌ Unexpected error: ${e.toString()}';
      });
    }
  }

  Future<void> _deleteStudent(Student student) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _status = 'Deleting student...';
    });

    try {
      final result = await _studentService.deleteSecurely(student.id!);

      result.fold(
        onSuccess: (_) {
          setState(() {
            _status = '✅ Deleted student: ${student.name}';
          });
        },
        onError: (error) {
          setState(() {
            _status = '❌ Error deleting: $error';
          });
        },
      );
    } catch (e) {
      setState(() {
        _status = '❌ Unexpected error: ${e.toString()}';
      });
    }
  }

  Future<void> _createSampleData() async {
    setState(() {
      _isLoading = true;
      _status = 'Creating sample data...';
    });

    final sampleStudents = [
      Student(name: 'Alice Johnson', age: 20, major: 'Computer Science'),
      Student(name: 'Bob Smith', age: 22, major: 'Mathematics'),
      Student(name: 'Carol Davis', age: 21, major: 'Physics'),
      Student(name: 'David Wilson', age: 23, major: 'Computer Engineering'),
      Student(name: 'Eva Brown', age: 19, major: 'Data Science'),
    ];

    try {
      final result = await _studentService.bulkCreateSecurely(sampleStudents);

      result.fold(
        onSuccess: (ids) {
          setState(() {
            _status = '✅ Created ${ids.length} sample students';
            _isLoading = false;
          });
        },
        onError: (error) {
          setState(() {
            _status = '❌ Error creating sample data: $error';
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _status = '❌ Unexpected error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _clearForm() {
    _nameController.clear();
    _ageController.clear();
    setState(() {
      _selectedMajor = 'Computer Science';
    });
  }

  void _showValidationRules() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Validation Rules'),
        content: SingleChildScrollView(
          child: Text(_studentService.getValidationRules()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateForm() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Create New Student',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _showValidationRules,
                  icon: const Icon(Icons.info_outline),
                  tooltip: 'Validation Rules',
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Student Name',
                hintText: 'Enter full name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                hintText: 'Enter age (16-120)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedMajor,
              decoration: const InputDecoration(
                labelText: 'Major',
                border: OutlineInputBorder(),
              ),
              items: StudentValidator.getValidMajors()
                  .map((major) => DropdownMenuItem(
                        value: major,
                        child: Text(major),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMajor = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _createStudent,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Create Student'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _createSampleData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text('Add Sample Data'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _clearForm,
                  child: const Text('Clear'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    if (_status.isEmpty) return const SizedBox.shrink();

    final isError = _status.contains('❌');
    final isSuccess = _status.contains('✅');

    return Card(
      margin: const EdgeInsets.all(8.0),
      color: isError
          ? Colors.red.shade50
          : isSuccess
              ? Colors.green.shade50
              : Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline
                  : isSuccess
                      ? Icons.check_circle_outline
                      : Icons.info_outline,
              color: isError
                  ? Colors.red
                  : isSuccess
                      ? Colors.green
                      : Colors.blue,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _status,
                style: TextStyle(
                  color: isError
                      ? Colors.red.shade700
                      : isSuccess
                          ? Colors.green.shade700
                          : Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              onPressed: () => setState(() => _status = ''),
              icon: const Icon(Icons.close),
              iconSize: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentsList() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Students (Real-time)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 400,
            child: StreamBuilder<List<Student>>(
              stream: _studentService.streamAll(
                orderBy: 'createdAt',
                descending: true,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 48),
                        const SizedBox(height: 8),
                        Text('Error: ${snapshot.error}'),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final students = snapshot.data ?? [];

                if (students.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.school, color: Colors.grey, size: 48),
                        SizedBox(height: 8),
                        Text('No students found'),
                        Text('Create some students to see them here'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    final isFromCache = snapshot.metadata?.isFromCache ?? false;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(child: Text(student.name)),
                          if (isFromCache)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'OFFLINE',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      subtitle: Text('${student.major} - Age: ${student.age}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _updateStudent(student),
                            icon: const Icon(Icons.edit),
                            tooltip: 'Update',
                          ),
                          IconButton(
                            onPressed: () => _deleteStudent(student),
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            tooltip: 'Delete',
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase CRUD Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _showValidationRules,
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCreateForm(),
            _buildStatusCard(),
            _buildStudentsList(),
          ],
        ),
      ),
    );
  }
}
