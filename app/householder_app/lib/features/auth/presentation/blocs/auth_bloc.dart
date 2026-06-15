import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required LoginUseCase loginUseCase})
    : _loginUseCase = loginUseCase,
      super(const AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  final LoginUseCase _loginUseCase;

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
}
