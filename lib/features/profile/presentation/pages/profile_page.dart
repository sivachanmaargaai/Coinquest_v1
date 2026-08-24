import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/badge_entity.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../../../monthly_report/presentation/pages/monthly_report_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc()..add(const ProfileStarted()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.status == ProfileStatus.loggedOut) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.welcome, (route) => false);
            }
          },
          builder: (context, state) {
            if (state.status == ProfileStatus.loading) {
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
                    Text('Profile', style: AppTextStyles.h3),
                    const Icon(
                      Icons.settings_rounded,
                      color: AppColors.primaryText,
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.space24),

                // Hero
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryPurple.withOpacity(0.3),
                          border: Border.all(
                            color: AppColors.goldAccent,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.goldAccent.withOpacity(0.4),
                              blurRadius: 24,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.face_rounded,
                          color: AppColors.goldAccent,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: AppSizes.space12),
                      Text(state.name, style: AppTextStyles.h2),
                      const SizedBox(height: 4),
                      Text(
                        'Age Group: ${state.ageGroupLabel}',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: AppSizes.space8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.goldAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: AppColors.darkPurple,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Level ${state.level} • Money Explorer',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.darkPurple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.space24),

                // Stat chips
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.star_rounded,
                        value: '${state.totalXp}',
                        label: 'XP',
                      ),
                    ),
                    const SizedBox(width: AppSizes.space12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.emoji_events_rounded,
                        value: '${state.badgeCount}',
                        label: 'Badges',
                      ),
                    ),
                    const SizedBox(width: AppSizes.space12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.local_fire_department_rounded,
                        value: '${state.streakDays}d',
                        label: 'Streak',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.space24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('My Badges', style: AppTextStyles.h3),
                    TextButton(onPressed: () {}, child: const Text('See all')),
                  ],
                ),
                const SizedBox(height: AppSizes.space8),

                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.badges.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppSizes.space12),
                    itemBuilder: (context, i) =>
                        _BadgeCircle(badge: state.badges[i]),
                  ),
                ),

                const SizedBox(height: AppSizes.space24),

                // Settings list
                _SettingsRow(
                  icon: Icons.manage_accounts_rounded,
                  label: 'Account Settings',
                  onTap: () {},
                ),
                _SettingsRow(
                  icon: Icons.family_restroom_rounded,
                  label: 'Connected Parent',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.successGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Linked ✓',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.successGreen,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
                _SettingsRow(
                  icon: Icons.bar_chart_rounded,
                  label: 'Monthly Report',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MonthlyReportPage(),
                      ),
                    );
                  },
                ),
                _SettingsRow(
                  icon: Icons.notifications_none_rounded,
                  label: 'Notifications',
                  onTap: () {},
                ),
                _SettingsRow(
                  icon: Icons.help_outline_rounded,
                  label: 'Help & Support',
                  onTap: () {},
                ),
                _SettingsRow(
                  icon: Icons.logout_rounded,
                  label: 'Log Out',
                  isDestructive: true,
                  onTap: () {
                    context.read<ProfileBloc>().add(
                      const ProfileLogoutRequested(),
                    );
                  },
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.space16),
      child: Column(
        children: [
          Icon(icon, color: AppColors.goldAccent, size: 22),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.h3),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _BadgeCircle extends StatelessWidget {
  final BadgeEntity badge;
  const _BadgeCircle({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: badge.isUnlocked
                    ? AppColors.glassCard
                    : AppColors.glassCard.withOpacity(0.4),
                border: Border.all(
                  color: badge.isUnlocked
                      ? AppColors.goldAccent.withOpacity(0.6)
                      : AppColors.secondaryText.withOpacity(0.3),
                ),
              ),
              child: Icon(
                badge.icon,
                color: badge.isUnlocked
                    ? AppColors.goldAccent
                    : AppColors.secondaryText,
                size: 24,
              ),
            ),
            if (!badge.isUnlocked)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.darkPurple,
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    size: 10,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(badge.label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final bool isDestructive;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.warning : AppColors.primaryText;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.space8),
      child: GestureDetector(
        onTap: onTap,
        child: GlassCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.space16,
            vertical: AppSizes.space12,
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: AppSizes.space12),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyLarge.copyWith(color: color),
                ),
              ),
              if (trailing != null) trailing!,
              if (!isDestructive)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.secondaryText,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
