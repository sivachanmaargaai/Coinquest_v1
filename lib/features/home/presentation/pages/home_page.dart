import 'package:coinquest_v1_app/features/ai_chat/presentation/pages/ai_chat_page.dart';
import 'package:coinquest_v1_app/features/expense/presentation/pages/expense_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../budget/presentation/pages/budget_page.dart';
import '../../../learn/presentation/pages/learn_page.dart';
import '../../../challenges/presentation/pages/challenges_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../../savings/presentation/pages/savings_page.dart';

/// Main app shell — hosts the bottom nav and switches between the 5 main
/// tabs using IndexedStack (keeps each tab's state alive when switching,
/// unlike Navigator.push which would rebuild from scratch every time).
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppNavTab _currentTab = AppNavTab.home;

  static const _tabOrder = [
    AppNavTab.home,
    AppNavTab.budget,
    AppNavTab.learn,
    AppNavTab.challenge,
    AppNavTab.profile,
  ];

  @override
  Widget build(BuildContext context) {
    final int currentIndex = _tabOrder.indexOf(_currentTab);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          _HomeDashboardTab(),
          BudgetPage(),
          LearnPage(),
          ChallengesPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: AppBottomNav(
            currentTab: _currentTab,
            onTabSelected: (tab) => setState(() => _currentTab = tab),
          ),
        ),
      ),
    );
  }
}

/// The actual Home Dashboard content (Screen 8) — unchanged from before,
/// just extracted out so it can live inside the IndexedStack above.
class _HomeDashboardTab extends StatelessWidget {
  const _HomeDashboardTab();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(const HomeStarted()),
      child: const _HomeDashboardView(),
    );
  }
}

class _HomeDashboardView extends StatelessWidget {
  const _HomeDashboardView();

  String _currency(double v) => '₹${v.abs().toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.goldAccent),
              );
            }

            final bool isSegment2 = state.isSegment2;

            return RefreshIndicator(
              color: AppColors.goldAccent,
              backgroundColor: AppColors.darkPurple,
              onRefresh: () async {
                context.read<HomeBloc>().add(const HomeRefreshed());
                await Future.delayed(const Duration(milliseconds: 400));
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPaddingH,
                  vertical: AppSizes.space16,
                ),
                children: [
                  _HeaderRow(userName: state.userName, isSegment2: isSegment2),
                  const SizedBox(height: AppSizes.space24),
                  _BalanceCard(state: state, isSegment2: isSegment2),
                  const SizedBox(height: AppSizes.space24),
                  _QuickActionsRow(isSegment2: isSegment2),
                  const SizedBox(height: AppSizes.space24),
                  _SavingsGoalCard(state: state, isSegment2: isSegment2),
                  const SizedBox(height: AppSizes.space24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isSegment2 ? 'Spending This Month' : 'Recent Expenses',
                        style: AppTextStyles.h3,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.space8),
                  ...state.recentExpenses.map(
                    (e) => _ExpenseRow(expense: e, currency: _currency),
                  ),
                  const SizedBox(height: AppSizes.space48),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final String userName;
  final bool isSegment2;
  const _HeaderRow({required this.userName, required this.isSegment2});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSegment2
                ? Colors.blueGrey.withOpacity(0.4)
                : AppColors.primaryPurple.withOpacity(0.3),
          ),
          child: Icon(
            isSegment2 ? Icons.person_rounded : Icons.face_rounded,
            color: AppColors.goldAccent,
          ),
        ),
        const SizedBox(width: AppSizes.space12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, $userName${isSegment2 ? '' : '! 👋'}',
                style: AppTextStyles.h3,
              ),
              Text(
                isSegment2
                    ? "Here's your financial snapshot"
                    : "Let's check your money today",
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const AiChatPage()));
          },
          child: Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: AppSizes.space8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryPurple.withOpacity(0.3),
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: AppColors.info,
              size: 20,
            ),
          ),
        ),
        Stack(
          children: [
            const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primaryText,
              size: 28,
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warning,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final HomeState state;
  final bool isSegment2;
  const _BalanceCard({required this.state, required this.isSegment2});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: AppColors.goldAccent.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isSegment2 ? 'Total Balance' : 'Your Balance',
                style: AppTextStyles.caption,
              ),
              Icon(
                isSegment2
                    ? Icons.trending_up_rounded
                    : Icons.monetization_on_rounded,
                color: AppColors.goldAccent,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.space4),
          Text('₹${state.balance.toStringAsFixed(2)}', style: AppTextStyles.h1),
          const SizedBox(height: AppSizes.space16),
          if (!isSegment2) ...[
            Row(
              children: [
                Text(
                  'Level ${state.level} • Money Explorer',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.goldAccent,
                  ),
                ),
                const Spacer(),
                Text(
                  '${state.currentXp} / ${state.targetXp} XP',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.space8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: state.xpProgress,
                minHeight: 6,
                backgroundColor: AppColors.darkPurple,
                valueColor: const AlwaysStoppedAnimation(AppColors.goldAccent),
              ),
            ),
          ] else ...[
            Row(
              children: const [
                Icon(
                  Icons.arrow_upward_rounded,
                  color: AppColors.successGreen,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  '+8.5% vs last month',
                  style: TextStyle(color: AppColors.successGreen, fontSize: 13),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  final bool isSegment2;
  const _QuickActionsRow({required this.isSegment2});

  @override
  Widget build(BuildContext context) {
    final actions = isSegment2
        ? const [
            (icon: Icons.account_balance_wallet_rounded, label: 'Budget'),
            (icon: Icons.receipt_long_rounded, label: 'Expenses'),
            (icon: Icons.show_chart_rounded, label: 'Invest Basics'),
            (icon: Icons.flag_rounded, label: 'Goals'),
          ]
        : const [
            (icon: Icons.account_balance_wallet_rounded, label: 'Budget'),
            (icon: Icons.receipt_long_rounded, label: 'Expenses'),
            (icon: Icons.flag_rounded, label: 'Goals'),
            (icon: Icons.emoji_events_rounded, label: 'Challenges'),
          ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((a) {
        return GestureDetector(
          onTap: () {
            if (a.label == 'Expenses') {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ExpensePage()));
            } else if (a.label == 'Goals') {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SavingsPage()));
            } else if (a.label == 'Challenges') {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ChallengesPage()));
            } else if (a.label == 'Budget') {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const BudgetPage()));
            }
            // TODO: wire "Invest Basics" once Segment 2 investing screen exists
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.glassCard,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryPurple.withOpacity(0.4),
                  ),
                ),
                child: Icon(a.icon, color: AppColors.goldAccent, size: 26),
              ),
              const SizedBox(height: AppSizes.space4),
              Text(a.label, style: AppTextStyles.caption),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _SavingsGoalCard extends StatelessWidget {
  final HomeState state;
  final bool isSegment2;
  const _SavingsGoalCard({required this.state, required this.isSegment2});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryPurple.withOpacity(0.3),
            ),
            child: Icon(
              isSegment2
                  ? Icons.directions_car_filled_rounded
                  : Icons.savings_rounded,
              color: AppColors.goldAccent,
            ),
          ),
          const SizedBox(width: AppSizes.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSegment2
                      ? state.savingsGoalTitle
                      : 'Savings Goal — ${state.savingsGoalTitle}',
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: AppSizes.space4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: state.savingsProgress,
                    minHeight: 6,
                    backgroundColor: AppColors.darkPurple,
                    valueColor: const AlwaysStoppedAnimation(
                      AppColors.goldAccent,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.space4),
                Text(
                  '₹${state.savingsCurrent.toStringAsFixed(0)} / ₹${state.savingsTarget.toStringAsFixed(0)}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.space8),
          Text(
            '${(state.savingsProgress * 100).toStringAsFixed(0)}%',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.goldAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseRow extends StatelessWidget {
  final RecentExpense expense;
  final String Function(double) currency;
  const _ExpenseRow({required this.expense, required this.currency});

  IconData get _categoryIcon {
    switch (expense.category) {
      case 'Food':
        return Icons.restaurant_rounded;
      case 'Transport':
        return Icons.directions_bus_rounded;
      case 'Shopping':
        return Icons.shopping_bag_rounded;
      case 'Entertainment':
        return Icons.sports_esports_rounded;
      case 'Education':
        return Icons.school_rounded;
      default:
        return Icons.more_horiz_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.space8),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.space16,
          vertical: AppSizes.space12,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryPurple.withOpacity(0.3),
              ),
              child: Icon(_categoryIcon, color: AppColors.goldAccent, size: 20),
            ),
            const SizedBox(width: AppSizes.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.primaryText,
                    ),
                  ),
                  Text(
                    '${expense.category} • ${expense.time}',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Text(
              '-${currency(expense.amount)}',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
