import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';
import '../bloc/leaderboard_bloc.dart';
import '../bloc/leaderboard_event.dart';
import '../bloc/leaderboard_state.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LeaderboardBloc()..add(const LeaderboardStarted()),
      child: const _LeaderboardView(),
    );
  }
}

class _LeaderboardView extends StatelessWidget {
  const _LeaderboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
            builder: (context, state) {
              if (state.status == LeaderboardStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.goldAccent),
                );
              }

              final top3 = state.entries.take(3).toList();
              final rest = state.entries.skip(3).toList();

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
                            'Leaderboard',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.h3,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: AppSizes.space16),

                    _ScopeTabs(isAllTime: state.isAllTime),
                    const SizedBox(height: AppSizes.space24),

                    if (top3.length == 3) _PodiumRow(top3: top3),

                    const SizedBox(height: AppSizes.space24),

                    Expanded(
                      child: ListView(
                        children: rest
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSizes.space8,
                                ),
                                child: _RankRow(entry: e),
                              ),
                            )
                            .toList(),
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

class _ScopeTabs extends StatelessWidget {
  final bool isAllTime;
  const _ScopeTabs({required this.isAllTime});

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
            label: 'This Week',
            isActive: !isAllTime,
            onTap: () {
              context.read<LeaderboardBloc>().add(
                const LeaderboardScopeChanged(false),
              );
            },
          ),
          _Tab(
            label: 'All Time',
            isActive: isAllTime,
            onTap: () {
              context.read<LeaderboardBloc>().add(
                const LeaderboardScopeChanged(true),
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

class _PodiumRow extends StatelessWidget {
  final List<LeaderboardEntryEntity> top3;
  const _PodiumRow({required this.top3});

  @override
  Widget build(BuildContext context) {
    final first = top3[0];
    final second = top3[1];
    final third = top3[2];

    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _PodiumSpot(
            entry: second,
            size: 56,
            ringColor: const Color(0xFFC0C0C0),
          ),
          _PodiumSpot(
            entry: first,
            size: 72,
            ringColor: AppColors.goldAccent,
            showCrown: true,
          ),
          _PodiumSpot(
            entry: third,
            size: 56,
            ringColor: const Color(0xFFCD7F32),
          ),
        ],
      ),
    );
  }
}

class _PodiumSpot extends StatelessWidget {
  final LeaderboardEntryEntity entry;
  final double size;
  final Color ringColor;
  final bool showCrown;

  const _PodiumSpot({
    required this.entry,
    required this.size,
    required this.ringColor,
    this.showCrown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showCrown)
          const Icon(
            Icons.emoji_events_rounded,
            color: AppColors.goldAccent,
            size: 24,
          ),
        const SizedBox(height: 4),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryPurple.withOpacity(0.3),
            border: Border.all(color: ringColor, width: 3),
          ),
          child: Icon(Icons.face_rounded, color: ringColor, size: size * 0.5),
        ),
        const SizedBox(height: 6),
        Text(
          entry.name,
          style: AppTextStyles.bodySmall,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${entry.xp} XP',
          style: AppTextStyles.caption.copyWith(color: AppColors.goldAccent),
        ),
      ],
    );
  }
}

class _RankRow extends StatelessWidget {
  final LeaderboardEntryEntity entry;
  const _RankRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: entry.isCurrentUser
          ? AppColors.goldAccent.withOpacity(0.6)
          : AppColors.primaryPurple.withOpacity(0.3),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.space16,
        vertical: AppSizes.space12,
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.darkPurple,
            ),
            child: Center(
              child: Text('${entry.rank}', style: AppTextStyles.bodySmall),
            ),
          ),
          const SizedBox(width: AppSizes.space12),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryPurple.withOpacity(0.3),
            ),
            child: const Icon(
              Icons.face_rounded,
              color: AppColors.goldAccent,
              size: 18,
            ),
          ),
          const SizedBox(width: AppSizes.space12),
          Expanded(
            child: Text(
              entry.name,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.primaryText,
              ),
            ),
          ),
          if (entry.isCurrentUser)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.goldAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'You',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.darkPurple,
                ),
              ),
            ),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 14,
                color: AppColors.goldAccent,
              ),
              const SizedBox(width: 4),
              Text(
                '${entry.xp}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.goldAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
