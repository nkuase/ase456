import 'package:flutter/foundation.dart';

/// Simple Base ViewModel for MVVM education
/// 
/// This demonstrates basic MVVM concepts:
/// 1. ChangeNotifier for reactive UI updates
/// 2. Loading state management
/// 3. Error handling
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  /// Current loading state
  bool get isLoading => _isLoading;

  /// Current error message
  String? get errorMessage => _errorMessage;

  /// Set loading state and notify UI
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message and notify UI
  void setError(String? error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Handle async operations with loading state
  Future<T?> handleAsync<T>(Future<T> Function() operation) async {
    setLoading(true);
    try {
      final result = await operation();
      setLoading(false);
      return result;
    } catch (error) {
      setError(error.toString());
      return null;
    }
  }
}
