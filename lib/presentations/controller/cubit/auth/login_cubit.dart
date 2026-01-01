import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import 'login_state.dart';



class LoginCubit extends Cubit<LoginState> {
  final AuthBloc authBloc;

  LoginCubit({required this.authBloc}) : super(const LoginState());

  void setEmail(String value) {
    final newFieldErrors = Map<String, String>.from(state.fieldErrors);
    newFieldErrors.remove('email');
    emit(state.copyWith(email: value, fieldErrors: newFieldErrors, showErrors: false));
  }

  void setPassword(String value) {
    final newFieldErrors = Map<String, String>.from(state.fieldErrors);
    newFieldErrors.remove('password');
    emit(state.copyWith(password: value, fieldErrors: newFieldErrors, showErrors: false));
  }


  void submit() {
    final email = state.email.trim();
    final password = state.password;

    final Map<String, String> errors = {};

    if (email.isEmpty) {
      errors['email'] = 'الرجاء إدخال البريد الإلكتروني';
    } else if (!email.contains('@') || !email.endsWith('.com' )) {
      errors['email'] = 'البريد غير صالح — مثال: example@gmail.com';
    }

    if (password.isEmpty) {
      errors['password'] = 'الرجاء إدخال كلمة السر';
    }

    if (errors.isNotEmpty) {
      emit(state.copyWith(fieldErrors: errors, showErrors: true));
      return;
    }


    emit(state.copyWith(submitting: true, showErrors: false, fieldErrors: {}));
    authBloc.add(LoginRequested(email, password));
  }
  bool keepMeLoggedIn = false;

  void setKeepMeLoggedIn(bool value) {
    emit(state.copyWith(keepMeLoggedIn: value));
  }



  void clearErrors() {
    emit(state.copyWith(fieldErrors: {}, showErrors: false));
  }
}
