import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/expense_entity.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import 'add_expense_page.dart';

class ExpensePage extends StatelessWidget {
  const ExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpenseBloc()..add(const ExpenseHistoryStarted()),
      child: const _ExpenseHistoryView(),
    );
  }
}

class _ExpenseHistoryView extends StatelessWidget {
  const _ExpenseHistoryView();

  String _currency(double v) => '₹${v.abs().toStringAsFixed(2)}';

  IconData _categoryIcon(ExpenseCategory c) {
    switch (c) {
      case ExpenseCategory.food:
        return Icons.restaurant_rounded;
      case ExpenseCategory.transport:
        return Icons.directions_bus_rounded;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag_rounded;
      case ExpenseCategory.entertainment:
        return Icons.sports_esports_rounded;
      case ExpenseCategory.education:
        return Icons.school_rounded;
      case ExpenseCategory.other:
        return Icons.more_horiz_rounded;
    }
  }

  String _dateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (context, state) {
              if (state.status == ExpenseStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.goldAccent),
                );
              }

              // Group expenses by date label
              final Map<String, List<ExpenseEntity>> grouped = {};
              for (final e in state.expenses) {
                final label = _dateLabel(e.date);
                grouped.putIfAbsent(label, () => []).add(e);
              }

              return Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.screenPaddingH,
                      vertical: AppSizes.space16,
                    ),
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: AppColors.primaryText,
                              size: 20,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Expense History',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.h3,
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: AppSizes.space16),

                      // Daily/Weekly/Monthly filter
                      _FilterTabs(
                        current: state.filter,
                        onChanged: (f) => context.read<ExpenseBloc>().add(
                          ExpenseFilterChanged(f),
                        ),
                      ),
                      const SizedBox(height: AppSizes.space16),

                      GlassCard(
                        borderColor: AppColors.goldAccent.withOpacity(0.4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${state.totalSpent.toStringAsFixed(0)} this week',
                              style: AppTextStyles.h3,
                            ),
                            const SizedBox(height: AppSizes.space4),
                            Text(
                              'Across ${state.expenses.length} transactions',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSizes.space24),

                      ...grouped.entries.map((entry) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSizes.space8,
                              ),
                              child: Text(
                                entry.key,
                                style: AppTextStyles.caption,
                              ),
                            ),
                            ...entry.value.map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSizes.space8,
                                ),
                                child: GlassCard(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.space16,
                                    vertical: AppSizes.space12,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primaryPurple
                                              .withOpacity(0.3),
                                        ),
                                        child: Icon(
                                          _categoryIcon(e.category),
                                          color: AppColors.goldAccent,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: AppSizes.space12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              e.description,
                                              style: AppTextStyles.bodyLarge
                                                  .copyWith(
                                                    color:
                                                        AppColors.primaryText,
                                                  ),
                                            ),
                                            Text(
                                              e.category.label,
                                              style: AppTextStyles.caption,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '-${_currency(e.amount)}',
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          color: AppColors.warning,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSizes.space8),
                          ],
                        );
                      }),
                      const SizedBox(height: 80),
                    ],
                  ),

                  // Floating Action Button
                  Positioned(
                    right: AppSizes.space16,
                    bottom: AppSizes.space16,
                    child: FloatingActionButton(
                      backgroundColor: AppColors.goldAccent,
                      onPressed: () async {
                        final bloc = context.read<ExpenseBloc>();
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: bloc,
                              child: const AddExpensePage(),
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.add_rounded,
                        color: AppColors.darkPurple,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  final ExpenseFilter current;
  final ValueChanged<ExpenseFilter> onChanged;

  const _FilterTabs({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final tabs = {
      ExpenseFilter.daily: 'Daily',
      ExpenseFilter.weekly: 'Weekly',
      ExpenseFilter.monthly: 'Monthly',
    };

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.glassCard,
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
      ),
      child: Row(
        children: tabs.entries.map((entry) {
          final bool isActive = entry.key == current;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: AppSizes.space8),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.goldAccent : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  entry.value,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isActive
                        ? AppColors.darkPurple
                        : AppColors.secondaryText,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
