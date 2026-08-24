import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

/// Initial state — still showing the logo / loading.
class SplashLoading extends SplashState {
  const SplashLoading();
}

/// Emitted once the splash delay is done and we know where to navigate.
/// [isFirstLaunch] decides Onboarding vs Welcome/Home in a real app.
class SplashCompleted extends SplashState {
  final bool isFirstLaunch;

  const SplashCompleted({this.isFirstLaunch = true});

  @override
  List<Object?> get props => [isFirstLaunch];
}