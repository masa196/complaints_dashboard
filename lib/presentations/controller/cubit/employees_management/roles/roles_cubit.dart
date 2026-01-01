import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'roles_cubit_state.dart';

class RolesCubit extends Cubit<RolesCubitState> {
  RolesCubit() : super(const RolesCubitState(selectedRoles: [], isLoading: false));

  void setRoles(List<String> roles) {
    emit(state.copyWith(selectedRoles: roles));
  }

  void addRole(String role) {
    emit(state.copyWith(selectedRoles: [role], isLoading: false));
  }

  void removeRole(String role) {
    emit(state.copyWith(selectedRoles: [role], isLoading: false));
  }

  void setLoading(bool value) {
    emit(state.copyWith(isLoading: value));
  }

  void clearRoles() {
    emit(state.copyWith(selectedRoles: [], isLoading: false));
  }
}
