import 'package:coinquest_v1_app/features/budget/domain/entities/savings_goal_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';

import '../bloc/savings_bloc.dart';
import '../bloc/savings_event.dart';
import '../bloc/savings_state.dart';
import 'goal_detail_page.dart';

class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SavingsBloc()..add(const SavingsStarted()),
      child: const _SavingsGoalListView(),
    );
  }
}

class _SavingsGoalListView extends StatelessWidget {
  const _SavingsGoalListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: BlocBuilder<SavingsBloc, SavingsState>(
            builder: (context, state) {
              if (state.status == SavingsStatus.loading) {
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
                      Text('Savings Goals', style: AppTextStyles.h3),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.goldAccent,
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: AppColors.darkPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.space16),

                  GlassCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Saved', style: AppTextStyles.caption),
                            Text(
                              '₹${state.totalSaved.toStringAsFixed(0)}',
                              style: AppTextStyles.h3,
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.savings_rounded,
                          color: AppColors.goldAccent,
                          size: 32,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.space24),

                  ...state.goals.map(
                    (g) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.space16),
                      child: _GoalCard(goal: g),
                    ),
                  ),
                  const SizedBox(height: AppSizes.space48),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final SavingsGoalEntity goal;
  const _GoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final bloc = context.read<SavingsBloc>();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: bloc,
              child: GoalDetailPage(goalId: goal.id),
            ),
          ),
        );
      },
      child: GlassCard(
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryPurple.withOpacity(0.3),
              ),
              child: Icon(goal.icon, color: AppColors.goldAccent),
            ),
            const SizedBox(width: AppSizes.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(goal.title, style: AppTextStyles.h3),
                  const SizedBox(height: AppSizes.space4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: goal.progress,
                      minHeight: 6,
                      backgroundColor: AppColors.darkPurple,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.goldAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.space4),
                  Text(
                    '₹${goal.currentAmount.toStringAsFixed(0)} / ₹${goal.targetAmount.toStringAsFixed(0)}',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.space8),
            Text(
              '${(goal.progress * 100).toStringAsFixed(0)}%',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.goldAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}
