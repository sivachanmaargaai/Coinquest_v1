import 'package:equatable/equatable.dart';

enum HomeStatus { loading, loaded, error }

/// Which design-system segment the current user belongs to.
enum HomeAgeGroup { teen1315, teen1618 }

class RecentExpense extends Equatable {
  final String title;
  final String category;
  final double amount;
  final String time;

  const RecentExpense({
    required this.title,
    required this.category,
    required this.amount,
    required this.time,
  });

  @override
  List<Object?> get props => [title, category, amount, time];
}

class HomeState extends Equatable {
  final HomeStatus status;
  final HomeAgeGroup ageGroup;
  final String userName;
  final double balance;
  final int level;
  final int currentXp;
  final int targetXp;
  final String savingsGoalTitle;
  final double savingsCurrent;
  final double savingsTarget;
  final List<RecentExpense> recentExpenses;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.loading,
    this.ageGroup = HomeAgeGroup.teen1315,
    this.userName = '',
    this.balance = 0,
    this.level = 1,
    this.currentXp = 0,
    this.targetXp = 1000,
    this.savingsGoalTitle = '',
    this.savingsCurrent = 0,
    this.savingsTarget = 0,
    this.recentExpenses = const [],
    this.errorMessage,
  });

  bool get isSegment2 => ageGroup == HomeAgeGroup.teen1618;
  double get xpProgress => targetXp == 0 ? 0 : currentXp / targetXp;
  double get savingsProgress =>
      savingsTarget == 0 ? 0 : savingsCurrent / savingsTarget;

  HomeState copyWith({
    HomeStatus? status,
    HomeAgeGroup? ageGroup,
    String? userName,
    double? balance,
    int? level,
    int? currentXp,
    int? targetXp,
    String? savingsGoalTitle,
    double? savingsCurrent,
    double? savingsTarget,
    List<RecentExpense>? recentExpenses,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      ageGroup: ageGroup ?? this.ageGroup,
      userName: userName ?? this.userName,
      balance: balance ?? this.balance,
      level: level ?? this.level,
      currentXp: currentXp ?? this.currentXp,
      targetXp: targetXp ?? this.targetXp,
      savingsGoalTitle: savingsGoalTitle ?? this.savingsGoalTitle,
      savingsCurrent: savingsCurrent ?? this.savingsCurrent,
      savingsTarget: savingsTarget ?? this.savingsTarget,
      recentExpenses: recentExpenses ?? this.recentExpenses,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    ageGroup,
    userName,
    balance,
    level,
    currentXp,
    targetXp,
    savingsGoalTitle,
    savingsCurrent,
    savingsTarget,
    recentExpenses,
    errorMessage,
  ];
}
