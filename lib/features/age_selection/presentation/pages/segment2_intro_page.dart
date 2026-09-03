import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

/// Shown only when the user picked Ages 16–18 on Age Selection.
/// Mature, "young adult prepping for independence" tone — no game
/// language, matches the Segment 2 design system.
class Segment2IntroPage extends StatelessWidget {
  const Segment2IntroPage({super.key});

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
              children: [
                const Spacer(),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueGrey.withOpacity(0.25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.3),
                        blurRadius: 50,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.laptop_mac_rounded,
                    size: 80,
                    color: AppColors.goldAccent,
                  ),
                ),
                const SizedBox(height: AppSizes.space32),
                Text(
                  'Get ready for financial independence',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h2,
                ),
                const SizedBox(height: AppSizes.space8),
                Text(
                  'Real budgeting, real goals, real-world skills',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge,
                ),
                const Spacer(),
                PrimaryButton(
                  label: 'Continue',
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                  },
                ),
                const SizedBox(height: AppSizes.space32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
