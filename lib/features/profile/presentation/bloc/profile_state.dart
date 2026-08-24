import 'package:equatable/equatable.dart';
import '../../domain/entities/badge_entity.dart';

enum ProfileStatus { loading, loaded, loggedOut }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final String name;
  final String ageGroupLabel;
  final int level;
  final int totalXp;
  final int badgeCount;
  final int streakDays;
  final List<BadgeEntity> badges;

  const ProfileState({
    this.status = ProfileStatus.loading,
    this.name = '',
    this.ageGroupLabel = '',
    this.level = 1,
    this.totalXp = 0,
    this.badgeCount = 0,
    this.streakDays = 0,
    this.badges = const [],
  });

  ProfileState copyWith({
    ProfileStatus? status,
    String? name,
    String? ageGroupLabel,
    int? level,
    int? totalXp,
    int? badgeCount,
    int? streakDays,
    List<BadgeEntity>? badges,
  }) {
    return ProfileState(
      status: status ?? this.status,
      name: name ?? this.name,
      ageGroupLabel: ageGroupLabel ?? this.ageGroupLabel,
      level: level ?? this.level,
      totalXp: totalXp ?? this.totalXp,
      badgeCount: badgeCount ?? this.badgeCount,
      streakDays: streakDays ?? this.streakDays,
      badges: badges ?? this.badges,
    );
  }

  @override
  List<Object?> get props => [
    status,
    name,
    ageGroupLabel,
    level,
    totalXp,
    badgeCount,
    streakDays,
    badges,
  ];
}
