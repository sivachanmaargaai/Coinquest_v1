import 'package:coinquest_v1_app/features/budget/domain/entities/savings_goal_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../bloc/savings_bloc.dart';
import '../bloc/savings_event.dart';

class AddSavingsPage extends StatefulWidget {
  final SavingsGoalEntity goal;

  const AddSavingsPage({super.key, required this.goal});

  @override
  State<AddSavingsPage> createState() => _AddSavingsPageState();
}

class _AddSavingsPageState extends State<AddSavingsPage> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _enteredAmount => double.tryParse(_amountController.text) ?? 0;

  void _quickAdd(double amount) {
    setState(() {
      final current = double.tryParse(_amountController.text) ?? 0;
      _amountController.text = (current + amount).toStringAsFixed(0);
    });
  }

  void _confirm() {
    if (_enteredAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    context.read<SavingsBloc>().add(
      SavingsContributed(goalId: widget.goal.id, amount: _enteredAmount),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final projectedTotal = widget.goal.currentAmount + _enteredAmount;

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
                        'Add to ${widget.goal.title}',
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

                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryPurple.withOpacity(0.3),
                  ),
                  child: Icon(
                    widget.goal.icon,
                    color: AppColors.goldAccent,
                    size: 32,
                  ),
                ),

                const SizedBox(height: AppSizes.space24),

                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.center,
                  autofocus: true,
                  style: AppTextStyles.h1,
                  onChanged: (_) => setState(() {}),
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

                const SizedBox(height: AppSizes.space24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [50, 100, 200, 500].map((amount) {
                    return OutlinedButton(
                      onPressed: () => _quickAdd(amount.toDouble()),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 40),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.space16,
                        ),
                      ),
                      child: Text('+₹$amount'),
                    );
                  }).toList(),
                ),

                const SizedBox(height: AppSizes.space32),

                Container(
                  padding: const EdgeInsets.all(AppSizes.space16),
                  decoration: BoxDecoration(
                    color: AppColors.glassCard,
                    borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${widget.goal.currentAmount.toStringAsFixed(0)}',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.primaryText,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.secondaryText,
                        size: 18,
                      ),
                      Text(
                        '₹${projectedTotal.toStringAsFixed(0)}',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.goldAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _confirm,
                    icon: const Icon(Icons.savings_rounded, size: 20),
                    label: const Text('Confirm & Save'),
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
