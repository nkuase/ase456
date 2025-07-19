import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

/// Standard API response wrapper for all operations
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  /// Whether the operation was successful
  final bool success;
  
  /// The response data (if successful)
  final T? data;
  
  /// Error message (if failed)
  final String? error;
  
  /// Additional error details for debugging
  final String? errorDetails;
  
  /// HTTP status code
  final int? statusCode;
  
  /// Response timestamp
  final String timestamp;
  
  /// Request ID for tracing
  final String? requestId;

  const ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.errorDetails,
    this.statusCode,
    required this.timestamp,
    this.requestId,
  });

  /// Create successful response
  factory ApiResponse.success(T data, {int? statusCode, String? requestId}) {
    return ApiResponse<T>(
      success: true,
      data: data,
      statusCode: statusCode ?? 200,
      timestamp: DateTime.now().toIso8601String(),
      requestId: requestId,
    );
  }

  /// Create error response
  factory ApiResponse.error(
    String error, {
    String? errorDetails,
    int? statusCode,
    String? requestId,
  }) {
    return ApiResponse<T>(
      success: false,
      error: error,
      errorDetails: errorDetails,
      statusCode: statusCode ?? 500,
      timestamp: DateTime.now().toIso8601String(),
      requestId: requestId,
    );
  }

  /// Create validation error response
  factory ApiResponse.validationError(
    List<String> validationErrors, {
    String? requestId,
  }) {
    return ApiResponse<T>(
      success: false,
      error: 'Validation failed',
      errorDetails: validationErrors.join(', '),
      statusCode: 400,
      timestamp: DateTime.now().toIso8601String(),
      requestId: requestId,
    );
  }

  /// Create not found response
  factory ApiResponse.notFound(String resource, {String? requestId}) {
    return ApiResponse<T>(
      success: false,
      error: '$resource not found',
      statusCode: 404,
      timestamp: DateTime.now().toIso8601String(),
      requestId: requestId,
    );
  }

  /// Convert to JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);

  /// Convert from JSON
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  @override
  String toString() {
    if (success) {
      return 'ApiResponse.success(data: $data)';
    } else {
      return 'ApiResponse.error(error: $error, details: $errorDetails)';
    }
  }
}

/// Paginated response for list operations
@JsonSerializable(genericArgumentFactories: true)
class PaginatedResponse<T> {
  /// List of items for current page
  final List<T> items;
  
  /// Total number of items across all pages
  final int totalItems;
  
  /// Current page number (0-based)
  final int page;
  
  /// Number of items per page
  final int pageSize;
  
  /// Total number of pages
  final int totalPages;
  
  /// Whether there is a next page
  final bool hasNext;
  
  /// Whether there is a previous page
  final bool hasPrevious;

  const PaginatedResponse({
    required this.items,
    required this.totalItems,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  /// Create paginated response from items and pagination info
  factory PaginatedResponse.fromItems(
    List<T> items,
    int totalItems,
    int page,
    int pageSize,
  ) {
    final totalPages = (totalItems / pageSize).ceil();
    
    return PaginatedResponse<T>(
      items: items,
      totalItems: totalItems,
      page: page,
      pageSize: pageSize,
      totalPages: totalPages,
      hasNext: page < totalPages - 1,
      hasPrevious: page > 0,
    );
  }

  /// Convert to JSON
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PaginatedResponseFromJson(json, fromJsonT);

  /// Convert from JSON
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PaginatedResponseToJson(this, toJsonT);

  @override
  String toString() {
    return 'PaginatedResponse(items: ${items.length}, totalItems: $totalItems, page: $page)';
  }
}

/// Batch operation response
@JsonSerializable()
class BatchResponse {
  /// Number of successful operations
  final int successCount;
  
  /// Number of failed operations
  final int failureCount;
  
  /// Total number of operations
  final int totalCount;
  
  /// List of errors for failed operations
  final List<BatchError> errors;
  
  /// List of successfully created IDs
  final List<String> createdIds;

  const BatchResponse({
    required this.successCount,
    required this.failureCount,
    required this.totalCount,
    required this.errors,
    required this.createdIds,
  });

  /// Create successful batch response
  factory BatchResponse.success(List<String> createdIds) {
    return BatchResponse(
      successCount: createdIds.length,
      failureCount: 0,
      totalCount: createdIds.length,
      errors: [],
      createdIds: createdIds,
    );
  }

  /// Create partial success batch response
  factory BatchResponse.partial(
    List<String> createdIds,
    List<BatchError> errors,
    int totalCount,
  ) {
    return BatchResponse(
      successCount: createdIds.length,
      failureCount: errors.length,
      totalCount: totalCount,
      errors: errors,
      createdIds: createdIds,
    );
  }

  /// Whether all operations were successful
  bool get isFullSuccess => failureCount == 0;

  /// Whether all operations failed
  bool get isFullFailure => successCount == 0;

  /// Whether some operations succeeded and some failed
  bool get isPartialSuccess => successCount > 0 && failureCount > 0;

  factory BatchResponse.fromJson(Map<String, dynamic> json) => _$BatchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BatchResponseToJson(this);
}

/// Error information for batch operations
@JsonSerializable()
class BatchError {
  /// Index of the failed item in the batch
  final int index;
  
  /// Error message
  final String error;
  
  /// Error details
  final String? details;

  const BatchError({
    required this.index,
    required this.error,
    this.details,
  });

  factory BatchError.fromJson(Map<String, dynamic> json) => _$BatchErrorFromJson(json);
  Map<String, dynamic> toJson() => _$BatchErrorToJson(this);

  @override
  String toString() {
    return 'BatchError(index: $index, error: $error)';
  }
}
