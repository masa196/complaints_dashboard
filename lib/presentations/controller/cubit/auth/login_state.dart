// lib/auth_admin/presentations/controllers/cubit/login_state.dart
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool showErrors;
  final Map<String, String> fieldErrors;
  final bool submitting;
  final bool keepMeLoggedIn;

  const LoginState({
    this.email = '',
    this.password = '',
    this.keepMeLoggedIn = false,
    this.showErrors = false,
    this.fieldErrors = const {},
    this.submitting = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? keepMeLoggedIn,
    bool? showErrors,
    Map<String, String>? fieldErrors,
    bool? submitting,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      keepMeLoggedIn: keepMeLoggedIn ?? this.keepMeLoggedIn,
      showErrors: showErrors ?? this.showErrors,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      submitting: submitting ?? this.submitting,
    );
  }

  @override
  List<Object?> get props => [email, password, showErrors, fieldErrors, submitting,keepMeLoggedIn];
}
