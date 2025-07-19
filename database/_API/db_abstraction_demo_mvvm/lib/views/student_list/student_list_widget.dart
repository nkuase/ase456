import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/student_list_viewmodel.dart';
import '../../models/student.dart';
import 'list_header.dart';
import 'search_bar.dart' as custom;
import 'student_list_item.dart';
import 'delete_dialog.dart';
import 'list_states.dart';

/// Main Student List Widget using smaller components
/// 
/// Clean, small file that composes smaller components:
/// 1. List header
/// 2. Search bar
/// 3. List items
/// 4. State management
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
                ListHeader(viewModel: viewModel),
                const SizedBox(height: 16),

                // Search bar
                custom.SearchBar(viewModel: viewModel),
                const SizedBox(height: 16),

                // Error message
                ListErrorState(viewModel: viewModel),

                // Student list
                Expanded(
                  child: _buildListContent(context, viewModel),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListContent(BuildContext context, StudentListViewModel viewModel) {
    if (viewModel.isLoading) {
      return const ListLoadingState();
    }

    if (viewModel.isEmpty) {
      return const ListEmptyState();
    }

    return ListView.builder(
      itemCount: viewModel.students.length,
      itemBuilder: (context, index) {
        final student = viewModel.students[index];
        return StudentListItem(
          student: student,
          onEdit: () => onEditStudent(student),
          onDelete: () => _handleDelete(context, student),
        );
      },
    );
  }

  void _handleDelete(BuildContext context, Student student) {
    DeleteConfirmationDialog.show(
      context,
      student,
      () => onDeleteStudent(student.id),
    );
  }
}
