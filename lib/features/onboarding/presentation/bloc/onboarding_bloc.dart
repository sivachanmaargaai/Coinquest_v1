import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

/// Tracks which onboarding slide is active (0 = Problem, 1 = Learn, 2 = Save)
/// and whether the flow is finished, so the UI knows when to navigate away.
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState()) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingSkipped>(_onSkipped);
    on<OnboardingCompleted>(_onCompleted);
  }

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(currentPage: event.pageIndex));
  }

  void _onSkipped(OnboardingSkipped event, Emitter<OnboardingState> emit) {
    // TODO: persist "hasSeenOnboarding" flag via local_storage_service
    emit(state.copyWith(isFinished: true));
  }

  void _onCompleted(OnboardingCompleted event, Emitter<OnboardingState> emit) {
    // TODO: persist "hasSeenOnboarding" flag via local_storage_service
    emit(state.copyWith(isFinished: true));
  }
}
