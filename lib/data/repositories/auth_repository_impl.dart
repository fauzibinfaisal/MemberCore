import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/member.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/mock_data_source.dart';
import '../models/member_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final MockDataSource _dataSource;
  final SharedPreferences _prefs;

  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyMemberId = 'member_id';
  static const _keyMemberName = 'member_name';
  static const _keyMemberEmail = 'member_email';
  static const _keyMemberCity = 'member_city';
  static const _keyMemberJoinDate = 'member_join_date';
  static const _keyMemberStatus = 'member_membership_status';

  AuthRepositoryImpl({
    required MockDataSource dataSource,
    required SharedPreferences prefs,
  })  : _dataSource = dataSource,
        _prefs = prefs;

  @override
  Future<Member> login(String email, String password) async {
    final member = await _dataSource.login(email, password);
    if (member != null) {
      await _prefs.setBool(_keyIsLoggedIn, true);
      await _prefs.setString(_keyMemberId, member.id);
      await _prefs.setString(_keyMemberName, member.name);
      await _prefs.setString(_keyMemberEmail, member.email);
      await _prefs.setString(_keyMemberCity, member.city);
      await _prefs.setString(
          _keyMemberJoinDate, member.joinDate.toIso8601String());
      await _prefs.setString(_keyMemberStatus, member.membershipStatus);
    }
    return member!;
  }

  @override
  Future<void> logout() async {
    await _prefs.clear();
  }

  @override
  Future<bool> isLoggedIn() async {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  @override
  Future<Member?> getCurrentMember() async {
    final isLoggedIn = _prefs.getBool(_keyIsLoggedIn) ?? false;
    if (!isLoggedIn) return null;

    final id = _prefs.getString(_keyMemberId);
    final name = _prefs.getString(_keyMemberName);
    final email = _prefs.getString(_keyMemberEmail);
    final city = _prefs.getString(_keyMemberCity);
    final joinDateStr = _prefs.getString(_keyMemberJoinDate);
    final status = _prefs.getString(_keyMemberStatus);

    if (id == null || name == null || email == null) return null;

    return MemberModel(
      id: id,
      name: name,
      email: email,
      city: city ?? '',
      joinDate:
      joinDateStr != null ? DateTime.parse(joinDateStr) : DateTime.now(),
      membershipStatus: status ?? 'Bronze',
    );
  }
}
