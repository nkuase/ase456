import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'base_viewmodel.dart';

class ProfileViewModel extends BaseViewModel {
  final UserService _userService = UserService();
  UserModel? _userModel;

  ProfileViewModel() {
    _initialize();
  }

  UserModel get userModel => _userModel ?? UserModel(
    name: 'John Doe',
    email: 'john.doe@example.com',
    address: 'Alexandria, KY, USA',
    posts: 1234,
    followers: 567,
    following: 89,
  );

  Future<void> _initialize() async {
    try {
      setLoading(true);
      await _userService.initialize();
      final users = await _userService.getUser();
      if (users != null) {
        _userModel = users;
      }
      notifyListeners();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadProfile() async {
    await _initialize();
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? address,
  }) async {
    final currentUser = _userModel;
    if (currentUser == null) return;

    await handleFuture(() async {
      final updatedUser = currentUser.copyWith(
        name: name,
        email: email,
        address: address,
      );
      await _userService.updateUser(updatedUser);
      _userModel = updatedUser;
      notifyListeners();
    });
  }

  Future<void> updateProfilePicture(String? imagePath) async {
    final currentUser = _userModel;
    if (currentUser == null) return;

    if (imagePath == null) {
      _userModel = currentUser.copyWith(profilePicture: null);
    } else {
      // Check if the path is a URL (starts with http:// or https://)
      if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
        _userModel = currentUser.copyWith(profilePicture: imagePath);
      } else {
        // For a local file, we'll use the file:// scheme
        _userModel = currentUser.copyWith(profilePicture: 'file://$imagePath');
      }
    }
    notifyListeners();
  }

  void removeProfilePicture() {
    final currentUser = _userModel;
    if (currentUser == null) return;

    _userModel = currentUser.copyWith(profilePicture: null);
    notifyListeners();
  }

  Future<void> updateStats(Map<String, int> newStats) async {
    final currentUser = _userModel;
    if (currentUser == null) return;

    await handleFuture(() async {
      final updatedUser = currentUser.copyWith(
        posts: newStats['posts'],
        followers: newStats['followers'],
        following: newStats['following'],
      );
      await _userService.updateUser(updatedUser);
      _userModel = updatedUser;
      notifyListeners();
    });
  }

  Future<void> deleteAccount() async {
    final currentUser = _userModel;
    if (currentUser == null) return;

    await handleFuture(() async {
      await _userService.deleteUser(0);
      _userModel = null;
      notifyListeners();
    });
  }

  Future<void> logout() async {
    await handleFuture(() async {
      _userModel = null;
      notifyListeners();
    });
  }
} 