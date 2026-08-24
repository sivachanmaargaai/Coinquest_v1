import 'package:equatable/equatable.dart';
import '../../../expense/domain/entities/expense_entity.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the budget overview (total budget + category limits).
class BudgetStarted extends BudgetEvent {
  const BudgetStarted();
}

/// Fired when the user edits one category's limit on the
/// Category Limits screen (via the +/- steppers or slider).
class CategoryLimitChanged extends BudgetEvent {
  final ExpenseCategory category;
  final double newLimit;

  const CategoryLimitChanged({required this.category, required this.newLimit});

  @override
  List<Object?> get props => [category, newLimit];
}

/// Fired when the user taps "Save Limits" on the Category Limits screen.
class BudgetLimitsSaved extends BudgetEvent {
  const BudgetLimitsSaved();
}