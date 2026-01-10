// lib/employee_dashboard/presentation/bloc/complaints/complaints_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/use_cases/complaints/get_complaints_usecase.dart';
import 'complaints_state.dart';

class ComplaintsCubit extends Cubit<ComplaintsState> {
  final GetComplaintsUseCase useCase;

  ComplaintsCubit({required this.useCase})
      : super(ComplaintsState(status: ComplaintsStatus.initial));

  Future<void> loadComplaints({int page = 1}) async {
    emit(state.copyWith(status: ComplaintsStatus.loading));

    final result = await useCase.execute(page: page);

    result.fold(
          (failure) => emit(state.copyWith(
        status: ComplaintsStatus.failure,
        message: failure.message,
        complaints: [],
      )),
          (paginationResult) => emit(state.copyWith(
        status: ComplaintsStatus.success,
        complaints: paginationResult.data,
        currentPage: paginationResult.currentPage,
        lastPage: paginationResult.lastPage,
        message: null,
      )),
    );
  }

  void nextPage() => (state.currentPage < state.lastPage) ? loadComplaints(page: state.currentPage + 1) : null;
  void prevPage() => (state.currentPage > 1) ? loadComplaints(page: state.currentPage - 1) : null;
  void filterComplaints(String filter) {
    emit(state.copyWith(filterStatus: filter));
    loadComplaints(page: 1);
  }
}