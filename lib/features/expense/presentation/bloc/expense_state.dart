import 'package:equatable/equatable.dart';
import '../../domain/entities/expense_entity.dart';
import 'expense_event.dart';

enum ExpenseStatus { loading, loaded, error }

class ExpenseState extends Equatable {
  final ExpenseStatus status;
  final List<ExpenseEntity> expenses;
  final ExpenseFilter filter;
  final bool justAdded;
  final String? errorMessage;

  const ExpenseState({
    this.status = ExpenseStatus.loading,
    this.expenses = const [],
    this.filter = ExpenseFilter.weekly,
    this.justAdded = false,
    this.errorMessage,
  });

  double get totalSpent => expenses.fold(0, (sum, e) => sum + e.amount);

  ExpenseState copyWith({
    ExpenseStatus? status,
    List<ExpenseEntity>? expenses,
    ExpenseFilter? filter,
    bool? justAdded,
    String? errorMessage,
  }) {
    return ExpenseState(
      status: status ?? this.status,
      expenses: expenses ?? this.expenses,
      filter: filter ?? this.filter,
      justAdded: justAdded ?? false,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    expenses,
    filter,
    justAdded,
    errorMessage,
  ];
}
