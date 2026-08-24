import 'package:coinquest_v1_app/features/budget/domain/entities/savings_goal_entity.dart';
import 'package:equatable/equatable.dart';

enum SavingsStatus { loading, loaded, error }

class SavingsState extends Equatable {
  final SavingsStatus status;
  final List<SavingsGoalEntity> goals;

  const SavingsState({
    this.status = SavingsStatus.loading,
    this.goals = const [],
  });

  double get totalSaved => goals.fold(0, (sum, g) => sum + g.currentAmount);

  SavingsState copyWith({
    SavingsStatus? status,
    List<SavingsGoalEntity>? goals,
  }) {
    return SavingsState(
      status: status ?? this.status,
      goals: goals ?? this.goals,
    );
  }

  @override
  List<Object?> get props => [status, goals];
}
