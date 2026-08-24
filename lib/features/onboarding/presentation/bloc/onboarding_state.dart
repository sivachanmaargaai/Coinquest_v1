import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  final int currentPage;
  final int totalPages;
  final bool isFinished;

  const OnboardingState({
    this.currentPage = 0,
    this.totalPages = 3,
    this.isFinished = false,
  });

  bool get isLastPage => currentPage == totalPages - 1;

  OnboardingState copyWith({
    int? currentPage,
    int? totalPages,
    bool? isFinished,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  @override
  List<Object?> get props => [currentPage, totalPages, isFinished];
}
