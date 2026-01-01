// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roles_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RolesModel _$RolesModelFromJson(Map<String, dynamic> json) => RolesModel(
  success: json['success'] as bool?,
  statusCode: (json['status_code'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => Role.fromJson(e as Map<String, dynamic>))
      .toList(),
  errors: json['errors'] as List<dynamic>?,
);

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  guardName: json['guard_name'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);
