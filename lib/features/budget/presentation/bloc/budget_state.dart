import 'package:equatable/equatable.dart';
import '../../domain/entities/budget_entity.dart';

enum BudgetStatus { loading, loaded, saved, error }

class BudgetState extends Equatable {
  final BudgetStatus status;
  final double totalBudget;
  final List<CategoryLimit> categoryLimits;

  const BudgetState({
    this.status = BudgetStatus.loading,
    this.totalBudget = 0,
    this.categoryLimits = const [],
  });

  double get totalSpent => categoryLimits.fold(0, (sum, c) => sum + c.spent);
  double get remaining => totalBudget - totalSpent;
  double get overallProgress =>
      totalBudget == 0 ? 0 : (totalSpent / totalBudget).clamp(0, 1);

  BudgetState copyWith({
    BudgetStatus? status,
    double? totalBudget,
    List<CategoryLimit>? categoryLimits,
  }) {
    return BudgetState(
      status: status ?? this.status,
      totalBudget: totalBudget ?? this.totalBudget,
      categoryLimits: categoryLimits ?? this.categoryLimits,
    );
  }

  @override
  List<Object?> get props => [status, totalBudget, categoryLimits];
}
