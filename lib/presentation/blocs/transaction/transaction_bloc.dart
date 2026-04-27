import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/transaction.dart';
import '../../../domain/usecases/transaction_usecases.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactionsUseCase getTransactionsUseCase;

  TransactionBloc({required this.getTransactionsUseCase})
      : super(const TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<FilterChanged>(_onFilterChanged);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onLoadTransactions(
      LoadTransactions event,
      Emitter<TransactionState> emit,
      ) async {
    emit(const TransactionLoading());
    try {
      final transactions = await getTransactionsUseCase(event.memberId);

      // Sort by date descending
      final sorted = List<Transaction>.from(transactions)
        ..sort((a, b) => b.date.compareTo(a.date));

      // Extract available filter options from data
      final months = _extractMonths(sorted);
      final categories = _extractCategories(sorted);
      final statuses = _extractStatuses(sorted);

      emit(TransactionLoaded(
        allTransactions: sorted,
        filteredTransactions: sorted,
        availableMonths: months,
        availableCategories: categories,
        availableStatuses: statuses,
      ));
    } catch (e) {
      emit(TransactionError(
          message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  void _onFilterChanged(
      FilterChanged event,
      Emitter<TransactionState> emit,
      ) {
    final currentState = state;
    if (currentState is TransactionLoaded) {
      final newState = currentState.copyWith(
        selectedMonth: () => event.selectedMonth,
        selectedStatus: () => event.selectedStatus,
        selectedCategory: () => event.selectedCategory,
      );

      final filtered = _applyFilters(
        newState.allTransactions,
        selectedMonth: newState.selectedMonth,
        selectedStatus: newState.selectedStatus,
        selectedCategory: newState.selectedCategory,
      );

      emit(newState.copyWith(filteredTransactions: filtered));
    }
  }

  void _onClearFilters(
      ClearFilters event,
      Emitter<TransactionState> emit,
      ) {
    final currentState = state;
    if (currentState is TransactionLoaded) {
      emit(TransactionLoaded(
        allTransactions: currentState.allTransactions,
        filteredTransactions: currentState.allTransactions,
        availableMonths: currentState.availableMonths,
        availableCategories: currentState.availableCategories,
        availableStatuses: currentState.availableStatuses,
      ));
    }
  }

  /// Core filtering logic — all filters work together (AND logic)
  List<Transaction> _applyFilters(
      List<Transaction> all, {
        String? selectedMonth,
        String? selectedStatus,
        String? selectedCategory,
      }) {
    return all.where((trx) {
      final matchMonth = selectedMonth == null ||
          DateFormat('MMM yyyy').format(trx.date) == selectedMonth;

      final matchStatus =
          selectedStatus == null || trx.status == selectedStatus;

      final matchCategory =
          selectedCategory == null || trx.categories.contains(selectedCategory);

      return matchMonth && matchStatus && matchCategory;
    }).toList();
  }

  List<String> _extractMonths(List<Transaction> transactions) {
    final months = <String>{};
    for (final t in transactions) {
      months.add(DateFormat('MMM yyyy').format(t.date));
    }
    return months.toList();
  }

  List<String> _extractCategories(List<Transaction> transactions) {
    final categories = <String>{};
    for (final t in transactions) {
      categories.addAll(t.categories);
    }
    final sorted = categories.toList()..sort();
    return sorted;
  }

  List<String> _extractStatuses(List<Transaction> transactions) {
    final statuses = <String>{};
    for (final t in transactions) {
      statuses.add(t.status);
    }
    return statuses.toList()..sort();
  }
}
