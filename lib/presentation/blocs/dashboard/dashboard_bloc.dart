import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/monthly_trend.dart';
import '../../../domain/usecases/member_usecases.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetMemberProfileUseCase getMemberProfileUseCase;
  final GetDashboardSummaryUseCase getDashboardSummaryUseCase;

  DashboardBloc({
    required this.getMemberProfileUseCase,
    required this.getDashboardSummaryUseCase,
  }) : super(const DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
    on<UpdateChartRange>(_onUpdateChartRange);
  }

  Future<void> _onLoadDashboard(
      LoadDashboard event,
      Emitter<DashboardState> emit,
      ) async {
    emit(const DashboardLoading());
    await _loadData(event.memberId, emit);
  }

  Future<void> _onRefreshDashboard(
      RefreshDashboard event,
      Emitter<DashboardState> emit,
      ) async {
    emit(const DashboardLoading());
    await _loadData(event.memberId, emit);
  }

  void _onUpdateChartRange(
      UpdateChartRange event,
      Emitter<DashboardState> emit,
      ) {
    final currentState = state;
    if (currentState is DashboardLoaded) {
      final filtered = _filterTrend(
        currentState.summary.monthlyTrend,
        event.startMonth,
        event.endMonth,
      );
      emit(currentState.copyWith(
        startMonth: event.startMonth,
        endMonth: event.endMonth,
        filteredTrend: filtered,
      ));
    }
  }

  Future<void> _loadData(
      String memberId,
      Emitter<DashboardState> emit,
      ) async {
    try {
      final results = await Future.wait([
        getMemberProfileUseCase(memberId),
        getDashboardSummaryUseCase(memberId),
      ]);

      final member = results[0] as dynamic;
      final summary = results[1] as dynamic;

      // Default range: all available data for now, but we'll use the last 6 months if possible
      final trend = summary.monthlyTrend as List<MonthlyTrend>;
      String? start;
      String? end;

      if (trend.isNotEmpty) {
        start = trend.length > 6 ? trend[trend.length - 6].month : trend.first.month;
        end = trend.last.month;
      }

      emit(DashboardLoaded(
        member: member,
        summary: summary,
        startMonth: start,
        endMonth: end,
        filteredTrend: _filterTrend(trend, start, end),
      ));
    } catch (e) {
      emit(DashboardError(
          message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  List<MonthlyTrend> _filterTrend(List<MonthlyTrend> all, String? start, String? end) {
    if (start == null || end == null) return all;

    final dateFormat = DateFormat('MMM yyyy');
    final startDate = dateFormat.parse(start);
    final endDate = dateFormat.parse(end);

    return all.where((t) {
      final date = dateFormat.parse(t.month);
      return (date.isAtSameMomentAs(startDate) || date.isAfter(startDate)) &&
          (date.isAtSameMomentAs(endDate) || date.isBefore(endDate));
    }).toList();
  }
}
