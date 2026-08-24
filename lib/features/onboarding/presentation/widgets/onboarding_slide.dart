import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Single onboarding slide layout — reused for all 3 slides
/// (Problem, Learn, Save). Only the icon/title/subtitle differ.
class OnboardingSlide extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const OnboardingSlide({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration placeholder — replace with mascot PNG/SVG later
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryPurple.withOpacity(0.25),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withOpacity(0.35),
                  blurRadius: 60,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Icon(icon, size: 96, color: AppColors.goldAccent),
          ),
          const SizedBox(height: AppSizes.space32),
          Text(title, textAlign: TextAlign.center, style: AppTextStyles.h2),
          const SizedBox(height: AppSizes.space8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge,
          ),
        ],
      ),
    );
  }
}
