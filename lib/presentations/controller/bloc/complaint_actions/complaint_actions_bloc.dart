// lib/employee_dashboard/presentation/bloc/complaint_actions/complaint_actions_bloc.dart
import 'package:bloc/bloc.dart';
import '../../../../domain/use_cases/complaints/lock_complaint_usecase.dart';
import '../../../../domain/use_cases/complaints/unlock_complaint_usecase.dart';
import '../../../../domain/use_cases/complaints/update_status_usecase.dart';
import '../../../../domain/use_cases/complaints/request_info_usecase.dart';

part 'complaint_actions_event.dart';
part 'complaint_actions_state.dart';

class ComplaintActionsBloc extends Bloc<ComplaintActionsEvent, ComplaintActionsState> {
  final LockComplaintUseCase lockUseCase;
  final UnlockComplaintUseCase unlockUseCase;
  final UpdateStatusUseCase updateStatusUseCase;
  final RequestInfoUseCase requestInfoUseCase;

  ComplaintActionsBloc({
    required this.lockUseCase,
    required this.unlockUseCase,
    required this.updateStatusUseCase,
    required this.requestInfoUseCase,
  }) : super(ComplaintActionsInitial()) {
    on<LockComplaintRequested>(_onLockRequested);
    on<UpdateStatusRequested>(_onUpdateStatusRequested);
    on<RequestInfoRequested>(_onRequestInfoRequested);
    on<UnlockComplaintRequested>(_onUnlockRequested);
  }

  Future<void> _onLockRequested(LockComplaintRequested event, Emitter<ComplaintActionsState> emit) async {
    emit(ComplaintActionInProgress(action: ComplaintAction.locking, complaintId: event.id));
    try {
      final res = await lockUseCase.execute(event.id);
      final sc = res['status_code'] is int ? res['status_code'] as int : int.tryParse(res['status_code']?.toString() ?? '') ?? 0;
      final msg = res['message']?.toString() ?? '';
      if (sc == 200) {
        emit(ComplaintActionSuccess(action: ComplaintAction.locked, complaintId: event.id, message: msg, statusCode: sc));
      } else {
        emit(ComplaintActionFailure(action: ComplaintAction.locking, complaintId: event.id, message: msg, statusCode: sc));
      }
    } catch (e) {
      emit(ComplaintActionFailure(action: ComplaintAction.locking, complaintId: event.id, message: e.toString(), statusCode: 0));
    }
  }

  Future<void> _onUpdateStatusRequested(UpdateStatusRequested event, Emitter<ComplaintActionsState> emit) async {
    emit(ComplaintActionInProgress(action: ComplaintAction.updatingStatus, complaintId: event.id));
    try {
      final res = await updateStatusUseCase.execute(event.id, event.status);
      final sc = res['status_code'] is int ? res['status_code'] as int : int.tryParse(res['status_code']?.toString() ?? '') ?? 0;
      final msg = res['message']?.toString() ?? '';
      if (sc == 200) {
        emit(ComplaintActionSuccess(action: ComplaintAction.updatedStatus, complaintId: event.id, message: msg, statusCode: sc));
      } else {
        emit(ComplaintActionFailure(action: ComplaintAction.updatingStatus, complaintId: event.id, message: msg, statusCode: sc));
      }
    } catch (e) {
      emit(ComplaintActionFailure(action: ComplaintAction.updatingStatus, complaintId: event.id, message: e.toString(), statusCode: 0));
    }
  }

  Future<void> _onRequestInfoRequested(RequestInfoRequested event, Emitter<ComplaintActionsState> emit) async {
    emit(ComplaintActionInProgress(action: ComplaintAction.requestingInfo, complaintId: event.id));
    try {
      final res = await requestInfoUseCase.execute(event.id, event.requestText);
      final sc = res['status_code'] is int ? res['status_code'] as int : int.tryParse(res['status_code']?.toString() ?? '') ?? 0;
      final msg = res['message']?.toString() ?? '';
      if (sc == 200 || sc == 201) {
        emit(ComplaintActionSuccess(action: ComplaintAction.requestedInfo, complaintId: event.id, message: msg, statusCode: sc));
      } else {
        emit(ComplaintActionFailure(action: ComplaintAction.requestingInfo, complaintId: event.id, message: msg, statusCode: sc));
      }
    } catch (e) {
      emit(ComplaintActionFailure(action: ComplaintAction.requestingInfo, complaintId: event.id, message: e.toString(), statusCode: 0));
    }
  }

  Future<void> _onUnlockRequested(UnlockComplaintRequested event, Emitter<ComplaintActionsState> emit) async {
    emit(ComplaintActionInProgress(action: ComplaintAction.unlocking, complaintId: event.id));
    try {
      final res = await unlockUseCase.execute(event.id);
      final sc = res['status_code'] is int ? res['status_code'] as int : int.tryParse(res['status_code']?.toString() ?? '') ?? 0;
      final msg = res['message']?.toString() ?? '';
      if (sc == 200) {
        emit(ComplaintActionSuccess(action: ComplaintAction.unlocked, complaintId: event.id, message: msg, statusCode: sc));
      } else {
        emit(ComplaintActionFailure(action: ComplaintAction.unlocking, complaintId: event.id, message: msg, statusCode: sc));
      }
    } catch (e) {
      emit(ComplaintActionFailure(action: ComplaintAction.unlocking, complaintId: event.id, message: e.toString(), statusCode: 0));
    }
  }
}
