import '../entities/member.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Member> call(String email, String password) {
    return repository.login(email, password);
  }
}

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}

class CheckSessionUseCase {
  final AuthRepository repository;

  CheckSessionUseCase(this.repository);

  Future<bool> call() {
    return repository.isLoggedIn();
  }
}

class GetCurrentMemberUseCase {
  final AuthRepository repository;

  GetCurrentMemberUseCase(this.repository);

  Future<Member?> call() {
    return repository.getCurrentMember();
  }
}