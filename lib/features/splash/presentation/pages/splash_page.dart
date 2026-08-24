import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/splash_bloc.dart';
import '../bloc/splash_event.dart';
import '../bloc/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashBloc()..add(const SplashStarted()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashCompleted) {
            // First launch -> Onboarding. Otherwise -> Welcome/Home later.
            Navigator.of(context).pushReplacementNamed(
              state.isFirstLaunch ? AppRoutes.onboarding : AppRoutes.welcome,
            );
          }
        },
        child: const _SplashView(),
      ),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Soft ambient glow behind the logo
            Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryPurple.withOpacity(0.25),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple.withOpacity(0.4),
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo placeholder — swap with Image.asset later
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.goldAccent,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.goldAccent.withOpacity(0.5),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'C',
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.darkPurple,
                        fontSize: 48,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.space24),
                Text('CoinQuest', style: AppTextStyles.h1),
                const SizedBox(height: AppSizes.space8),
                Text(
                  'Play. Learn. Save. Grow.',
                  style: AppTextStyles.bodyLarge,
                ),
              ],
            ),
            Positioned(
              bottom: 80,
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.goldAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
