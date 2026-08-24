import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../quiz/presentation/pages/quiz_question_page.dart';

class LessonCompletedPage extends StatelessWidget {
  final String lessonTitle;
  const LessonCompletedPage({super.key, required this.lessonTitle});

  @override
  Widget build(BuildContext context) {
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
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.goldAccent.withOpacity(0.2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.goldAccent.withOpacity(0.4),
                        blurRadius: 40,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    size: 72,
                    color: AppColors.goldAccent,
                  ),
                ),
                const SizedBox(height: AppSizes.space32),
                Text(
                  'Lesson Completed! 🎉',
                  style: AppTextStyles.h2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.space8),
                Text(
                  "You've mastered $lessonTitle",
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
                    children: const [
                      _RewardChip(icon: Icons.star_rounded, label: '+50 XP'),
                      _RewardChip(
                        icon: Icons.emoji_events_rounded,
                        label: 'Badge Earned',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.space32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const QuizQuestionPage(),
                        ),
                      );
                    },
                    child: const Text('Take Quiz'),
                  ),
                ),
                const SizedBox(height: AppSizes.space12),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                  child: const Text('Back to Lessons'),
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
