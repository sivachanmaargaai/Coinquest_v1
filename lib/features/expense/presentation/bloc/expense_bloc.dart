import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/expense_entity.dart';
import 'expense_event.dart';
import 'expense_state.dart';

/// Handles both listing expenses (History screen) and adding a new one
/// (Add Expense screen). In-memory mock data for now.
/// TODO: replace with GetExpensesUseCase / AddExpenseUseCase backed by a
/// real repository once the backend is ready.
class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(const ExpenseState()) {
    on<ExpenseHistoryStarted>(_onStarted);
    on<ExpenseAdded>(_onAdded);
    on<ExpenseFilterChanged>(_onFilterChanged);
  }

  Future<void> _onStarted(
    ExpenseHistoryStarted event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(state.copyWith(status: ExpenseStatus.loading));
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now();
    emit(
      state.copyWith(
        status: ExpenseStatus.loaded,
        expenses: [
          ExpenseEntity(
            id: '1',
            amount: 12.50,
            category: ExpenseCategory.food,
            description: 'Lunch',
            date: now,
          ),
          ExpenseEntity(
            id: '2',
            amount: 8.00,
            category: ExpenseCategory.transport,
            description: 'Bus Pass',
            date: now,
          ),
          ExpenseEntity(
            id: '3',
            amount: 15.00,
            category: ExpenseCategory.entertainment,
            description: 'Movie Ticket',
            date: now.subtract(const Duration(days: 1)),
          ),
          ExpenseEntity(
            id: '4',
            amount: 45.50,
            category: ExpenseCategory.shopping,
            description: 'New Shoes',
            date: now.subtract(const Duration(days: 2)),
          ),
        ],
      ),
    );
  }

  Future<void> _onAdded(ExpenseAdded event, Emitter<ExpenseState> emit) async {
    final newExpense = ExpenseEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: event.amount,
      category: event.category,
      description: event.description,
      date: DateTime.now(),
    );

    emit(
      state.copyWith(
        expenses: [newExpense, ...state.expenses],
        justAdded: true,
      ),
    );
  }

  void _onFilterChanged(
    ExpenseFilterChanged event,
    Emitter<ExpenseState> emit,
  ) {
    emit(state.copyWith(filter: event.filter));
  }
}
