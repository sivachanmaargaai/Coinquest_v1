import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the Splash screen first loads — starts the timer / checks
/// login state (in a real app this would check a token via a UseCase).
class SplashStarted extends SplashEvent {
  const SplashStarted();
}
