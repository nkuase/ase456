// lib/main.dart
import 'package:flutter/material.dart';
import 'providers/providers.dart';
import 'screens/profile_screen.dart';
import 'constants/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp(
        title: 'Profile App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
          ),
        ),
        home: const ProfileScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}