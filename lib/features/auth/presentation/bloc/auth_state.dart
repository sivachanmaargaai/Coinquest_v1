import 'package:equatable/equatable.dart';

enum AuthStatus { initial, submitting, success, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final bool isPasswordVisible;
  final bool termsAccepted;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.isPasswordVisible = false,
    this.termsAccepted = false,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    bool? isPasswordVisible,
    bool? termsAccepted,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isPasswordVisible,
    termsAccepted,
    errorMessage,
  ];
}
