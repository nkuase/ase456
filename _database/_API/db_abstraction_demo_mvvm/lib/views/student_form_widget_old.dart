import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/student_form_viewmodel.dart';

/// Simple Student Form Widget demonstrating MVVM View
/// 
/// Key MVVM concepts shown:
/// 1. View only handles UI rendering and user input
/// 2. All logic is in the ViewModel
/// 3. UI automatically updates when ViewModel changes
/// 4. Clear separation of concerns
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
                Text(
                  viewModel.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),

                // Name field
                TextField(
                  controller: viewModel.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // Email field
                TextField(
                  controller: viewModel.emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // Age field
                TextField(
                  controller: viewModel.ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),

                // Major field
                TextField(
                  controller: viewModel.majorController,
                  decoration: const InputDecoration(
                    labelText: 'Major',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Error message
                if (viewModel.validationError != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      viewModel.validationError!,
                      style: TextStyle(color: Colors.red.shade800),
                    ),
                  ),

                if (viewModel.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Error: ${viewModel.errorMessage}',
                      style: TextStyle(color: Colors.red.shade800),
                    ),
                  ),

                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: viewModel.isLoading ? null : () async {
                          final success = await viewModel.saveStudent();
                          if (success) {
                            onStudentSaved();
                          }
                        },
                        child: viewModel.isLoading
                            ? const CircularProgressIndicator()
                            : Text(viewModel.buttonText),
                      ),
                    ),
                    if (viewModel.isEditMode) ...[
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: viewModel.isLoading ? null : () {
                          viewModel.clearForm();
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
