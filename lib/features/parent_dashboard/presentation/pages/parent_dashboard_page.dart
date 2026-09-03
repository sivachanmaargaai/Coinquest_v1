import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';
import '../bloc/parent_dashboard_bloc.dart';
import '../bloc/parent_dashboard_event.dart';
import '../bloc/parent_dashboard_state.dart';
import 'child_progress_page.dart';

class ParentDashboardPage extends StatelessWidget {
  const ParentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ParentDashboardBloc()..add(const ParentDashboardStarted()),
      child: const _ParentOverviewView(),
    );
  }
}

class _ParentOverviewView extends StatelessWidget {
  const _ParentOverviewView();

  static const _categoryColors = {
    'Food': Color(0xFFFF9F43),
    'Transport': Color(0xFF6EE7FF),
    'Shopping': Color(0xFFA78BFA),
    'Entertainment': Color(0xFFFF6FA6),
    'Education': Color(0xFF34C759),
    'Other': Color(0xFFCFC8FF),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: BlocBuilder<ParentDashboardBloc, ParentDashboardState>(
            builder: (context, state) {
              if (state.status == ParentDashboardStatus.loading ||
                  state.report == null) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.goldAccent),
                );
              }

              final r = state.report!;
              final totalSpending = r.categorySpending.values.fold<double>(
                0,
                (a, b) => a + b,
              );

              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPaddingH,
                  vertical: AppSizes.space16,
                ),
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryPurple.withOpacity(0.3),
                        ),
                        child: const Icon(
                          Icons.face_rounded,
                          color: AppColors.goldAccent,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: AppSizes.space8),
                      Expanded(
                        child: Text(
                          "${r.childName}'s Overview",
                          style: AppTextStyles.h3,
                        ),
                      ),
                      const Icon(
                        Icons.settings_rounded,
                        color: AppColors.primaryText,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.space16),

                  // Top stat row
                  Row(
                    children: [
                      Expanded(
                        child: _StatMiniCard(
                          label: 'Spending This Month',
                          value: '₹${r.spentThisMonth.toStringAsFixed(0)}',
                          icon: Icons.account_balance_wallet_rounded,
                          accent: AppColors.primaryPurple,
                        ),
                      ),
                      const SizedBox(width: AppSizes.space12),
                      Expanded(
                        child: _StatMiniCard(
                          label: 'Budget Kept',
                          value: '${r.budgetKeptPercent.toStringAsFixed(0)}%',
                          icon: Icons.pie_chart_rounded,
                          accent: AppColors.goldAccent,
                        ),
                      ),
                      const SizedBox(width: AppSizes.space12),
                      Expanded(
                        child: _StatMiniCard(
                          label: 'Savings Progress',
                          value:
                              '${r.savingsProgressPercent.toStringAsFixed(0)}%',
                          icon: Icons.savings_rounded,
                          accent: AppColors.successGreen,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.space24),

                  Text('Spending Overview', style: AppTextStyles.h3),
                  const SizedBox(height: AppSizes.space8),
                  GlassCard(
                    child: Column(
                      children: r.categorySpending.entries.map((entry) {
                        final pct = totalSpending == 0
                            ? 0.0
                            : entry.value / totalSpending;
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSizes.space8,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _categoryColors[entry.key] ??
                                      AppColors.secondaryText,
                                ),
                              ),
                              const SizedBox(width: AppSizes.space8),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  entry.key,
                                  style: AppTextStyles.bodySmall,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: pct,
                                    minHeight: 6,
                                    backgroundColor: AppColors.darkPurple,
                                    valueColor: AlwaysStoppedAnimation(
                                      _categoryColors[entry.key] ??
                                          AppColors.goldAccent,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSizes.space8),
                              Text(
                                '₹${entry.value.toStringAsFixed(0)}',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: AppSizes.space24),

                  Text('Learning Activity', style: AppTextStyles.h3),
                  const SizedBox(height: AppSizes.space8),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: r.lessonsTotal == 0
                                ? 0
                                : r.lessonsCompleted / r.lessonsTotal,
                            minHeight: 6,
                            backgroundColor: AppColors.darkPurple,
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.goldAccent,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.space4),
                        Text(
                          '${r.lessonsCompleted}/${r.lessonsTotal} lessons completed',
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(height: AppSizes.space4),
                        Text(
                          'Last active: ${r.lastActiveLabel}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.space24),

                  Text('Recent Challenges', style: AppTextStyles.h3),
                  const SizedBox(height: AppSizes.space8),
                  Row(
                    children: [
                      Expanded(
                        child: _ChallengeChip(
                          label: 'No Spend Weekend',
                          isComplete: true,
                        ),
                      ),
                      const SizedBox(width: AppSizes.space12),
                      Expanded(
                        child: _ChallengeChip(
                          label: 'Save ₹500',
                          isComplete: false,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.space32),

                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ChildProgressPage(),
                        ),
                      );
                    },
                    child: const Text('View Detailed Report'),
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

class _StatMiniCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  const _StatMiniCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSizes.space12),
      borderColor: accent.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 18),
          const SizedBox(height: AppSizes.space4),
          Text(value, style: AppTextStyles.h3),
          Text(label, style: AppTextStyles.caption, maxLines: 2),
        ],
      ),
    );
  }
}

class _ChallengeChip extends StatelessWidget {
  final String label;
  final bool isComplete;
  const _ChallengeChip({required this.label, required this.isComplete});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.space12,
        vertical: AppSizes.space12,
      ),
      child: Row(
        children: [
          Icon(
            isComplete
                ? Icons.check_circle_rounded
                : Icons.hourglass_bottom_rounded,
            color: isComplete ? AppColors.successGreen : AppColors.goldAccent,
            size: 18,
          ),
          const SizedBox(width: AppSizes.space8),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
