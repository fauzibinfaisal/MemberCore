import 'package:equatable/equatable.dart';

import 'monthly_trend.dart';

class DashboardSummary extends Equatable {
  final double totalPurchaseThisMonth;
  final DateTime? lastTransactionDate;
  final int totalTransactions;
  final List<MonthlyTrend> monthlyTrend;

  const DashboardSummary({
    required this.totalPurchaseThisMonth,
    this.lastTransactionDate,
    required this.totalTransactions,
    required this.monthlyTrend,
  });

  @override
  List<Object?> get props =>
      [totalPurchaseThisMonth, lastTransactionDate, totalTransactions, monthlyTrend];
}

