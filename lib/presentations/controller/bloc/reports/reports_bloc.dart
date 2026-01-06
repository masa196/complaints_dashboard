import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/use_cases/Statistic/download_report_usecase.dart';
part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final DownloadReportUseCase downloadReportUseCase;

  ReportsBloc(this.downloadReportUseCase) : super(ReportsInitial()) {
    on<StartDownloadEvent>((event, emit) async {
      emit(ReportsLoading(event.type));
      final result = await downloadReportUseCase(event.type);
      result.fold(
            (failure) => emit(ReportsError(failure.message)),
            (_) => emit(ReportsSuccess()),
      );
    });
  }
}