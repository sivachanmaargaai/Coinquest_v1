import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../theme/app_text_styles.dart';

enum ButtonVariant { gold, purple, outline, ghost }

/// Reusable button used across the whole app (Component Library).
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool fullWidth;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.gold,
    this.fullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: AppSizes.space8),
        ],
        Text(label),
      ],
    );

    Widget button;
    switch (variant) {
      case ButtonVariant.gold:
        button = ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.goldAccent,
            foregroundColor: AppColors.darkPurple,
          ),
          child: child,
        );
        break;
      case ButtonVariant.purple:
        button = ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryPurple,
            foregroundColor: AppColors.primaryText,
          ),
          child: child,
        );
        break;
      case ButtonVariant.outline:
        button = OutlinedButton(onPressed: onPressed, child: child);
        break;
      case ButtonVariant.ghost:
        button = TextButton(onPressed: onPressed, child: child);
        break;
    }

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
