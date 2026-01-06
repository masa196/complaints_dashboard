import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

enum AdminPage { createEmployee, rolesManagement, employeesList,statistics }

class AdminNavigationState extends Equatable {
  final AdminPage currentPage;
  final DateTime timestamp;

  const AdminNavigationState(this.currentPage, this.timestamp);

  @override
  List<Object?> get props => [currentPage, timestamp];
}

class AdminNavigationCubit extends Cubit<AdminNavigationState> {
  AdminNavigationCubit()
      : super(AdminNavigationState(AdminPage.statistics, DateTime.now()));

  void goToCreateEmployee() => emit(AdminNavigationState(AdminPage.createEmployee, DateTime.now()));
  void goToRolesManagement() => emit(AdminNavigationState(AdminPage.rolesManagement, DateTime.now()));
  void goToEmployeesList() => emit(AdminNavigationState(AdminPage.employeesList, DateTime.now()));
  void goToStatistics() => emit(AdminNavigationState(AdminPage.statistics, DateTime.now()));
}