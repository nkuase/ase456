import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../viewmodels/settings_viewmodel.dart';

class LanguageDialog extends StatelessWidget {
  final SettingsViewModel viewModel;

  const LanguageDialog({
    super.key,
    required this.viewModel,
  });

  static Future<void> show(BuildContext context, SettingsViewModel viewModel) {
    return showDialog(
      context: context,
      builder: (context) => LanguageDialog(viewModel: viewModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Language'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('English'),
            trailing: viewModel.selectedLanguage == 'English'
                ? const Icon(Icons.check, color: AppColors.primary)
                : null,
            onTap: () {
              viewModel.setLanguage('English');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Spanish'),
            trailing: viewModel.selectedLanguage == 'Spanish'
                ? const Icon(Icons.check, color: AppColors.primary)
                : null,
            onTap: () {
              viewModel.setLanguage('Spanish');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
} 