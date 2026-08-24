import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class QuizStarted extends QuizEvent {
  const QuizStarted();
}

class QuizOptionSelected extends QuizEvent {
  final String optionId;
  const QuizOptionSelected(this.optionId);

  @override
  List<Object?> get props => [optionId];
}

class QuizAnswerSubmitted extends QuizEvent {
  const QuizAnswerSubmitted();
}

class QuizNextQuestion extends QuizEvent {
  const QuizNextQuestion();
}
