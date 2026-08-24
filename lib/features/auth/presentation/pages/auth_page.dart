import 'package:coinquest_v1_app/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => AuthBloc(), child: const _SignUpView());
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        SignUpSubmitted(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Account created! 🎉')));
          Navigator.of(context).pushReplacementNamed(AppRoutes.ageSelection);
        } else if (state.status == AuthStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPaddingH,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.space16),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.primaryText,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: AppSizes.space8),
                    Text('Create your account', style: AppTextStyles.h2),
                    const SizedBox(height: AppSizes.space4),
                    Text(
                      'Start your money journey today',
                      style: AppTextStyles.bodyLarge,
                    ),
                    const SizedBox(height: AppSizes.space32),

                    // Full Name
                    TextFormField(
                      controller: _nameController,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.primaryText,
                      ),
                      validator: Validators.validateName,
                      decoration: const InputDecoration(
                        hintText: 'Full Name',
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.space16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.primaryText,
                      ),
                      validator: Validators.validateEmail,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(
                          Icons.mail_outline_rounded,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.space16),

                    // Password
                    BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (prev, curr) =>
                          prev.isPasswordVisible != curr.isPasswordVisible,
                      builder: (context, state) {
                        return TextFormField(
                          controller: _passwordController,
                          obscureText: !state.isPasswordVisible,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.primaryText,
                          ),
                          validator: Validators.validatePassword,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                              color: AppColors.secondaryText,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                state.isPasswordVisible
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                color: AppColors.secondaryText,
                              ),
                              onPressed: () => context.read<AuthBloc>().add(
                                const PasswordVisibilityToggled(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSizes.space16),

                    // Terms checkbox
                    BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (prev, curr) =>
                          prev.termsAccepted != curr.termsAccepted,
                      builder: (context, state) {
                        return Row(
                          children: [
                            Checkbox(
                              value: state.termsAccepted,
                              activeColor: AppColors.goldAccent,
                              onChanged: (_) => context.read<AuthBloc>().add(
                                const TermsAcceptedToggled(),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'I agree to Terms & Privacy Policy',
                                style: AppTextStyles.caption,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: AppSizes.space24),

                    // Submit button
                    BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (prev, curr) => prev.status != curr.status,
                      builder: (context, state) {
                        final isLoading = state.status == AuthStatus.submitting;
                        return PrimaryButton(
                          label: isLoading
                              ? 'Creating Account...'
                              : 'Create Account',
                          onPressed: isLoading ? null : () => _submit(context),
                        );
                      },
                    ),

                    const SizedBox(height: AppSizes.space24),

                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: AppColors.secondaryText),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.space12,
                          ),
                          child: Text(
                            'or continue with',
                            style: AppTextStyles.caption,
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: AppColors.secondaryText),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSizes.space16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialIconButton(
                          icon: Icons.g_mobiledata_rounded,
                          onTap: () {},
                        ),
                        const SizedBox(width: AppSizes.space16),
                        _SocialIconButton(
                          icon: Icons.apple_rounded,
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSizes.space32),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.caption,
                          children: [
                            const TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Log In',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.goldAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSizes.space32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryPurple, width: 1.5),
        ),
        child: Icon(icon, color: AppColors.primaryText, size: 28),
      ),
    );
  }
}
