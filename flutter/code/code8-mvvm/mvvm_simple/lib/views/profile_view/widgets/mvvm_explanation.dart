// lib/views/profile_view/widgets/mvvm_explanation.dart
import 'package:flutter/material.dart';

class MVVMExplanation extends StatelessWidget {
  const MVVMExplanation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildExplanationItems(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.info, color: Colors.green.shade700, size: 20),
        const SizedBox(width: 8),
        Text(
          'MVVM Pattern in Action',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildExplanationItems() {
    final items = [
      ExplanationItem(
        title: 'Model',
        description: 'User class in models/user.dart',
      ),
      ExplanationItem(
        title: 'View',
        description: 'ProfileView (this UI) in views/profile_view/',
      ),
      ExplanationItem(
        title: 'ViewModel',
        description: 'ProfileViewModel in viewmodels/profile_viewmodel.dart',
      ),
      ExplanationItem(
        title: 'State Management',
        description: 'ChangeNotifier + AnimatedBuilder',
      ),
      ExplanationItem(
        title: 'Data Flow',
        description: 'View → ViewModel → Model → View',
      ),
      ExplanationItem(
        title: 'File Structure',
        description: 'Separated into modular components',
      ),
    ];

    return Column(
      children: items.map((item) => _buildExplanationItem(item)).toList(),
    );
  }

  Widget _buildExplanationItem(ExplanationItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              color: Colors.green.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            '${item.title}: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.green.shade700,
              fontSize: 13,
            ),
          ),
          Expanded(
            child: Text(
              item.description,
              style: TextStyle(
                color: Colors.green.shade600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExplanationItem {
  final String title;
  final String description;

  ExplanationItem({
    required this.title,
    required this.description,
  });
}