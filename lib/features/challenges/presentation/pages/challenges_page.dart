import 'package:coinquest_v1_app/features/challenges/domain/entities/challenges_entity.dart';
import 'package:coinquest_v1_app/features/leaderboard/presentation/pages/leaderboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';

import '../bloc/challenges_bloc.dart';
import '../bloc/challenges_event.dart';
import '../bloc/challenges_state.dart';


class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChallengesBloc()..add(const ChallengesStarted()),
      child: const _ChallengesView(),
    );
  }
}

class _ChallengesView extends StatelessWidget {
  const _ChallengesView();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: SafeArea(
        child: BlocBuilder<ChallengesBloc, ChallengesState>(
          builder: (context, state) {
            if (state.status == ChallengesStatus.loading) {
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
                    Text('Challenges', style: AppTextStyles.h3),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LeaderboardPage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.local_fire_department_rounded,
                              size: 16,
                              color: Colors.orangeAccent,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${state.streakDays} Day Streak',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.orangeAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.space16),

                if (state.featured != null)
                  _FeaturedChallengeCard(challenge: state.featured!),
                const SizedBox(height: AppSizes.space16),

                _TabRow(showCompleted: state.showCompletedTab),
                const SizedBox(height: AppSizes.space16),

                ...state.visibleChallenges.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.space12),
                    child: _ChallengeCard(challenge: c),
                  ),
                ),

                if (state.visibleChallenges.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.space32,
                    ),
                    child: Center(
                      child: Text(
                        state.showCompletedTab
                            ? 'No completed challenges yet'
                            : 'No active challenges right now',
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                  ),

                const SizedBox(height: AppSizes.space16),

                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LeaderboardPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.leaderboard_rounded, size: 18),
                    label: const Text('View Leaderboard'),
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

class _FeaturedChallengeCard extends StatelessWidget {
  final ChallengeEntity challenge;
  const _FeaturedChallengeCard({required this.challenge});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: AppColors.goldAccent.withOpacity(0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔥 Weekly Challenge',
            style: AppTextStyles.caption.copyWith(color: AppColors.goldAccent),
          ),
          const SizedBox(height: AppSizes.space4),
          Text(challenge.title, style: AppTextStyles.h3),
          const SizedBox(height: AppSizes.space4),
          Text(challenge.description, style: AppTextStyles.bodySmall),
          const SizedBox(height: AppSizes.space12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: challenge.progress,
              minHeight: 6,
              backgroundColor: AppColors.darkPurple,
              valueColor: const AlwaysStoppedAnimation(AppColors.goldAccent),
            ),
          ),
          const SizedBox(height: AppSizes.space8),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.goldAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '+${challenge.xpReward} XP',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.darkPurple,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabRow extends StatelessWidget {
  final bool showCompleted;
  const _TabRow({required this.showCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.glassCard,
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
      ),
      child: Row(
        children: [
          _Tab(
            label: 'Active',
            isActive: !showCompleted,
            onTap: () {
              context.read<ChallengesBloc>().add(
                const ChallengesTabChanged(false),
              );
            },
          ),
          _Tab(
            label: 'Completed',
            isActive: showCompleted,
            onTap: () {
              context.read<ChallengesBloc>().add(
                const ChallengesTabChanged(true),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _Tab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: AppSizes.space8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.goldAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: isActive ? AppColors.darkPurple : AppColors.secondaryText,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final ChallengeEntity challenge;
  const _ChallengeCard({required this.challenge});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: challenge.isCompleted
                  ? AppColors.successGreen.withOpacity(0.2)
                  : AppColors.primaryPurple.withOpacity(0.3),
            ),
            child: Icon(
              challenge.type.icon,
              color: challenge.isCompleted
                  ? AppColors.successGreen
                  : AppColors.goldAccent,
            ),
          ),
          const SizedBox(width: AppSizes.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(challenge.title, style: AppTextStyles.h3),
                const SizedBox(height: 2),
                Text(challenge.description, style: AppTextStyles.bodySmall),
                if (!challenge.isCompleted) ...[
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: challenge.progress,
                      minHeight: 5,
                      backgroundColor: AppColors.darkPurple,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.goldAccent,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSizes.space8),
          if (challenge.isCompleted)
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.successGreen,
              size: 22,
            )
          else
            Text(
              '+${challenge.xpReward} XP',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.goldAccent,
              ),
            ),
        ],
      ),
    );
  }
}
