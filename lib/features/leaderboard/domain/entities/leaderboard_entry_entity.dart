import 'package:equatable/equatable.dart';

class LeaderboardEntryEntity extends Equatable {
  final int rank;
  final String name;
  final int xp;
  final bool isCurrentUser;

  const LeaderboardEntryEntity({
    required this.rank,
    required this.name,
    required this.xp,
    this.isCurrentUser = false,
  });

  @override
  List<Object?> get props => [rank, name, xp, isCurrentUser];
}
