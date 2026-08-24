import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

/// Handles the splash delay + decides where the app should go next.
/// Later this can call a UseCase (e.g. CheckAuthStatusUseCase) instead
/// of just waiting on a timer.
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashLoading()) {
    on<SplashStarted>(_onSplashStarted);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    // Simulate checking auth/local storage + minimum splash display time.
    await Future.delayed(const Duration(seconds: 2));

    // TODO: replace with real check — e.g. localStorageService.hasSeenOnboarding()
    const bool isFirstLaunch = true;

    emit(const SplashCompleted(isFirstLaunch: isFirstLaunch));
  }
}
