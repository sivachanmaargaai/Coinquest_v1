import 'package:equatable/equatable.dart';

/// The two customer segments from the design system.
enum AgeGroup { teen1315, teen1618 }

class AgeSelectionState extends Equatable {
  final AgeGroup? selectedGroup;
  final bool isConfirmed;

  const AgeSelectionState({this.selectedGroup, this.isConfirmed = false});

  bool get canContinue => selectedGroup != null;

  AgeSelectionState copyWith({AgeGroup? selectedGroup, bool? isConfirmed}) {
    return AgeSelectionState(
      selectedGroup: selectedGroup ?? this.selectedGroup,
      isConfirmed: isConfirmed ?? this.isConfirmed,
    );
  }

  @override
  List<Object?> get props => [selectedGroup, isConfirmed];
}
