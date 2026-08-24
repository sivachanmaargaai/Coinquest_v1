import 'package:equatable/equatable.dart';
import '../../domain/entities/lesson_entity.dart';

abstract class LearnEvent extends Equatable {
  const LearnEvent();

  @override
  List<Object?> get props => [];
}

class LearnStarted extends LearnEvent {
  const LearnStarted();
}

class LearnTopicFilterChanged extends LearnEvent {
  final LessonTopic? topic; // null = "All"

  const LearnTopicFilterChanged(this.topic);

  @override
  List<Object?> get props => [topic];
}

class LessonMarkedCompleted extends LearnEvent {
  final String lessonId;

  const LessonMarkedCompleted(this.lessonId);

  @override
  List<Object?> get props => [lessonId];
}
