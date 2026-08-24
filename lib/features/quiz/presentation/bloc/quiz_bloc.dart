import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/quiz_question_entity.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

/// Runs a 5-question quiz: select option -> submit -> next -> ... -> finished.
/// TODO: replace mock questions with GetQuizUseCase tied to the lesson.
class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(const QuizState()) {
    on<QuizStarted>(_onStarted);
    on<QuizOptionSelected>(_onOptionSelected);
    on<QuizAnswerSubmitted>(_onAnswerSubmitted);
    on<QuizNextQuestion>(_onNextQuestion);
  }

  Future<void> _onStarted(QuizStarted event, Emitter<QuizState> emit) async {
    emit(state.copyWith(status: QuizStatus.loading));
    await Future.delayed(const Duration(milliseconds: 300));

    emit(
      state.copyWith(
        status: QuizStatus.inProgress,
        questions: const [
          QuizQuestionEntity(
            id: 'q1',
            question: 'What is a "need"?',
            options: [
              QuizOption(id: 'a', text: 'Something essential to live'),
              QuizOption(id: 'b', text: 'The newest phone model'),
              QuizOption(id: 'c', text: 'Extra snacks'),
              QuizOption(id: 'd', text: 'Branded sneakers'),
            ],
            correctOptionId: 'a',
            explanation:
                'Needs are things essential for living, like food and shelter.',
          ),
          QuizQuestionEntity(
            id: 'q2',
            question: 'In the 50/30/20 rule, what does the 20% go to?',
            options: [
              QuizOption(id: 'a', text: 'Wants'),
              QuizOption(id: 'b', text: 'Needs'),
              QuizOption(id: 'c', text: 'Savings'),
              QuizOption(id: 'd', text: 'Gifts'),
            ],
            correctOptionId: 'c',
            explanation: '20% of your budget goes toward savings in this rule.',
          ),
          QuizQuestionEntity(
            id: 'q3',
            question:
                'If you earn ₹500 allowance, how much should ideally go to savings (20% rule)?',
            options: [
              QuizOption(id: 'a', text: '₹50'),
              QuizOption(id: 'b', text: '₹100'),
              QuizOption(id: 'c', text: '₹150'),
              QuizOption(id: 'd', text: '₹250'),
            ],
            correctOptionId: 'b',
            explanation: '20% of ₹500 is ₹100.',
          ),
          QuizQuestionEntity(
            id: 'q4',
            question: 'Why is saving early beneficial?',
            options: [
              QuizOption(id: 'a', text: 'It gives money more time to grow'),
              QuizOption(id: 'b', text: 'It has no real benefit'),
              QuizOption(id: 'c', text: 'It only matters for adults'),
              QuizOption(id: 'd', text: 'It reduces your allowance'),
            ],
            correctOptionId: 'a',
            explanation: 'Starting early gives your savings more time to grow.',
          ),
          QuizQuestionEntity(
            id: 'q5',
            question: 'What makes a financial goal effective?',
            options: [
              QuizOption(id: 'a', text: 'Just thinking about it'),
              QuizOption(id: 'b', text: 'A name, amount, and target date'),
              QuizOption(id: 'c', text: 'Keeping it a secret'),
              QuizOption(id: 'd', text: 'Never reviewing it'),
            ],
            correctOptionId: 'b',
            explanation:
                'A clear goal needs a name, target amount, and a date.',
          ),
        ],
      ),
    );
  }

  void _onOptionSelected(QuizOptionSelected event, Emitter<QuizState> emit) {
    if (state.answerSubmitted) return; // lock after submit
    emit(state.copyWith(selectedOptionId: event.optionId));
  }

  void _onAnswerSubmitted(QuizAnswerSubmitted event, Emitter<QuizState> emit) {
    if (state.selectedOptionId == null || state.answerSubmitted) return;

    final bool correct = state.isCorrect;
    emit(
      state.copyWith(
        answerSubmitted: true,
        correctCount: correct ? state.correctCount + 1 : state.correctCount,
      ),
    );
  }

  void _onNextQuestion(QuizNextQuestion event, Emitter<QuizState> emit) {
    if (state.isLastQuestion) {
      emit(state.copyWith(status: QuizStatus.finished));
    } else {
      emit(
        state.copyWith(
          currentIndex: state.currentIndex + 1,
          answerSubmitted: false,
          clearSelection: true,
        ),
      );
    }
  }
}
