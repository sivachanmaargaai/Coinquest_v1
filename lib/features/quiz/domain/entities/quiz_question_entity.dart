import 'package:equatable/equatable.dart';

class QuizOption extends Equatable {
  final String id;
  final String text;

  const QuizOption({required this.id, required this.text});

  @override
  List<Object?> get props => [id, text];
}

class QuizQuestionEntity extends Equatable {
  final String id;
  final String question;
  final List<QuizOption> options;
  final String correctOptionId;
  final String explanation;

  const QuizQuestionEntity({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionId,
    required this.explanation,
  });

  @override
  List<Object?> get props => [
    id,
    question,
    options,
    correctOptionId,
    explanation,
  ];
}
