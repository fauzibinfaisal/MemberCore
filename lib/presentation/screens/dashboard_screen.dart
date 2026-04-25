import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/member.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/dashboard/dashboard_bloc.dart';
import '../blocs/dashboard/dashboard_event.dart';
import '../blocs/dashboard/dashboard_state.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Member member;

  const DashboardScreen({super.key, required this.member});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<DashboardBloc>()
        .add(LoadDashboard(memberId: widget.member.id));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert_rounded),
              onSelected: (value) {
                if (value == 'logout') {
                  _showLogoutDialog(context);
                }
              },
              itemBuilder: (BuildContext context) => [

                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded,
                          size: 20.sp, color: Colors.red),
                      SizedBox(width: 12.w),
                      Text('Logout', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is DashboardError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(32.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 64.sp,
                        color: theme.colorScheme.error.withValues(alpha: 0.6),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                      SizedBox(height: 24.h),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<DashboardBloc>().add(
                            LoadDashboard(memberId: widget.member.id),
                          );
                        },
                        icon: Icon(Icons.refresh),
                        label: Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is DashboardLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  final bloc = context.read<DashboardBloc>();
                  bloc.add(RefreshDashboard(memberId: widget.member.id));
                  // Use a subscription with timeout to avoid getting stuck
                  await bloc.stream
                      .where(
                          (s) => s is DashboardLoaded || s is DashboardError)
                      .first
                      .timeout(
                    const Duration(seconds: 5),
                    onTimeout: () => bloc.state,
                  );
                },
                child: ListView(
                  padding: EdgeInsets.all(20.r),
                  children: [],
                ),
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text('Logout'),
        content: Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AuthBloc>().add(const LogoutRequested());
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
