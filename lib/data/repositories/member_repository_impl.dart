import 'package:intl/intl.dart';
import '../../domain/entities/member.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/monthly_trend.dart';
import '../../domain/repositories/member_repository.dart';
import '../datasources/mock_data_source.dart';

class MemberRepositoryImpl implements MemberRepository {
  final MockDataSource _dataSource;

  MemberRepositoryImpl({required MockDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Member> getMemberProfile(String memberId) {
    return _dataSource.getMemberProfile(memberId);
  }

  @override
  Future<DashboardSummary> getDashboardSummary(String memberId) async {
    final transactions = await _dataSource.getTransactions(memberId);
    final now = DateTime.now();

    final thisMonthTxns = transactions.where((t) =>
    t.date.year == now.year &&
        t.date.month == now.month &&
        t.status == 'Completed');

    final totalThisMonth =
    thisMonthTxns.fold<double>(0, (sum, t) => sum + t.amount);

    DateTime? lastDate;
    if (transactions.isNotEmpty) {
      final sorted = List.of(transactions)
        ..sort((a, b) => b.date.compareTo(a.date));
      lastDate = sorted.first.date;
    }

    // Calculate monthly trend (count per month)
    final trendMap = <String, int>{};
    final dateFormat = DateFormat('MMM yyyy');

    for (final t in transactions) {
      final key = dateFormat.format(t.date);
      trendMap[key] = (trendMap[key] ?? 0) + 1;
    }

    // Sort by date to ensure chronological order if needed, but for now just map
    final monthlyTrend = trendMap.entries.map((e) => MonthlyTrend(
      month: e.key,
      count: e.value,
    )).toList();

    // Sort monthly trend chronologically
    monthlyTrend.sort((a, b) {
      final dateA = dateFormat.parse(a.month);
      final dateB = dateFormat.parse(b.month);
      return dateA.compareTo(dateB);
    });

    return DashboardSummary(
      totalPurchaseThisMonth: totalThisMonth,
      lastTransactionDate: lastDate,
      totalTransactions: transactions.length,
      monthlyTrend: monthlyTrend,
    );
  }
}
