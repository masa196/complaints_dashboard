import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../data/models/employees/paginated_employees_model.dart';
import '../../../../../domain/entities/employees/update_employee_entity.dart';
import '../../../../../domain/use_cases/employees_managements/delete_employee_usecase.dart';
import '../../../../../domain/use_cases/employees_managements/get_employees_usecase.dart';
import '../../../../../domain/use_cases/employees_managements/update_employess_usecase.dart';

part 'employees_event.dart';
part 'employees_state.dart';

class EmployeesBloc extends Bloc<IEmployeesEvent, EmployeesState> {
  final GetEmployeesUseCase getEmployeesUseCase;
  final DeleteEmployeeUseCase deleteEmployeeUseCase;
  final UpdateEmployeeUseCase updateEmployeeUseCase;

  EmployeesBloc(
      this.getEmployeesUseCase,
      this.deleteEmployeeUseCase,
      this.updateEmployeeUseCase,
      ) : super(EmployeesInitial()) {
    on<FetchEmployees>(_onFetchEmployees);
    on<NextPage>(_onNextPage);
    on<PreviousPage>(_onPreviousPage);
    on<DeleteEmployee>(_onDeleteEmployee);
    on<UpdateEmployeeEvent>(_onUpdateEmployee);
    on<RefreshEmployees>(_onRefreshEmployees);
  }

  int currentPage = 1;

  // دالة مساعدة لجلب البيانات دون تكرار الكود
  Future<void> _fetchCurrentPage(Emitter<EmployeesState> emit) async {
    final result = await getEmployeesUseCase(currentPage);
    result.fold(
          (failure) => emit(EmployeesFailed(failure.message)),
          (data) {
        currentPage = data.currentPage;
        emit(EmployeesLoaded(data));
      },
    );
  }

  FutureOr<void> _onFetchEmployees(FetchEmployees event, Emitter<EmployeesState> emit) async {
    emit(EmployeesLoading());
    currentPage = event.page;
    final result = await getEmployeesUseCase(event.page);
    result.fold(
          (failure) => emit(EmployeesFailed(failure.message)),
          (data) => emit(EmployeesLoaded(data)),
    );
  }

  FutureOr<void> _onNextPage(NextPage event, Emitter<EmployeesState> emit) async {
    add(FetchEmployees(currentPage + 1));
  }

  FutureOr<void> _onPreviousPage(PreviousPage event, Emitter<EmployeesState> emit) async {
    if (currentPage > 1) {
      add(FetchEmployees(currentPage - 1));
    }
  }

  FutureOr<void> _onDeleteEmployee(DeleteEmployee event, Emitter<EmployeesState> emit) async {
    emit(EmployeesLoading());
    final result = await deleteEmployeeUseCase(event.employeeId);
    await result.fold(
          (failure) async => emit(EmployeesFailed(failure.message)),
          (_) async {
        emit(const EmployeeDeleteSuccess('تم حذف الموظف بنجاح'));
        // جلب البيانات فوراً لتحديث الجدول
        await _fetchCurrentPage(emit);
      },
    );
  }

  FutureOr<void> _onUpdateEmployee(UpdateEmployeeEvent event, Emitter<EmployeesState> emit) async {
    emit(EmployeesLoading());
    final result = await updateEmployeeUseCase(event.entity);
    await result.fold(
          (failure) async => emit(EmployeesFailed(failure.message)),
          (_) async {
        emit(const EmployeeUpdateSuccess('تم تعديل المستخدم بنجاح'));
        // جلب البيانات فوراً لتحديث الجدول
        await _fetchCurrentPage(emit);
      },
    );
  }

  FutureOr<void> _onRefreshEmployees(RefreshEmployees event, Emitter<EmployeesState> emit) async {
    // تنفيذ الجلب المباشر لضمان استقرار الواجهة
    await _fetchCurrentPage(emit);
  }
}