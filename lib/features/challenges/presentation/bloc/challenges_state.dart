import 'package:coinquest_v1_app/features/challenges/domain/entities/challenges_entity.dart';
import 'package:equatable/equatable.dart';

enum ChallengesStatus { loading, loaded, error }

class ChallengesState extends Equatable {
  final ChallengesStatus status;
  final List<ChallengeEntity> allChallenges;
  final bool showCompletedTab;
  final int streakDays;

  const ChallengesState({
    this.status = ChallengesStatus.loading,
    this.allChallenges = const [],
    this.showCompletedTab = false,
    this.streakDays = 0,
  });

  ChallengeEntity? get featured => allChallenges
      .where((c) => c.isFeatured)
      .cast<ChallengeEntity?>()
      .firstOrNull;

  List<ChallengeEntity> get visibleChallenges => allChallenges
      .where((c) => !c.isFeatured && c.isCompleted == showCompletedTab)
      .toList();

  ChallengesState copyWith({
    ChallengesStatus? status,
    List<ChallengeEntity>? allChallenges,
    bool? showCompletedTab,
    int? streakDays,
  }) {
    return ChallengesState(
      status: status ?? this.status,
      allChallenges: allChallenges ?? this.allChallenges,
      showCompletedTab: showCompletedTab ?? this.showCompletedTab,
      streakDays: streakDays ?? this.streakDays,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allChallenges,
    showCompletedTab,
    streakDays,
  ];
}
