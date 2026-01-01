part of 'create_role_cubit.dart';

class CreateRoleState extends Equatable {
  final CreateRoleEntity entity;
  final List<String> allPermissions;

  const CreateRoleState({
    required this.entity,
    required this.allPermissions,
  });

  factory CreateRoleState.initial(List<String> allPermissions) {
    return CreateRoleState(
      entity: CreateRoleEntity(name: '', permissions: const []),
      allPermissions: allPermissions,
    );
  }

  bool get isValid => entity.name.trim().isNotEmpty;

  CreateRoleState copyWith({
    CreateRoleEntity? entity,
    List<String>? allPermissions,
  }) {
    return CreateRoleState(
      entity: entity ?? this.entity,
      allPermissions: allPermissions ?? this.allPermissions,
    );
  }

  @override
  List<Object?> get props => [entity, allPermissions];
}
