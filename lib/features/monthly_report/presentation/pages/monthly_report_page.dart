import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/monthly_report_entity.dart';
import '../bloc/monthly_report_bloc.dart';
import '../bloc/monthly_report_event.dart';
import '../bloc/monthly_report_state.dart';

class MonthlyReportPage extends StatelessWidget {
  const MonthlyReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MonthlyReportBloc()..add(const MonthlyReportStarted()),
      child: const _MonthlyReportView(),
    );
  }
}

class _MonthlyReportView extends StatelessWidget {
  const _MonthlyReportView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: BlocBuilder<MonthlyReportBloc, MonthlyReportState>(
            builder: (context, state) {
              if (state.status == MonthlyReportStatus.loading ||
                  state.report == null) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.goldAccent),
                );
              }

              final r = state.report!;

              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPaddingH,
                  vertical: AppSizes.space16,
                ),
                children: [
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
                          r.monthLabel,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h3,
                        ),
                      ),
                      const Icon(
                        Icons.ios_share_rounded,
                        color: AppColors.primaryText,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.space16),

                  // AI Summary
                  GlassCard(
                    borderColor: AppColors.goldAccent.withOpacity(0.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: 16,
                              color: AppColors.goldAccent,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'AI Summary',
                              style: TextStyle(
                                color: AppColors.goldAccent,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.space8),
                        Text(
                          r.aiSummary,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.space24),

                  // Money section
                  _SectionHeader(
                    title: 'Money',
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                  const SizedBox(height: AppSizes.space8),
                  GlassCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: _MiniStat(
                            label: 'Spent',
                            value: '₹${r.spent.toStringAsFixed(0)}',
                          ),
                        ),
                        Expanded(
                          child: _MiniStat(
                            label: 'Saved',
                            value: '₹${r.saved.toStringAsFixed(0)}',
                          ),
                        ),
                        Expanded(
                          child: _MiniStat(
                            label: 'Budget Kept',
                            value: '${r.budgetKeptPercent.toStringAsFixed(0)}%',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.space24),

                  // Learning section
                  _SectionHeader(
                    title: 'Learning',
                    icon: Icons.menu_book_rounded,
                  ),
                  const SizedBox(height: AppSizes.space8),
                  GlassCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: _MiniStat(
                            label: 'Lessons',
                            value: '${r.lessonsCompleted}',
                          ),
                        ),
                        Expanded(
                          child: _MiniStat(
                            label: 'Quiz Avg',
                            value: '${r.quizAverage.toStringAsFixed(0)}%',
                          ),
                        ),
                        Expanded(
                          child: _MiniStat(
                            label: 'Mastered',
                            value: '${r.topicsMastered}',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.space24),

                  // Engagement section
                  _SectionHeader(
                    title: 'Engagement',
                    icon: Icons.emoji_events_rounded,
                  ),
                  const SizedBox(height: AppSizes.space8),
                  GlassCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: _MiniStat(
                            label: 'Challenges',
                            value: '${r.challengesCompleted}',
                          ),
                        ),
                        Expanded(
                          child: _MiniStat(
                            label: 'XP Earned',
                            value: '+${r.xpEarned}',
                          ),
                        ),
                        Expanded(
                          child: _MiniStat(
                            label: 'Streak',
                            value: '${r.streakDays}d',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.space32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('View Next Month\'s Plan'),
                    ),
                  ),
                  const SizedBox(height: AppSizes.space24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.goldAccent),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.h3),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h3.copyWith(color: AppColors.goldAccent),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption, textAlign: TextAlign.center),
      ],
    );
  }
}
