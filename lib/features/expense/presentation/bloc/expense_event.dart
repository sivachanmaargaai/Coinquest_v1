import 'package:equatable/equatable.dart';
import '../../domain/entities/expense_entity.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the expense list (History screen).
class ExpenseHistoryStarted extends ExpenseEvent {
  const ExpenseHistoryStarted();
}

/// Adds a new expense (Add Expense screen).
class ExpenseAdded extends ExpenseEvent {
  final double amount;
  final ExpenseCategory category;
  final String description;

  const ExpenseAdded({
    required this.amount,
    required this.category,
    required this.description,
  });

  @override
  List<Object?> get props => [amount, category, description];
}

/// Switches the Daily/Weekly/Monthly filter tab on the History screen.
class ExpenseFilterChanged extends ExpenseEvent {
  final ExpenseFilter filter;

  const ExpenseFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

enum ExpenseFilter { daily, weekly, monthly }
