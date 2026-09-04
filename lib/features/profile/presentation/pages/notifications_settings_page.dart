import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({super.key});

  @override
  State<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _expenseReminders = true;
  bool _budgetAlerts = true;
  bool _savingsMilestones = true;
  bool _lessonReminders = false;
  bool _challengeUpdates = true;
  bool _streakReminders = true;

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
                        'Notifications',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h3,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: AppSizes.space16),

                Expanded(
                  child: ListView(
                    children: [
                      _NotificationToggle(
                        icon: Icons.receipt_long_rounded,
                        title: 'Expense Reminders',
                        subtitle: 'Remind me to log daily expenses',
                        value: _expenseReminders,
                        onChanged: (v) => setState(() => _expenseReminders = v),
                      ),
                      _NotificationToggle(
                        icon: Icons.account_balance_wallet_rounded,
                        title: 'Budget Alerts',
                        subtitle: 'Notify when nearing category limits',
                        value: _budgetAlerts,
                        onChanged: (v) => setState(() => _budgetAlerts = v),
                      ),
                      _NotificationToggle(
                        icon: Icons.savings_rounded,
                        title: 'Savings Milestones',
                        subtitle: 'Celebrate goal progress milestones',
                        value: _savingsMilestones,
                        onChanged: (v) =>
                            setState(() => _savingsMilestones = v),
                      ),
                      _NotificationToggle(
                        icon: Icons.menu_book_rounded,
                        title: 'Lesson Reminders',
                        subtitle: 'Nudge to complete lessons',
                        value: _lessonReminders,
                        onChanged: (v) => setState(() => _lessonReminders = v),
                      ),
                      _NotificationToggle(
                        icon: Icons.emoji_events_rounded,
                        title: 'Challenge Updates',
                        subtitle: 'New challenges and progress updates',
                        value: _challengeUpdates,
                        onChanged: (v) => setState(() => _challengeUpdates = v),
                      ),
                      _NotificationToggle(
                        icon: Icons.local_fire_department_rounded,
                        title: 'Streak Reminders',
                        subtitle: "Don't lose your streak!",
                        value: _streakReminders,
                        onChanged: (v) => setState(() => _streakReminders = v),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.space12),
      child: GlassCard(
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryPurple.withOpacity(0.3),
              ),
              child: Icon(icon, color: AppColors.goldAccent, size: 20),
            ),
            const SizedBox(width: AppSizes.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.primaryText,
                    ),
                  ),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.goldAccent,
              activeTrackColor: AppColors.goldAccent.withOpacity(0.3),
              inactiveThumbColor: AppColors.secondaryText,
              inactiveTrackColor: AppColors.darkPurple,
            ),
          ],
        ),
      ),
    );
  }
}
