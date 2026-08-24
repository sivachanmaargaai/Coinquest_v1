import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Reusable glassmorphism card — base for Balance Card, Budget Card,
/// Savings Card, Lesson Card, etc.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final double borderWidth;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSizes.space16),
    this.borderColor,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.glassCard,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color: borderColor ?? AppColors.primaryPurple.withOpacity(0.3),
          width: borderWidth,
        ),
      ),
      child: child,
    );
  }
}
