import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../viewmodels/settings_viewmodel.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileViewModel()..loadProfile()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
      ],
      child: child,
    );
  }
} 
/*        ChangeNotifierProvider(
          create: (_) {
            // Create the ViewModel and initialize it
            final profileViewModel = ProfileViewModel();
            // Load the profile data
            profileViewModel.loadProfile();
            return profileViewModel;
          },
        ),
*/