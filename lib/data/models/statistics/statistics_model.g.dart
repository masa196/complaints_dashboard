// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatisticsModel _$StatisticsModelFromJson(Map<String, dynamic> json) =>
    StatisticsModel(
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      errors: json['errors'] as List<dynamic>?,
    );

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  usersCount: (json['users_count'] as num?)?.toInt(),
  complaintsCount: (json['complaints_count'] as num?)?.toInt(),
  complaintsByStatus: (json['complaints_by_status'] as List<dynamic>?)
      ?.map((e) => ComplaintsByStatus.fromJson(e as Map<String, dynamic>))
      .toList(),
  complaintsByAgency: (json['complaints_by_agency'] as List<dynamic>?)
      ?.map((e) => ComplaintsByAgency.fromJson(e as Map<String, dynamic>))
      .toList(),
);

ComplaintsByAgency _$ComplaintsByAgencyFromJson(Map<String, dynamic> json) =>
    ComplaintsByAgency(
      governmentAgencyId: (json['government_agency_id'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      agency: json['agency'] == null
          ? null
          : Agency.fromJson(json['agency'] as Map<String, dynamic>),
    );

Agency _$AgencyFromJson(Map<String, dynamic> json) =>
    Agency(id: (json['id'] as num?)?.toInt(), name: json['name'] as String?);

ComplaintsByStatus _$ComplaintsByStatusFromJson(Map<String, dynamic> json) =>
    ComplaintsByStatus(
      status: json['status'] as String?,
      total: (json['total'] as num?)?.toInt(),
    );
