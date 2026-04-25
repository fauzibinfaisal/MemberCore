import '../../domain/entities/member.dart';
import '../../domain/entities/dashboard_summary.dart';
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

    return DashboardSummary(
      totalPurchaseThisMonth: 0,
      lastTransactionDate: DateTime.now(),
      totalTransactions: 0,
    );
  }
}
