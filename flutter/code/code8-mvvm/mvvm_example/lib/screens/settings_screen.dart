import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../dialogs/delete_account_dialog.dart';
import '../dialogs/language_dialog.dart';
import '../dialogs/logout_dialog.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../viewmodels/settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.watch<ProfileViewModel>();
    
    return ChangeNotifierProvider(
      create: (_) => SettingsViewModel(),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Consumer<SettingsViewModel>(
          builder: (context, settingsViewModel, child) {
            if (settingsViewModel.isLoading || profileViewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (settingsViewModel.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(settingsViewModel.error!, style: AppTextStyles.error),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => settingsViewModel.clearError(),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            if (profileViewModel.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(profileViewModel.error!, style: AppTextStyles.error),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => profileViewModel.loadProfile(),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            return _buildBody(context, settingsViewModel, profileViewModel);
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Settings'),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildBody(
    BuildContext context,
    SettingsViewModel settingsViewModel,
    ProfileViewModel profileViewModel,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAccountSection(context, settingsViewModel, profileViewModel),
        const SizedBox(height: 24),
        _buildAppSection(context, settingsViewModel),
        const SizedBox(height: 24),
        _buildSupportSection(context, settingsViewModel),
        const SizedBox(height: 24),
        _buildDangerSection(context, settingsViewModel, profileViewModel),
      ],
    );
  }

  Widget _buildAccountSection(
    BuildContext context, 
    SettingsViewModel settingsViewModel,
    ProfileViewModel profileViewModel,
  ) {
    return _buildSection(
      title: 'Account',
      items: settingsViewModel.getAccountItems(
        profileViewModel.userModel.name,
        profileViewModel,
        context,
      ),
    );
  }

  Widget _buildAppSection(BuildContext context, SettingsViewModel viewModel) {
    return _buildSection(
      title: 'App Settings',
      items: viewModel.getAppSettingsItems(context),
    );
  }

  Widget _buildSupportSection(BuildContext context, SettingsViewModel viewModel) {
    return _buildSection(
      title: 'Support',
      items: viewModel.getSupportItems(),
    );
  }

  Widget _buildDangerSection(
    BuildContext context,
    SettingsViewModel settingsViewModel,
    ProfileViewModel profileViewModel,
  ) {
    return _buildSection(
      title: 'Account Management',
      items: settingsViewModel.getDangerItems(
        () => LogoutDialog.show(context, profileViewModel),
        () => DeleteAccountDialog.show(context, profileViewModel),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<dynamic> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: items.map((item) => ListTile(
              leading: Icon(
                item.icon,
                color: item.iconColor ?? AppColors.primary,
              ),
              title: Text(
                item.title,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: item.titleColor,
                ),
              ),
              subtitle: item.subtitle != null 
                  ? Text(item.subtitle!, style: AppTextStyles.caption)
                  : null,
              trailing: item.trailing ?? 
                  (item.onTap != null 
                      ? const Icon(Icons.chevron_right, color: AppColors.textSecondary)
                      : null),
              onTap: item.onTap,
            )).toList(),
          ),
        ),
      ],
    );
  }
} 