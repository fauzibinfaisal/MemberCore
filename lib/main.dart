import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:member_core/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:member_core/presentation/screens/dashboard_screen.dart';
import 'package:member_core/presentation/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/theme/app_theme.dart';
import 'data/datasources/mock_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/member_repository_impl.dart';
import 'domain/usecases/auth_usecases.dart';
import 'domain/usecases/member_usecases.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'presentation/blocs/auth/auth_state.dart';
import 'presentation/blocs/theme/theme_bloc.dart';
import 'presentation/blocs/theme/theme_state.dart';
import 'presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MemberDashboardApp(prefs: prefs));
}

class MemberDashboardApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MemberDashboardApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    // Dependency injection — manual, no framework needed
    final dataSource = MockDataSource();

    final authRepo = AuthRepositoryImpl(
      dataSource: dataSource,
      prefs: prefs,
    );
    final memberRepo = MemberRepositoryImpl(dataSource: dataSource);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            loginUseCase: LoginUseCase(authRepo),
            logoutUseCase: LogoutUseCase(authRepo),
            checkSessionUseCase: CheckSessionUseCase(authRepo),
            getCurrentMemberUseCase: GetCurrentMemberUseCase(authRepo),
          )..add(const CheckSession()),
        ),
        BlocProvider<DashboardBloc>(
          create: (_) => DashboardBloc(
            getMemberProfileUseCase: GetMemberProfileUseCase(memberRepo),
            getDashboardSummaryUseCase:
            GetDashboardSummaryUseCase(memberRepo),
          ),
        ),
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc(prefs: prefs),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // Standard design size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                title: 'Member Dashboard',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                home: child,
              );
            },
          );
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthInitial) {
              return const SplashScreen();
            }
            if (state is AuthAuthenticated) {
              return DashboardScreen(member: state.member);
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}