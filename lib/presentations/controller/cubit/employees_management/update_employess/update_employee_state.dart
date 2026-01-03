part of 'update_employee_cubit.dart';

class UpdateEmployeeState extends Equatable {
  final UpdateEmployeeEntity? employeeEntity;
  final String? nameError;
  final String? emailError;
  const UpdateEmployeeState({required this.employeeEntity, this.nameError, this.emailError});

  UpdateEmployeeState copyWith({UpdateEmployeeEntity? employeeEntity, String? nameError, String? emailError}) {
    return UpdateEmployeeState(
      employeeEntity: employeeEntity ?? this.employeeEntity,
      nameError: nameError,
      emailError: emailError,
    );
  }

  @override
  List<Object?> get props => [employeeEntity, nameError, emailError];
}
