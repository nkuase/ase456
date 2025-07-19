// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiResponse<T>(
      success: json['success'] as bool,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      error: json['error'] as String?,
      errorDetails: json['errorDetails'] as String?,
      statusCode: json['statusCode'] as int?,
      timestamp: json['timestamp'] as String,
      requestId: json['requestId'] as String?,
    );

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'success': instance.success,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
      'error': instance.error,
      'errorDetails': instance.errorDetails,
      'statusCode': instance.statusCode,
      'timestamp': instance.timestamp,
      'requestId': instance.requestId,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

PaginatedResponse<T> _$PaginatedResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    PaginatedResponse<T>(
      items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
      totalItems: json['totalItems'] as int,
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      totalPages: json['totalPages'] as int,
      hasNext: json['hasNext'] as bool,
      hasPrevious: json['hasPrevious'] as bool,
    );

Map<String, dynamic> _$PaginatedResponseToJson<T>(
  PaginatedResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'items': instance.items.map(toJsonT).toList(),
      'totalItems': instance.totalItems,
      'page': instance.page,
      'pageSize': instance.pageSize,
      'totalPages': instance.totalPages,
      'hasNext': instance.hasNext,
      'hasPrevious': instance.hasPrevious,
    };

BatchResponse _$BatchResponseFromJson(Map<String, dynamic> json) => BatchResponse(
      successCount: json['successCount'] as int,
      failureCount: json['failureCount'] as int,
      totalCount: json['totalCount'] as int,
      errors: (json['errors'] as List<dynamic>)
          .map((e) => BatchError.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdIds: (json['createdIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$BatchResponseToJson(BatchResponse instance) =>
    <String, dynamic>{
      'successCount': instance.successCount,
      'failureCount': instance.failureCount,
      'totalCount': instance.totalCount,
      'errors': instance.errors,
      'createdIds': instance.createdIds,
    };

BatchError _$BatchErrorFromJson(Map<String, dynamic> json) => BatchError(
      index: json['index'] as int,
      error: json['error'] as String,
      details: json['details'] as String?,
    );

Map<String, dynamic> _$BatchErrorToJson(BatchError instance) =>
    <String, dynamic>{
      'index': instance.index,
      'error': instance.error,
      'details': instance.details,
    };
