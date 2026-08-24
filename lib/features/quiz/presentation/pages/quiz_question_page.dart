import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';
import '../bloc/quiz_state.dart';
import 'quiz_result_page.dart';

class QuizQuestionPage extends StatelessWidget {
  const QuizQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizBloc()..add(const QuizStarted()),
      child: const _QuizView(),
    );
  }
}

class _QuizView extends StatelessWidget {
  const _QuizView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: BlocConsumer<QuizBloc, QuizState>(
            listener: (context, state) {
              if (state.status == QuizStatus.finished) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => QuizResultPage(
                      correctCount: state.correctCount,
                      totalQuestions: state.questions.length,
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.status == QuizStatus.loading ||
                  state.currentQuestion == null) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.goldAccent),
                );
              }

              final q = state.currentQuestion!;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPaddingH,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppSizes.space8),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.primaryText,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Question ${state.currentIndex + 1} of ${state.questions.length}',
                                style: AppTextStyles.caption,
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value:
                                      (state.currentIndex + 1) /
                                      state.questions.length,
                                  minHeight: 4,
                                  backgroundColor: AppColors.darkPurple,
                                  valueColor: const AlwaysStoppedAnimation(
                                    AppColors.goldAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: AppSizes.space32),

                    Container(
                      padding: const EdgeInsets.all(AppSizes.space24),
                      decoration: BoxDecoration(
                        color: AppColors.glassCard,
                        borderRadius: BorderRadius.circular(
                          AppSizes.cardRadius,
                        ),
                      ),
                      child: Text(
                        q.question,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h3,
                      ),
                    ),

                    const SizedBox(height: AppSizes.space24),

                    Expanded(
                      child: ListView(
                        children: q.options.map((opt) {
                          final bool isSelected =
                              state.selectedOptionId == opt.id;
                          final bool showResult = state.answerSubmitted;
                          final bool isCorrectOption =
                              opt.id == q.correctOptionId;

                          Color borderColor = AppColors.primaryPurple
                              .withOpacity(0.4);
                          Color? fillColor;

                          if (showResult) {
                            if (isCorrectOption) {
                              borderColor = AppColors.successGreen;
                              fillColor = AppColors.successGreen.withOpacity(
                                0.15,
                              );
                            } else if (isSelected && !isCorrectOption) {
                              borderColor = AppColors.warning;
                              fillColor = AppColors.warning.withOpacity(0.15);
                            }
                          } else if (isSelected) {
                            borderColor = AppColors.goldAccent;
                            fillColor = AppColors.goldAccent.withOpacity(0.15);
                          }

                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSizes.space12,
                            ),
                            child: GestureDetector(
                              onTap: () => context.read<QuizBloc>().add(
                                QuizOptionSelected(opt.id),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(AppSizes.space16),
                                decoration: BoxDecoration(
                                  color: fillColor ?? AppColors.glassCard,
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.buttonRadius,
                                  ),
                                  border: Border.all(
                                    color: borderColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        opt.text,
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          color: AppColors.primaryText,
                                        ),
                                      ),
                                    ),
                                    if (showResult && isCorrectOption)
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: AppColors.successGreen,
                                        size: 20,
                                      ),
                                    if (showResult &&
                                        isSelected &&
                                        !isCorrectOption)
                                      const Icon(
                                        Icons.cancel_rounded,
                                        color: AppColors.warning,
                                        size: 20,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    if (state.answerSubmitted) ...[
                      Container(
                        padding: const EdgeInsets.all(AppSizes.space12),
                        margin: const EdgeInsets.only(bottom: AppSizes.space12),
                        decoration: BoxDecoration(
                          color: AppColors.glassCard,
                          borderRadius: BorderRadius.circular(
                            AppSizes.cardRadius,
                          ),
                        ),
                        child: Text(
                          q.explanation,
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                    ],

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.selectedOptionId == null
                            ? null
                            : () {
                                if (!state.answerSubmitted) {
                                  context.read<QuizBloc>().add(
                                    const QuizAnswerSubmitted(),
                                  );
                                } else {
                                  context.read<QuizBloc>().add(
                                    const QuizNextQuestion(),
                                  );
                                }
                              },
                        child: Text(
                          state.answerSubmitted
                              ? (state.isLastQuestion
                                    ? 'See Results'
                                    : 'Next Question')
                              : 'Submit Answer',
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.space24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
