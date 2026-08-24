import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/age_selection_bloc.dart';
import '../bloc/age_selection_event.dart';
import '../bloc/age_selection_state.dart';

class AgeSelectionPage extends StatelessWidget {
  const AgeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AgeSelectionBloc(),
      child: const _AgeSelectionView(),
    );
  }
}

class _AgeSelectionView extends StatelessWidget {
  const _AgeSelectionView();

  void _goToHome(BuildContext context) {
    // TODO: replace with real Home route once built (Screen 8)
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AgeSelectionBloc, AgeSelectionState>(
      listener: (context, state) {
        if (state.isConfirmed) {
          _goToHome(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPaddingH,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.space8),

                    // Header row: back arrow + step progress
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
                        const Spacer(),
                        _StepProgress(currentStep: 1, totalSteps: 2),
                        const Spacer(),
                        const SizedBox(width: 48), // balance the back button
                      ],
                    ),

                    const SizedBox(height: AppSizes.space32),

                    Center(
                      child: Text(
                        'How old are you?',
                        style: AppTextStyles.h2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppSizes.space8),
                    Center(
                      child: Text(
                        'This helps us personalize your experience',
                        style: AppTextStyles.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: AppSizes.space32),

                    _AgeGroupCard(
                      icon: Icons.face_rounded,
                      title: 'Ages 13–15',
                      subtitle: 'Learning the basics of saving & spending',
                      isSelected: state.selectedGroup == AgeGroup.teen1315,
                      onTap: () => context.read<AgeSelectionBloc>().add(
                        const AgeGroupSelected(AgeGroup.teen1315),
                      ),
                    ),
                    const SizedBox(height: AppSizes.space16),
                    _AgeGroupCard(
                      icon: Icons.face_6_rounded,
                      title: 'Ages 16–18',
                      subtitle: 'Preparing for financial independence',
                      isSelected: state.selectedGroup == AgeGroup.teen1618,
                      onTap: () => context.read<AgeSelectionBloc>().add(
                        const AgeGroupSelected(AgeGroup.teen1618),
                      ),
                    ),

                    const Spacer(),

                    PrimaryButton(
                      label: 'Continue',
                      onPressed: state.canContinue
                          ? () => context.read<AgeSelectionBloc>().add(
                              const AgeSelectionConfirmed(),
                            )
                          : null,
                    ),

                    const SizedBox(height: AppSizes.space32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StepProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepProgress({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Row(
        children: List.generate(totalSteps, (index) {
          final bool isFilled = index < currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 4),
              decoration: BoxDecoration(
                color: isFilled
                    ? AppColors.goldAccent
                    : AppColors.secondaryText.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _AgeGroupCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _AgeGroupCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSizes.space16),
        decoration: BoxDecoration(
          color: AppColors.glassCard,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          border: Border.all(
            color: isSelected
                ? AppColors.goldAccent
                : AppColors.primaryPurple.withOpacity(0.4),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.goldAccent.withOpacity(0.3),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryPurple.withOpacity(0.3),
              ),
              child: Icon(icon, size: 32, color: AppColors.goldAccent),
            ),
            const SizedBox(width: AppSizes.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h3),
                  const SizedBox(height: AppSizes.space4),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldAccent,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: AppColors.darkPurple,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
