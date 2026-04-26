import 'package:flutter_test/flutter_test.dart';
import 'package:member_core/domain/entities/transaction.dart';
import 'package:member_core/domain/entities/transaction_item.dart';
import 'package:member_core/domain/entities/product.dart';
import 'package:intl/intl.dart';

/// Tests the core filtering logic that powers the Transaction screen.
/// This is the most critical business logic in the app.
void main() {
  const pFood = Product(category: 'natural_food', name: 'Honey', sku: '1', price: 85000, description: '', package: '');
  const pShop = Product(category: 'personal_care', name: 'Cream', sku: '2', price: 450000, description: '', package: '');
  const pTrans = Product(category: 'supplements_immunity', name: 'Propoelix', sku: '3', price: 120000, description: '', package: '');
  const pBills = Product(category: 'kids', name: 'Gummy', sku: '4', price: 35000, description: '', package: '');

  final testTransactions = [
    Transaction(
      id: '1',
      date: DateTime(2026, 4, 24),
      items: const [TransactionItem(product: pFood, quantity: 1)],
      status: 'Completed',
    ),
    Transaction(
      id: '2',
      date: DateTime(2026, 4, 20),
      items: const [TransactionItem(product: pShop, quantity: 1)],
      status: 'Pending',
    ),
    Transaction(
      id: '3',
      date: DateTime(2026, 3, 15),
      items: const [TransactionItem(product: pTrans, quantity: 1)],
      status: 'Completed',
    ),
    Transaction(
      id: '4',
      date: DateTime(2026, 3, 10),
      items: const [TransactionItem(product: pBills, quantity: 1)],
      status: 'Failed',
    ),
    Transaction(
      id: '5',
      date: DateTime(2026, 2, 25),
      items: const [TransactionItem(product: pFood, quantity: 2)],
      status: 'Completed',
    ),
  ];

  /// Replicates the filtering logic from TransactionBloc
  List<Transaction> applyFilters(
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
          selectedCategory == null || trx.category == selectedCategory;
      return matchMonth && matchStatus && matchCategory;
    }).toList();
  }

  group('Transaction Filtering', () {
    test('no filters returns all transactions', () {
      final result = applyFilters(testTransactions);
      expect(result.length, 5);
    });

    test('filter by month returns correct transactions', () {
      final result = applyFilters(
        testTransactions,
        selectedMonth: 'Apr 2026',
      );
      expect(result.length, 2);
      expect(result.every((t) => t.date.month == 4), true);
    });

    test('filter by status returns correct transactions', () {
      final result = applyFilters(
        testTransactions,
        selectedStatus: 'Completed',
      );
      expect(result.length, 3);
      expect(result.every((t) => t.status == 'Completed'), true);
    });

    test('filter by category returns correct transactions', () {
      final result = applyFilters(
        testTransactions,
        selectedCategory: 'NF', // natural_food
      );
      expect(result.length, 2);
      expect(result.every((t) => t.category == 'NF'), true);
    });

    test('combined filters (month + status) work together', () {
      final result = applyFilters(
        testTransactions,
        selectedMonth: 'Apr 2026',
        selectedStatus: 'Completed',
      );
      expect(result.length, 1);
      expect(result.first.id, '1');
    });

    test('combined filters (month + category) work together', () {
      final result = applyFilters(
        testTransactions,
        selectedMonth: 'Mar 2026',
        selectedCategory: 'SP', // supplements
      );
      expect(result.length, 1);
      expect(result.first.items.first.product.name, 'Propoelix');
    });

    test('all three filters combined', () {
      final result = applyFilters(
        testTransactions,
        selectedMonth: 'Apr 2026',
        selectedStatus: 'Pending',
        selectedCategory: 'PC', // personal_care
      );
      expect(result.length, 1);
      expect(result.first.id, '2');
    });

    test('filters with no match return empty list', () {
      final result = applyFilters(
        testTransactions,
        selectedMonth: 'Jan 2025',
      );
      expect(result.isEmpty, true);
    });

    test('filter by failed status', () {
      final result = applyFilters(
        testTransactions,
        selectedStatus: 'Failed',
      );
      expect(result.length, 1);
      expect(result.first.category, 'KD'); // kids
    });
  });

  group('Transaction Entity', () {
    test('two identical transactions are equal (Equatable)', () {
      final date = DateTime(2026, 4, 1);
      final t1 = Transaction(
        id: '1',
        date: date,
        items: const [TransactionItem(product: pFood, quantity: 1)],
        status: 'Completed',
      );
      final t2 = Transaction(
        id: '1',
        date: date,
        items: const [TransactionItem(product: pFood, quantity: 1)],
        status: 'Completed',
      );
      expect(t1, equals(t2));
    });

    test('transactions with different ids are not equal', () {
      final date = DateTime(2026, 4, 1);
      final t1 = Transaction(
        id: '1',
        date: date,
        items: const [TransactionItem(product: pFood, quantity: 1)],
        status: 'Completed',
      );
      final t2 = Transaction(
        id: '2',
        date: date,
        items: const [TransactionItem(product: pFood, quantity: 1)],
        status: 'Completed',
      );
      expect(t1, isNot(equals(t2)));
    });
  });
}
