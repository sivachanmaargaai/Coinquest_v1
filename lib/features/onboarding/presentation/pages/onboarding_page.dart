import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/onboarding_dots.dart';
import '../widgets/onboarding_slide.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  late final PageController _controller;

  static const List<Map<String, dynamic>> _slides = [
    {
      'icon': Icons.help_outline_rounded,
      'title': 'Managing money is confusing',
      'subtitle': 'Most teens never learn how to save, budget, or spend smart',
    },
    {
      'icon': Icons.emoji_events_rounded,
      'title': 'Learn money skills the fun way',
      'subtitle': 'Bite-sized lessons and quizzes that actually stick',
    },
    {
      'icon': Icons.savings_rounded,
      'title': 'Save smarter, reach your goals',
      'subtitle': 'Set goals, track progress, and celebrate wins',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToWelcome() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state.isFinished) {
          _goToWelcome();
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
              child: Column(
                children: [
                  // Skip button (hidden on last slide)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.space16,
                        vertical: AppSizes.space8,
                      ),
                      child: Opacity(
                        opacity: state.isLastPage ? 0 : 1,
                        child: TextButton(
                          onPressed: state.isLastPage
                              ? null
                              : () => context.read<OnboardingBloc>().add(
                                  const OnboardingSkipped(),
                                ),
                          child: const Text('Skip'),
                        ),
                      ),
                    ),
                  ),

                  // Slides
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _slides.length,
                      onPageChanged: (index) {
                        context.read<OnboardingBloc>().add(
                          OnboardingPageChanged(index),
                        );
                      },
                      itemBuilder: (context, index) {
                        final slide = _slides[index];
                        return OnboardingSlide(
                          icon: slide['icon'] as IconData,
                          title: slide['title'] as String,
                          subtitle: slide['subtitle'] as String,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: AppSizes.space24),

                  OnboardingDots(
                    currentIndex: state.currentPage,
                    total: state.totalPages,
                  ),

                  const SizedBox(height: AppSizes.space24),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.screenPaddingH,
                    ),
                    child: PrimaryButton(
                      label: state.isLastPage ? 'Get Started' : 'Next',
                      onPressed: () {
                        if (state.isLastPage) {
                          context.read<OnboardingBloc>().add(
                            const OnboardingCompleted(),
                          );
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: AppSizes.space32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
