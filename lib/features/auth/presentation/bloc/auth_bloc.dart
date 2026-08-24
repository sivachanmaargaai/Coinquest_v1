import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Handles Sign Up form submission + UI toggles (password visibility, terms).
/// Later _onSignUpSubmitted will call a real UseCase (SignUpUseCase) that
/// hits the auth repository -> remote datasource -> API.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
    on<PasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<TermsAcceptedToggled>(_onTermsAcceptedToggled);
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (!state.termsAccepted) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Please accept the Terms & Privacy Policy',
        ),
      );
      return;
    }

    emit(state.copyWith(status: AuthStatus.submitting));

    // TODO: replace with real SignUpUseCase call
    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(status: AuthStatus.success));
  }

  void _onPasswordVisibilityToggled(
    PasswordVisibilityToggled event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void _onTermsAcceptedToggled(
    TermsAcceptedToggled event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(termsAccepted: !state.termsAccepted));
  }
}
