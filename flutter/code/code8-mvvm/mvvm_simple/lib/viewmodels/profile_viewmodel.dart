// lib/viewmodels/profile_viewmodel.dart
import 'package:flutter/material.dart';
import '../models/user.dart';

class ProfileViewModel extends ChangeNotifier {
  // Private state variables
  User _user = User.empty();
  bool _isLoading = false;
  String _message = '';

  // Public getters - View can access these
  User get user => _user;
  bool get isLoading => _isLoading;
  String get message => _message;

  // Computed properties
  bool get hasUser => !_user.isEmpty;
  String get statusText => _isLoading ? 'Loading...' : _message;

  // Business Logic: Load user profile
  Future<void> loadUserProfile() async {
    _setLoadingState(true, 'Loading user profile...');

    try {
      // Simulate network API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate successful data loading
      _user = User.dummy();
      _setLoadingState(false, 'Profile loaded successfully!');
    } catch (e) {
      _setLoadingState(false, 'Failed to load profile: $e');
    }
  }

  // Business Logic: Update user age
  void updateAge(int newAge) {
    if (_user.isEmpty) {
      _setMessage('No user to update');
      return;
    }

    _user = _user.copyWith(age: newAge);
    _setMessage('Age updated to $newAge');
  }

  // Business Logic: Increase age by 1
  void increaseAge() {
    updateAge(_user.age + 1);
  }

  // Business Logic: Clear user profile
  void clearProfile() {
    _user = User.empty();
    _setMessage('Profile cleared');
  }

  // Business Logic: Reset to initial state
  void reset() {
    _user = User.empty();
    _isLoading = false;
    _message = 'Ready to load profile';
    notifyListeners();
  }

  // Helper method to set loading state
  void _setLoadingState(bool loading, String message) {
    _isLoading = loading;
    _message = message;
    notifyListeners(); // Notify UI to rebuild
  }

  // Helper method to set message
  void _setMessage(String message) {
    _message = message;
    notifyListeners(); // Notify UI to rebuild
  }

  @override
  void dispose() {
    // Clean up resources when ViewModel is disposed
    super.dispose();
  }
}