import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';
import '../bloc/parent_dashboard_bloc.dart';
import '../bloc/parent_dashboard_state.dart';

class ChildProgressPage extends StatelessWidget {
  const ChildProgressPage({super.key});

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
              if (state.report == null) {
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
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: AppColors.primaryText, size: 20),
                      ),
                      Expanded(
                        child: Text("${r.childName}'s Progress",
                            textAlign: TextAlign.center, style: AppTextStyles.h3),
                      ),
                      const Icon(Icons.ios_share_rounded, color: AppColors.primaryText, size: 20),
                    ],
                  ),
                  const SizedBox(height: AppSizes.space8),

                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.glassCard,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(r.monthLabel, style: AppTextStyles.bodySmall),
                    ),
                  ),

                  const SizedBox(height: AppSizes.space24),

                  _SectionTitle(title: 'Spending Trends'),
                  const SizedBox(height: AppSizes.space8),
                  GlassCard(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 80,
                          child: _MiniSparkline(values: r.dailySpendTrend),
                        ),
                        const SizedBox(height: AppSizes.space8),
                        Text('Avg ₹${r.avgSpendPerDay.toStringAsFixed(0)}/day',
                            style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.space24),

                  _SectionTitle(title: 'Savings Progress'),
                  const SizedBox(height: AppSizes.space8),
                  GlassCard(
                    child: Column(
                      children: [
                        _GoalProgressRow(name: r.goalName1, percent: r.goalProgressPercent1),
                        const SizedBox(height: AppSizes.space12),
                        _GoalProgressRow(name: r.goalName2, percent: r.goalProgressPercent2),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.space24),

                  _SectionTitle(title: 'Budget Performance'),
                  const SizedBox(height: AppSizes.space8),
                  GlassCard(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 64,
                          height: 64,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: r.budgetKeptPercent / 100,
                                strokeWidth: 8,
                                backgroundColor: AppColors.darkPurple,
                                valueColor: const AlwaysStoppedAnimation(AppColors.goldAccent),
                              ),
                              Text('${r.budgetKeptPercent.toStringAsFixed(0)}%',
                                  style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSizes.space16),
                        Expanded(
                          child: Text(
                            'Stayed within budget ${r.weeksBudgetKept} of ${r.totalWeeks} weeks',
                            style: AppTextStyles.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.space24),

                  _SectionTitle(title: 'Learning Progress'),
                  const SizedBox(height: AppSizes.space8),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${r.lessonsCompleted}/${r.lessonsTotal} lessons',
                                style: AppTextStyles.bodySmall),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.goldAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('Quiz avg ${r.quizAverage.toStringAsFixed(0)}%',
                                  style: AppTextStyles.caption.copyWith(color: AppColors.goldAccent)),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.space12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: r.topics.map((t) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: t.isMastered
                                    ? AppColors.successGreen.withOpacity(0.15)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: t.isMastered
                                      ? AppColors.successGreen
                                      : AppColors.warning.withOpacity(0.6),
                                ),
                              ),
                              child: Text(
                                t.isMastered ? '${t.topic} ✓' : '${t.topic} (practice)',
                                style: AppTextStyles.caption.copyWith(
                                  color: t.isMastered ? AppColors.successGreen : AppColors.warning,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.space24),

                  _SectionTitle(title: 'Challenge Completion'),
                  const SizedBox(height: AppSizes.space8),
                  GlassCard(
                    child: Row(
                      children: [
                        const Icon(Icons.emoji_events_rounded, color: AppColors.goldAccent, size: 28),
                        const SizedBox(width: AppSizes.space12),
                        Text(
                          '${r.challengesCompletedThisMonth} Challenges Completed This Month',
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primaryText),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.space32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Encouragement sent! 💛')),
                        );
                      },
                      icon: const Icon(Icons.favorite_rounded, size: 18),
                      label: const Text('Send Encouragement'),
                    ),
                  ),
                  const SizedBox(height: AppSizes.space12),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Export as PDF'),
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

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.h3);
  }
}

class _GoalProgressRow extends StatelessWidget {
  final String name;
  final double percent;
  const _GoalProgressRow({required this.name, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: AppTextStyles.bodySmall),
            Text('${percent.toStringAsFixed(0)}%',
                style: AppTextStyles.caption.copyWith(color: AppColors.goldAccent)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 6,
            backgroundColor: AppColors.darkPurple,
            valueColor: const AlwaysStoppedAnimation(AppColors.goldAccent),
          ),
        ),
      ],
    );
  }
}

/// Simple hand-drawn sparkline using CustomPaint — no chart package needed.
class _MiniSparkline extends StatelessWidget {
  final List<double> values;
  const _MiniSparkline({required this.values});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 80),
      painter: _SparklinePainter(values),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  _SparklinePainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final minVal = values.reduce((a, b) => a < b ? a : b);
    final range = (maxVal - minVal) == 0 ? 1 : (maxVal - minVal);

    final path = Path();
    final stepX = size.width / (values.length - 1);

    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final normalized = (values[i] - minVal) / range;
      final y = size.height - (normalized * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final linePaint = Paint()
      ..color = const Color(0xFFFFC83D)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // Fill under the line
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final fillPaint = Paint()
      ..color = const Color(0xFFFFC83D).withOpacity(0.15)
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) => false;
}