import 'package:flutter/material.dart';
import '../viewmodels/profile_viewmodel.dart';

class LogoutDialog extends StatelessWidget {
  final ProfileViewModel viewModel;

  const LogoutDialog({
    super.key,
    required this.viewModel,
  });

  static Future<void> show(BuildContext context, ProfileViewModel viewModel) {
    return showDialog(
      context: context,
      builder: (context) => LogoutDialog(viewModel: viewModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await viewModel.logout();
            // TODO: Navigate to login screen
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
} 