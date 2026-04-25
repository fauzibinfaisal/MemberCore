import '../entities/member.dart';

abstract class AuthRepository {
  Future<Member> login(String email, String password);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<Member?> getCurrentMember();
}
