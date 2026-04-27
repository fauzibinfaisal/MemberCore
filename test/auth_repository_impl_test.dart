import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:member_core/data/datasources/mock_data_source.dart';
import 'package:member_core/data/repositories/auth_repository_impl.dart';
import 'package:member_core/domain/entities/member.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockDataSource dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    dataSource = MockDataSource();
    repository = AuthRepositoryImpl(dataSource: dataSource, prefs: prefs);
  });

  group('AuthRepositoryImpl Tests', () {
    test('login should authenticate via MockDataSource and save session to SharedPreferences', () async {
      // Act
      final member = await repository.login('MB001', 'password123');

      // Assert
      expect(member, isA<Member>());
      expect(member.id, 'MB001');

      final isLoggedIn = await repository.isLoggedIn();
      expect(isLoggedIn, true);

      final currentMember = await repository.getCurrentMember();
      expect(currentMember, isNotNull);
      expect(currentMember?.id, 'MB001');
      expect(currentMember?.name, 'Fauzi Fauzi');
    });

    test('login with invalid credentials should throw Exception and not save session', () async {
      // Act & Assert
      expect(
            () => repository.login('MB001', 'wrongpass'),
        throwsA(isA<Exception>()),
      );

      final isLoggedIn = await repository.isLoggedIn();
      expect(isLoggedIn, false);

      final currentMember = await repository.getCurrentMember();
      expect(currentMember, isNull);
    });

    test('logout should clear SharedPreferences', () async {
      // Arrange - login first
      await repository.login('MB001', 'password123');
      expect(await repository.isLoggedIn(), true);

      // Act
      await repository.logout();

      // Assert
      expect(await repository.isLoggedIn(), false);
      expect(await repository.getCurrentMember(), isNull);
    });

    test('getCurrentMember should return null when no session is active', () async {
      final currentMember = await repository.getCurrentMember();
      expect(currentMember, isNull);
    });
  });
}
