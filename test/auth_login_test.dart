import 'package:flutter_test/flutter_test.dart';
import 'package:member_core/data/datasources/mock_data_source.dart';

void main() {
  late MockDataSource dataSource;

  setUp(() {
    dataSource = MockDataSource();
  });

  group('MockDataSource Login Authentication', () {
    test('Successful login with MB001 and correct password', () async {
      final member = await dataSource.login('MB001', 'password123');
      expect(member, isNotNull);
      expect(member?.id, 'MB001');
      expect(member?.name, 'Fauzi Fauzi');
    });

    test('Successful login with fauzi.f@tech.com and correct password', () async {
      final member = await dataSource.login('fauzi.f@tech.com', 'password123');
      expect(member, isNotNull);
      expect(member?.id, 'MB001');
    });

    test('Successful login with MB002 and correct password', () async {
      final member = await dataSource.login('MB002', 'qwerty123');
      expect(member, isNotNull);
      expect(member?.id, 'MB002');
      expect(member?.name, 'Sarah Putri');
    });

    test('Failed login with MB001 and incorrect password throws Exception', () async {
      expect(
            () => dataSource.login('MB001', 'wrongpass'),
        throwsA(isA<Exception>().having(
                (e) => e.toString(), 'message', contains('Invalid User ID/Email or password'))),
      );
    });

    test('Failed login with MB002 and incorrect password throws Exception', () async {
      expect(
            () => dataSource.login('MB002', 'password123'),
        throwsA(isA<Exception>().having(
                (e) => e.toString(), 'message', contains('Invalid User ID/Email or password'))),
      );
    });

    test('Failed login with non-existent user throws Exception', () async {
      expect(
            () => dataSource.login('unknown@user.com', 'password123'),
        throwsA(isA<Exception>().having(
                (e) => e.toString(), 'message', contains('Invalid User ID/Email or password'))),
      );
    });

    test('Failed login with short password throws Exception', () async {
      expect(
            () => dataSource.login('MB001', '123'),
        throwsA(isA<Exception>().having(
                (e) => e.toString(), 'message', contains('Password must be at least 4 characters'))),
      );
    });
  });
}
