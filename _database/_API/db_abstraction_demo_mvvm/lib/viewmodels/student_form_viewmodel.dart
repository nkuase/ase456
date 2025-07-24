import 'package:flutter/material.dart';
import 'base_viewmodel.dart';
import '../models/student.dart';
import '../services/database_service_notifier.dart';

/// Simple ViewModel for Student Form
///
/// This demonstrates core MVVM concepts:
/// 1. Form state management
/// 2. Validation logic separated from UI
/// 3. Data operations coordination
/// 4. Reactive updates to View
class StudentFormViewModel extends BaseViewModel {
  final DatabaseServiceNotifier _databaseService;

  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final majorController = TextEditingController();

  // Form state
  Student? _editingStudent;
  String? _validationError;

  StudentFormViewModel(this._databaseService);

  // Getters
  Student? get editingStudent => _editingStudent;
  String? get validationError => _validationError;
  bool get isEditMode => _editingStudent != null;
  String get buttonText => isEditMode ? 'Update' : 'Create';
  String get title => isEditMode ? 'Edit Student' : 'Add Student';

  /// Set student for editing
  void setEditingStudent(Student? student) {
    _editingStudent = student;

    if (student != null) {
      nameController.text = student.name;
      emailController.text = student.email;
      ageController.text = student.age.toString();
      majorController.text = student.major;
    } else {
      clearForm();
    }

    notifyListeners();
  }

  /// Clear the form
  void clearForm() {
    nameController.clear();
    emailController.clear();
    ageController.clear();
    majorController.clear();
    _editingStudent = null;
    _validationError = null;
    notifyListeners();
  }

  /// Validate form data
  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      _validationError = 'Name is required';
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      _validationError = 'Email is required';
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text)) {
      _validationError = 'Invalid email format';
      return false;
    }

    final age = int.tryParse(ageController.text);
    if (age == null || age < 16 || age > 100) {
      _validationError = 'Age must be between 16 and 100';
      return false;
    }

    if (majorController.text.trim().isEmpty) {
      _validationError = 'Major is required';
      return false;
    }

    _validationError = null;
    return true;
  }

  /// Save student (create or update)
  Future<bool> saveStudent() async {
    clearError();

    if (!_validateForm()) {
      notifyListeners();
      return false;
    }

    return await handleAsync(() async {
          final student = Student(
            id: _editingStudent?.id ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            age: int.parse(ageController.text.trim()),
            major: majorController.text.trim(),
            createdAt: _editingStudent?.createdAt ?? DateTime.now(),
          );

          if (isEditMode) {
            await _databaseService.updateStudent(student);
          } else {
            await _databaseService.createStudent(student);
          }

          clearForm();
          return true;
        }) ??
        false;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    majorController.dispose();
    super.dispose();
  }
}
