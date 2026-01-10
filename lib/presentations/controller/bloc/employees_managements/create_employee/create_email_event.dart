import 'package:equatable/equatable.dart';

abstract class CreateEmailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends CreateEmailEvent {}


class ResetCreateEmailEvent extends CreateEmailEvent {}

class CreateEmailRequested extends CreateEmailEvent {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final int governmentAgencyId;

  CreateEmailRequested(this.name, this.email, this.password,
      this.passwordConfirmation, this.governmentAgencyId);

  @override
  List<Object?> get props => [name, email, password, passwordConfirmation, governmentAgencyId];
}