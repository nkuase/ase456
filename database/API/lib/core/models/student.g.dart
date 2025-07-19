// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
      id: json['id'] as String?,
      name: json['name'] as String,
      age: json['age'] as int,
      major: json['major'] as String,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'major': instance.major,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

StudentQuery _$StudentQueryFromJson(Map<String, dynamic> json) => StudentQuery(
      nameContains: json['nameContains'] as String?,
      major: json['major'] as String?,
      minAge: json['minAge'] as int?,
      maxAge: json['maxAge'] as int?,
      sortBy: json['sortBy'] as String?,
      sortDescending: json['sortDescending'] as bool? ?? false,
      limit: json['limit'] as int?,
      offset: json['offset'] as int?,
    );

Map<String, dynamic> _$StudentQueryToJson(StudentQuery instance) => <String, dynamic>{
      'nameContains': instance.nameContains,
      'major': instance.major,
      'minAge': instance.minAge,
      'maxAge': instance.maxAge,
      'sortBy': instance.sortBy,
      'sortDescending': instance.sortDescending,
      'limit': instance.limit,
      'offset': instance.offset,
    };
