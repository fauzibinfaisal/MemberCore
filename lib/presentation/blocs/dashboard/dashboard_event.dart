import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {
  final String memberId;

  const LoadDashboard({required this.memberId});

  @override
  List<Object?> get props => [memberId];
}

class RefreshDashboard extends DashboardEvent {
  final String memberId;

  const RefreshDashboard({required this.memberId});

  @override
  List<Object?> get props => [memberId];
}
class UpdateChartRange extends DashboardEvent {
  final String startMonth;
  final String endMonth;

  const UpdateChartRange({required this.startMonth, required this.endMonth});

  @override
  List<Object?> get props => [startMonth, endMonth];
}