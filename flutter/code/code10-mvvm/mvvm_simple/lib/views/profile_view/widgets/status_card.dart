// lib/views/profile_view/widgets/status_card.dart
import 'package:flutter/material.dart';
import '../../../viewmodels/profile_viewmodel.dart';

class StatusCard extends StatelessWidget {
  final ProfileViewModel viewModel;

  const StatusCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: 8),
          _buildStatusText(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Icon(
          Icons.info_outline,
          color: Colors.blue.shade700,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'Status',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusText() {
    return Text(
      viewModel.statusText.isEmpty ? 'Ready to load profile' : viewModel.statusText,
      style: TextStyle(
        color: Colors.blue.shade600,
        fontSize: 14,
      ),
    );
  }
}