// lib/employee_dashboard/presentation/bloc/complaint_actions/complaint_actions_state.dart
part of 'complaint_actions_bloc.dart';

enum ComplaintAction { locking, locked, updatingStatus, updatedStatus, requestingInfo, requestedInfo, unlocking, unlocked }

abstract class ComplaintActionsState {
  const ComplaintActionsState();
}

class ComplaintActionsInitial extends ComplaintActionsState {
  const ComplaintActionsInitial();
}

class ComplaintActionInProgress extends ComplaintActionsState {
  final ComplaintAction action;
  final int complaintId;
  ComplaintActionInProgress({required this.action, required this.complaintId});
}

class ComplaintActionSuccess extends ComplaintActionsState {
  final ComplaintAction action;
  final int complaintId;
  final String message;
  final int statusCode;
  ComplaintActionSuccess({required this.action, required this.complaintId, required this.message, required this.statusCode});
}

class ComplaintActionFailure extends ComplaintActionsState {
  final ComplaintAction action;
  final int complaintId;
  final String message;
  final int statusCode;
  ComplaintActionFailure({required this.action, required this.complaintId, required this.message, required this.statusCode});
}
