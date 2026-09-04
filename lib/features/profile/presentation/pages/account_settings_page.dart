import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final _nameController = TextEditingController(text: 'Alex Johnson');
  final _emailController = TextEditingController(
    text: 'alex.johnson@email.com',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Account settings saved ✓')));
  }

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
                        'Account Settings',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h3,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: AppSizes.space24),

                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryPurple.withOpacity(0.3),
                          border: Border.all(
                            color: AppColors.goldAccent,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.face_rounded,
                          color: AppColors.goldAccent,
                          size: 44,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.goldAccent,
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 14,
                            color: AppColors.darkPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.space32),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Full Name', style: AppTextStyles.caption),
                ),
                const SizedBox(height: AppSizes.space8),
                TextField(
                  controller: _nameController,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.primaryText,
                  ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.space16),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Email', style: AppTextStyles.caption),
                ),
                const SizedBox(height: AppSizes.space8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.primaryText,
                  ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.mail_outline_rounded,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.space16),

                GlassCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.space16,
                    vertical: AppSizes.space16,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.primaryText,
                        size: 20,
                      ),
                      const SizedBox(width: AppSizes.space12),
                      const Expanded(child: Text('Change Password')),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.secondaryText,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _save,
                    child: const Text('Save Changes'),
                  ),
                ),
                const SizedBox(height: AppSizes.space24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
