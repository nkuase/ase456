class FirebaseResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const FirebaseResult._({
    this.data,
    this.error,
    required this.isSuccess,
  });

  factory FirebaseResult.success(T data) {
    return FirebaseResult._(
      data: data,
      isSuccess: true,
    );
  }

  factory FirebaseResult.error(String error) {
    return FirebaseResult._(
      error: error,
      isSuccess: false,
    );
  }

  bool get isError => !isSuccess;

  T get value {
    if (isError) {
      throw Exception('Tried to get value from error result: $error');
    }
    return data as T;
  }

  String get errorMessage {
    if (isSuccess) {
      throw Exception('Tried to get error from success result');
    }
    return error!;
  }

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

  FirebaseResult<R> map<R>(R Function(T data) mapper) {
    if (isSuccess) {
      try {
        return FirebaseResult.success(mapper(data as T));
      } catch (e) {
        return FirebaseResult.error('Mapping error: ${e.toString()}');
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
  int get hashCode => Object.hash(data, error, isSuccess);
}