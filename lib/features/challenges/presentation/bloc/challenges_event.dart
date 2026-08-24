import 'package:equatable/equatable.dart';

abstract class ChallengesEvent extends Equatable {
  const ChallengesEvent();

  @override
  List<Object?> get props => [];
}

class ChallengesStarted extends ChallengesEvent {
  const ChallengesStarted();
}

class ChallengesTabChanged extends ChallengesEvent {
  final bool showCompleted; // false = Active, true = Completed

  const ChallengesTabChanged(this.showCompleted);

  @override
  List<Object?> get props => [showCompleted];
}
