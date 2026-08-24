import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the PageView settles on a new page (swipe or Next button).
class OnboardingPageChanged extends OnboardingEvent {
  final int pageIndex;

  const OnboardingPageChanged(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}

/// Fired when the user taps "Skip".
class OnboardingSkipped extends OnboardingEvent {
  const OnboardingSkipped();
}

/// Fired when the user taps "Get Started" on the last slide.
class OnboardingCompleted extends OnboardingEvent {
  const OnboardingCompleted();
}
