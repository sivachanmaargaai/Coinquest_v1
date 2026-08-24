import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';
import 'leaderboard_event.dart';
import 'leaderboard_state.dart';

/// Loads the weekly/all-time XP leaderboard.
/// TODO: replace mock data with GetLeaderboardUseCase.
class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  LeaderboardBloc() : super(const LeaderboardState()) {
    on<LeaderboardStarted>(_onStarted);
    on<LeaderboardScopeChanged>(_onScopeChanged);
  }

  Future<void> _onStarted(
    LeaderboardStarted event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(state.copyWith(status: LeaderboardStatus.loading));
    await Future.delayed(const Duration(milliseconds: 400));
    emit(
      state.copyWith(status: LeaderboardStatus.loaded, entries: _mockEntries),
    );
  }

  void _onScopeChanged(
    LeaderboardScopeChanged event,
    Emitter<LeaderboardState> emit,
  ) {
    emit(state.copyWith(isAllTime: event.isAllTime));
    // TODO: reload entries for the new scope from backend
  }

  static const _mockEntries = [
    LeaderboardEntryEntity(rank: 1, name: 'Maya', xp: 2650),
    LeaderboardEntryEntity(rank: 2, name: 'Jordan', xp: 2480),
    LeaderboardEntryEntity(rank: 3, name: 'Sam', xp: 2210),
    LeaderboardEntryEntity(
      rank: 4,
      name: 'Alex (You)',
      xp: 1900,
      isCurrentUser: true,
    ),
    LeaderboardEntryEntity(rank: 5, name: 'Priya', xp: 1720),
    LeaderboardEntryEntity(rank: 6, name: 'Kabir', xp: 1580),
    LeaderboardEntryEntity(rank: 7, name: 'Zoe', xp: 1340),
  ];
}
