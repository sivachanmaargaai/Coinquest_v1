import 'package:equatable/equatable.dart';
import '../../domain/entities/lesson_entity.dart';

enum LearnStatus { loading, loaded, error }

class LearnState extends Equatable {
  final LearnStatus status;
  final List<LessonEntity> allLessons;
  final LessonTopic? activeFilter;

  const LearnState({
    this.status = LearnStatus.loading,
    this.allLessons = const [],
    this.activeFilter,
  });

  List<LessonEntity> get filteredLessons => activeFilter == null
      ? allLessons
      : allLessons.where((l) => l.topic == activeFilter).toList();

  int get completedCount => allLessons.where((l) => l.isCompleted).length;
  double get overallProgress =>
      allLessons.isEmpty ? 0 : completedCount / allLessons.length;

  LearnState copyWith({
    LearnStatus? status,
    List<LessonEntity>? allLessons,
    LessonTopic? activeFilter,
    bool clearFilter = false,
  }) {
    return LearnState(
      status: status ?? this.status,
      allLessons: allLessons ?? this.allLessons,
      activeFilter: clearFilter ? null : (activeFilter ?? this.activeFilter),
    );
  }

  @override
  List<Object?> get props => [status, allLessons, activeFilter];
}
