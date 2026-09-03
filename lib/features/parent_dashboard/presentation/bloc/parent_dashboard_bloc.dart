import 'package:coinquest_v1_app/features/parent_dashboard/domain/entities/parent_dashboard_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'parent_dashboard_event.dart';
import 'parent_dashboard_state.dart';

/// Loads the parent-facing report for the connected teen.
/// TODO: replace mock data with GetParentReportUseCase tied to the
/// parent's linked child account.
class ParentDashboardBloc
    extends Bloc<ParentDashboardEvent, ParentDashboardState> {
  ParentDashboardBloc() : super(const ParentDashboardState()) {
    on<ParentDashboardStarted>(_onStarted);
  }

  Future<void> _onStarted(
    ParentDashboardStarted event,
    Emitter<ParentDashboardState> emit,
  ) async {
    emit(state.copyWith(status: ParentDashboardStatus.loading));
    await Future.delayed(const Duration(milliseconds: 400));

    emit(
      state.copyWith(
        status: ParentDashboardStatus.loaded,
        report: const ParentReportEntity(
          childName: 'Alex',
          monthLabel: 'August 2026',
          spentThisMonth: 4200,
          budgetKeptPercent: 85,
          savingsProgressPercent: 44,
          categorySpending: {
            'Food': 1200,
            'Transport': 600,
            'Shopping': 950,
            'Entertainment': 720,
            'Education': 400,
            'Other': 330,
          },
          lessonsCompleted: 12,
          lessonsTotal: 20,
          lastActiveLabel: 'Today at 4:30 PM',
          dailySpendTrend: [80, 120, 60, 200, 140, 90, 160, 110, 70, 180],
          avgSpendPerDay: 140,
          goalProgressPercent1: 44,
          goalName1: 'New Laptop',
          goalProgressPercent2: 70,
          goalName2: 'New Headphones',
          quizAverage: 88,
          topics: [
            TopicMastery(topic: 'Saving', isMastered: true),
            TopicMastery(topic: 'Budgeting', isMastered: true),
            TopicMastery(topic: 'Needs vs. Wants', isMastered: false),
          ],
          challengesCompletedThisMonth: 8,
          weeksBudgetKept: 3,
          totalWeeks: 4,
        ),
      ),
    );
  }
}
