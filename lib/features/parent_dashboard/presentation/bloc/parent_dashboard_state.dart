import 'package:coinquest_v1_app/features/parent_dashboard/domain/entities/parent_dashboard_entity.dart' show ParentReportEntity;
import 'package:equatable/equatable.dart';

enum ParentDashboardStatus { loading, loaded }

class ParentDashboardState extends Equatable {
  final ParentDashboardStatus status;
  final ParentReportEntity? report;

  const ParentDashboardState({
    this.status = ParentDashboardStatus.loading,
    this.report,
  });

  ParentDashboardState copyWith({
    ParentDashboardStatus? status,
    ParentReportEntity? report,
  }) {
    return ParentDashboardState(
      status: status ?? this.status,
      report: report ?? this.report,
    );
  }

  @override
  List<Object?> get props => [status, report];
}