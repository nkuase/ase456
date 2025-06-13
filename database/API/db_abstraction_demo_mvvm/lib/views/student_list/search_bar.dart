import 'package:flutter/material.dart';
import '../../viewmodels/student_list_viewmodel.dart';

/// Search bar component for student list
/// 
/// Small component for searching students by name or email.
class SearchBar extends StatelessWidget {
  final StudentListViewModel viewModel;

  const SearchBar({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Search students...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onChanged: viewModel.searchStudents,
    );
  }
}
