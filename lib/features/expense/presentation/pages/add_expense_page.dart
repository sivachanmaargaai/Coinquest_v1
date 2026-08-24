import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/expense_entity.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import 'category_picker_page.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  ExpenseCategory _selectedCategory = ExpenseCategory.food;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickCategory() async {
    final result = await Navigator.of(context).push<ExpenseCategory>(
      MaterialPageRoute(
        builder: (_) => CategoryPickerPage(initialCategory: _selectedCategory),
      ),
    );
    if (result != null) {
      setState(() => _selectedCategory = result);
    }
  }

  void _save() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    context.read<ExpenseBloc>().add(
      ExpenseAdded(
        amount: amount,
        category: _selectedCategory,
        description: _descriptionController.text.trim().isEmpty
            ? _selectedCategory.label
            : _descriptionController.text.trim(),
      ),
    );

    Navigator.of(context).pop();
  }

  IconData get _categoryIcon {
    switch (_selectedCategory) {
      case ExpenseCategory.food:
        return Icons.restaurant_rounded;
      case ExpenseCategory.transport:
        return Icons.directions_bus_rounded;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag_rounded;
      case ExpenseCategory.entertainment:
        return Icons.sports_esports_rounded;
      case ExpenseCategory.education:
        return Icons.school_rounded;
      case ExpenseCategory.other:
        return Icons.more_horiz_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                const SizedBox(height: AppSizes.space16),
                Row(
                  children: [
                    const SizedBox(width: 48),
                    Expanded(
                      child: Text(
                        'Add Expense',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h3,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.space32),

                // Amount input
                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.center,
                  autofocus: true,
                  style: AppTextStyles.h1,
                  decoration: InputDecoration(
                    prefixText: '₹',
                    prefixStyle: AppTextStyles.h1,
                    hintText: '0',
                    hintStyle: AppTextStyles.h1.copyWith(
                      color: AppColors.secondaryText,
                    ),
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.goldAccent,
                        width: 2,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.goldAccent,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.space32),

                // Category selector (tap to open picker)
                GestureDetector(
                  onTap: _pickCategory,
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.space16),
                    decoration: BoxDecoration(
                      color: AppColors.glassCard,
                      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                      border: Border.all(
                        color: AppColors.primaryPurple.withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.goldAccent.withOpacity(0.2),
                          ),
                          child: Icon(
                            _categoryIcon,
                            color: AppColors.goldAccent,
                          ),
                        ),
                        const SizedBox(width: AppSizes.space12),
                        Expanded(
                          child: Text(
                            _selectedCategory.label,
                            style: AppTextStyles.bodyLarge,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.secondaryText,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.space16),

                // Description
                TextField(
                  controller: _descriptionController,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.primaryText,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Add description (optional)',
                    prefixIcon: Icon(
                      Icons.notes_rounded,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.space16),

                Row(
                  children: [
                    Text('Date', style: AppTextStyles.caption),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 16,
                          color: AppColors.secondaryText,
                        ),
                        SizedBox(width: 4),
                        Text('Date', style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.savings_rounded, size: 20),
                    label: const Text('Save Expense'),
                  ),
                ),

                const SizedBox(height: AppSizes.space32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
