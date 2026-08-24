import 'package:equatable/equatable.dart';

abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();

  @override
  List<Object?> get props => [];
}

class LeaderboardStarted extends LeaderboardEvent {
  const LeaderboardStarted();
}

class LeaderboardScopeChanged extends LeaderboardEvent {
  final bool isAllTime; // false = This Week

  const LeaderboardScopeChanged(this.isAllTime);

  @override
  List<Object?> get props => [isAllTime];
}
