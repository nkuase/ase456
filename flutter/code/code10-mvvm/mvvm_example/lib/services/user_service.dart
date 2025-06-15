// lib/services/user_service.dart
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'database_helper.dart';

class UserService extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _error;
  UserModel? _currentUser;

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initialize() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _dbHelper.initialize();
      final usersData = await _dbHelper.getAllUsers();
      if (usersData.isNotEmpty) {
        final userData = usersData.first;
        _currentUser = UserModel(
          name: userData['name'] as String,
          email: userData['email'] as String,
          address: userData['address'] as String,
          profilePicture: userData['profilePicture'] as String?,
          posts: userData['posts'] as int? ?? 0,
          followers: userData['followers'] as int? ?? 0,
          following: userData['following'] as int? ?? 0,
        );
      }
    } catch (e) {
      _error = e.toString();
      print('Error initializing UserService: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserModel?> getUser() async {
    if (_currentUser != null) {
      return _currentUser;
    }

    try {
      final usersData = await _dbHelper.getAllUsers();
      if (usersData.isEmpty) {
        return null;
      }
      final userData = usersData.first;
      _currentUser = UserModel(
        name: userData['name'] as String,
        email: userData['email'] as String,
        address: userData['address'] as String,
        profilePicture: userData['profilePicture'] as String?,
        posts: userData['posts'] as int? ?? 0,
        followers: userData['followers'] as int? ?? 0,
        following: userData['following'] as int? ?? 0,
      );
      return _currentUser;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userData = {
        'name': user.name,
        'email': user.email,
        'address': user.address,
        'profilePicture': user.profilePicture,
        'posts': user.posts,
        'followers': user.followers,
        'following': user.following,
      };

      await _dbHelper.addUser(userData);
      await loadUsers(); // Reload users to get the new user with ID
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

      final userData = {
        'name': user.name,
        'email': user.email,
        'address': user.address,
        'profilePicture': user.profilePicture,
        'posts': user.posts,
        'followers': user.followers,
        'following': user.following,
      };

      await _dbHelper.updateUser(userData);
      _currentUser = user;
    } catch (e) {
      _error = e.toString();
      print('Error updating user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _dbHelper.deleteUser(id);
      _currentUser = null;
    } catch (e) {
      _error = e.toString();
      print('Error deleting user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUsers() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final usersData = await _dbHelper.getAllUsers();
      _users = usersData.map((data) => UserModel(
        name: data['name'] as String,
        email: data['email'] as String,
        address: data['address'] as String,
        profilePicture: data['profilePicture'] as String?,
        posts: data['posts'] as int? ?? 0,
        followers: data['followers'] as int? ?? 0,
        following: data['following'] as int? ?? 0,
      )).toList();
    } catch (e) {
      _error = e.toString();
      print('Error loading users: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserModel> getCurrentUser() async {
    if (_currentUser != null) return _currentUser!;
    
    final user = await getUser();
    if (user != null) {
      _currentUser = user;
      return user;
    }

    // Create default user if none exists
    final defaultUser = UserModel(
      name: 'John Doe',
      email: 'john.doe@example.com',
      address: 'Alexandria, KY, USA',
      profilePicture: null,
      posts: 1234,
      followers: 567,
      following: 89,
    );
    await updateUser(defaultUser);
    _currentUser = defaultUser;
    return defaultUser;
  }

  Future<UserModel> updateUserProfile(UserModel user) async {
    await updateUser(user);
    _currentUser = user;
    return user;
  }

  void clearCurrentUser() {
    _currentUser = null;
    notifyListeners();
  }

  Map<String, dynamic> _userToMap(UserModel user) {
    return {
      'name': user.name,
      'email': user.email,
      'address': user.address,
      'profilePicture': user.profilePicture,
      'posts': user.posts,
      'followers': user.followers,
      'following': user.following,
    };
  }

  UserModel _userFromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      email: map['email'],
      address: map['address'],
      profilePicture: map['profilePicture'],
      posts: map['posts'],
      followers: map['followers'],
      following: map['following'],
    );
  }

  // User login (actually API call)
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return getCurrentUser();
  }

  // User logout (actually API call)
  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1));
    clearCurrentUser();
  }

  // Get user followers (actually API call)
  Future<List<UserModel>> getFollowers() async {
    await Future.delayed(const Duration(seconds: 1));
    final user = await getCurrentUser();
    return [user];
  }

  // Delete account
  Future<void> deleteAccount() async {
    await Future.delayed(const Duration(seconds: 1));
    clearCurrentUser();
  }
}