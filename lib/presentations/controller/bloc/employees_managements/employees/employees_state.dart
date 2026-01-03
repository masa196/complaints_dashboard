part of 'employees_bloc.dart';

sealed class EmployeesState extends Equatable {
  const EmployeesState();

  @override
  List<Object?> get props => [];
}

final class EmployeesInitial extends EmployeesState {}

final class EmployeesLoading extends EmployeesState {}

final class EmployeesLoaded extends EmployeesState {
  final PaginatedEmployeesModel data;

  const EmployeesLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

final class EmployeesFailed extends EmployeesState {
  final String message;

  const EmployeesFailed(this.message);

  @override
  List<Object?> get props => [message];
}

final class EmployeeDeleteSuccess extends EmployeesState {
  final String message;

  const EmployeeDeleteSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class EmployeeUpdateSuccess extends EmployeesState {
  final String message;

  const EmployeeUpdateSuccess(this.message);

  @override
  List<Object?> get props => [message];
}


