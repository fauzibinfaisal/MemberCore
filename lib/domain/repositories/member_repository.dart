import '../entities/member.dart';
import '../entities/dashboard_summary.dart';

abstract class MemberRepository {
  Future<Member> getMemberProfile(String memberId);
  Future<DashboardSummary> getDashboardSummary(String memberId);
}
