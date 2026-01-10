// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditResponseModel _$AuditResponseModelFromJson(Map<String, dynamic> json) =>
    AuditResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: AuditPaginationData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuditResponseModelToJson(AuditResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

AuditPaginationData _$AuditPaginationDataFromJson(Map<String, dynamic> json) =>
    AuditPaginationData(
      currentPage: (json['current_page'] as num).toInt(),
      lastPage: (json['last_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => AuditLogItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AuditPaginationDataToJson(
  AuditPaginationData instance,
) => <String, dynamic>{
  'current_page': instance.currentPage,
  'last_page': instance.lastPage,
  'total': instance.total,
  'per_page': instance.perPage,
  'data': instance.data,
};

AuditLogItem _$AuditLogItemFromJson(Map<String, dynamic> json) => AuditLogItem(
  id: (json['id'] as num).toInt(),
  action: json['action'] as String,
  method: json['method'] as String,
  url: json['url'] as String,
  ip: json['ip'] as String,
  statusCode: (json['status_code'] as num).toInt(),
  payload: json['payload'],
  createdAt: json['created_at'] as String,
  actor: json['actor'] == null
      ? null
      : AuditActor.fromJson(json['actor'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuditLogItemToJson(AuditLogItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'method': instance.method,
      'url': instance.url,
      'ip': instance.ip,
      'status_code': instance.statusCode,
      'payload': instance.payload,
      'created_at': instance.createdAt,
      'actor': instance.actor,
    };

AuditActor _$AuditActorFromJson(Map<String, dynamic> json) => AuditActor(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$AuditActorToJson(AuditActor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
    };
