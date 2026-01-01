import 'package:equatable/equatable.dart';
import 'admin.dart';

class LoginResponse extends Equatable {
  final Admin admin;
  final String token;

  const LoginResponse({
    required this.admin,
    required this.token,
  });

  @override
  List<Object?> get props => [admin, token];
}
