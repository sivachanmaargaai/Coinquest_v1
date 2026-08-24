import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/entities/badge_entity.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// Loads profile info (name, level, badges) + reads persisted age group
/// so the label reflects the user's chosen segment.
/// TODO: replace mock data with GetProfileUseCase.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final LocalStorageService _localStorageService;

  ProfileBloc({LocalStorageService? localStorageService})
    : _localStorageService = localStorageService ?? LocalStorageService(),
      super(const ProfileState()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final savedGroup = await _localStorageService.getAgeGroup();
    final ageGroupLabel = savedGroup == 'teen1618'
        ? 'Ages 16–18'
        : 'Ages 13–15';

    await Future.delayed(const Duration(milliseconds: 300));

    emit(
      state.copyWith(
        status: ProfileStatus.loaded,
        name: 'Alex Johnson',
        ageGroupLabel: ageGroupLabel,
        level: 7,
        totalXp: 700,
        badgeCount: 12,
        streakDays: 7,
        badges: const [
          BadgeEntity(id: 'b1', label: 'Saver', icon: Icons.savings_rounded),
          BadgeEntity(
            id: 'b2',
            label: 'Budgeter',
            icon: Icons.pie_chart_rounded,
          ),
          BadgeEntity(
            id: 'b3',
            label: 'Quiz Master',
            icon: Icons.school_rounded,
          ),
          BadgeEntity(
            id: 'b4',
            label: 'Streak',
            icon: Icons.local_fire_department_rounded,
          ),
          BadgeEntity(
            id: 'b5',
            label: 'Champion',
            icon: Icons.emoji_events_rounded,
            isUnlocked: false,
          ),
        ],
      ),
    );
  }

  Future<void> _onLogoutRequested(
    ProfileLogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    // TODO: clear auth token via local_storage_service / api_service
    emit(state.copyWith(status: ProfileStatus.loggedOut));
  }
}
