import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/login_with_google_usecase.dart';
import '../../domain/usecases/register_with_google_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required LoginWithGoogleUseCase loginWithGoogleUseCase,
    required RegisterWithGoogleUseCase registerWithGoogleUseCase,
  }) : _loginUseCase = loginUseCase,
       _loginWithGoogleUseCase = loginWithGoogleUseCase,
       _registerWithGoogleUseCase = registerWithGoogleUseCase,
       super(const AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<GoogleAuthSubmitted>(_onGoogleAuthSubmitted);
  }

  static const _googleSignUpRole = 'Householder';

  final LoginUseCase _loginUseCase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  final RegisterWithGoogleUseCase _registerWithGoogleUseCase;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _loginUseCase(email: event.email, password: event.password);
      emit(const AuthAuthenticated());
    } on Failure catch (failure) {
      emit(
        AuthFailureState(
          code: failure.code,
          fieldErrors: failure is ValidationFailure
              ? failure.fieldErrors
              : const {},
        ),
      );
    } catch (error) {
      emit(const AuthFailureState(code: 'unknown.error'));
    }
  }

  Future<void> _onGoogleAuthSubmitted(
    GoogleAuthSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final result = await _loginWithGoogleUseCase(event.idToken);
      if (!result.isNewUser) {
        emit(const AuthAuthenticated());
        return;
      }
      await _registerWithGoogleUseCase(
        idToken: event.idToken,
        role: _googleSignUpRole,
      );
      emit(const AuthAuthenticated());
    } on Failure catch (failure) {
      emit(AuthFailureState(code: failure.code));
    } catch (error) {
      emit(const AuthFailureState(code: 'unknown.error'));
    }
  }
}
