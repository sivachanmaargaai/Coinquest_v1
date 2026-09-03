import 'package:equatable/equatable.dart';

abstract class ParentDashboardEvent extends Equatable {
  const ParentDashboardEvent();

  @override
  List<Object?> get props => [];
}

class ParentDashboardStarted extends ParentDashboardEvent {
  const ParentDashboardStarted();
}
