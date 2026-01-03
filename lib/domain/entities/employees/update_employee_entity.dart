import 'package:equatable/equatable.dart';

class UpdateEmployeeEntity extends Equatable {
  final int id;
  final String? name;
  final String? email;


  const UpdateEmployeeEntity({
    required this.id,
    this.name,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name!.trim(),
      if (email != null) 'email': email!.trim(),
    };
  }

  @override
  List<Object?> get props => [id, name, email];
}
