import 'package:equatable/equatable.dart';

class DashboardSummary extends Equatable {
  final double totalPurchaseThisMonth;
  final DateTime? lastTransactionDate;
  final int totalTransactions;

  const DashboardSummary({
    required this.totalPurchaseThisMonth,
    this.lastTransactionDate,
    required this.totalTransactions,
  });

  @override
  List<Object?> get props =>
      [totalPurchaseThisMonth, lastTransactionDate, totalTransactions];
}
