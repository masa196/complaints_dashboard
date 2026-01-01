// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleModel _$RoleModelFromJson(Map<String, dynamic> json) => RoleModel(
  success: json['success'] as bool?,
  statusCode: (json['status_code'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : RoleDetails.fromJson(json['data'] as Map<String, dynamic>),
  errors: json['errors'] as List<dynamic>?,
);

RoleDetails _$RoleDetailsFromJson(Map<String, dynamic> json) => RoleDetails(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  guardName: json['guard_name'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  permissions: (json['permissions'] as List<dynamic>?)
      ?.map((e) => RoleDetails.fromJson(e as Map<String, dynamic>))
      .toList(),
  pivot: json['pivot'] == null
      ? null
      : Pivot.fromJson(json['pivot'] as Map<String, dynamic>),
);

Pivot _$PivotFromJson(Map<String, dynamic> json) => Pivot(
  roleId: (json['role_id'] as num?)?.toInt(),
  permissionId: (json['permission_id'] as num?)?.toInt(),
);
