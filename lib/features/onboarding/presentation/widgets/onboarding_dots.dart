import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Progress dots: active dot is a wide gold pill, inactive dots are small
/// circles — matches the onboarding Stitch prompt spec.
class OnboardingDots extends StatelessWidget {
  final int currentIndex;
  final int total;

  const OnboardingDots({
    super.key,
    required this.currentIndex,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final bool isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.goldAccent : AppColors.secondaryText,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
