import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SavingsContribution extends Equatable {
  final double amount;
  final DateTime date;

  const SavingsContribution({required this.amount, required this.date});

  @override
  List<Object?> get props => [amount, date];
}

class SavingsGoalEntity extends Equatable {
  final String id;
  final String title;
  final IconData icon;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final List<SavingsContribution> history;

  const SavingsGoalEntity({
    required this.id,
    required this.title,
    required this.icon,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    this.history = const [],
  });

  double get progress =>
      targetAmount == 0 ? 0 : (currentAmount / targetAmount).clamp(0, 1);
  double get remaining =>
      (targetAmount - currentAmount).clamp(0, double.infinity);

  SavingsGoalEntity copyWith({
    double? currentAmount,
    List<SavingsContribution>? history,
  }) {
    return SavingsGoalEntity(
      id: id,
      title: title,
      icon: icon,
      targetAmount: targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate,
      history: history ?? this.history,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    targetAmount,
    currentAmount,
    targetDate,
    history,
  ];
}
