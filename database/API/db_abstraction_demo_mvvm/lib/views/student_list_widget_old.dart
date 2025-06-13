import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/student_list_viewmodel.dart';
import '../models/student.dart';

/// Simple Student List Widget demonstrating MVVM View
///
/// Key MVVM concepts shown:
/// 1. View only handles UI rendering and user input
/// 2. All logic is in the ViewModel
/// 3. UI automatically updates when ViewModel changes
/// 4. Clear data binding between View and ViewModel
class StudentListWidget extends StatelessWidget {
  final Function(Student) onEditStudent;
  final Function(String) onDeleteStudent;

  const StudentListWidget({
    Key? key,
    required this.onEditStudent,
    required this.onDeleteStudent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentListViewModel>(
      builder: (context, viewModel, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Text(
                      'Students (${viewModel.studentCount})',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: viewModel.refresh,
                      tooltip: 'Refresh',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Search bar
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search students...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: viewModel.searchStudents,
                ),
                const SizedBox(height: 16),

                // Error message
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

                // Student list
                Expanded(
                  child: viewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : viewModel.isEmpty
                          ? const Center(
                              child: Text('No students found'),
                            )
                          : ListView.builder(
                              itemCount: viewModel.students.length,
                              itemBuilder: (context, index) {
                                final student = viewModel.students[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    title: Text(student.name),
                                    subtitle: Text(
                                      '${student.email} • ${student.major} • Age ${student.age}',
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () =>
                                              onEditStudent(student),
                                          tooltip: 'Edit',
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () => _confirmDelete(
                                            context,
                                            student,
                                          ),
                                          tooltip: 'Delete',
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDeleteStudent(student.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
