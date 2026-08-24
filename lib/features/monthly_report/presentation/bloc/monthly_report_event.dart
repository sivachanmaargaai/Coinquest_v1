import 'package:equatable/equatable.dart';

abstract class MonthlyReportEvent extends Equatable {
  const MonthlyReportEvent();

  @override
  List<Object?> get props => [];
}

class MonthlyReportStarted extends MonthlyReportEvent {
  const MonthlyReportStarted();
}
