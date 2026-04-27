import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:member_core/domain/entities/monthly_trend.dart';
import 'package:mocktail/mocktail.dart';
import 'package:member_core/domain/entities/member.dart';
import 'package:member_core/domain/entities/dashboard_summary.dart';
import 'package:member_core/domain/usecases/member_usecases.dart';
import 'package:member_core/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:member_core/presentation/blocs/dashboard/dashboard_event.dart';
import 'package:member_core/presentation/blocs/dashboard/dashboard_state.dart';

class MockGetMemberProfileUseCase extends Mock implements GetMemberProfileUseCase {}
class MockGetDashboardSummaryUseCase extends Mock implements GetDashboardSummaryUseCase {}

void main() {
  late MockGetMemberProfileUseCase getMemberProfileUseCase;
  late MockGetDashboardSummaryUseCase getDashboardSummaryUseCase;

  final mockMember = Member(
    id: 'MB001',
    name: 'Fauzi Fauzi',
    email: 'fauzi.f@tech.com',
    city: 'Jakarta',
    joinDate: DateTime(2023, 3, 15),
    membershipStatus: 'Gold',
  );

  final mockTrend = [
    const MonthlyTrend(month: 'Jan 2026', count: 5),
    const MonthlyTrend(month: 'Feb 2026', count: 3),
  ];

  final mockSummary = DashboardSummary(
    totalPurchaseThisMonth: 1250.0,
    totalTransactions: 15,
    monthlyTrend: mockTrend,
  );

  setUp(() {
    getMemberProfileUseCase = MockGetMemberProfileUseCase();
    getDashboardSummaryUseCase = MockGetDashboardSummaryUseCase();
  });

  DashboardBloc buildBloc() => DashboardBloc(
    getMemberProfileUseCase: getMemberProfileUseCase,
    getDashboardSummaryUseCase: getDashboardSummaryUseCase,
  );

  group('DashboardBloc', () {
    test('initial state should be DashboardInitial', () {
      expect(buildBloc().state, equals(const DashboardInitial()));
    });

    blocTest<DashboardBloc, DashboardState>(
      'emits [DashboardLoading, DashboardLoaded] when LoadDashboard succeeds',
      build: () {
        when(() => getMemberProfileUseCase(any())).thenAnswer((_) async => mockMember);
        when(() => getDashboardSummaryUseCase(any())).thenAnswer((_) async => mockSummary);
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadDashboard(memberId: 'MB001')),
      expect: () => [
        const DashboardLoading(),
        DashboardLoaded(
          member: mockMember,
          summary: mockSummary,
          startMonth: 'Jan 2026',
          endMonth: 'Feb 2026',
          filteredTrend: mockTrend,
        ),
      ],
    );

    blocTest<DashboardBloc, DashboardState>(
      'emits [DashboardLoading, DashboardError] when LoadDashboard fails',
      build: () {
        when(() => getMemberProfileUseCase(any())).thenThrow(Exception('Failed to load profile'));
        when(() => getDashboardSummaryUseCase(any())).thenAnswer((_) async => mockSummary);
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadDashboard(memberId: 'MB001')),
      expect: () => [
        const DashboardLoading(),
        const DashboardError(message: 'Failed to load profile'),
      ],
    );

    blocTest<DashboardBloc, DashboardState>(
      'emits [DashboardLoading, DashboardLoaded] when RefreshDashboard is called',
      build: () {
        when(() => getMemberProfileUseCase(any())).thenAnswer((_) async => mockMember);
        when(() => getDashboardSummaryUseCase(any())).thenAnswer((_) async => mockSummary);
        return buildBloc();
      },
      act: (bloc) => bloc.add(const RefreshDashboard(memberId: 'MB001')),
      expect: () => [
        const DashboardLoading(),
        DashboardLoaded(
          member: mockMember,
          summary: mockSummary,
          startMonth: 'Jan 2026',
          endMonth: 'Feb 2026',
          filteredTrend: mockTrend,
        ),
      ],
    );
  });
}
