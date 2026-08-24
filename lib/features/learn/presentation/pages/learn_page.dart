import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/lesson_entity.dart';
import '../bloc/learn_bloc.dart';
import '../bloc/learn_event.dart';
import '../bloc/learn_state.dart';
import 'lesson_detail_page.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LearnBloc()..add(const LearnStarted()),
      child: const _LearnView(),
    );
  }
}

class _LearnView extends StatelessWidget {
  const _LearnView();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: SafeArea(
        child: BlocBuilder<LearnBloc, LearnState>(
          builder: (context, state) {
            if (state.status == LearnStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.goldAccent),
              );
            }

            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPaddingH,
                vertical: AppSizes.space16,
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Learn', style: AppTextStyles.h3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.glassCard,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: AppColors.goldAccent,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Level 7',
                            style: TextStyle(
                              color: AppColors.goldAccent,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.space16),

                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Learning Progress',
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(height: AppSizes.space8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: state.overallProgress,
                          minHeight: 6,
                          backgroundColor: AppColors.darkPurple,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.goldAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.space4),
                      Text(
                        '${state.completedCount} of ${state.allLessons.length} lessons completed',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.space16),

                _TopicFilterRow(activeFilter: state.activeFilter),
                const SizedBox(height: AppSizes.space16),

                ...state.filteredLessons.map(
                  (lesson) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.space12),
                    child: _LessonCard(lesson: lesson),
                  ),
                ),
                const SizedBox(height: AppSizes.space48),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TopicFilterRow extends StatelessWidget {
  final LessonTopic? activeFilter;
  const _TopicFilterRow({required this.activeFilter});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(
            label: 'All',
            isActive: activeFilter == null,
            onTap: () => context.read<LearnBloc>().add(
              const LearnTopicFilterChanged(null),
            ),
          ),
          ...LessonTopic.values.map(
            (t) => Padding(
              padding: const EdgeInsets.only(left: AppSizes.space8),
              child: _FilterChip(
                label: t.label,
                isActive: activeFilter == t,
                onTap: () =>
                    context.read<LearnBloc>().add(LearnTopicFilterChanged(t)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.goldAccent : AppColors.glassCard,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isActive ? AppColors.darkPurple : AppColors.secondaryText,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final LessonEntity lesson;
  const _LessonCard({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final bloc = context.read<LearnBloc>();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: bloc,
              child: LessonDetailPage(lessonId: lesson.id),
            ),
          ),
        );
      },
      child: GlassCard(
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryPurple.withOpacity(0.3),
              ),
              child: Icon(lesson.topic.icon, color: AppColors.goldAccent),
            ),
            const SizedBox(width: AppSizes.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lesson.title, style: AppTextStyles.h3),
                  const SizedBox(height: 2),
                  Text(lesson.description, style: AppTextStyles.bodySmall),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: AppColors.secondaryText,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${lesson.durationMinutes} min',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (lesson.isCompleted)
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.successGreen,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Start',
                  style: AppTextStyles.caption.copyWith(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
