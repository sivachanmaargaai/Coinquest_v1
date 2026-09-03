import 'package:coinquest_v1_app/features/budget/domain/entities/savings_goal_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/local_storage_service.dart';
import 'savings_event.dart';
import 'savings_state.dart';

/// Loads savings goals + lets the user add contributions.
/// Segment 1 gets playful goal names (Laptop, Headphones, Concert).
/// Segment 2 gets independence-track goals (Car, Emergency Fund).
class SavingsBloc extends Bloc<SavingsEvent, SavingsState> {
  final LocalStorageService _localStorageService;

  SavingsBloc({LocalStorageService? localStorageService})
    : _localStorageService = localStorageService ?? LocalStorageService(),
      super(const SavingsState()) {
    on<SavingsStarted>(_onStarted);
    on<SavingsContributed>(_onContributed);
  }

  Future<void> _onStarted(
    SavingsStarted event,
    Emitter<SavingsState> emit,
  ) async {
    emit(state.copyWith(status: SavingsStatus.loading));

    final savedGroup = await _localStorageService.getAgeGroup();
    final bool isSegment2 = savedGroup == 'teen1618';

    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now();

    emit(
      state.copyWith(
        status: SavingsStatus.loaded,
        isSegment2: isSegment2,
        goals: isSegment2
            ? [
                SavingsGoalEntity(
                  id: 'g1',
                  title: 'First Car Fund',
                  icon: Icons.directions_car_filled_rounded,
                  targetAmount: 8000,
                  currentAmount: 3200,
                  targetDate: DateTime(2027, 6, 1),
                  history: [
                    SavingsContribution(amount: 150, date: now),
                    SavingsContribution(
                      amount: 200,
                      date: now.subtract(const Duration(days: 5)),
                    ),
                  ],
                ),
                SavingsGoalEntity(
                  id: 'g2',
                  title: 'Emergency Fund',
                  icon: Icons.shield_rounded,
                  targetAmount: 5000,
                  currentAmount: 1800,
                  targetDate: DateTime(2027, 1, 1),
                  history: [
                    SavingsContribution(
                      amount: 300,
                      date: now.subtract(const Duration(days: 2)),
                    ),
                  ],
                ),
                SavingsGoalEntity(
                  id: 'g3',
                  title: 'College Textbooks',
                  icon: Icons.menu_book_rounded,
                  targetAmount: 3000,
                  currentAmount: 900,
                  targetDate: DateTime(2026, 12, 15),
                  history: const [],
                ),
              ]
            : [
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
