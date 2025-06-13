import 'package:flutter/material.dart';
import '../../viewmodels/student_form_viewmodel.dart';

/// Action buttons for student form
/// 
/// Small, focused component for form actions:
/// 1. Save/Update button
/// 2. Cancel button (when editing)
class FormButtons extends StatelessWidget {
  final StudentFormViewModel viewModel;
  final VoidCallback onStudentSaved;

  const FormButtons({
    Key? key,
    required this.viewModel,
    required this.onStudentSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: viewModel.isLoading ? null : () => _handleSave(),
            icon: viewModel.isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(viewModel.isEditMode ? Icons.save : Icons.add),
            label: Text(viewModel.buttonText),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        if (viewModel.isEditMode) ...[
          const SizedBox(width: 12),
          TextButton.icon(
            onPressed: viewModel.isLoading ? null : () => viewModel.clearForm(),
            icon: const Icon(Icons.cancel),
            label: const Text('Cancel'),
          ),
        ],
      ],
    );
  }

  Future<void> _handleSave() async {
    final success = await viewModel.saveStudent();
    if (success) {
      onStudentSaved();
    }
  }
}
