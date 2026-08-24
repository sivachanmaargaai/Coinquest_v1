import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the user taps "Create Account" on the Sign Up screen.
class SignUpSubmitted extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const SignUpSubmitted({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

/// Toggles the password field's visibility (eye icon).
class PasswordVisibilityToggled extends AuthEvent {
  const PasswordVisibilityToggled();
}

/// Toggles the "I agree to Terms" checkbox.
class TermsAcceptedToggled extends AuthEvent {
  const TermsAcceptedToggled();
}
