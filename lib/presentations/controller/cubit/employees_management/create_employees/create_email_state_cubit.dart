import 'package:equatable/equatable.dart';

class CreateEmailStateCubit extends Equatable {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final int? governmentAgencyId; // ← مهم: صار int? بدل 0
  final bool showErrors;
  final Map<String, String> fieldErrors;
  final bool submitting;
  final bool obscurePassword;
  final bool obscureConfirmation;

  const CreateEmailStateCubit({
    this.name = '',
    this.email = '',
    this.password = '',
    this.passwordConfirmation = '',
    this.governmentAgencyId,
    this.showErrors = false,
    this.fieldErrors = const {},
    this.submitting = false,
    this.obscurePassword = true,
    this.obscureConfirmation = true,
  });

  CreateEmailStateCubit copyWith({
    String? name,
    String? email,
    String? password,
    String? passwordConfirmation,
    int? governmentAgencyId,
    bool? showErrors,
    Map<String, String>? fieldErrors,
    bool? submitting,
    bool? obscurePassword,
    bool? obscureConfirmation,
  }) {
    return CreateEmailStateCubit(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      governmentAgencyId: governmentAgencyId ?? this.governmentAgencyId,
      showErrors: showErrors ?? this.showErrors,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      submitting: submitting ?? this.submitting,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmation: obscureConfirmation ?? this.obscureConfirmation,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    passwordConfirmation,
    governmentAgencyId,
    showErrors,
    fieldErrors,
    submitting,
    obscurePassword,
    obscureConfirmation,
  ];
}
