import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/student_form_viewmodel.dart';
import 'form_fields.dart';
import 'form_messages.dart';
import 'form_buttons.dart';

/// Main Student Form Widget using smaller components
/// 
/// Clean, small file that composes smaller components:
/// 1. Form fields
/// 2. Error messages
/// 3. Action buttons
class StudentFormWidget extends StatelessWidget {
  final VoidCallback onStudentSaved;

  const StudentFormWidget({
    Key? key,
    required this.onStudentSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentFormViewModel>(
      builder: (context, viewModel, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  children: [
                    Icon(
                      viewModel.isEditMode ? Icons.edit : Icons.add,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      viewModel.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Form fields
                NameField(viewModel: viewModel),
                const SizedBox(height: 12),
                EmailField(viewModel: viewModel),
                const SizedBox(height: 12),
                AgeField(viewModel: viewModel),
                const SizedBox(height: 12),
                MajorField(viewModel: viewModel),
                const SizedBox(height: 16),

                // Messages
                FormMessages(viewModel: viewModel),
                const SizedBox(height: 16),

                // Action buttons
                FormButtons(
                  viewModel: viewModel,
                  onStudentSaved: onStudentSaved,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
