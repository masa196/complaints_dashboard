part of 'audit_bloc.dart';

abstract class AuditEvent extends Equatable {
  const AuditEvent();
  @override
  List<Object> get props => [];
}

class FetchAuditLogsEvent extends AuditEvent {
  final int page;
  const FetchAuditLogsEvent(this.page);

  @override
  List<Object> get props => [page];
}
