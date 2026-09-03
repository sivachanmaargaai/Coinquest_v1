import 'package:equatable/equatable.dart';
import '../../domain/entities/lesson_entity.dart';

enum LearnStatus { loading, loaded, error }

class LearnState extends Equatable {
  final LearnStatus status;
  final List<LessonEntity> allLessons;
  final LessonTopic? activeFilter;
  final bool isSegment2;

  const LearnState({
    this.status = LearnStatus.loading,
    this.allLessons = const [],
    this.activeFilter,
    this.isSegment2 = false,
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
    bool? isSegment2,
  }) {
    return LearnState(
      status: status ?? this.status,
      allLessons: allLessons ?? this.allLessons,
      activeFilter: clearFilter ? null : (activeFilter ?? this.activeFilter),
      isSegment2: isSegment2 ?? this.isSegment2,
    );
  }

  @override
  List<Object?> get props => [status, allLessons, activeFilter, isSegment2];
}
