import 'package:coinquest_v1_app/features/age_selection/presentation/bloc/age_selection_state.dart';
import 'package:equatable/equatable.dart';

abstract class AgeSelectionEvent extends Equatable {
  const AgeSelectionEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the user taps one of the two age group cards.
class AgeGroupSelected extends AgeSelectionEvent {
  final AgeGroup group;

  const AgeGroupSelected(this.group);

  @override
  List<Object?> get props => [group];
}

/// Fired when the user taps "Continue".
class AgeSelectionConfirmed extends AgeSelectionEvent {
  const AgeSelectionConfirmed();
}
