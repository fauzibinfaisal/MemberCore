import '../models/member_model.dart';

/// Mock data source that simulates API responses.
/// Replace this with a real API data source when backend is ready.
class MockDataSource {
  // Simulated network delay
  static const _delay = Duration(milliseconds: 800);

  static final _members = {
    'fauzi.f@tech.com': MemberModel(
      id: 'MB001',
      name: 'Fauzi Fauzi',
      email: 'fauzi.f@tech.com',
      city: 'Jakarta',
      joinDate: DateTime(2023, 3, 15),
      membershipStatus: 'Gold',
    ),
    'demo@tech.com': MemberModel(
      id: 'MB002',
      name: 'Sarah Putri',
      email: 'demo@tech.com',
      city: 'Singapore',
      joinDate: DateTime(2024, 1, 10),
      membershipStatus: 'Silver',
    ),
  };

  Future<MemberModel?> login(String identifier, String password) async {
    await Future.delayed(_delay);
    // Common error message for security
    const commonError = 'Invalid User ID/Email or password';

    if (password.length < 4) {
      throw Exception('Password must be at least 4 characters');
    }

    final search = identifier.toLowerCase();
    MemberModel? member;
    try {
      member = _members.values.firstWhere(
            (m) => m.email.toLowerCase() == search || m.id.toLowerCase() == search,
      );
    } catch (_) {}

    if (member == null) {
      throw Exception(commonError);
    }

    // Verify passwords
    final expectedPassword = member.id == 'MB001' ? 'password123' : 'qwerty123';
    if (password != expectedPassword) {
      throw Exception(commonError);
    }

    return member;
  }

  Future<MemberModel> getMemberProfile(String memberId) async {
    await Future.delayed(_delay);
    final member = _members.values.firstWhere(
          (m) => m.id == memberId,
      orElse: () => throw Exception('Member not found'),
    );
    return member;
  }
}

