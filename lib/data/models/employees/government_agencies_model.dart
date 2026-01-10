import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'government_agencies_model.g.dart';

@JsonSerializable(createToJson: false)
class GovernmentAgenciesModel extends Equatable {
  GovernmentAgenciesModel({
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
  final List<Datum>? data;
  final List<dynamic>? errors;

  factory GovernmentAgenciesModel.fromJson(Map<String, dynamic> json) => _$GovernmentAgenciesModelFromJson(json);

  @override
  List<Object?> get props => [
    success, statusCode, message, data, errors, ];
}

@JsonSerializable(createToJson: false)
class Datum extends Equatable {
  Datum({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final dynamic address;
  final dynamic phone;
  final dynamic description;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  @override
  List<Object?> get props => [
    id, name, address, phone, description, createdAt, updatedAt, ];
}
