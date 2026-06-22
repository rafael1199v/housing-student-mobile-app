import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../domain/usecases/confirm_email_usecase.dart';

part 'confirm_email_event.dart';
part 'confirm_email_state.dart';

class ConfirmEmailBloc extends Bloc<ConfirmEmailEvent, ConfirmEmailState> {
  ConfirmEmailBloc({required ConfirmEmailUseCase confirmEmailUseCase})
    : _confirmEmailUseCase = confirmEmailUseCase,
      super(const ConfirmEmailInitial()) {
    on<ConfirmEmailRequested>(_onConfirmEmailRequested);
  }

  final ConfirmEmailUseCase _confirmEmailUseCase;

  Future<void> _onConfirmEmailRequested(
    ConfirmEmailRequested event,
    Emitter<ConfirmEmailState> emit,
  ) async {
    if (event.userId.isEmpty || event.token.isEmpty) {
      emit(const ConfirmEmailFailureState(code: 'invalid.token'));
      return;
    }

    emit(const ConfirmEmailLoading());
    try {
      await _confirmEmailUseCase(userId: event.userId, token: event.token);
      emit(const ConfirmEmailSuccess());
    } on Failure catch (failure) {
      emit(ConfirmEmailFailureState(code: failure.code));
    } catch (_) {
      emit(const ConfirmEmailFailureState(code: 'unknown.error'));
    }
  }
}
