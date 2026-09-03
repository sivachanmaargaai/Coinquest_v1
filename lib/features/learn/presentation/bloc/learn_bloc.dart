import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/entities/lesson_entity.dart';
import 'learn_event.dart';
import 'learn_state.dart';

/// Loads lessons based on the user's saved age group.
/// Segment 1 (13–15): saving/budgeting/spending/planning basics.
/// Segment 2 (16–18): investing, credit, independence-track content.
class LearnBloc extends Bloc<LearnEvent, LearnState> {
  final LocalStorageService _localStorageService;

  LearnBloc({LocalStorageService? localStorageService})
    : _localStorageService = localStorageService ?? LocalStorageService(),
      super(const LearnState()) {
    on<LearnStarted>(_onStarted);
    on<LearnTopicFilterChanged>(_onFilterChanged);
    on<LessonMarkedCompleted>(_onLessonCompleted);
  }

  Future<void> _onStarted(LearnStarted event, Emitter<LearnState> emit) async {
    emit(state.copyWith(status: LearnStatus.loading));

    final savedGroup = await _localStorageService.getAgeGroup();
    final bool isSegment2 = savedGroup == 'teen1618';

    await Future.delayed(const Duration(milliseconds: 400));

    emit(
      state.copyWith(
        status: LearnStatus.loaded,
        isSegment2: isSegment2,
        allLessons: isSegment2 ? _segment2Lessons : _segment1Lessons,
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

  static const _segment1Lessons = [
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
  ];

  static const _segment2Lessons = [
    LessonEntity(
      id: 's1',
      title: 'What is Compound Interest?',
      description: 'The concept that makes early investing powerful',
      topic: LessonTopic.saving,
      durationMinutes: 6,
      isCompleted: true,
      content: [
        'Compound interest means you earn returns not just on your original money, but on the returns it already made.',
        'The earlier you start, the more time your money has to compound — even small amounts add up significantly over years.',
        'This is why financial advisors often say "time in the market beats timing the market."',
      ],
    ),
    LessonEntity(
      id: 's2',
      title: 'Understanding Credit Scores',
      description: 'What they are and why they matter later in life',
      topic: LessonTopic.planning,
      durationMinutes: 7,
      content: [
        'A credit score is a number that represents how reliably you repay borrowed money.',
        'It affects your ability to rent an apartment, get a car loan, or qualify for a credit card with good terms.',
        'You can start building good habits now — like paying bills on time — even before you have credit of your own.',
      ],
    ),
    LessonEntity(
      id: 's3',
      title: 'Budgeting for College',
      description: 'Planning for tuition, housing, and daily expenses',
      topic: LessonTopic.budgeting,
      durationMinutes: 6,
      content: [
        'College budgets need to account for tuition, housing, food, books, and personal expenses separately.',
        'Track fixed costs (rent, tuition) versus variable costs (food, entertainment) so you know where flexibility exists.',
        'Building a simple spreadsheet or using an app early prevents surprises later in the semester.',
      ],
    ),
    LessonEntity(
      id: 's4',
      title: 'Your First Paycheck',
      description: 'What to expect and how to plan around it',
      topic: LessonTopic.planning,
      durationMinutes: 5,
      content: [
        'Your first paycheck often looks smaller than expected due to taxes and deductions.',
        'A good starting habit: automatically move a portion of every paycheck straight to savings before you spend anything.',
        'Understanding gross pay vs. net pay early prevents budgeting mistakes down the line.',
      ],
    ),
  ];
}
