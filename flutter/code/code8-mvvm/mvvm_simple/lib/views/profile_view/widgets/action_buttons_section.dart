// lib/views/profile_view/widgets/action_buttons_section.dart
import 'package:flutter/material.dart';
import '../../../viewmodels/profile_viewmodel.dart';
import 'action_button.dart';

class ActionButtonsSection extends StatelessWidget {
  final ProfileViewModel viewModel;

  const ActionButtonsSection({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(),
        const SizedBox(height: 12),
        _buildButtonsGrid(),
      ],
    );
  }

  Widget _buildSectionTitle() {
    return Text(
      'Actions',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade700,
      ),
    );
  }

  Widget _buildButtonsGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ActionButton.load(
          onPressed: viewModel.isLoading ? null : viewModel.loadUserProfile,
        ),
        ActionButton.increaseAge(
          onPressed: !viewModel.hasUser ? null : viewModel.increaseAge,
        ),
        ActionButton.clear(
          onPressed: !viewModel.hasUser ? null : viewModel.clearProfile,
        ),
        ActionButton.reset(
          onPressed: viewModel.reset,
        ),
      ],
    );
  }
}