import 'package:equatable/equatable.dart';
import '../../domain/entities/monthly_report_entity.dart';

enum MonthlyReportStatus { loading, loaded }

class MonthlyReportState extends Equatable {
  final MonthlyReportStatus status;
  final MonthlyReportEntity? report;

  const MonthlyReportState({
    this.status = MonthlyReportStatus.loading,
    this.report,
  });

  MonthlyReportState copyWith({
    MonthlyReportStatus? status,
    MonthlyReportEntity? report,
  }) {
    return MonthlyReportState(
      status: status ?? this.status,
      report: report ?? this.report,
    );
  }

  @override
  List<Object?> get props => [status, report];
}
