import 'package:equatable/equatable.dart';
import '../../../domain/entities/transaction.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

class TransactionLoading extends TransactionState {
  const TransactionLoading();
}

class TransactionLoaded extends TransactionState {
  final List<Transaction> allTransactions;
  final List<Transaction> filteredTransactions;
  final String? selectedMonth;
  final String? selectedStatus;
  final String? selectedCategory;
  final List<String> availableMonths;
  final List<String> availableCategories;
  final List<String> availableStatuses;

  const TransactionLoaded({
    required this.allTransactions,
    required this.filteredTransactions,
    this.selectedMonth,
    this.selectedStatus,
    this.selectedCategory,
    required this.availableMonths,
    required this.availableCategories,
    required this.availableStatuses,
  });

  TransactionLoaded copyWith({
    List<Transaction>? allTransactions,
    List<Transaction>? filteredTransactions,
    String? Function()? selectedMonth,
    String? Function()? selectedStatus,
    String? Function()? selectedCategory,
    List<String>? availableMonths,
    List<String>? availableCategories,
    List<String>? availableStatuses,
  }) {
    return TransactionLoaded(
      allTransactions: allTransactions ?? this.allTransactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      selectedMonth:
      selectedMonth != null ? selectedMonth() : this.selectedMonth,
      selectedStatus:
      selectedStatus != null ? selectedStatus() : this.selectedStatus,
      selectedCategory:
      selectedCategory != null ? selectedCategory() : this.selectedCategory,
      availableMonths: availableMonths ?? this.availableMonths,
      availableCategories: availableCategories ?? this.availableCategories,
      availableStatuses: availableStatuses ?? this.availableStatuses,
    );
  }

  @override
  List<Object?> get props => [
    allTransactions,
    filteredTransactions,
    selectedMonth,
    selectedStatus,
    selectedCategory,
    availableMonths,
    availableCategories,
    availableStatuses,
  ];
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError({required this.message});

  @override
  List<Object?> get props => [message];
}
