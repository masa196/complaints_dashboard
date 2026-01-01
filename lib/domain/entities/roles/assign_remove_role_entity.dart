class AssignRemoveRoleEntity {
  final String role;
  final int employeeId;


  AssignRemoveRoleEntity({
    required this.role,
    required this.employeeId,
  });

  AssignRemoveRoleEntity copyWith({
    required String role,
    required int userId,
  }) {
    return AssignRemoveRoleEntity(
      role: role ,
      employeeId: employeeId ,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roles': role,
    };
  }
}
