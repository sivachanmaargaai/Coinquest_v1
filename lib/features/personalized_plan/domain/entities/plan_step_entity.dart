import 'package:equatable/equatable.dart';

enum PlanStepStatus { active, upcoming, done }

class PlanStepEntity extends Equatable {
  final int stepNumber;
  final String title;
  final String description;
  final PlanStepStatus status;

  const PlanStepEntity({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.status,
  });

  @override
  List<Object?> get props => [stepNumber, title, description, status];
}
