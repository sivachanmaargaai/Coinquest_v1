import 'package:coinquest_v1_app/features/learn/domain/entities/lesson_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';
import '../bloc/learn_bloc.dart';
import '../bloc/learn_event.dart';
import '../bloc/learn_state.dart';
import 'lesson_completed_page.dart';

class LessonDetailPage extends StatefulWidget {
  final String lessonId;
  const LessonDetailPage({super.key, required this.lessonId});

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: BlocBuilder<LearnBloc, LearnState>(
            builder: (context, state) {
              final lesson = state.allLessons.firstWhere(
                (l) => l.id == widget.lessonId,
              );
              final totalSteps = lesson.content.length;
              final isLastStep = _step == totalSteps - 1;

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
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.primaryText,
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            lesson.title,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.h3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.bookmark_border_rounded,
                          color: AppColors.primaryText,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.space16),

                    // Hero banner
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.glassCard,
                        borderRadius: BorderRadius.circular(
                          AppSizes.cardRadius,
                        ),
                      ),
                      child: Icon(
                        lesson.topic.icon,
                        size: 56,
                        color: AppColors.goldAccent,
                      ),
                    ),
                    const SizedBox(height: AppSizes.space16),

                    Row(
                      children: [
                        Text(
                          'Step ${_step + 1} of $totalSteps',
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(width: AppSizes.space8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: (_step + 1) / totalSteps,
                              minHeight: 4,
                              backgroundColor: AppColors.darkPurple,
                              valueColor: const AlwaysStoppedAnimation(
                                AppColors.goldAccent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.space16),

                    Expanded(
                      child: SingleChildScrollView(
                        child: GlassCard(
                          child: Text(
                            lesson.content[_step],
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.primaryText,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.space16,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (isLastStep) {
                              context.read<LearnBloc>().add(
                                LessonMarkedCompleted(lesson.id),
                              );
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => LessonCompletedPage(
                                    lessonTitle: lesson.title,
                                  ),
                                ),
                              );
                            } else {
                              setState(() => _step++);
                            }
                          },
                          label: Text(
                            isLastStep ? 'Finish Lesson' : 'Continue',
                          ),
                          icon: const Icon(Icons.chevron_right_rounded),
                        ),
                      ),
                    ),
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
