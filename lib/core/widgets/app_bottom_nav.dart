import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../theme/app_text_styles.dart';

enum AppNavTab { home, budget, learn, challenge, profile }

/// Bottom Navigation Bar — always Home | Budget | Learn | Challenge | Profile.
/// Reused on every main app screen (design system rule).
class AppBottomNav extends StatelessWidget {
  final AppNavTab currentTab;
  final ValueChanged<AppNavTab> onTabSelected;

  const AppBottomNav({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  static const _items = [
    (tab: AppNavTab.home, icon: Icons.home_rounded, label: 'Home'),
    (
      tab: AppNavTab.budget,
      icon: Icons.account_balance_wallet_rounded,
      label: 'Budget',
    ),
    (tab: AppNavTab.learn, icon: Icons.menu_book_rounded, label: 'Learn'),
    (
      tab: AppNavTab.challenge,
      icon: Icons.emoji_events_rounded,
      label: 'Challenge',
    ),
    (tab: AppNavTab.profile, icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.space8),
      decoration: BoxDecoration(
        color: AppColors.glassCard,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.screenRadius),
          topRight: Radius.circular(AppSizes.screenRadius),
        ),
        border: Border(
          top: BorderSide(color: AppColors.primaryPurple.withOpacity(0.3)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _items.map((item) {
          final bool isActive = item.tab == currentTab;
          return InkWell(
            onTap: () => onTabSelected(item.tab),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.space12,
                vertical: AppSizes.space8,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.goldAccent.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    size: 24,
                    color: isActive
                        ? AppColors.goldAccent
                        : AppColors.secondaryText,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.label,
                    style: AppTextStyles.caption.copyWith(
                      color: isActive
                          ? AppColors.goldAccent
                          : AppColors.secondaryText,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
