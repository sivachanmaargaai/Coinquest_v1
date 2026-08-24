import 'package:equatable/equatable.dart';
import '../../domain/entities/quiz_question_entity.dart';

enum QuizStatus { loading, inProgress, finished }

class QuizState extends Equatable {
  final QuizStatus status;
  final List<QuizQuestionEntity> questions;
  final int currentIndex;
  final String? selectedOptionId;
  final bool answerSubmitted;
  final int correctCount;

  const QuizState({
    this.status = QuizStatus.loading,
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedOptionId,
    this.answerSubmitted = false,
    this.correctCount = 0,
  });

  QuizQuestionEntity? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  bool get isLastQuestion => currentIndex == questions.length - 1;
  bool get isCorrect =>
      selectedOptionId != null &&
      selectedOptionId == currentQuestion?.correctOptionId;

  QuizState copyWith({
    QuizStatus? status,
    List<QuizQuestionEntity>? questions,
    int? currentIndex,
    String? selectedOptionId,
    bool? answerSubmitted,
    int? correctCount,
    bool clearSelection = false,
  }) {
    return QuizState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedOptionId: clearSelection
          ? null
          : (selectedOptionId ?? this.selectedOptionId),
      answerSubmitted: answerSubmitted ?? this.answerSubmitted,
      correctCount: correctCount ?? this.correctCount,
    );
  }

  @override
  List<Object?> get props => [
    status,
    questions,
    currentIndex,
    selectedOptionId,
    answerSubmitted,
    correctCount,
  ];
}
