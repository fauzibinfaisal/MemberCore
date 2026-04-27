import 'package:equatable/equatable.dart';
import '../../../domain/entities/member.dart';
import '../../../domain/entities/dashboard_summary.dart';
import '../../../domain/entities/monthly_trend.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final Member member;
  final DashboardSummary summary;
  final String? startMonth;
  final String? endMonth;
  final List<MonthlyTrend> filteredTrend;

  const DashboardLoaded({
    required this.member,
    required this.summary,
    this.startMonth,
    this.endMonth,
    required this.filteredTrend,
  });

  DashboardLoaded copyWith({
    Member? member,
    DashboardSummary? summary,
    String? startMonth,
    String? endMonth,
    List<MonthlyTrend>? filteredTrend,
  }) {
    return DashboardLoaded(
      member: member ?? this.member,
      summary: summary ?? this.summary,
      startMonth: startMonth ?? this.startMonth,
      endMonth: endMonth ?? this.endMonth,
      filteredTrend: filteredTrend ?? this.filteredTrend,
    );
  }

  @override
  List<Object?> get props => [member, summary, startMonth, endMonth, filteredTrend];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}
