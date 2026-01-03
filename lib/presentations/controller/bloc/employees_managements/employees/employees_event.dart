part of 'employees_bloc.dart';

sealed class IEmployeesEvent extends Equatable {
  const IEmployeesEvent();

  @override
  List<Object?> get props => [];
}

final class FetchEmployees extends IEmployeesEvent {
  final int page;

  const FetchEmployees(this.page);

  @override
  List<Object?> get props => [page];
}

final class NextPage extends IEmployeesEvent {}

final class PreviousPage extends IEmployeesEvent {}

final class DeleteEmployee extends IEmployeesEvent {
  final int employeeId;

  const DeleteEmployee(this.employeeId);

  @override
  List<Object?> get props => [employeeId];
}

final class UpdateEmployeeEvent extends IEmployeesEvent {
  final UpdateEmployeeEntity entity;

  const UpdateEmployeeEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}



final class RefreshEmployees extends IEmployeesEvent {}
