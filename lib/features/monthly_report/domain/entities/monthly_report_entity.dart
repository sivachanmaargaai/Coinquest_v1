import 'package:equatable/equatable.dart';

class MonthlyReportEntity extends Equatable {
  final String monthLabel;
  final String aiSummary;

  // Money
  final double spent;
  final double saved;
  final double budgetKeptPercent;

  // Learning
  final int lessonsCompleted;
  final double quizAverage;
  final int topicsMastered;

  // Engagement
  final int challengesCompleted;
  final int xpEarned;
  final int streakDays;

  const MonthlyReportEntity({
    required this.monthLabel,
    required this.aiSummary,
    required this.spent,
    required this.saved,
    required this.budgetKeptPercent,
    required this.lessonsCompleted,
    required this.quizAverage,
    required this.topicsMastered,
    required this.challengesCompleted,
    required this.xpEarned,
    required this.streakDays,
  });

  @override
  List<Object?> get props => [
    monthLabel,
    aiSummary,
    spent,
    saved,
    budgetKeptPercent,
    lessonsCompleted,
    quizAverage,
    topicsMastered,
    challengesCompleted,
    xpEarned,
    streakDays,
  ];
}
