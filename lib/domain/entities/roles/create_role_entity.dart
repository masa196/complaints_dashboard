class CreateRoleEntity {
  final String name;
  final List<String> permissions;

  CreateRoleEntity({
    required this.name,
    required this.permissions,
  });

  CreateRoleEntity copyWith({
    String? name,
    List<String>? permissions,
  }) {
    return CreateRoleEntity(
      name: name ?? this.name,
      permissions: permissions ?? this.permissions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'permissions': permissions,
    };
  }
}
