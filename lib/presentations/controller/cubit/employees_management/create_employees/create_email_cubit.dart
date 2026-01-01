import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/employees_managements/create_employee/create_email_bloc.dart';
import '../../../bloc/employees_managements/create_employee/create_email_event.dart';
import '../../../bloc/employees_managements/create_employee/create_email_state.dart';
import 'create_email_state_cubit.dart';

class CreateEmailCubit extends Cubit<CreateEmailStateCubit> {
  final CreateEmailBloc createEmailBloc;
  StreamSubscription? _blocSub;

  CreateEmailCubit({required this.createEmailBloc})
      : super(const CreateEmailStateCubit()) {
    _blocSub = createEmailBloc.stream.listen((blocState) {
      if (blocState is CreateEmailLoading) {
        emit(state.copyWith(submitting: true));
      } else if (blocState is Created) {
        emit(state.copyWith(submitting: false, fieldErrors: {}, showErrors: false));
      } else if (blocState is CreateEmailFailure) {
        final map = Map<String, String>.from(state.fieldErrors);
        map['general'] = blocState.message;
        emit(state.copyWith(submitting: false, showErrors: true, fieldErrors: map));
      } else {
        emit(state.copyWith(submitting: false));
      }
    });
  }

  void setName(String value) {
    final newFieldErrors = {...state.fieldErrors}..remove('name');
    emit(state.copyWith(name: value, fieldErrors: newFieldErrors));
  }

  void setEmail(String value) {
    final newFieldErrors = {...state.fieldErrors}..remove('email');
    emit(state.copyWith(email: value, fieldErrors: newFieldErrors));
  }

  void setGovernmentAgencyId(int? id) {
    print("Cubit → received id: $id");
    emit(state.copyWith(governmentAgencyId: id));
    print("Cubit → updated state.govAgencyId: ${state.governmentAgencyId}");
  }

  void setPassword(String value) {
    final newFieldErrors = {...state.fieldErrors}..remove('password');
    emit(state.copyWith(password: value, fieldErrors: newFieldErrors));
  }

  void setPasswordConfirmation(String value) {
    final newFieldErrors = {...state.fieldErrors}..remove('password_confirmation');
    emit(state.copyWith(passwordConfirmation: value, fieldErrors: newFieldErrors));
  }

  void toggleObscurePassword() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleObscureConfirmation() {
    emit(state.copyWith(obscureConfirmation: !state.obscureConfirmation));
  }

  void submit() {
    final name = state.name.trim();
    final email = state.email.trim();
    final governmentAgencyId = state.governmentAgencyId;
    final password = state.password;
    final passwordConfirmation = state.passwordConfirmation;

    print("Submit → final govAgencyId = $governmentAgencyId");

    final Map<String, String> errors = {};

    if (email.isEmpty) {
      errors['email'] = 'الرجاء إدخال البريد الإلكتروني';
    } else if (!email.contains('@') || !email.contains('.')) {
      errors['email'] = 'البريد غير صالح — مثال: example@gmail.com';
    }

    if (name.isEmpty) {
      errors['name'] = 'الرجاء إدخال اسم الموظف';
    }

    if (governmentAgencyId == null || governmentAgencyId <= 0) {
      errors['government_agency_id'] = 'الرجاء إدخال رقم الوزارة (1-5)';
    }

    if (password.isEmpty) {
      errors['password'] = 'الرجاء إدخال كلمة السر';
    } else if (password.length < 6) {
      errors['password'] = 'كلمة المرور يجب أن تكون على الأقل 6 أحرف';
    }

    if (passwordConfirmation.isEmpty || passwordConfirmation != password) {
      errors['password_confirmation'] = 'كلمة السر غير متطابقة';
    }

    if (errors.isNotEmpty) {
      emit(state.copyWith(fieldErrors: errors, showErrors: true));
      return;
    }

    emit(state.copyWith(submitting: true, fieldErrors: {}));

    createEmailBloc.add(
      CreateEmailRequested(
        name,
        email,
        password,
        passwordConfirmation,
        governmentAgencyId!,
      ),
    );
  }

  void clearAll() {
    emit(const CreateEmailStateCubit());
  }

  @override
  Future<void> close() {
    _blocSub?.cancel();
    return super.close();
  }
}
