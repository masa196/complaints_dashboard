// role_details_state.dart

part of 'role_details_bloc.dart';

abstract class RoleDetailsState extends Equatable {
  const RoleDetailsState();

  @override
  List<Object?> get props => [];
}

class RoleDetailsInitial extends RoleDetailsState {}

class RoleDetailsLoading extends RoleDetailsState {}

class RoleDetailsLoaded extends RoleDetailsState {
  final RoleModel role;
  final List<DatumPer> allPermissions;

  const RoleDetailsLoaded({
    required this.role,
    required this.allPermissions,
  });

  @override
  List<Object?> get props => [role, allPermissions];
}

class RoleDetailsFailed extends RoleDetailsState {
  final String message;

  const RoleDetailsFailed(this.message);

  @override
  List<Object?> get props => [message];
}


