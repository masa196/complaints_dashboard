import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'all_permissions_model.g.dart';

@JsonSerializable(createToJson: false)
class AllPermissionsModel extends Equatable {
  const AllPermissionsModel({
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
  final List<DatumPer>? data;
  final List<dynamic>? errors;

  factory AllPermissionsModel.fromJson(Map<String, dynamic> json) => _$AllPermissionsModelFromJson(json);

  @override
  List<Object?> get props => [
    success, statusCode, message, data, errors, ];
}

@JsonSerializable(createToJson: false)
class DatumPer extends Equatable {
  const DatumPer({
    required this.id,
    required this.name,
    required this.guardName,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;

  @JsonKey(name: 'guard_name')
  final String? guardName;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  factory DatumPer.fromJson(Map<String, dynamic> json) => _$DatumPerFromJson(json);

  @override
  List<Object?> get props => [
    id, name, guardName, createdAt, updatedAt, ];
}
