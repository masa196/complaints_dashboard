// lib/auth_admin/presentations/controllers/block/create_email_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/utils/shared_prefs_storage.dart';
import '../../../../../domain/entities/auth/login_response.dart';
import '../../../../../domain/use_cases/employees_managements/create_email_usecase.dart';
import 'create_email_event.dart';
import 'create_email_state.dart';

class CreateEmailBloc extends Bloc<CreateEmailEvent, CreateEmailState> {
  final CreateEmailUseCase createEmailUseCase;

  CreateEmailBloc({required this.createEmailUseCase}) : super(CreateEmailInitial()) {
    on<CreateEmailRequested>(_onCreateEmailRequested);
  }

  Future<void> _onCreateEmailRequested(CreateEmailRequested event, Emitter<CreateEmailState> emit) async {
    emit(CreateEmailLoading());
    final Either<Failure, LoginResponse> result = await createEmailUseCase.execute(
      event.name,
      event.email,
      event.password,
      event.passwordConfirmation,
      event.governmentAgencyId,
    );

    await result.fold(
          (failure) async {
        emit(CreateEmailFailure(message: failure.message));
      },
          (loginResponse) async {
        await SharedPrefsStorage.saveToken(loginResponse.token);
        await SharedPrefsStorage.saveAdminName(loginResponse.admin.name);
        await SharedPrefsStorage.saveAdminEmail(loginResponse.admin.email);
        emit(Created(loginResponse.admin, loginResponse.token));
      },
    );
  }
}
