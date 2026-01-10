part of 'audit_bloc.dart';

abstract class AuditState extends Equatable {
  const AuditState();
  @override
  List<Object> get props => [];
}

class AuditInitial extends AuditState {}
class AuditLoading extends AuditState {}
class AuditLoaded extends AuditState {
  final AuditResponseModel auditResponse;
  const AuditLoaded(this.auditResponse);

  @override
  List<Object> get props => [auditResponse];
}
class AuditError extends AuditState {
  final String message;
  const AuditError(this.message);

  @override
  List<Object> get props => [message];
}
