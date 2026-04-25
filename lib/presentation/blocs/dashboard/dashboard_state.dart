import 'package:equatable/equatable.dart';
import '../../../domain/entities/member.dart';
import '../../../domain/entities/dashboard_summary.dart';

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

  const DashboardLoaded({required this.member, required this.summary});

  @override
  List<Object?> get props => [member, summary];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}
