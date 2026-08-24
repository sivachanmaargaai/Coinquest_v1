import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../expense/domain/entities/expense_entity.dart';
import '../../domain/entities/budget_entity.dart';
import '../bloc/budget_bloc.dart';
import '../bloc/budget_event.dart';
import '../bloc/budget_state.dart';
import 'budget_success_page.dart';

class CategoryLimitsPage extends StatelessWidget {
  const CategoryLimitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: BlocConsumer<BudgetBloc, BudgetState>(
            listener: (context, state) {
              if (state.status == BudgetStatus.saved) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<BudgetBloc>(),
                      child: const BudgetSuccessPage(),
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPaddingH,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppSizes.space8),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.primaryText,
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Category Limits',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.h3,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.read<BudgetBloc>().add(
                            const BudgetLimitsSaved(),
                          ),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.space4),
                    Text(
                      'Set spending limits for each category',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: AppSizes.space16),

                    Expanded(
                      child: ListView(
                        children: state.categoryLimits
                            .map((c) => _CategoryLimitEditor(categoryLimit: c))
                            .toList(),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(AppSizes.space16),
                      margin: const EdgeInsets.only(bottom: AppSizes.space16),
                      decoration: BoxDecoration(
                        color: AppColors.glassCard,
                        borderRadius: BorderRadius.circular(
                          AppSizes.cardRadius,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Budget', style: AppTextStyles.bodySmall),
                          Text(
                            '₹${state.totalBudget.toStringAsFixed(0)}',
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.goldAccent,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.read<BudgetBloc>().add(
                          const BudgetLimitsSaved(),
                        ),
                        child: const Text('Save Limits'),
                      ),
                    ),
                    const SizedBox(height: AppSizes.space24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CategoryLimitEditor extends StatelessWidget {
  final CategoryLimit categoryLimit;
  const _CategoryLimitEditor({required this.categoryLimit});

  IconData get _icon {
    switch (categoryLimit.category) {
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

  void _adjust(BuildContext context, double delta) {
    final newLimit = (categoryLimit.limit + delta).clamp(0, 999999).toDouble();
    context.read<BudgetBloc>().add(
      CategoryLimitChanged(
        category: categoryLimit.category,
        newLimit: newLimit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.space16),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.space16),
        decoration: BoxDecoration(
          color: AppColors.glassCard,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryPurple.withOpacity(0.3),
                  ),
                  child: Icon(_icon, color: AppColors.goldAccent, size: 18),
                ),
                const SizedBox(width: AppSizes.space12),
                Expanded(
                  child: Text(
                    categoryLimit.category.label,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
                _StepperButton(
                  icon: Icons.remove_rounded,
                  onTap: () => _adjust(context, -50),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    '₹${categoryLimit.limit.toStringAsFixed(0)}',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.goldAccent,
                    ),
                  ),
                ),
                _StepperButton(
                  icon: Icons.add_rounded,
                  onTap: () => _adjust(context, 50),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.space8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.goldAccent,
                inactiveTrackColor: AppColors.darkPurple,
                thumbColor: AppColors.goldAccent,
                overlayColor: AppColors.goldAccent.withOpacity(0.2),
                trackHeight: 4,
              ),
              child: Slider(
                value: categoryLimit.limit.clamp(0, 2000),
                min: 0,
                max: 2000,
                onChanged: (value) {
                  context.read<BudgetBloc>().add(
                    CategoryLimitChanged(
                      category: categoryLimit.category,
                      newLimit: value,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.goldAccent,
        ),
        child: Icon(icon, size: 16, color: AppColors.darkPurple),
      ),
    );
  }
}
