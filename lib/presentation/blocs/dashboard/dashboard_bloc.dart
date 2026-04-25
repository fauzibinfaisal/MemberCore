import 'package:flutter_bloc/flutter_bloc.dart';
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
    // Must emit a new state so equatable deduplication doesn't swallow
    // the re-emitted DashboardLoaded when data is unchanged.
    emit(const DashboardLoading());
    await _loadData(event.memberId, emit);
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

      emit(DashboardLoaded(
        member: results[0] as dynamic,
        summary: results[1] as dynamic,
      ));
    } catch (e) {
      emit(DashboardError(
          message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
