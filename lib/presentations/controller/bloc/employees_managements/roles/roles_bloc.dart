import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../data/models/roles/roles_model.dart';
import '../../../../../domain/entities/roles/create_role_entity.dart';
import '../../../../../domain/use_cases/roles/create_role_usecase.dart';
import '../../../../../domain/use_cases/roles/delete_role_usecase.dart';
import '../../../../../domain/use_cases/roles/get_roles_usecase.dart';
import '../../../../../data/models/roles/role_model.dart';




part 'roles_event.dart';
part 'roles_state.dart';

class RolesBloc extends Bloc<RolesEvent, RolesState> {
  final GetRolesUseCase getRolesUseCase;
  final CreateRoleUseCase createRoleUseCase;
  final DeleteRoleUseCase deleteRoleUseCase;

  RolesBloc(
      this.getRolesUseCase,
      this.createRoleUseCase,
      this.deleteRoleUseCase,
      ) : super(RolesInitial()) {
    on<FetchRolesEvent>(_onFetchRoles);
    on<CreateRoleEvent>(_onCreateRole);
    on<DeleteRoleEvent>(_onDeleteRole);
  }

  Future<void> _onFetchRoles(FetchRolesEvent event, Emitter<RolesState> emit,) async {
    emit(RolesLoading());
    final result = await getRolesUseCase();
    result.fold(
          (failure) => emit(RolesFailed(failure.message)),
          (roles) => emit(RolesLoaded(roles)),
    );
  }

  Future<void> _onCreateRole(CreateRoleEvent event, Emitter<RolesState> emit,) async {
    final result = await createRoleUseCase(event.entity);

    result.fold(
          (failure) => emit(RolesFailed(failure.message)),
          (_) {
        emit(const RoleCreateSuccess('Role created successfully'));
        add(FetchRolesEvent());
      },
    );
  }


  Future<void> _onDeleteRole(DeleteRoleEvent event, Emitter<RolesState> emit,) async {
    emit(RolesLoading());

    final result = await deleteRoleUseCase(event.roleId);

    result.fold(
          (failure) => emit(RolesFailed(failure.message)),
          (_) {
        emit(const RoleDeleteSuccess('Role deleted successfully'));
        add(FetchRolesEvent());
      },
    );
  }




}
