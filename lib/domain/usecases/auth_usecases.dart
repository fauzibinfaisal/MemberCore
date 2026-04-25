import '../entities/member.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Member> call(String email, String password) {
    return repository.login(email, password);
  }
}
