import 'package:equatable/equatable.dart';
import '../../../domain/entities/auth/admin.dart';

class AdminModel extends Admin with EquatableMixin {
  const AdminModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json["id"] is int
          ? json["id"] as int
          : int.parse(json["id"].toString()),

      name: json["name"] as String,
      email: json["email"] as String,


      role: json["role"] == null
          ? null
          : (json["role"] is int
          ? json["role"] as int
          : int.tryParse(json["role"].toString())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "roles": role,
    };
  }

  @override
  List<Object?> get props => [id, name, email, role];
}
