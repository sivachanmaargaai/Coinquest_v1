import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class BadgeEntity extends Equatable {
  final String id;
  final String label;
  final IconData icon;
  final bool isUnlocked;

  const BadgeEntity({
    required this.id,
    required this.label,
    required this.icon,
    this.isUnlocked = true,
  });

  @override
  List<Object?> get props => [id, label, icon, isUnlocked];
}
