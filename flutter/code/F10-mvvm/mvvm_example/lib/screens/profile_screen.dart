// lib/screens/profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../dialogs/edit_avatar_dialog.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../widgets/avatar/avatar_widget.dart';
import '../widgets/avatar/edit_badge.dart';
import '../widgets/info/info_widget.dart';
import '../widgets/stats/stats_widget.dart';
import '../extensions/widget_extensions.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: Consumer<ProfileViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    );
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      AvatarWidget(
                        imageUrl: viewModel.userModel.profilePicture,
                        size: 120,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: EditBadge(
                          onTap: () => EditAvatarDialog.show(context, viewModel),
                        ),
                      ),
                    ],
                  ).paddingAll(16),
                  InfoWidget(userModel: viewModel.userModel).paddingAll(16),
                  StatsWidget(userModel: viewModel.userModel).paddingAll(16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}