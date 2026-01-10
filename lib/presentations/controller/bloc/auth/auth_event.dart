
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class LogoutRequested extends AuthEvent {
  final bool keepLoggedIn;
  LogoutRequested({this.keepLoggedIn = false});
}

class StartCooldown extends AuthEvent {
  final int seconds;
  final String message;

  StartCooldown({required this.seconds, required this.message});

  @override
  List<Object?> get props => [seconds, message];
}

class DecrementCooldown extends AuthEvent {}
