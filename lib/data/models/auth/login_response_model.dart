// lib/auth_admin/data/models/login_response_model.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/auth/login_response.dart';
import 'admin_model.dart';

class LoginResponseModel extends LoginResponse with EquatableMixin {
  const LoginResponseModel({required super.admin, required super.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['admin'] == null) {
      throw Exception("LoginResponseModel: admin field is null");
    }
    if (json['token'] == null) {
      throw Exception("LoginResponseModel: token field is null");
    }

    final adminJson = Map<String, dynamic>.from(json['admin'] as Map);
    final tokenVal = json['token'].toString();

    return LoginResponseModel(
      admin: AdminModel.fromJson(adminJson),
      token: tokenVal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "admin": (admin as AdminModel).toJson(),
      "token": token,
    };
  }

  @override
  List<Object?> get props => [admin, token];
}
