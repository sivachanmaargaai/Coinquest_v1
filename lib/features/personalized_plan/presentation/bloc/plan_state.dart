import 'package:equatable/equatable.dart';
import '../../domain/entities/plan_step_entity.dart';

enum PlanStatus { loading, loaded }

class PlanState extends Equatable {
  final PlanStatus status;
  final String planTitle;
  final List<PlanStepEntity> steps;

  const PlanState({
    this.status = PlanStatus.loading,
    this.planTitle = '',
    this.steps = const [],
  });

  PlanState copyWith({
    PlanStatus? status,
    String? planTitle,
    List<PlanStepEntity>? steps,
  }) {
    return PlanState(
      status: status ?? this.status,
      planTitle: planTitle ?? this.planTitle,
      steps: steps ?? this.steps,
    );
  }

  @override
  List<Object?> get props => [status, planTitle, steps];
}
