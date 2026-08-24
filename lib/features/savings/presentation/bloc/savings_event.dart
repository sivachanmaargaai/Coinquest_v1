import 'package:equatable/equatable.dart';

abstract class SavingsEvent extends Equatable {
  const SavingsEvent();

  @override
  List<Object?> get props => [];
}

/// Loads all savings goals (Goal List screen).
class SavingsStarted extends SavingsEvent {
  const SavingsStarted();
}

/// Adds money to a specific goal (Add Savings screen).
class SavingsContributed extends SavingsEvent {
  final String goalId;
  final double amount;

  const SavingsContributed({required this.goalId, required this.amount});

  @override
  List<Object?> get props => [goalId, amount];
}
