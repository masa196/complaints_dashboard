
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/shared_prefs_storage.dart';
import '../../../../core/utils/token_service.dart';
import '../../../../domain/entities/auth/admin.dart';
import '../../../../domain/entities/auth/login_response.dart';
import '../../../../domain/use_cases/auth/login_usecase.dart';
import '../../../../domain/use_cases/auth/logout_usecase.dart';


part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  Timer? _cooldownTimer;
  int _currentSeconds = 0;
  String _cooldownMessage = '';

  AuthBloc({required this.loginUseCase, required this.logoutUseCase}) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<StartCooldown>(_onStartCooldown);
    on<DecrementCooldown>(_onDecrementCooldown);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final token = await TokenService().loadToken();
    if (token != null) {
      final name = await SharedPrefsStorage.getAdminName() ?? '';
      final email = await SharedPrefsStorage.getAdminEmail() ?? '';
      emit(AuthAuthenticatedFromLocal(name: name, email: email, token: token));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    // 🛑 حماية: منع الطلب إذا كان هناك Cooldown أو تحميل حالي
    if (state is AuthLoading || state is AuthCooldown) return;

    emit(AuthLoading());
    final result = await loginUseCase.execute(event.email, event.password);

    await result.fold(
          (failure) async {
        if (failure is ServerFailure && failure.retryAfterSeconds != null) {
          add(StartCooldown(seconds: failure.retryAfterSeconds!, message: failure.message));
        } else {
          emit(AuthFailure(message: failure.message));
        }
      },
          (loginResponse) async {
        await TokenService().saveToken(loginResponse.token);
        await SharedPrefsStorage.saveAdminName(loginResponse.admin.name);
        await SharedPrefsStorage.saveAdminEmail(loginResponse.admin.email);
        emit(AuthAuthenticated(admin: loginResponse.admin, token: loginResponse.token));
      },
    );
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final token = TokenService().token;
    if (token == null) {
      await SharedPrefsStorage.clearAll();
      emit(AuthUnauthenticated());
      return;
    }

    final Either<Failure, bool> resEither = await logoutUseCase.execute();

    await resEither.fold(
          (failure) async {
        if (!event.keepLoggedIn) {
          await TokenService().clearToken();
          await SharedPrefsStorage.clearAll();
        }
        emit(AuthFailure(message: failure.message));
      },
          (success) async {
        if (!event.keepLoggedIn) {
          await TokenService().clearToken();
          await SharedPrefsStorage.clearAll();
        }
        emit(AuthUnauthenticated());
      },
    );
  }

  Future<void> _onStartCooldown(StartCooldown event, Emitter<AuthState> emit) async {
    _cooldownTimer?.cancel();
    _currentSeconds = event.seconds;
    _cooldownMessage = event.message;

    emit(AuthCooldown(secondsRemaining: _currentSeconds, message: _cooldownMessage));

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isClosed) {
        add(DecrementCooldown());
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _onDecrementCooldown(DecrementCooldown event, Emitter<AuthState> emit) async {
    if (_currentSeconds > 1) {
      _currentSeconds--;
      emit(AuthCooldown(secondsRemaining: _currentSeconds, message: _cooldownMessage));
    } else {
      _cooldownTimer?.cancel();
      _cooldownTimer = null;
      _currentSeconds = 0;
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _cooldownTimer?.cancel();
    return super.close();
  }
}
