// role_details_event.dart

part of 'role_details_bloc.dart';

abstract class RoleDetailsEvent extends Equatable {
  const RoleDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchRoleDetailsEvent extends RoleDetailsEvent {
  final int roleId;

  const FetchRoleDetailsEvent(this.roleId);

  @override
  List<Object?> get props => [roleId];
}


class UpdateRolePermissionsEvent extends RoleDetailsEvent {
  final int roleId;
  final List<String> permissions;

  const UpdateRolePermissionsEvent({
    required this.roleId,
    required this.permissions,
  });

  @override
  List<Object?> get props => [roleId, permissions];
}

class ClearRoleDetailsEvent extends RoleDetailsEvent {}