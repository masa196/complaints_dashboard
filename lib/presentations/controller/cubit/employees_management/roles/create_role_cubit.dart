import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../domain/entities/roles/create_role_entity.dart';



part 'create_role_state.dart';

class CreateRoleCubit extends Cubit<CreateRoleState> {
  final List<String> allPermissions;

  CreateRoleCubit(this.allPermissions) : super(CreateRoleState.initial(allPermissions));

  void updateName(String value) {
    emit(state.copyWith(
      entity: state.entity.copyWith(name: value),
    ));
  }

  void togglePermission(String permission) {
    final permissions = List<String>.from(state.entity.permissions);

    if (permissions.contains(permission)) {
      permissions.remove(permission);
    } else {
      permissions.add(permission);
    }

    emit(state.copyWith(
      entity: state.entity.copyWith(permissions: permissions),
    ));
  }

  void reset() {
    emit(CreateRoleState.initial(allPermissions));
  }
}
