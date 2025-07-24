import 'package:flutter/material.dart';
import '../../viewmodels/student_form_viewmodel.dart';

/// Individual form fields for student form
/// 
/// Small, focused components for each input field.
/// Each field handles its own styling and validation display.
class NameField extends StatelessWidget {
  final StudentFormViewModel viewModel;

  const NameField({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: viewModel.nameController,
      decoration: const InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
    );
  }
}

class EmailField extends StatelessWidget {
  final StudentFormViewModel viewModel;

  const EmailField({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: viewModel.emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class AgeField extends StatelessWidget {
  final StudentFormViewModel viewModel;

  const AgeField({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: viewModel.ageController,
      decoration: const InputDecoration(
        labelText: 'Age',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.cake),
      ),
      keyboardType: TextInputType.number,
    );
  }
}

class MajorField extends StatelessWidget {
  final StudentFormViewModel viewModel;

  const MajorField({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: viewModel.majorController,
      decoration: const InputDecoration(
        labelText: 'Major',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.school),
      ),
    );
  }
}
