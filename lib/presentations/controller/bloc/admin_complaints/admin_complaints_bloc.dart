import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/models/complaint_for_admin/complaints_for_admin_model.dart';
import '../../../../domain/use_cases/complaints_for_admin/get_admin_complaints_usecase.dart';

part 'admin_complaints_event.dart';
part 'admin_complaints_state.dart';

class AdminComplaintsBloc extends Bloc<AdminComplaintsEvent, AdminComplaintsState> {
  final GetAdminComplaintsUseCase useCase;

  AdminComplaintsBloc(this.useCase) : super(AdminComplaintsInitial()) {
    on<FetchAdminComplaintsEvent>((event, emit) async {
      emit(AdminComplaintsLoading());
      final result = await useCase.execute(status: event.status);

      result.fold(
            (failure) => emit(AdminComplaintsError(failure.message)),
            (data) => emit(AdminComplaintsLoaded(data)),
      );
    });
  }
}
