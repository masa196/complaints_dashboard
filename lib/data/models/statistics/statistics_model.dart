import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'statistics_model.g.dart';

@JsonSerializable(createToJson: false)
class StatisticsModel extends Equatable {
  const StatisticsModel({
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
  final Data? data;
  final List<dynamic>? errors;

  factory StatisticsModel.fromJson(Map<String, dynamic> json) => _$StatisticsModelFromJson(json);

  @override
  List<Object?> get props => [
    success, statusCode, message, data, errors, ];
}

@JsonSerializable(createToJson: false)
class Data extends Equatable {
 const  Data({
    required this.usersCount,
    required this.complaintsCount,
    required this.complaintsByStatus,
    required this.complaintsByAgency,
  });

  @JsonKey(name: 'users_count')
  final int? usersCount;

  @JsonKey(name: 'complaints_count')
  final int? complaintsCount;

  @JsonKey(name: 'complaints_by_status')
  final List<ComplaintsByStatus>? complaintsByStatus;

  @JsonKey(name: 'complaints_by_agency')
  final List<ComplaintsByAgency>? complaintsByAgency;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  @override
  List<Object?> get props => [
    usersCount, complaintsCount, complaintsByStatus, complaintsByAgency, ];
}

@JsonSerializable(createToJson: false)
class ComplaintsByAgency extends Equatable {
  const ComplaintsByAgency({
    required this.governmentAgencyId,
    required this.total,
    required this.agency,
  });

  @JsonKey(name: 'government_agency_id')
  final int? governmentAgencyId;
  final int? total;
  final Agency? agency;

  factory ComplaintsByAgency.fromJson(Map<String, dynamic> json) => _$ComplaintsByAgencyFromJson(json);

  @override
  List<Object?> get props => [
    governmentAgencyId, total, agency, ];
}

@JsonSerializable(createToJson: false)
class Agency extends Equatable {
  const Agency({
    required this.id,
    required this.name,
  });

  final int? id;
  final String? name;

  factory Agency.fromJson(Map<String, dynamic> json) => _$AgencyFromJson(json);

  @override
  List<Object?> get props => [
    id, name, ];
}

@JsonSerializable(createToJson: false)
class ComplaintsByStatus extends Equatable {
  ComplaintsByStatus({
    required this.status,
    required this.total,
  });

  final String? status;
  final int? total;

  factory ComplaintsByStatus.fromJson(Map<String, dynamic> json) => _$ComplaintsByStatusFromJson(json);

  @override
  List<Object?> get props => [
    status, total, ];
}
