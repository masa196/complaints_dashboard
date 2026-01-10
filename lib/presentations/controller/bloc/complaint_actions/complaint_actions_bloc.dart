
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

    final result = await lockUseCase.execute(event.id);

    result.fold(
          (failure) => emit(ComplaintActionFailure(
          action: ComplaintAction.locking,
          complaintId: event.id,
          message: failure.message,
          statusCode: 0
      )),
          (res) => emit(ComplaintActionSuccess(
          action: ComplaintAction.locked,
          complaintId: event.id,
          message: res['message']?.toString() ?? 'تم القفل بنجاح',
          statusCode: 200
      )),
    );
  }

  Future<void> _onUpdateStatusRequested(UpdateStatusRequested event, Emitter<ComplaintActionsState> emit) async {
    emit(ComplaintActionInProgress(action: ComplaintAction.updatingStatus, complaintId: event.id));

    final result = await updateStatusUseCase.execute(event.id, event.status);

    result.fold(
          (failure) => emit(ComplaintActionFailure(
          action: ComplaintAction.updatingStatus,
          complaintId: event.id,
          message: failure.message,
          statusCode: 0
      )),
          (res) => emit(ComplaintActionSuccess(
          action: ComplaintAction.updatedStatus,
          complaintId: event.id,
          message: res['message']?.toString() ?? 'تم تحديث الحالة',
          statusCode: 200
      )),
    );
  }

  Future<void> _onRequestInfoRequested(RequestInfoRequested event, Emitter<ComplaintActionsState> emit) async {
    emit(ComplaintActionInProgress(action: ComplaintAction.requestingInfo, complaintId: event.id));

    final result = await requestInfoUseCase.execute(event.id, event.requestText);

    result.fold(
          (failure) => emit(ComplaintActionFailure(
          action: ComplaintAction.requestingInfo,
          complaintId: event.id,
          message: failure.message,
          statusCode: 0
      )),
          (res) => emit(ComplaintActionSuccess(
          action: ComplaintAction.requestedInfo,
          complaintId: event.id,
          message: res['message']?.toString() ?? 'تم طلب المعلومات',
          statusCode: 200
      )),
    );
  }

  Future<void> _onUnlockRequested(UnlockComplaintRequested event, Emitter<ComplaintActionsState> emit) async {
    emit(ComplaintActionInProgress(action: ComplaintAction.unlocking, complaintId: event.id));

    final result = await unlockUseCase.execute(event.id);

    result.fold(
          (failure) => emit(ComplaintActionFailure(
          action: ComplaintAction.unlocking,
          complaintId: event.id,
          message: failure.message,
          statusCode: 0
      )),
          (res) => emit(ComplaintActionSuccess(
          action: ComplaintAction.unlocked,
          complaintId: event.id,
          message: res['message']?.toString() ?? 'تم إلغاء القفل',
          statusCode: 200
      )),
    );
  }
}