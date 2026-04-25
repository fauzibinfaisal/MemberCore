import '../entities/member.dart';
import '../entities/dashboard_summary.dart';
import '../repositories/member_repository.dart';

class GetMemberProfileUseCase {
  final MemberRepository repository;

  GetMemberProfileUseCase(this.repository);

  Future<Member> call(String memberId) {
    return repository.getMemberProfile(memberId);
  }
}

class GetDashboardSummaryUseCase {
  final MemberRepository repository;

  GetDashboardSummaryUseCase(this.repository);

  Future<DashboardSummary> call(String memberId) {
    return repository.getDashboardSummary(memberId);
  }
}
