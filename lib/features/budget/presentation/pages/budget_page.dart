import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../expense/domain/entities/expense_entity.dart';
import '../../domain/entities/budget_entity.dart';
import '../bloc/budget_bloc.dart';
import '../bloc/budget_event.dart';
import '../bloc/budget_state.dart';
import 'category_limits_page.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BudgetBloc()..add(const BudgetStarted()),
      child: const _BudgetOverviewView(),
    );
  }
}

class _BudgetOverviewView extends StatelessWidget {
  const _BudgetOverviewView();

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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: SafeArea(
        child: BlocBuilder<BudgetBloc, BudgetState>(
          builder: (context, state) {
            if (state.status == BudgetStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.goldAccent),
              );
            }

            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPaddingH,
                vertical: AppSizes.space16,
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('My Budget', style: AppTextStyles.h3),
                    IconButton(
                      onPressed: () async {
                        final bloc = context.read<BudgetBloc>();
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: bloc,
                              child: const CategoryLimitsPage(),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit_rounded,
                        color: AppColors.primaryText,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.space16),

                // Hero circular progress card
                GlassCard(
                  borderColor: AppColors.goldAccent.withOpacity(0.5),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 140,
                              height: 140,
                              child: CircularProgressIndicator(
                                value: state.overallProgress,
                                strokeWidth: 12,
                                backgroundColor: AppColors.darkPurple,
                                valueColor: AlwaysStoppedAnimation(
                                  state.overallProgress > 0.9
                                      ? AppColors.warning
                                      : AppColors.goldAccent,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '₹${state.totalSpent.toStringAsFixed(0)}',
                                  style: AppTextStyles.h2,
                                ),
                                Text(
                                  'of ₹${state.totalBudget.toStringAsFixed(0)}',
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSizes.space16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatChip(
                            color: AppColors.warning,
                            label:
                                'Spent ₹${state.totalSpent.toStringAsFixed(0)}',
                          ),
                          _StatChip(
                            color: AppColors.successGreen,
                            label:
                                'Left ₹${state.remaining.toStringAsFixed(0)}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.space24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Category Limits', style: AppTextStyles.h3),
                    TextButton(
                      onPressed: () async {
                        final bloc = context.read<BudgetBloc>();
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: bloc,
                              child: const CategoryLimitsPage(),
                            ),
                          ),
                        );
                      },
                      child: const Text('Edit'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.space8),

                ...state.categoryLimits.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.space8),
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.space16,
                        vertical: AppSizes.space12,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryPurple.withOpacity(0.3),
                            ),
                            child: Icon(
                              _categoryIcon(c.category),
                              color: AppColors.goldAccent,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: AppSizes.space12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.category.label,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColors.primaryText,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: c.progress,
                                    minHeight: 5,
                                    backgroundColor: AppColors.darkPurple,
                                    valueColor: AlwaysStoppedAnimation(
                                      c.isOverLimit
                                          ? AppColors.warning
                                          : AppColors.goldAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSizes.space8),
                          Text(
                            '₹${c.spent.toStringAsFixed(0)} / ₹${c.limit.toStringAsFixed(0)}',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.space24),

                OutlinedButton(
                  onPressed: () async {
                    final bloc = context.read<BudgetBloc>();
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: bloc,
                          child: const CategoryLimitsPage(),
                        ),
                      ),
                    );
                  },
                  child: const Text('Adjust Budget'),
                ),

                const SizedBox(height: AppSizes.space48),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final Color color;
  final String label;
  const _StatChip({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}
