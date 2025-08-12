// lib/views/profile_view/widgets/loading_indicator.dart
import 'package:flutter/material.dart';
import '../../../viewmodels/profile_viewmodel.dart';

class LoadingIndicator extends StatelessWidget {
  final ProfileViewModel viewModel;

  const LoadingIndicator({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    if (!viewModel.isLoading) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text(
              'Loading user profile...',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}