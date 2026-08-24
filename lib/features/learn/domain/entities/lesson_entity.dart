import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum LessonTopic { saving, budgeting, spending, planning }

extension LessonTopicX on LessonTopic {
  String get label {
    switch (this) {
      case LessonTopic.saving:
        return 'Saving';
      case LessonTopic.budgeting:
        return 'Budgeting';
      case LessonTopic.spending:
        return 'Spending';
      case LessonTopic.planning:
        return 'Planning';
    }
  }

  IconData get icon {
    switch (this) {
      case LessonTopic.saving:
        return Icons.savings_rounded;
      case LessonTopic.budgeting:
        return Icons.pie_chart_rounded;
      case LessonTopic.spending:
        return Icons.shopping_bag_rounded;
      case LessonTopic.planning:
        return Icons.flag_rounded;
    }
  }
}

class LessonEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final LessonTopic topic;
  final int durationMinutes;
  final bool isCompleted;
  final List<String> content; // paragraphs shown on Lesson Detail

  const LessonEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.topic,
    required this.durationMinutes,
    this.isCompleted = false,
    this.content = const [],
  });

  LessonEntity copyWith({bool? isCompleted}) {
    return LessonEntity(
      id: id,
      title: title,
      description: description,
      topic: topic,
      durationMinutes: durationMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      content: content,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    topic,
    durationMinutes,
    isCompleted,
  ];
}
