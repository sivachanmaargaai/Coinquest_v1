import 'package:equatable/equatable.dart';

class TopicMastery extends Equatable {
  final String topic;
  final bool
  isMastered; // true = mastered (green), false = needs practice (amber)

  const TopicMastery({required this.topic, required this.isMastered});

  @override
  List<Object?> get props => [topic, isMastered];
}

class ParentReportEntity extends Equatable {
  final String childName;
  final String monthLabel;

  // Top summary
  final double spentThisMonth;
  final double budgetKeptPercent;
  final double savingsProgressPercent;

  // Spending Overview (category -> amount)
  final Map<String, double> categorySpending;

  // Learning Activity
  final int lessonsCompleted;
  final int lessonsTotal;
  final String lastActiveLabel;

  // Detailed report (Child Progress screen)
  final List<double> dailySpendTrend; // simple sparkline data
  final double avgSpendPerDay;
  final double goalProgressPercent1;
  final String goalName1;
  final double goalProgressPercent2;
  final String goalName2;
  final double quizAverage;
  final List<TopicMastery> topics;
  final int challengesCompletedThisMonth;
  final int weeksBudgetKept;
  final int totalWeeks;

  const ParentReportEntity({
    required this.childName,
    required this.monthLabel,
    required this.spentThisMonth,
    required this.budgetKeptPercent,
    required this.savingsProgressPercent,
    required this.categorySpending,
    required this.lessonsCompleted,
    required this.lessonsTotal,
    required this.lastActiveLabel,
    required this.dailySpendTrend,
    required this.avgSpendPerDay,
    required this.goalProgressPercent1,
    required this.goalName1,
    required this.goalProgressPercent2,
    required this.goalName2,
    required this.quizAverage,
    required this.topics,
    required this.challengesCompletedThisMonth,
    required this.weeksBudgetKept,
    required this.totalWeeks,
  });

  @override
  List<Object?> get props => [
    childName,
    monthLabel,
    spentThisMonth,
    budgetKeptPercent,
    savingsProgressPercent,
    categorySpending,
    lessonsCompleted,
    lessonsTotal,
    lastActiveLabel,
  ];
}
