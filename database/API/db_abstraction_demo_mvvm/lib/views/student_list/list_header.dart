import 'package:flutter/material.dart';
import '../../viewmodels/student_list_viewmodel.dart';

/// Header component for student list
/// 
/// Small component showing:
/// 1. Title with student count
/// 2. Refresh button
class ListHeader extends StatelessWidget {
  final StudentListViewModel viewModel;

  const ListHeader({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.people,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 8),
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
    );
  }
}
