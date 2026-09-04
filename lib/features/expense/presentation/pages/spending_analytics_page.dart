import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/expense_entity.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_state.dart';

class SpendingAnalyticsPage extends StatelessWidget {
  const SpendingAnalyticsPage({super.key});

  static const _categoryColors = {
    ExpenseCategory.food: Color(0xFFFF9F43),
    ExpenseCategory.transport: Color(0xFF6EE7FF),
    ExpenseCategory.shopping: Color(0xFFA78BFA),
    ExpenseCategory.entertainment: Color(0xFFFF6FA6),
    ExpenseCategory.education: Color(0xFF34C759),
    ExpenseCategory.other: Color(0xFFCFC8FF),
  };

  Map<ExpenseCategory, double> _groupByCategory(List<ExpenseEntity> expenses) {
    final Map<ExpenseCategory, double> totals = {};
    for (final e in expenses) {
      totals.update(e.category, (v) => v + e.amount, ifAbsent: () => e.amount);
    }
    return totals;
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

              final grouped = _groupByCategory(state.expenses);
              final total = grouped.values.fold<double>(0, (a, b) => a + b);
              final sortedEntries = grouped.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));

              return ListView(
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
                          'Spending Analytics',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h3,
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.goldAccent.withOpacity(0.2),
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: AppColors.goldAccent,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.space16),

                  // Month selector (static display for now)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.space16,
                      vertical: AppSizes.space8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.glassCard,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.chevron_left_rounded,
                          color: AppColors.secondaryText,
                        ),
                        const SizedBox(width: AppSizes.space16),
                        Text('August 2026', style: AppTextStyles.bodyLarge),
                        const SizedBox(width: AppSizes.space16),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.secondaryText,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.space24),

                  // Donut chart card
                  GlassCard(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomPaint(
                                size: const Size(200, 200),
                                painter: _DonutChartPainter(
                                  entries: sortedEntries,
                                  colors: _categoryColors,
                                  total: total,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '₹${total.toStringAsFixed(0)}',
                                    style: AppTextStyles.h2,
                                  ),
                                  Text(
                                    'Total Spent',
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.space16),

                  // Legend
                  ...sortedEntries.map((entry) {
                    final pct = total == 0 ? 0.0 : (entry.value / total) * 100;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.space8),
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.space16,
                          vertical: AppSizes.space12,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _categoryColors[entry.key],
                              ),
                            ),
                            const SizedBox(width: AppSizes.space12),
                            Expanded(
                              child: Text(
                                entry.key.label,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.primaryText,
                                ),
                              ),
                            ),
                            Text(
                              '${pct.toStringAsFixed(0)}%',
                              style: AppTextStyles.caption,
                            ),
                            const SizedBox(width: AppSizes.space12),
                            Text(
                              '₹${entry.value.toStringAsFixed(0)}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primaryText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: AppSizes.space16),

                  // AI Tip Card
                  GlassCard(
                    borderColor: AppColors.info.withOpacity(0.4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryPurple.withOpacity(0.4),
                          ),
                          child: const Icon(
                            Icons.smart_toy_rounded,
                            color: AppColors.info,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: AppSizes.space12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Personalized Insight',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.goldAccent,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                sortedEntries.isNotEmpty
                                    ? 'Your ${sortedEntries.first.key.label.toLowerCase()} spending is your biggest category this month — worth keeping an eye on!'
                                    : 'Start tracking expenses to see personalized insights here.',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
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

/// Simple donut chart drawn with CustomPaint — no chart package dependency.
class _DonutChartPainter extends CustomPainter {
  final List<MapEntry<ExpenseCategory, double>> entries;
  final Map<ExpenseCategory, Color> colors;
  final double total;

  _DonutChartPainter({
    required this.entries,
    required this.colors,
    required this.total,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (total == 0 || entries.isEmpty) {
      final emptyPaint = Paint()
        ..color = const Color(0xFF2A235A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 24;
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 2 - 12,
        emptyPaint,
      );
      return;
    }

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    double startAngle = -math.pi / 2;

    for (final entry in entries) {
      final sweepAngle = (entry.value / total) * 2 * math.pi;
      final paint = Paint()
        ..color = colors[entry.key] ?? Colors.grey
        ..style = PaintingStyle.stroke
        ..strokeWidth = 24
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) => true;
}
