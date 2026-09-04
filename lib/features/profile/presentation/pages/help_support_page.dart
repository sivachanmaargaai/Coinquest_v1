import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  static const _faqs = [
    (
      q: 'How do I set a savings goal?',
      a: 'Go to the Goals tab, tap the + button, and fill in a title, target amount, and target date.',
    ),
    (
      q: 'Can I edit my budget after setting it?',
      a: 'Yes — open Budget, tap the pencil icon, and adjust any category limit with the steppers or slider.',
    ),
    (
      q: 'What happens if I go over a category limit?',
      a: 'The category bar turns red on your Budget screen so you can see it at a glance — there\'s no penalty, just a visual nudge.',
    ),
    (
      q: 'How does the AI assistant work?',
      a: 'Money Buddy AI looks at your recent activity to give personalized tips on saving, budgeting, and spending.',
    ),
    (
      q: 'Is my data shared with my parent?',
      a: 'Only high-level progress (spending, savings, learning activity) is shared if you\'ve linked a parent account.',
    ),
  ];

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
                        'Help & Support',
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
                      Row(
                        children: [
                          Expanded(
                            child: _ContactCard(
                              icon: Icons.mail_outline_rounded,
                              label: 'Email Us',
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: AppSizes.space12),
                          Expanded(
                            child: _ContactCard(
                              icon: Icons.chat_bubble_outline_rounded,
                              label: 'Live Chat',
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.space24),

                      Text(
                        'Frequently Asked Questions',
                        style: AppTextStyles.h3,
                      ),
                      const SizedBox(height: AppSizes.space12),

                      ..._faqs.map((f) => _FaqTile(question: f.q, answer: f.a)),

                      const SizedBox(height: AppSizes.space24),
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

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        child: Column(
          children: [
            Icon(icon, color: AppColors.goldAccent, size: 24),
            const SizedBox(height: AppSizes.space8),
            Text(label, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqTile({required this.question, required this.answer});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.space12),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: AppColors.secondaryText,
                  ),
                ],
              ),
            ),
            if (_expanded) ...[
              const SizedBox(height: AppSizes.space8),
              Text(widget.answer, style: AppTextStyles.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}
