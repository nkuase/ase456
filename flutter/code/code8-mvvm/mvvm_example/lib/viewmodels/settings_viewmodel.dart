import 'package:flutter/material.dart';
import '../models/settings_model.dart';
import '../constants/app_colors.dart';
import '../dialogs/language_dialog.dart';
<<<<<<< HEAD
import '../dialogs/edit_profile_dialog.dart';
import '../viewmodels/profile_viewmodel.dart';
=======
import '../services/database_helper.dart';
>>>>>>> 6806e03426fb21b7e6e3158958fddba40ac26441
import 'base_viewmodel.dart';

class SettingsViewModel extends BaseViewModel {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';

  SettingsViewModel() {
    // Initialize settings when view model is created
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      setLoading(true);
      // Ensure database is initialized
      await _dbHelper.initialize();
      
      // Load settings from database
      final settings = await _dbHelper.getSettings();
      if (settings != null) {
        _notificationsEnabled = settings['notificationsEnabled'] ?? true;
        _darkModeEnabled = settings['darkModeEnabled'] ?? false;
        _selectedLanguage = settings['language'] ?? 'English';
      }
      notifyListeners();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadSettings() async {
    try {
      setLoading(true);
      // Ensure database is initialized
      await _dbHelper.initialize();
      
      // Load settings from database
      final settings = await _dbHelper.getSettings();
      if (settings != null) {
        _notificationsEnabled = settings['notificationsEnabled'] ?? true;
        _darkModeEnabled = settings['darkModeEnabled'] ?? false;
        _selectedLanguage = settings['language'] ?? 'English';
      }
      notifyListeners();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  bool get notificationsEnabled => _notificationsEnabled;
  bool get darkModeEnabled => _darkModeEnabled;
  String get selectedLanguage => _selectedLanguage;

<<<<<<< HEAD
  List<SettingsModel> getAccountItems(String userName, ProfileViewModel profileViewModel, BuildContext context) {
=======
  Future<void> _initialize() async {
    try {
      setLoading(true);
      await _dbHelper.initialize();
      
      // Load settings from database
      final settings = await _dbHelper.getSettings();
      if (settings != null) {
        _notificationsEnabled = settings['notificationsEnabled'] ?? true;
        _darkModeEnabled = settings['darkModeEnabled'] ?? false;
        _selectedLanguage = settings['language'] ?? 'English';
      }
      notifyListeners();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  List<SettingsModel> getAccountItems(String userName, Function(String, String, String) onUpdateProfile) {
>>>>>>> 6806e03426fb21b7e6e3158958fddba40ac26441
    return [
      SettingsModel(
        icon: Icons.person_outline,
        title: 'Edit Profile',
        subtitle: userName,
<<<<<<< HEAD
        onTap: () => EditProfileDialog.show(context, profileViewModel),
=======
        onTap: () async {
          await onUpdateProfile(
            'Updated $userName',
            '', // email remains same
            '', // address remains same
          );
        },
>>>>>>> 6806e03426fb21b7e6e3158958fddba40ac26441
      ),
      SettingsModel(
        icon: Icons.lock_outline,
        title: 'Change Password',
        subtitle: 'Change regularly for security',
        onTap: () => print('Change Password'),
      ),
      SettingsModel(
        icon: Icons.privacy_tip_outlined,
        title: 'Privacy Settings',
        subtitle: 'Set profile visibility',
        onTap: () => print('Privacy Settings'),
      ),
    ];
  }

  List<SettingsModel> getAppSettingsItems(BuildContext context) {
    return [
      SettingsModel(
        icon: Icons.notifications_outlined,
        title: 'Notifications',
        subtitle: 'Push and email notification settings',
        trailing: Switch(
          value: _notificationsEnabled,
          onChanged: toggleNotifications,
          activeColor: AppColors.primary,
        ),
        onTap: () => toggleNotifications(!_notificationsEnabled),
      ),
      SettingsModel(
        icon: Icons.dark_mode_outlined,
        title: 'Dark Mode',
        subtitle: 'Use dark theme',
        trailing: Switch(
          value: _darkModeEnabled,
          onChanged: toggleDarkMode,
          activeColor: AppColors.primary,
        ),
        onTap: () => toggleDarkMode(!_darkModeEnabled),
      ),
      SettingsModel(
        icon: Icons.language_outlined,
        title: 'Language',
        subtitle: _selectedLanguage,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => LanguageDialog.show(context, this),
      ),
    ];
  }

  List<SettingsModel> getSupportItems() {
    return [
      SettingsModel(
        icon: Icons.help_outline,
        title: 'Help',
        subtitle: 'FAQ and user guide',
        onTap: () => print('Help'),
      ),
      SettingsModel(
        icon: Icons.feedback_outlined,
        title: 'Send Feedback',
        subtitle: 'Share your thoughts to improve the app',
        onTap: () => print('Feedback'),
      ),
      SettingsModel(
        icon: Icons.info_outline,
        title: 'App Info',
        subtitle: 'Version 1.0.0',
        onTap: () => print('App Info'),
      ),
    ];
  }

  List<SettingsModel> getDangerItems(VoidCallback onLogout, VoidCallback onDeleteAccount) {
    return [
      SettingsModel(
        icon: Icons.logout,
        title: 'Logout',
        titleColor: Colors.red,
        onTap: onLogout,
      ),
      SettingsModel(
        icon: Icons.delete_forever,
        title: 'Delete Account',
        subtitle: 'All data will be permanently deleted',
        titleColor: Colors.red,
        onTap: onDeleteAccount,
      ),
    ];
  }

  Future<void> toggleNotifications(bool value) async {
    await handleFuture(() async {
      _notificationsEnabled = value;
      await _saveSettings();
      notifyListeners();
    });
  }

  Future<void> toggleDarkMode(bool value) async {
    await handleFuture(() async {
      _darkModeEnabled = value;
      await _saveSettings();
      notifyListeners();
    });
  }

  Future<void> setLanguage(String language) async {
    await handleFuture(() async {
      _selectedLanguage = language;
      await _saveSettings();
      notifyListeners();
    });
  }

  Future<void> _saveSettings() async {
    final settings = {
      'id': 'app_settings',
      'notificationsEnabled': _notificationsEnabled,
      'darkModeEnabled': _darkModeEnabled,
      'language': _selectedLanguage,
    };

    try {
      await _dbHelper.updateSettings(settings);
    } catch (e) {
      print('Error saving settings: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await handleFuture(() async {
      // Reset settings to defaults
      _notificationsEnabled = true;
      _darkModeEnabled = false;
      _selectedLanguage = 'English';
      await _saveSettings();
      notifyListeners();
    });
  }

  Future<void> deleteAccount() async {
    await handleFuture(() async {
      // Reset settings to defaults
      _notificationsEnabled = true;
      _darkModeEnabled = false;
      _selectedLanguage = 'English';
      await _saveSettings();
      notifyListeners();
    });
  }
} 