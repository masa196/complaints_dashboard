import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'complaints_for_admin_model.g.dart';

@JsonSerializable(createToJson: false)
class ComplaintsForAdminModel extends Equatable {
  ComplaintsForAdminModel({
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
  final List<DatumForAdmin>? data;
  final List<dynamic>? errors;

  factory ComplaintsForAdminModel.fromJson(Map<String, dynamic> json) => _$ComplaintsForAdminModelFromJson(json);

  @override
  List<Object?> get props => [
    success, statusCode, message, data, errors, ];
}

@JsonSerializable(createToJson: false)
class DatumForAdmin extends Equatable {
  DatumForAdmin({
    required this.id,
    required this.userId,
    required this.governmentAgencyId,
    required this.referenceNumber,
    required this.title,
    required this.description,
    required this.location,
    required this.status,
    required this.lockedByAdminId,
    required this.lockedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.agency,
  });

  final int? id;

  @JsonKey(name: 'user_id')
  final int? userId;

  @JsonKey(name: 'government_agency_id')
  final int? governmentAgencyId;

  @JsonKey(name: 'reference_number')
  final String? referenceNumber;
  final String? title;
  final String? description;
  final String? location;
  final String? status;

  @JsonKey(name: 'locked_by_admin_id')
  final dynamic lockedByAdminId;

  @JsonKey(name: 'locked_at')
  final dynamic lockedAt;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final Agency2? user;
  final Agency2? agency;

  factory DatumForAdmin.fromJson(Map<String, dynamic> json) => _$DatumForAdminFromJson(json);

  @override
  List<Object?> get props => [
    id, userId, governmentAgencyId, referenceNumber, title, description, location, status, lockedByAdminId, lockedAt, createdAt, updatedAt, user, agency, ];
}

@JsonSerializable(createToJson: false)
class Agency2 extends Equatable {
  Agency2({
    required this.id,
    required this.name,
  });

  final int? id;
  final String? name;

  factory Agency2.fromJson(Map<String, dynamic> json) => _$Agency2FromJson(json);

  @override
  List<Object?> get props => [
    id, name, ];
}
