import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'role_model.g.dart';

@JsonSerializable(createToJson: false)
class RoleModel extends Equatable {
  const RoleModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.errors,
  });

  final bool? success;

  @JsonKey(name: 'status_code')
  final int? statusCode;
  final String? message;
  final RoleDetails? data;
  final List<dynamic>? errors;

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);

  @override
  List<Object?> get props => [success, statusCode, message, data, errors];
}

@JsonSerializable(createToJson: false)
class RoleDetails extends Equatable {
  RoleDetails({
    required this.id,
    required this.name,
    required this.guardName,
    required this.createdAt,
    required this.updatedAt,
    required this.permissions,
    required this.pivot,
  });

  final int? id;
  final String? name;

  @JsonKey(name: 'guard_name')
  final String? guardName;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final List<RoleDetails>? permissions;
  final Pivot? pivot;

  factory RoleDetails.fromJson(Map<String, dynamic> json) =>
      _$RoleDetailsFromJson(json);

  @override
  List<Object?> get props =>
      [id, name, guardName, createdAt, updatedAt, permissions, pivot];
}

@JsonSerializable(createToJson: false)
class Pivot extends Equatable {
  Pivot({
    required this.roleId,
    required this.permissionId,
  });

  @JsonKey(name: 'role_id')
  final int? roleId;

  @JsonKey(name: 'permission_id')
  final int? permissionId;

  factory Pivot.fromJson(Map<String, dynamic> json) => _$PivotFromJson(json);

  @override
  List<Object?> get props => [roleId, permissionId];
}


extension RoleDetailsCopyWith on RoleDetails {
  RoleDetails copyWith({
    int? id,
    String? name,
    String? guardName,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<RoleDetails>? permissions,
    Pivot? pivot,
  }) {
    return RoleDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      guardName: guardName ?? this.guardName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      permissions: permissions ?? this.permissions,
      pivot: pivot ?? this.pivot,
    );
  }
}


extension RoleModelCopyWith on RoleModel {
  RoleModel copyWith({
    bool? success,
    int? statusCode,
    String? message,
    RoleDetails? data,
    List<dynamic>? errors,
  }) {
    return RoleModel(
      success: success ?? this.success,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      data: data ?? this.data,
      errors: errors ?? this.errors,
    );
  }
}

