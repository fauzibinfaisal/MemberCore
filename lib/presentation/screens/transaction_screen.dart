import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/transaction/transaction_bloc.dart';
import '../blocs/transaction/transaction_event.dart';
import '../blocs/transaction/transaction_state.dart';
import '../widgets/transaction_card.dart';
import '../widgets/filter_chip_row.dart';

class TransactionScreen extends StatefulWidget {
  final String memberId;

  const TransactionScreen({super.key, required this.memberId});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<TransactionBloc>()
        .add(LoadTransactions(memberId: widget.memberId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase History'),
      ),
      endDrawer: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoaded) {
            return _buildFilterDrawer(context, state, theme);
          }
          return const Drawer();
        },
      ),
      body: Builder(
        builder: (scaffoldContext) {
          return BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              if (state is TransactionLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is TransactionError) {
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
                            context.read<TransactionBloc>().add(
                              LoadTransactions(memberId: widget.memberId),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is TransactionLoaded) {
                return Column(
                  children: [
                    // Horizontal Filter Row
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: theme.cardTheme.color,
                        border: Border(
                          bottom: BorderSide(
                            color: theme.dividerTheme.color ?? Colors.grey.shade200,
                          ),
                        ),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Filter Button
                            OutlinedButton.icon(
                              onPressed: () {
                                Scaffold.of(scaffoldContext).openEndDrawer();
                              },
                              icon: Icon(Icons.tune_rounded, size: 18.sp),
                              label: const Text('Filter'),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),

                            // Active Filters
                            if (state.selectedMonth != null) ...[
                              SizedBox(width: 8.w),
                              InputChip(
                                label: Text(state.selectedMonth!),
                                onDeleted: () {
                                  context.read<TransactionBloc>().add(
                                    FilterChanged(
                                      selectedMonth: null,
                                      selectedStatus: state.selectedStatus,
                                      selectedCategory: state.selectedCategory,
                                    ),
                                  );
                                },
                                deleteIconColor: theme.colorScheme.onSurface,
                              ),
                            ],
                            if (state.selectedStatus != null) ...[
                              SizedBox(width: 8.w),
                              InputChip(
                                label: Text(state.selectedStatus!),
                                onDeleted: () {
                                  context.read<TransactionBloc>().add(
                                    FilterChanged(
                                      selectedMonth: state.selectedMonth,
                                      selectedStatus: null,
                                      selectedCategory: state.selectedCategory,
                                    ),
                                  );
                                },
                                deleteIconColor: theme.colorScheme.onSurface,
                              ),
                            ],
                            if (state.selectedCategory != null) ...[
                              SizedBox(width: 8.w),
                              InputChip(
                                label: Text(state.selectedCategory!),
                                onDeleted: () {
                                  context.read<TransactionBloc>().add(
                                    FilterChanged(
                                      selectedMonth: state.selectedMonth,
                                      selectedStatus: state.selectedStatus,
                                      selectedCategory: null,
                                    ),
                                  );
                                },
                                deleteIconColor: theme.colorScheme.onSurface,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // Results count
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      child: Row(
                        children: [
                          Text(
                            '${state.filteredTransactions.length} transaction${state.filteredTransactions.length != 1 ? 's' : ''}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (state.filteredTransactions.length !=
                              state.allTransactions.length)
                            Text(
                              ' of ${state.allTransactions.length}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.35),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Transaction List
                    Expanded(
                      child: state.filteredTransactions.isEmpty
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 72.sp,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.15),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No transactions found',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Try adjusting your filters',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                          ],
                        ),
                      )
                          : RefreshIndicator(
                        onRefresh: () async {
                          context.read<TransactionBloc>().add(
                            LoadTransactions(memberId: widget.memberId),
                          );
                          await context
                              .read<TransactionBloc>()
                              .stream
                              .firstWhere(
                                (s) =>
                            s is TransactionLoaded ||
                                s is TransactionError,
                          );
                        },
                        child: ListView.separated(
                          padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 50.h),
                          itemCount: state.filteredTransactions.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            return TransactionCard(
                              transaction:
                              state.filteredTransactions[index],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  Widget _buildFilterDrawer(BuildContext context, TransactionLoaded state, ThemeData theme) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.w, right: 16.w, top: 16.h, bottom: 16.h),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Filter',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (state.selectedMonth != null ||
                      state.selectedStatus != null ||
                      state.selectedCategory != null)
                    TextButton(
                      onPressed: () {
                        context.read<TransactionBloc>().add(const ClearFilters());
                      },
                      child: const Text('Reset'),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  FilterChipRow(
                    label: 'Month',
                    options: state.availableMonths,
                    selected: state.selectedMonth,
                    onSelected: (value) {
                      context.read<TransactionBloc>().add(
                        FilterChanged(
                          selectedMonth: value,
                          selectedStatus: state.selectedStatus,
                          selectedCategory: state.selectedCategory,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                  FilterChipRow(
                    label: 'Status',
                    options: state.availableStatuses,
                    selected: state.selectedStatus,
                    onSelected: (value) {
                      context.read<TransactionBloc>().add(
                        FilterChanged(
                          selectedMonth: state.selectedMonth,
                          selectedStatus: value,
                          selectedCategory: state.selectedCategory,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                  FilterChipRow(
                    label: 'Category',
                    options: state.availableCategories,
                    selected: state.selectedCategory,
                    onSelected: (value) {
                      context.read<TransactionBloc>().add(
                        FilterChanged(
                          selectedMonth: state.selectedMonth,
                          selectedStatus: state.selectedStatus,
                          selectedCategory: value,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}