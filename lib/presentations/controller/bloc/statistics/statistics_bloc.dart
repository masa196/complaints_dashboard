import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/models/statistics/statistics_model.dart';
import '../../../../domain/use_cases/Statistic/get_statistic_usecase.dart';


part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final GetStatisticUseCase getStatisticUseCase;

  StatisticsBloc(this.getStatisticUseCase) : super(StatisticsInitial()) {
    on<FetchStatisticsEvent>(_onFetchStatistics);
  }

  Future<void> _onFetchStatistics(
      FetchStatisticsEvent event,
      Emitter<StatisticsState> emit,
      ) async {
    emit(StatisticsLoading());
    final result = await getStatisticUseCase();

    result.fold(
          (failure) => emit(StatisticsError(failure.message)),
          (stats) => emit(StatisticsLoaded(stats)),
    );
  }
}