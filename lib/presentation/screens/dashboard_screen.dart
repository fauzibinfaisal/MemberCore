import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:member_core/presentation/screens/settings_screen.dart';
import '../../core/utils/format_utils.dart';
import '../../domain/entities/member.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/dashboard/dashboard_bloc.dart';
import '../blocs/dashboard/dashboard_event.dart';
import '../blocs/dashboard/dashboard_state.dart';
import '../widgets/summary_card.dart';
import '../widgets/member_header.dart';
import '../widgets/transaction_chart.dart';
import 'login_screen.dart';
import 'transaction_screen.dart';

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
                if (value == 'settings') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                } else if (value == 'logout') {
                  _showLogoutDialog(context);
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings_outlined, size: 20.sp),
                      SizedBox(width: 12.w),
                      Text('Settings'),
                    ],
                  ),
                ),
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
              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        final bloc = context.read<DashboardBloc>();
                        bloc.add(RefreshDashboard(memberId: widget.member.id));
                        await bloc.stream
                            .where((s) => s is DashboardLoaded || s is DashboardError)
                            .first
                            .timeout(
                          const Duration(seconds: 5),
                          onTimeout: () => bloc.state,
                        );
                      },
                      child: ListView(
                        padding: EdgeInsets.all(20.r),
                        children: [
                          MemberHeader(member: state.member),
                          SizedBox(height: 24.h),
                          Text(
                            'Overview',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            children: [
                              Expanded(
                                child: SummaryCard(
                                  icon: Icons.shopping_bag_outlined,
                                  title: 'This Month',
                                  value: FormatUtils.currency(
                                    state.summary.totalPurchaseThisMonth,
                                  ),
                                  color: const Color(0xFF6C5CE7),
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: SummaryCard(
                                  icon: Icons.receipt_long_outlined,
                                  title: 'Transactions',
                                  value: '${state.summary.totalTransactions}',
                                  color: const Color(0xFF00CEC9),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            children: [
                              Expanded(
                                child: SummaryCard(
                                  icon: Icons.calendar_today_outlined,
                                  title: 'Last Transaction',
                                  value: state.summary.lastTransactionDate != null
                                      ? FormatUtils.relativeDate(
                                      state.summary.lastTransactionDate!)
                                      : '-',
                                  color: const Color(0xFFFD79A8),
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: SummaryCard(
                                  icon: Icons.star_outline_rounded,
                                  title: 'Status',
                                  value: state.member.membershipStatus,
                                  color: const Color(0xFFFDCB6E),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          TransactionChart(
                            trend: state.filteredTrend,
                            startMonth: state.startMonth,
                            endMonth: state.endMonth,
                            availableMonths:
                            state.summary.monthlyTrend.map((t) => t.month).toList(),
                            onRangeChanged: (start, end) {
                              context.read<DashboardBloc>().add(
                                UpdateChartRange(startMonth: start, endMonth: end),
                              );
                            },
                          ),
                          SizedBox(height: 40.h), // Extra space after chart
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          offset: Offset(0, -4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => TransactionScreen(
                                  memberId: widget.member.id,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.history_rounded),
                          label: Text('View Purchase History'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            side: BorderSide(
                              color: theme.colorScheme.primary.withValues(alpha: 0.3),
                            ),
                            textStyle: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
