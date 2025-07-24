import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service_notifier.dart';
import '../models/student.dart';

/// Widget for adding and editing students
/// This demonstrates form handling, validation, and state management
class StudentFormWidget extends StatefulWidget {
  final Student? editingStudent;
  final VoidCallback onStudentSaved;
  final VoidCallback onCancelEdit;
  final Function(String) onError;

  const StudentFormWidget({
    Key? key,
    this.editingStudent,
    required this.onStudentSaved,
    required this.onCancelEdit,
    required this.onError,
  }) : super(key: key);

  @override
  State<StudentFormWidget> createState() => _StudentFormWidgetState();
}

class _StudentFormWidgetState extends State<StudentFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _majorController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _populateForm();
  }

  @override
  void didUpdateWidget(StudentFormWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.editingStudent != oldWidget.editingStudent) {
      _populateForm();
    }
  }

  void _populateForm() {
    final student = widget.editingStudent;
    if (student != null) {
      _nameController.text = student.name;
      _emailController.text = student.email;
      _ageController.text = student.age.toString();
      _majorController.text = student.major;
    } else {
      _clearForm();
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _ageController.clear();
    _majorController.clear();
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final dbServiceNotifier = Provider.of<DatabaseServiceNotifier>(context, listen: false);
      
      final student = Student(
        id: widget.editingStudent?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        major: _majorController.text.trim(),
        createdAt: widget.editingStudent?.createdAt ?? DateTime.now(),
      );

      // Validate student data
      final validationError = dbServiceNotifier.validateStudent(student);
      if (validationError != null) {
        widget.onError(validationError);
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (widget.editingStudent != null) {
        await dbServiceNotifier.updateStudent(student);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Student updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        await dbServiceNotifier.createStudent(student);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Student created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      _clearForm();
      widget.onStudentSaved();
      
    } catch (e) {
      widget.onError('Failed to save student: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.editingStudent != null ? 'Edit Student' : 'Add New Student',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              
              // Email field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Invalid email format';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              
              // Age field
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Age is required';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 16 || age > 100) {
                    return 'Age must be between 16 and 100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              
              // Major field
              TextFormField(
                controller: _majorController,
                decoration: const InputDecoration(
                  labelText: 'Major',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Major is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveStudent,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(widget.editingStudent != null ? 'Update' : 'Create'),
                    ),
                  ),
                  if (widget.editingStudent != null) ...[
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: _isLoading ? null : () {
                        _clearForm();
                        widget.onCancelEdit();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
