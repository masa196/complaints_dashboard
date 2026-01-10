// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'government_agencies_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GovernmentAgenciesModel _$GovernmentAgenciesModelFromJson(
  Map<String, dynamic> json,
) => GovernmentAgenciesModel(
  success: json['success'] as bool?,
  statusCode: (json['status_code'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
      .toList(),
  errors: json['errors'] as List<dynamic>?,
);

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  address: json['address'],
  phone: json['phone'],
  description: json['description'],
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);
