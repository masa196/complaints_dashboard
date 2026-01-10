
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final Admin admin;
  final String token;

  AuthAuthenticated({required this.admin, required this.token});

  @override
  List<Object?> get props => [admin, token];
}

class AuthAuthenticatedFromLocal extends AuthState {
  final String name;
  final String email;
  final String token;

  AuthAuthenticatedFromLocal({required this.name, required this.email, required this.token});

  @override
  List<Object?> get props => [name, email, token];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthCooldown extends AuthState {
  final int secondsRemaining;
  final String message;
  AuthCooldown({required this.secondsRemaining, required this.message});

  @override
  List<Object?> get props => [secondsRemaining, message];
}
