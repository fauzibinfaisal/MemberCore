import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckSessionUseCase checkSessionUseCase;
  final GetCurrentMemberUseCase getCurrentMemberUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.checkSessionUseCase,
    required this.getCurrentMemberUseCase,
  }) : super(const AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<CheckSession>(_onCheckSession);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());
    try {
      final member = await loginUseCase(event.email, event.password);
      emit(AuthAuthenticated(member: member));
    } catch (e) {
      emit(AuthError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onCheckSession(
      CheckSession event,
      Emitter<AuthState> emit,
      ) async {
    try {
      final isLoggedIn = await checkSessionUseCase();
      if (isLoggedIn) {
        final member = await getCurrentMemberUseCase();
        if (member != null) {
          emit(AuthAuthenticated(member: member));
        } else {
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    await logoutUseCase();
    emit(const AuthUnauthenticated());
  }
}