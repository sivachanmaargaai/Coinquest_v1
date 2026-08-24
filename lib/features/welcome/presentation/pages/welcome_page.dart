import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

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
                const SizedBox(height: AppSizes.space48),

                // Small logo mark
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.goldAccent,
                  ),
                  child: Center(
                    child: Text(
                      'C',
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.darkPurple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.space8),
                Text('Play. Learn. Save. Grow.', style: AppTextStyles.caption),

                const Spacer(),

                // Mascot placeholder pair — swap with real illustration later
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _MascotCircle(
                      color: AppColors.primaryPurple,
                      icon: Icons.face_rounded,
                    ),
                    const SizedBox(width: AppSizes.space16),
                    _MascotCircle(
                      color: AppColors.goldAccent,
                      icon: Icons.face_3_rounded,
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.space32),

                Text(
                  'Welcome to CoinQuest',
                  style: AppTextStyles.h2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.space8),
                Text(
                  'Your journey to smart money starts here',
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),

                const Spacer(),

                PrimaryButton(
                  label: 'Sign Up',
                  variant: ButtonVariant.gold,
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.signUp);
                  },
                ),
                const SizedBox(height: AppSizes.space12),
                PrimaryButton(
                  label: 'Log In',
                  variant: ButtonVariant.outline,
                  onPressed: () {
                    // TODO: wire to Login screen once built
                  },
                ),
                const SizedBox(height: AppSizes.space12),
                PrimaryButton(
                  label: 'Continue as Guest',
                  variant: ButtonVariant.ghost,
                  onPressed: () {
                    // TODO: wire to Home (guest mode) once built
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

class _MascotCircle extends StatelessWidget {
  final Color color;
  final IconData icon;

  const _MascotCircle({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.25),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Icon(icon, size: 44, color: color),
    );
  }
}
