/// Comprehensive error handling pattern for Firebase operations
class FirebaseResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const FirebaseResult._({
    this.data,
    this.error,
    required this.isSuccess,
  });

  /// Create a successful result with data
  factory FirebaseResult.success(T data) {
    return FirebaseResult._(data: data, isSuccess: true);
  }

  /// Create an error result with error message
  factory FirebaseResult.error(String error) {
    return FirebaseResult._(error: error, isSuccess: false);
  }

  /// Check if this result represents an error
  bool get isError => !isSuccess;

  /// Get the value from a successful result
  /// Throws an exception if called on an error result
  T get value {
    if (isError) {
      throw Exception('Tried to get value from error result: $error');
    }
    return data as T;
  }

  /// Get the error message from an error result
  /// Throws an exception if called on a successful result
  String get errorMessage {
    if (isSuccess) {
      throw Exception('Tried to get error from success result');
    }
    return error!;
  }

  /// Functional programming pattern to handle both success and error cases
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String error) onError,
  }) {
    if (isSuccess) {
      return onSuccess(data as T);
    } else {
      return onError(error!);
    }
  }

  /// Transform the data if this is a successful result
  FirebaseResult<R> map<R>(R Function(T data) transform) {
    if (isSuccess) {
      try {
        return FirebaseResult.success(transform(data as T));
      } catch (e) {
        return FirebaseResult.error('Transform failed: ${e.toString()}');
      }
    } else {
      return FirebaseResult.error(error!);
    }
  }

  /// Chain operations that return FirebaseResult
  FirebaseResult<R> flatMap<R>(FirebaseResult<R> Function(T data) transform) {
    if (isSuccess) {
      try {
        return transform(data as T);
      } catch (e) {
        return FirebaseResult.error('FlatMap failed: ${e.toString()}');
      }
    } else {
      return FirebaseResult.error(error!);
    }
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'FirebaseResult.success($data)';
    } else {
      return 'FirebaseResult.error($error)';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FirebaseResult<T> &&
        other.data == data &&
        other.error == error &&
        other.isSuccess == isSuccess;
  }

  @override
  int get hashCode {
    return data.hashCode ^ error.hashCode ^ isSuccess.hashCode;
  }
}
