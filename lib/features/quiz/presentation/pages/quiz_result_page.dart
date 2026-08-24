import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';

class QuizResultPage extends StatelessWidget {
  final int correctCount;
  final int totalQuestions;

  const QuizResultPage({
    super.key,
    required this.correctCount,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final double scorePercent = totalQuestions == 0
        ? 0
        : correctCount / totalQuestions;
    final int xpEarned = correctCount * 10;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPaddingH,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                          value: scorePercent,
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
                            '$correctCount/$totalQuestions',
                            style: AppTextStyles.h1,
                          ),
                          Text('Correct', style: AppTextStyles.caption),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.space24),
                Text('Great Job!', style: AppTextStyles.h2),
                const SizedBox(height: AppSizes.space8),
                Text(
                  "You're getting smarter with money every day",
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.space24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.space16,
                    vertical: AppSizes.space16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.glassCard,
                    borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _RewardChip(
                        icon: Icons.star_rounded,
                        label: '+$xpEarned XP',
                      ),
                      const _RewardChip(
                        icon: Icons.emoji_events_rounded,
                        label: 'New Badge',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.space32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).popUntil((r) => r.isFirst),
                    child: const Text('Continue Learning'),
                  ),
                ),
                const SizedBox(height: AppSizes.space12),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RewardChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _RewardChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.goldAccent, size: 28),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}
