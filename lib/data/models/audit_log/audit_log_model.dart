import 'package:json_annotation/json_annotation.dart';

part 'audit_log_model.g.dart';

@JsonSerializable()
class AuditResponseModel {
  final bool success;
  final String message;
  final AuditPaginationData data;

  AuditResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AuditResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuditResponseModelFromJson(json);
}

@JsonSerializable()
class AuditPaginationData {
  @JsonKey(name: 'current_page')
  final int currentPage;
  @JsonKey(name: 'last_page')
  final int lastPage;
  final int total;
  @JsonKey(name: 'per_page')
  final int perPage;
  final List<AuditLogItem> data;

  AuditPaginationData({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
    required this.data,
  });

  factory AuditPaginationData.fromJson(Map<String, dynamic> json) =>
      _$AuditPaginationDataFromJson(json);
}

@JsonSerializable()
class AuditLogItem {
  final int id;
  final String action;
  final String method;
  final String url;
  final String ip;
  @JsonKey(name: 'status_code')
  final int statusCode;


  final dynamic payload;

  @JsonKey(name: 'created_at')
  final String createdAt;
  final AuditActor? actor;

  AuditLogItem({
    required this.id,
    required this.action,
    required this.method,
    required this.url,
    required this.ip,
    required this.statusCode,
    this.payload,
    required this.createdAt,
    this.actor,
  });

  factory AuditLogItem.fromJson(Map<String, dynamic> json) =>
      _$AuditLogItemFromJson(json);
}

@JsonSerializable()
class AuditActor {
  final int id;
  final String name;
  final String email;

  AuditActor({required this.id, required this.name, required this.email});

  factory AuditActor.fromJson(Map<String, dynamic> json) =>
      _$AuditActorFromJson(json);
}