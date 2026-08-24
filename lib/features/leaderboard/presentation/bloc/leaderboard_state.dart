import 'package:equatable/equatable.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';

enum LeaderboardStatus { loading, loaded }

class LeaderboardState extends Equatable {
  final LeaderboardStatus status;
  final List<LeaderboardEntryEntity> entries;
  final bool isAllTime;

  const LeaderboardState({
    this.status = LeaderboardStatus.loading,
    this.entries = const [],
    this.isAllTime = false,
  });

  LeaderboardState copyWith({
    LeaderboardStatus? status,
    List<LeaderboardEntryEntity>? entries,
    bool? isAllTime,
  }) {
    return LeaderboardState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      isAllTime: isAllTime ?? this.isAllTime,
    );
  }

  @override
  List<Object?> get props => [status, entries, isAllTime];
}
