import 'package:equatable/equatable.dart';

abstract class PlanEvent extends Equatable {
  const PlanEvent();

  @override
  List<Object?> get props => [];
}

class PlanStarted extends PlanEvent {
  const PlanStarted();
}

class PlanRegenerated extends PlanEvent {
  const PlanRegenerated();
}
