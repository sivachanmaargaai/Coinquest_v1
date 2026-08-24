import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ChallengeType { savings, budget, quiz, streak }

extension ChallengeTypeX on ChallengeType {
  IconData get icon {
    switch (this) {
      case ChallengeType.savings:
        return Icons.savings_rounded;
      case ChallengeType.budget:
        return Icons.account_balance_wallet_rounded;
      case ChallengeType.quiz:
        return Icons.quiz_rounded;
      case ChallengeType.streak:
        return Icons.local_fire_department_rounded;
    }
  }
}

class ChallengeEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final ChallengeType type;
  final double progress;
  final int xpReward;
  final bool isCompleted;
  final bool isFeatured;

  const ChallengeEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.progress,
    required this.xpReward,
    this.isCompleted = false,
    this.isFeatured = false,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    type,
    progress,
    xpReward,
    isCompleted,
    isFeatured,
  ];
}
