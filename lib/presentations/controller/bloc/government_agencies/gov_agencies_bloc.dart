import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/use_cases/employees_managements/get_government_agencies_usecase.dart';
import '../../../../data/models/employees/government_agencies_model.dart';

part 'gov_agencies_event.dart';
part 'gov_agencies_state.dart';



class GovAgenciesBloc extends Bloc<GovAgenciesEvent, GovAgenciesState> {
  final GetGovernmentAgenciesUseCase useCase;

  GovAgenciesBloc(this.useCase) : super(GovAgenciesInitial()) {
    on<FetchGovAgenciesEvent>(_onFetchAgencies);
  }

  Future<void> _onFetchAgencies(
      GovAgenciesEvent event,
      Emitter<GovAgenciesState> emit,
      ) async {
    emit(GovAgenciesLoading());

    final result = await useCase.execute();

    result.fold(
          (failure) => emit(GovAgenciesError(failure.message)),
          (model) => emit(GovAgenciesLoaded(model.data ?? [])),
    );
  }
}

