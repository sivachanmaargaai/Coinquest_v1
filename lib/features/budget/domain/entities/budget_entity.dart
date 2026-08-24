import 'package:equatable/equatable.dart';
import '../../../expense/domain/entities/expense_entity.dart';

/// One category's spending limit + how much has been spent against it.
class CategoryLimit extends Equatable {
  final ExpenseCategory category;
  final double limit;
  final double spent;

  const CategoryLimit({
    required this.category,
    required this.limit,
    required this.spent,
  });

  double get progress => limit == 0 ? 0 : (spent / limit).clamp(0, 1);
  bool get isOverLimit => spent > limit;
  bool get isNearLimit => progress >= 0.9 && !isOverLimit;

  CategoryLimit copyWith({double? limit, double? spent}) {
    return CategoryLimit(
      category: category,
      limit: limit ?? this.limit,
      spent: spent ?? this.spent,
    );
  }

  @override
  List<Object?> get props => [category, limit, spent];
}
