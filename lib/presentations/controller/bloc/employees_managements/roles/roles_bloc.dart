import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../data/models/roles/roles_model.dart';
import '../../../../../domain/entities/employees/assign_remove_role_entity.dart';
import '../../../../../domain/entities/roles/create_role_entity.dart';
import '../../../../../domain/use_cases/employees_managements/assign_role_usecase.dart';
import '../../../../../domain/use_cases/employees_managements/remove_role_usecase.dart';
import '../../../../../domain/use_cases/roles/create_role_usecase.dart';
import '../../../../../domain/use_cases/roles/delete_role_usecase.dart';
import '../../../../../domain/use_cases/roles/get_roles_usecase.dart';


part 'roles_event.dart';
part 'roles_state.dart';

class RolesBloc extends Bloc<RolesEvent, RolesState> {
  final GetRolesUseCase getRolesUseCase;
  final CreateRoleUseCase createRoleUseCase;
  final DeleteRoleUseCase deleteRoleUseCase;
  final AssignRoleUseCase assignRoleUseCase;
  final RemoveRoleUseCase removeRoleUseCase;

  RolesBloc(
      this.getRolesUseCase,
      this.createRoleUseCase,
      this.deleteRoleUseCase,
      this.assignRoleUseCase,
      this.removeRoleUseCase,
      ) : super(RolesInitial()) {
    on<FetchRolesEvent>(_onFetchRoles);
    on<CreateRoleEvent>(_onCreateRole);
    on<DeleteRoleEvent>(_onDeleteRole);
    on<SyncEmployeeRolesEvent>(_onSyncEmployeeRoles);
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


  Future<void> _onDeleteRole(DeleteRoleEvent event, Emitter<RolesState> emit) async {
    final currentState = state;

    // لا نرسل Loading هنا لتبقى القائمة ظاهرة
    final result = await deleteRoleUseCase(event.roleId);

    result.fold(
          (failure) {
        // نرسل الفشل ليتم التقاطه في الـ Listener
        emit(RolesFailed(failure.message));

        // نعيد الحالة فوراً إلى Loaded (إذا كانت كذلك) لضمان استقرار الواجهة
        if (currentState is RolesLoaded) {
          emit(currentState);
        }
      },
          (_) {
        emit(const RoleDeleteSuccess('Role deleted successfully'));
        add(FetchRolesEvent());
      },
    );
  }

  Future<void> _onSyncEmployeeRoles(SyncEmployeeRolesEvent event, Emitter<RolesState> emit,) async {
    emit(RolesUpdating());
    final toRemove =
    event.oldRoles.where((r) => !event.newRoles.contains(r)).toList();
    final toAdd =
    event.newRoles.where((r) => !event.oldRoles.contains(r)).toList();

    try {
      for (final role in toRemove) {
        await _safeRemove(event.employeeId, role);
      }
      for (final role in toAdd) {
        await _safeAssign(event.employeeId, role);
      }
      add(FetchRolesEvent());
    } catch (e) {
      emit(RolesFailed(e.toString()));
    }
  }

  Future<void> _safeAssign(int employeeId, String role) async {
    final result = await assignRoleUseCase(
      AssignRemoveRoleEntity(employeeId: employeeId, role: role),
    );
    result.fold(
          (failure) => throw Exception(failure.message),
          (_) => null,
    );
  }

  Future<void> _safeRemove(int employeeId, String role) async {
    final result = await removeRoleUseCase(
      AssignRemoveRoleEntity(employeeId: employeeId, role: role),
    );
    result.fold(
          (failure) => throw Exception(failure.message),
          (_) => null,
    );
  }





}
