import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/lesson_entity.dart';
import 'learn_event.dart';
import 'learn_state.dart';

/// Loads lessons + tracks topic filter + marks lessons completed.
/// TODO: replace mock data with GetLessonsUseCase / MarkLessonCompleteUseCase.
class LearnBloc extends Bloc<LearnEvent, LearnState> {
  LearnBloc() : super(const LearnState()) {
    on<LearnStarted>(_onStarted);
    on<LearnTopicFilterChanged>(_onFilterChanged);
    on<LessonMarkedCompleted>(_onLessonCompleted);
  }

  Future<void> _onStarted(LearnStarted event, Emitter<LearnState> emit) async {
    emit(state.copyWith(status: LearnStatus.loading));
    await Future.delayed(const Duration(milliseconds: 400));

    emit(
      state.copyWith(
        status: LearnStatus.loaded,
        allLessons: const [
          LessonEntity(
            id: 'l1',
            title: 'Needs vs. Wants',
            description: 'Learn to tell the difference and spend smarter',
            topic: LessonTopic.spending,
            durationMinutes: 5,
            isCompleted: true,
            content: [
              'A "need" is something essential for living — food, shelter, basic clothing, transportation to school or work.',
              'A "want" is something nice to have but not essential — the latest phone, branded sneakers, or extra snacks.',
              'Before buying something, ask yourself: "Do I need this, or do I just want it?" This simple question can save you a lot of money over time.',
            ],
          ),
          LessonEntity(
            id: 'l2',
            title: 'Building a Simple Budget',
            description: 'The 50/30/20 rule made easy for teens',
            topic: LessonTopic.budgeting,
            durationMinutes: 6,
            content: [
              'A budget is just a plan for your money. One popular method is the 50/30/20 rule.',
              '50% of your money goes to needs, 30% to wants, and 20% to savings.',
              'You don\'t need to be exact — the goal is to build the habit of planning before you spend.',
            ],
          ),
          LessonEntity(
            id: 'l3',
            title: 'Why Save Early?',
            description: 'The power of starting small, starting now',
            topic: LessonTopic.saving,
            durationMinutes: 4,
            content: [
              'Saving even a small amount regularly adds up faster than you think.',
              'Starting early gives your money more time to grow — this is called compound growth.',
              'Set a small, achievable savings goal and build the habit before increasing the amount.',
            ],
          ),
          LessonEntity(
            id: 'l4',
            title: 'Setting Financial Goals',
            description: 'Turn "I want that" into a real plan',
            topic: LessonTopic.planning,
            durationMinutes: 5,
            content: [
              'A goal without a plan is just a wish. Give your goal a name, an amount, and a date.',
              'Break big goals into smaller milestones so progress feels achievable.',
              'Review your goal regularly and adjust your plan as your situation changes.',
            ],
          ),
        ],
      ),
    );
  }

  void _onFilterChanged(
    LearnTopicFilterChanged event,
    Emitter<LearnState> emit,
  ) {
    if (event.topic == null) {
      emit(state.copyWith(clearFilter: true));
    } else {
      emit(state.copyWith(activeFilter: event.topic));
    }
  }

  void _onLessonCompleted(
    LessonMarkedCompleted event,
    Emitter<LearnState> emit,
  ) {
    final updated = state.allLessons.map((l) {
      if (l.id == event.lessonId) return l.copyWith(isCompleted: true);
      return l;
    }).toList();

    emit(state.copyWith(allLessons: updated));
  }
}
