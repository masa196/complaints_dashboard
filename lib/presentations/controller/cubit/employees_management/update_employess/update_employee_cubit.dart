import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled/domain/entities/employees/update_employee_entity.dart';
part 'update_employee_state.dart';

class UpdateEmployeeCubit extends Cubit<UpdateEmployeeState> {
  UpdateEmployeeCubit() : super(const UpdateEmployeeState(
      employeeEntity: null));

  void loadUser(UpdateEmployeeEntity employeeEntity ) => emit(state.copyWith(employeeEntity: employeeEntity));

  void nameChanged(String name) => emit(state.copyWith(employeeEntity: state.employeeEntity!.copyWith(name: name), nameError: null));

  void emailChanged(String email) => emit(state.copyWith(employeeEntity: state.employeeEntity!.copyWith(email: email), emailError: null));



  bool validate() {
    String? nameError;
    String? emailError;

    if (state.employeeEntity?.name == null || state.employeeEntity!.name!.isEmpty) nameError = 'Name is required';
    if (state.employeeEntity?.email == null || state.employeeEntity!.email!.isEmpty) emailError = 'Email is required';

    emit(state.copyWith(nameError: nameError, emailError: emailError));

    return nameError == null && emailError == null;
  }
}

extension on UpdateEmployeeEntity {
  UpdateEmployeeEntity copyWith({String? name, String? email}) {
    return UpdateEmployeeEntity(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
