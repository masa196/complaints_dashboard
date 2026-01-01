part of 'roles_bloc.dart';

abstract class RolesEvent extends Equatable {
  const RolesEvent();

  @override
  List<Object?> get props => [];
}

class FetchRolesEvent extends RolesEvent {}

class SyncUserRolesEvent extends RolesEvent {
  final int userId;
  final List<String> oldRoles;
  final List<String> newRoles;

  const SyncUserRolesEvent({
    required this.userId,
    required this.oldRoles,
    required this.newRoles,
  });

  @override
  List<Object?> get props => [userId, oldRoles, newRoles];
}

class CreateRoleEvent extends RolesEvent {
  final CreateRoleEntity entity;

  const CreateRoleEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}

class DeleteRoleEvent extends RolesEvent {
  final int roleId;

  const DeleteRoleEvent(this.roleId);

  @override
  List<Object?> get props => [roleId];
}
