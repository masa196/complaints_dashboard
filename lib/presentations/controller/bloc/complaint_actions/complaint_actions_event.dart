
part of 'complaint_actions_bloc.dart';

abstract class ComplaintActionsEvent {}

class LockComplaintRequested extends ComplaintActionsEvent {
  final int id;
  LockComplaintRequested(this.id);
}

class UpdateStatusRequested extends ComplaintActionsEvent {
  final int id;
  final String status;
  UpdateStatusRequested({required this.id, required this.status});
}

class RequestInfoRequested extends ComplaintActionsEvent {
  final int id;
  final String requestText;
  RequestInfoRequested({required this.id, required this.requestText});
}

class UnlockComplaintRequested extends ComplaintActionsEvent {
  final int id;
  UnlockComplaintRequested(this.id);
}
