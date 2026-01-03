import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employees_model.g.dart';

@JsonSerializable(createToJson: false)
class EmployeeModel extends Equatable {
  const EmployeeModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.roles,
  });

  final int id;
  final String name;
  final String email;
  final String? phone;
  final List<RoleModel>? roles;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);

  @override
  List<Object?> get props => [id, name, email, phone, roles];
}

@JsonSerializable(createToJson: false)
class RoleModel extends Equatable {
  const RoleModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);

  @override
  List<Object?> get props => [id, name];
}

/// ✅ Extension لتنظيف الـ UI
extension EmployeesRolesX on EmployeeModel {
  List<RoleModel> get safeRoles => roles ?? [];
}
