import 'package:equatable/equatable.dart';

enum ExpenseCategory {
  food,
  transport,
  shopping,
  entertainment,
  education,
  other,
}

extension ExpenseCategoryX on ExpenseCategory {
  String get label {
    switch (this) {
      case ExpenseCategory.food:
        return 'Food';
      case ExpenseCategory.transport:
        return 'Transport';
      case ExpenseCategory.shopping:
        return 'Shopping';
      case ExpenseCategory.entertainment:
        return 'Entertainment';
      case ExpenseCategory.education:
        return 'Education';
      case ExpenseCategory.other:
        return 'Other';
    }
  }
}

/// Pure business object for a single expense — no JSON, no Flutter widgets.
class ExpenseEntity extends Equatable {
  final String id;
  final double amount;
  final ExpenseCategory category;
  final String description;
  final DateTime date;

  const ExpenseEntity({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });

  @override
  List<Object?> get props => [id, amount, category, description, date];
}
