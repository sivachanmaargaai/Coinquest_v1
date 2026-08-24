import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/expense_entity.dart';

/// Full-screen category picker. Returns the selected ExpenseCategory
/// via Navigator.pop(context, category) — used by Add Expense screen.
class CategoryPickerPage extends StatefulWidget {
  final ExpenseCategory? initialCategory;

  const CategoryPickerPage({super.key, this.initialCategory});

  @override
  State<CategoryPickerPage> createState() => _CategoryPickerPageState();
}

class _CategoryPickerPageState extends State<CategoryPickerPage> {
  ExpenseCategory? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialCategory;
  }

  static const Map<ExpenseCategory, (IconData, Color)> _config = {
    ExpenseCategory.food: (Icons.restaurant_rounded, Color(0xFFFF9F43)),
    ExpenseCategory.transport: (
      Icons.directions_bus_rounded,
      Color(0xFF6EE7FF),
    ),
    ExpenseCategory.entertainment: (
      Icons.sports_esports_rounded,
      Color(0xFFFF6FA6),
    ),
    ExpenseCategory.shopping: (Icons.shopping_bag_rounded, Color(0xFFA78BFA)),
    ExpenseCategory.education: (Icons.school_rounded, Color(0xFF34C759)),
    ExpenseCategory.other: (Icons.more_horiz_rounded, Color(0xFFCFC8FF)),
  };

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
                        'Select Category',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h3,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: AppSizes.space16),

                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: AppSizes.space16,
                    crossAxisSpacing: AppSizes.space16,
                    children: ExpenseCategory.values.map((cat) {
                      final (icon, color) = _config[cat]!;
                      final bool isSelected = _selected == cat;
                      return GestureDetector(
                        onTap: () => setState(() => _selected = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          decoration: BoxDecoration(
                            color: AppColors.glassCard,
                            borderRadius: BorderRadius.circular(
                              AppSizes.cardRadius,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.goldAccent
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color.withOpacity(0.25),
                                ),
                                child: Icon(icon, color: color, size: 26),
                              ),
                              const SizedBox(height: AppSizes.space8),
                              Text(cat.label, style: AppTextStyles.bodySmall),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.space24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selected == null
                          ? null
                          : () => Navigator.of(context).pop(_selected),
                      child: const Text('Confirm Selection'),
                    ),
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
