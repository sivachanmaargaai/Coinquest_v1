import 'package:coinquest_v1_app/features/challenges/domain/entities/challenges_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'challenges_event.dart';
import 'challenges_state.dart';

/// Loads challenges + tracks Active/Completed tab.
/// TODO: replace mock data with GetChallengesUseCase.
class ChallengesBloc extends Bloc<ChallengesEvent, ChallengesState> {
  ChallengesBloc() : super(const ChallengesState()) {
    on<ChallengesStarted>(_onStarted);
    on<ChallengesTabChanged>(_onTabChanged);
  }

  Future<void> _onStarted(
    ChallengesStarted event,
    Emitter<ChallengesState> emit,
  ) async {
    emit(state.copyWith(status: ChallengesStatus.loading));
    await Future.delayed(const Duration(milliseconds: 400));

    emit(
      state.copyWith(
        status: ChallengesStatus.loaded,
        streakDays: 7,
        allChallenges: const [
          ChallengeEntity(
            id: 'c0',
            title: 'No Spend Weekend',
            description: 'Avoid non-essential spending for 2 days',
            type: ChallengeType.budget,
            progress: 0.5,
            xpReward: 100,
            isFeatured: true,
          ),
          ChallengeEntity(
            id: 'c1',
            title: 'Save ₹500 This Month',
            description: 'Add to any savings goal 3 times',
            type: ChallengeType.savings,
            progress: 0.6,
            xpReward: 80,
          ),
          ChallengeEntity(
            id: 'c2',
            title: 'Track Every Expense',
            description: 'Log an expense every day for 5 days',
            type: ChallengeType.budget,
            progress: 0.4,
            xpReward: 60,
          ),
          ChallengeEntity(
            id: 'c3',
            title: 'Quiz Master',
            description: 'Score 100% on any quiz',
            type: ChallengeType.quiz,
            progress: 0.0,
            xpReward: 50,
          ),
          ChallengeEntity(
            id: 'c4',
            title: '7-Day Streak',
            description: 'Open the app 7 days in a row',
            type: ChallengeType.streak,
            progress: 1.0,
            xpReward: 70,
            isCompleted: true,
          ),
          ChallengeEntity(
            id: 'c5',
            title: 'First Lesson Done',
            description: 'Complete your first lesson',
            type: ChallengeType.quiz,
            progress: 1.0,
            xpReward: 30,
            isCompleted: true,
          ),
        ],
      ),
    );
  }

  void _onTabChanged(
    ChallengesTabChanged event,
    Emitter<ChallengesState> emit,
  ) {
    emit(state.copyWith(showCompletedTab: event.showCompleted));
  }
}
