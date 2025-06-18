import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../viewmodels/profile_viewmodel.dart';

class DeleteAccountDialog extends StatelessWidget {
  final ProfileViewModel viewModel;

  const DeleteAccountDialog({
    super.key,
    required this.viewModel,
  });

  static Future<void> show(BuildContext context, ProfileViewModel viewModel) {
    return showDialog(
      context: context,
      builder: (context) => DeleteAccountDialog(viewModel: viewModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Account'),
      content: const Text(
        'Are you sure you want to delete your account? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await viewModel.deleteAccount();
            // TODO: Navigate to login screen
          },
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: const Text('Delete'),
        ),
      ],
    );
  }
} 