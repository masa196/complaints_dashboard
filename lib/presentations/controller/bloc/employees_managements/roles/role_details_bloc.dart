
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../data/models/roles/role_model.dart';
import '../../../../../data/models/permissions/all_permissions_model.dart';
import '../../../../../domain/use_cases/permissions/get_permissions.dart';
import '../../../../../domain/use_cases/permissions/update_role_permissions_usecase.dart';
import '../../../../../domain/use_cases/roles/get_role_details.dart';


part 'role_details_event.dart';
part 'role_details_state.dart';

class RoleDetailsBloc extends Bloc<RoleDetailsEvent, RoleDetailsState> {
  final GetRoleDetailsUseCase getRoleDetails;
  final GetPermissionsDetailsUseCase getAllPermissions;
  final UpdateRolePermissionsUseCase updateRolePermissions;

  RoleDetailsBloc(
      this.getRoleDetails,
      this.getAllPermissions,
      this.updateRolePermissions,
      ) : super(RoleDetailsInitial()) {
    on<FetchRoleDetailsEvent>(_onFetchDetails);
    on<UpdateRolePermissionsEvent>(_onUpdatePermissions);

    on<ClearRoleDetailsEvent>((event, emit) {
      emit(RoleDetailsInitial());
    });
  }

  Future<void> _onFetchDetails(
      FetchRoleDetailsEvent event,
      Emitter<RoleDetailsState> emit,
      ) async {
    emit(RoleDetailsLoading());

    final roleResult = await getRoleDetails(event.roleId);
    final permissionsResult = await getAllPermissions();

    roleResult.fold(
          (f) => emit(RoleDetailsFailed(f.message)),
          (role) {
        permissionsResult.fold(
              (f) => emit(RoleDetailsFailed(f.message)),
              (permissions) {
            emit(RoleDetailsLoaded(
              role: role,
              allPermissions: permissions.data ?? [],
            ));
          },
        );
      },
    );
  }


  Future<void> _onUpdatePermissions(UpdateRolePermissionsEvent event, Emitter<RoleDetailsState> emit,) async {
    final currentState = state;

    if (currentState is! RoleDetailsLoaded) return;

    emit(RoleDetailsLoading());

    final result = await updateRolePermissions(
      event.roleId,
      event.permissions,
    );

    result.fold(
          (f) => emit(RoleDetailsFailed(f.message)),
          (_) {
        final role = currentState.role.data!;


        final updatedPermissions = currentState.allPermissions
            .where((p) => event.permissions.contains(p.name))
            .map(
              (p) => RoleDetails(
            id: p.id,
            name: p.name,
            guardName: p.guardName,
            createdAt: p.createdAt,
            updatedAt: p.updatedAt,
            permissions: const [],
            pivot: null,
          ),
        )
            .toList();

        final updatedRole = role.copyWith(
          permissions: updatedPermissions,
        );

        emit(RoleDetailsLoaded(
          role: currentState.role.copyWith(data: updatedRole),
          allPermissions: currentState.allPermissions,
        ));
      },
    );
  }



}
