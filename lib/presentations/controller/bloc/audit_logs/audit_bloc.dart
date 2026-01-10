import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/audit_log/audit_log_model.dart';
import '../../../../domain/use_cases/audit_logs/get_audit_logs_usecase.dart';

part 'audit_event.dart';
part 'audit_state.dart';

class AuditBloc extends Bloc<AuditEvent, AuditState> {
  final GetAuditLogsUseCase getAuditLogsUseCase;

  AuditBloc(this.getAuditLogsUseCase) : super(AuditInitial()) {
    on<FetchAuditLogsEvent>((event, emit) async {
      emit(AuditLoading());
      final result = await getAuditLogsUseCase(event.page);
      result.fold(
            (failure) => emit(AuditError(failure.message)),
            (response) => emit(AuditLoaded(response)),
      );
    });
  }
}

