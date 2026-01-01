
import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/auth/admin.dart';


abstract class CreateEmailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateEmailInitial extends CreateEmailState {}

class CreateEmailLoading extends CreateEmailState {}

class Created extends CreateEmailState {
  final Admin admin;
  final String token;


  Created(this.admin, this.token);

  @override
  List<Object?> get props => [admin, token];
}


class CreateEmailFailure extends CreateEmailState {
  final String message;
  CreateEmailFailure({required this.message});

  @override
  List<Object?> get props => [message];
}



