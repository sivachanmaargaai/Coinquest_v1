import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';
import '../bloc/savings_bloc.dart';
import '../bloc/savings_state.dart';
import 'add_savings_page.dart';

class GoalDetailPage extends StatelessWidget {
  final String goalId;

  const GoalDetailPage({super.key, required this.goalId});

  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month - 1]} ${d.year}';
  }

  String _dateLabel(DateTime date) {
    final now = DateTime.now();
    final diff = DateTime(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime(date.year, date.month, date.day)).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${diff}d ago';
  }

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
              final goal = state.goals.firstWhere((g) => g.id == goalId);

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
                            'Goal Details',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.h3,
                          ),
                        ),
                        const Icon(
                          Icons.more_vert_rounded,
                          color: AppColors.primaryText,
                        ),
                      ],
                    ),

                    Expanded(
                      child: ListView(
                        children: [
                          const SizedBox(height: AppSizes.space16),

                          Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryPurple.withOpacity(0.3),
                                border: Border.all(
                                  color: AppColors.goldAccent,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                goal.icon,
                                color: AppColors.goldAccent,
                                size: 44,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSizes.space16),
                          Center(
                            child: Text(goal.title, style: AppTextStyles.h2),
                          ),

                          const SizedBox(height: AppSizes.space24),

                          Center(
                            child: SizedBox(
                              width: 180,
                              height: 180,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 160,
                                    height: 160,
                                    child: CircularProgressIndicator(
                                      value: goal.progress,
                                      strokeWidth: 12,
                                      backgroundColor: AppColors.darkPurple,
                                      valueColor: const AlwaysStoppedAnimation(
                                        AppColors.goldAccent,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '₹${goal.currentAmount.toStringAsFixed(0)}',
                                        style: AppTextStyles.h2,
                                      ),
                                      Text(
                                        'of ₹${goal.targetAmount.toStringAsFixed(0)}',
                                        style: AppTextStyles.caption,
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.goldAccent,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          '${(goal.progress * 100).toStringAsFixed(0)}%',
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.darkPurple,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: AppSizes.space24),

                          Row(
                            children: [
                              Expanded(
                                child: _InfoChip(
                                  icon: Icons.account_balance_wallet_rounded,
                                  label: 'Remaining',
                                  value:
                                      '₹${goal.remaining.toStringAsFixed(0)}',
                                ),
                              ),
                              const SizedBox(width: AppSizes.space12),
                              Expanded(
                                child: _InfoChip(
                                  icon: Icons.calendar_today_rounded,
                                  label: 'Target Date',
                                  value: _formatDate(goal.targetDate),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSizes.space24),

                          Text('Savings History', style: AppTextStyles.h3),
                          const SizedBox(height: AppSizes.space8),

                          if (goal.history.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSizes.space16,
                              ),
                              child: Text(
                                'No contributions yet',
                                style: AppTextStyles.bodySmall,
                              ),
                            )
                          else
                            ...goal.history.map(
                              (h) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSizes.space8,
                                ),
                                child: GlassCard(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.space16,
                                    vertical: AppSizes.space12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _dateLabel(h.date),
                                        style: AppTextStyles.bodySmall,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.monetization_on_rounded,
                                            color: AppColors.goldAccent,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '+₹${h.amount.toStringAsFixed(0)}',
                                            style: AppTextStyles.bodyLarge
                                                .copyWith(
                                                  color: AppColors.successGreen,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: AppSizes.space24),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.space24),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final bloc = context.read<SavingsBloc>();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: bloc,
                                  child: AddSavingsPage(goal: goal),
                                ),
                              ),
                            );
                          },
                          child: const Text('Add Savings'),
                        ),
                      ),
                    ),
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSizes.space12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.goldAccent, size: 20),
          const SizedBox(height: AppSizes.space4),
          Text(label, style: AppTextStyles.caption),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
