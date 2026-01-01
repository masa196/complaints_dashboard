import 'package:equatable/equatable.dart';

class Admin extends Equatable {
  final int id;
  final String name;
  final String email;
  final int? role;

  const Admin({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  List<Object?> get props => [id, name, email, role];
}
