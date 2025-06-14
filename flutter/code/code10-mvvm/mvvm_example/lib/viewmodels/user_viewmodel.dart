import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService;
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserViewModel(this._userService) {
    _initialize();
  }

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _initialize() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _userService.initialize();
      _currentUser = await _userService.getUser();
    } catch (e) {
      _error = e.toString();
      print('Error initializing UserViewModel: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _userService.createUser(user);
      _currentUser = user;
    } catch (e) {
      _error = e.toString();
      print('Error creating user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (_currentUser != null) {
        await _userService.updateUser(0, user);
        _currentUser = user;
      }
    } catch (e) {
      _error = e.toString();
      print('Error updating user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (_currentUser != null) {
        await _userService.deleteUser(0);
        _currentUser = null;
      }
    } catch (e) {
      _error = e.toString();
      print('Error deleting user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 