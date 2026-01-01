import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/use_cases/complaints/get_complaints_usecase.dart';
import 'complaints_state.dart';

class ComplaintsCubit extends Cubit<ComplaintsState> {
  final GetComplaintsUseCase useCase;

  ComplaintsCubit({required this.useCase})
      : super(ComplaintsState(status: ComplaintsStatus.initial));

  Future<void> loadComplaints({int page = 1}) async {
    try {
      emit(state.copyWith(status: ComplaintsStatus.loading));

      final result = await useCase.execute(page: page);

      emit(state.copyWith(
        status: ComplaintsStatus.success,
        complaints: result.data,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ComplaintsStatus.failure,
        message: e.toString(),
      ));
    }
  }

  void nextPage() {
    if (state.currentPage < state.lastPage) {
      loadComplaints(page: state.currentPage + 1);
    }
  }

  void prevPage() {
    if (state.currentPage > 1) {
      loadComplaints(page: state.currentPage - 1);
    }
  }

  void filterComplaints(String filter) {
    emit(state.copyWith(filterStatus: filter));
    // يمكن تحميل الصفحة الأولى عند تغيير الفلتر
    loadComplaints(page: 1);
  }
}
