import 'package:flutter/material.dart';
import '../../viewmodels/student_form_viewmodel.dart';

/// Error and validation message components for student form
/// 
/// Small components to display different types of messages:
/// 1. Validation errors
/// 2. General error messages
class ValidationMessage extends StatelessWidget {
  final StudentFormViewModel viewModel;

  const ValidationMessage({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (viewModel.validationError == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.orange.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              viewModel.validationError!,
              style: TextStyle(color: Colors.orange.shade800),
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorMessage extends StatelessWidget {
  final StudentFormViewModel viewModel;

  const ErrorMessage({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (viewModel.errorMessage == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Error: ${viewModel.errorMessage}',
              style: TextStyle(color: Colors.red.shade800),
            ),
          ),
        ],
      ),
    );
  }
}

/// Combined message display component
class FormMessages extends StatelessWidget {
  final StudentFormViewModel viewModel;

  const FormMessages({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValidationMessage(viewModel: viewModel),
        if (viewModel.validationError != null && viewModel.errorMessage != null)
          const SizedBox(height: 8),
        ErrorMessage(viewModel: viewModel),
      ],
    );
  }
}
