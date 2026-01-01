part of 'roles_bloc.dart';

abstract class RolesState extends Equatable {
  const RolesState();

  @override
  List<Object?> get props => [];
}

class RolesInitial extends RolesState {}

class RolesLoading extends RolesState {}

class RolesUpdating extends RolesState {}

class RolesLoaded extends RolesState {
  final List<Role> roles;

  const RolesLoaded(this.roles);

  @override
  List<Object?> get props => [roles];
}

class RolesFailed extends RolesState {
  final String message;

  const RolesFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class RoleCreateSuccess extends RolesState {
  final String message;

  const RoleCreateSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class RoleDeleteSuccess extends RolesState {
  final String message;

  const RoleDeleteSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
