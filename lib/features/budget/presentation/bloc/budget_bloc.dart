import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../expense/domain/entities/expense_entity.dart';
import '../../domain/entities/budget_entity.dart';
import 'budget_event.dart';
import 'budget_state.dart';

/// Loads the budget overview + lets the user edit category limits.
/// TODO: replace mock data with GetBudgetUseCase / SaveBudgetLimitsUseCase.
class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc() : super(const BudgetState()) {
    on<BudgetStarted>(_onStarted);
    on<CategoryLimitChanged>(_onCategoryLimitChanged);
    on<BudgetLimitsSaved>(_onLimitsSaved);
  }

  Future<void> _onStarted(
    BudgetStarted event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.loading));
    await Future.delayed(const Duration(milliseconds: 400));

    emit(
      state.copyWith(
        status: BudgetStatus.loaded,
        totalBudget: 5000,
        categoryLimits: const [
          CategoryLimit(
            category: ExpenseCategory.food,
            limit: 1200,
            spent: 800,
          ),
          CategoryLimit(
            category: ExpenseCategory.transport,
            limit: 800,
            spent: 350,
          ),
          CategoryLimit(
            category: ExpenseCategory.shopping,
            limit: 1000,
            spent: 950,
          ),
          CategoryLimit(
            category: ExpenseCategory.entertainment,
            limit: 700,
            spent: 720,
          ),
          CategoryLimit(
            category: ExpenseCategory.education,
            limit: 800,
            spent: 400,
          ),
          CategoryLimit(
            category: ExpenseCategory.other,
            limit: 500,
            spent: 180,
          ),
        ],
      ),
    );
  }

  void _onCategoryLimitChanged(
    CategoryLimitChanged event,
    Emitter<BudgetState> emit,
  ) {
    final updated = state.categoryLimits.map((c) {
      if (c.category == event.category) {
        return c.copyWith(limit: event.newLimit);
      }
      return c;
    }).toList();

    final newTotal = updated.fold<double>(0, (sum, c) => sum + c.limit);

    emit(state.copyWith(categoryLimits: updated, totalBudget: newTotal));
  }

  Future<void> _onLimitsSaved(
    BudgetLimitsSaved event,
    Emitter<BudgetState> emit,
  ) async {
    // TODO: persist via SaveBudgetLimitsUseCase
    emit(state.copyWith(status: BudgetStatus.saved));
  }
}
