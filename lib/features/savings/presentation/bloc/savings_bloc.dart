import 'package:coinquest_v1_app/features/budget/domain/entities/savings_goal_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'savings_event.dart';
import 'savings_state.dart';

/// Loads savings goals + lets the user add contributions.
/// TODO: replace mock data with GetSavingsGoalsUseCase / AddSavingsUseCase.
class SavingsBloc extends Bloc<SavingsEvent, SavingsState> {
  SavingsBloc() : super(const SavingsState()) {
    on<SavingsStarted>(_onStarted);
    on<SavingsContributed>(_onContributed);
  }

  Future<void> _onStarted(
    SavingsStarted event,
    Emitter<SavingsState> emit,
  ) async {
    emit(state.copyWith(status: SavingsStatus.loading));
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now();
    emit(
      state.copyWith(
        status: SavingsStatus.loaded,
        goals: [
          SavingsGoalEntity(
            id: 'g1',
            title: 'New Laptop',
            icon: Icons.laptop_mac_rounded,
            targetAmount: 8000,
            currentAmount: 3350,
            targetDate: DateTime(2026, 12, 1),
            history: [
              SavingsContribution(amount: 200, date: now),
              SavingsContribution(
                amount: 150,
                date: now.subtract(const Duration(days: 3)),
              ),
              SavingsContribution(
                amount: 100,
                date: now.subtract(const Duration(days: 7)),
              ),
            ],
          ),
          SavingsGoalEntity(
            id: 'g2',
            title: 'New Headphones',
            icon: Icons.headphones_rounded,
            targetAmount: 3000,
            currentAmount: 2100,
            targetDate: DateTime(2026, 10, 15),
            history: [
              SavingsContribution(
                amount: 300,
                date: now.subtract(const Duration(days: 2)),
              ),
            ],
          ),
          SavingsGoalEntity(
            id: 'g3',
            title: 'Concert Tickets',
            icon: Icons.confirmation_number_rounded,
            targetAmount: 5000,
            currentAmount: 1000,
            targetDate: DateTime(2027, 1, 20),
            history: const [],
          ),
        ],
      ),
    );
  }

  Future<void> _onContributed(
    SavingsContributed event,
    Emitter<SavingsState> emit,
  ) async {
    final updatedGoals = state.goals.map((g) {
      if (g.id == event.goalId) {
        return g.copyWith(
          currentAmount: g.currentAmount + event.amount,
          history: [
            SavingsContribution(amount: event.amount, date: DateTime.now()),
            ...g.history,
          ],
        );
      }
      return g;
    }).toList();

    emit(state.copyWith(goals: updatedGoals));
  }
}
