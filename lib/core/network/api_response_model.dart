import 'package:equatable/equatable.dart';

class ApiResponseModel extends Equatable {
  final bool? success;
  final int? statusCode;
  final String? message;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? errors;

  const ApiResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
    this.errors,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiResponseModel(
      success: json['success'] is bool ? json['success'] as bool : null,
      statusCode: json['status_code'] is int ? json['status_code'] as int : null,
      message: json['message'] is String ? json['message'] as String : null,
      data: json['data'] is Map ? Map<String, dynamic>.from(json['data']) : null,
      errors: json['errors'] is Map ? Map<String, dynamic>.from(json['errors']) : null,
    );
  }

  @override
  List<Object?> get props => [success, statusCode, message, data, errors];
}
