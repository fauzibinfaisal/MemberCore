import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {
  final String memberId;

  const LoadTransactions({required this.memberId});

  @override
  List<Object?> get props => [memberId];
}

class FilterChanged extends TransactionEvent {
  final String? selectedMonth;
  final String? selectedStatus;
  final String? selectedCategory;

  const FilterChanged({
    this.selectedMonth,
    this.selectedStatus,
    this.selectedCategory,
  });

  @override
  List<Object?> get props => [selectedMonth, selectedStatus, selectedCategory];
}

class ClearFilters extends TransactionEvent {
  const ClearFilters();
}
