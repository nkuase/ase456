// lib/views/profile_view/profile_view.dart
import 'package:flutter/material.dart';
import '../../viewmodels/profile_viewmodel.dart';
import 'widgets/status_card.dart';
import 'widgets/loading_indicator.dart';
import 'widgets/user_profile_card.dart';
import 'widgets/action_buttons_section.dart';
import 'widgets/mvvm_explanation.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // Create ViewModel instance
  final ProfileViewModel _viewModel = ProfileViewModel();

  @override
  void initState() {
    super.initState();
    // Set initial message
    _viewModel.reset();
  }

  @override
  void dispose() {
    // Clean up ViewModel
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Simple MVVM Demo'),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 2,
    );
  }

  Widget _buildBody() {
    return AnimatedBuilder(
      animation: _viewModel, // Listen to ViewModel changes
      builder: (context, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Card - Shows current state
              StatusCard(viewModel: _viewModel),
              const SizedBox(height: 20),
              
              // Loading Indicator - Shows when loading
              LoadingIndicator(viewModel: _viewModel),
              
              // User Profile Card - Shows user data when loaded
              UserProfileCard(viewModel: _viewModel),
              const SizedBox(height: 20),
              
              // Action Buttons - All the interactive buttons
              ActionButtonsSection(viewModel: _viewModel),
              const SizedBox(height: 30),
              
              // MVVM Explanation - Educational content
              const MVVMExplanation(),
            ],
          ),
        );
      },
    );
  }
}