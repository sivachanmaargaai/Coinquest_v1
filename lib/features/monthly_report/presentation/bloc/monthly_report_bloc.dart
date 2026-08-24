import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/monthly_report_entity.dart';
import 'monthly_report_event.dart';
import 'monthly_report_state.dart';

/// Loads the AI-generated monthly summary.
/// TODO: replace mock data with GetMonthlyReportUseCase.
class MonthlyReportBloc extends Bloc<MonthlyReportEvent, MonthlyReportState> {
  MonthlyReportBloc() : super(const MonthlyReportState()) {
    on<MonthlyReportStarted>(_onStarted);
  }

  Future<void> _onStarted(
    MonthlyReportStarted event,
    Emitter<MonthlyReportState> emit,
  ) async {
    emit(state.copyWith(status: MonthlyReportStatus.loading));
    await Future.delayed(const Duration(milliseconds: 400));

    emit(
      state.copyWith(
        status: MonthlyReportStatus.loaded,
        report: const MonthlyReportEntity(
          monthLabel: 'August 2026',
          aiSummary:
              'This month, you improved your saving consistency and stayed closer to your budget. Your biggest area to improve is entertainment spending.',
          spent: 4200,
          saved: 1800,
          budgetKeptPercent: 85,
          lessonsCompleted: 6,
          quizAverage: 88,
          topicsMastered: 3,
          challengesCompleted: 4,
          xpEarned: 320,
          streakDays: 12,
        ),
      ),
    );
  }
}
