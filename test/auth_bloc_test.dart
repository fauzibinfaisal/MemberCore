import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:member_core/domain/entities/member.dart';
import 'package:member_core/domain/usecases/auth_usecases.dart';
import 'package:member_core/presentation/blocs/auth/auth_bloc.dart';
import 'package:member_core/presentation/blocs/auth/auth_event.dart';
import 'package:member_core/presentation/blocs/auth/auth_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockCheckSessionUseCase extends Mock implements CheckSessionUseCase {}
class MockGetCurrentMemberUseCase extends Mock implements GetCurrentMemberUseCase {}

void main() {
  late MockLoginUseCase loginUseCase;
  late MockLogoutUseCase logoutUseCase;
  late MockCheckSessionUseCase checkSessionUseCase;
  late MockGetCurrentMemberUseCase getCurrentMemberUseCase;

  final mockMember = Member(
    id: 'MB001',
    name: 'Fauzi Fauzi',
    email: 'fauzi.f@tech.com',
    city: 'Jakarta',
    joinDate: DateTime(2023, 3, 15),
    membershipStatus: 'Gold',
  );

  setUp(() {
    loginUseCase = MockLoginUseCase();
    logoutUseCase = MockLogoutUseCase();
    checkSessionUseCase = MockCheckSessionUseCase();
    getCurrentMemberUseCase = MockGetCurrentMemberUseCase();
  });

  AuthBloc buildBloc() => AuthBloc(
    loginUseCase: loginUseCase,
    logoutUseCase: logoutUseCase,
    checkSessionUseCase: checkSessionUseCase,
    getCurrentMemberUseCase: getCurrentMemberUseCase,
  );

  group('AuthBloc', () {
    test('initial state should be AuthInitial', () {
      expect(buildBloc().state, equals(const AuthInitial()));
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when LoginSubmitted succeeds',
      build: () {
        when(() => loginUseCase(any(), any())).thenAnswer((_) async => mockMember);
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoginSubmitted(email: 'MB001', password: 'password123')),
      expect: () => [
        const AuthLoading(),
        AuthAuthenticated(member: mockMember),
      ],
      verify: (_) {
        verify(() => loginUseCase('MB001', 'password123')).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when LoginSubmitted fails',
      build: () {
        when(() => loginUseCase(any(), any()))
            .thenThrow(Exception('Invalid User ID/Email or password'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoginSubmitted(email: 'wrong', password: 'pass')),
      expect: () => [
        const AuthLoading(),
        const AuthError(message: 'Invalid User ID/Email or password'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthUnauthenticated] when LogoutRequested is called',
      build: () {
        when(() => logoutUseCase()).thenAnswer((_) async {});
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LogoutRequested()),
      expect: () => [
        const AuthUnauthenticated(),
      ],
      verify: (_) {
        verify(() => logoutUseCase()).called(1);
      },
    );
  });
}
