import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:member_core/domain/entities/transaction.dart';
import 'package:member_core/domain/entities/transaction_item.dart';
import 'package:member_core/domain/entities/product.dart';
import 'package:member_core/domain/usecases/transaction_usecases.dart';
import 'package:member_core/presentation/blocs/transaction/transaction_bloc.dart';
import 'package:member_core/presentation/blocs/transaction/transaction_event.dart';
import 'package:member_core/presentation/blocs/transaction/transaction_state.dart';

class MockGetTransactionsUseCase extends Mock implements GetTransactionsUseCase {}

void main() {
  late MockGetTransactionsUseCase getTransactionsUseCase;

  const p1 = Product(category: 'supplements_immunity', name: 'Product 1', sku: 'SKU1', price: 100, description: '', package: '');
  const p2 = Product(category: 'skincare', name: 'Product 2', sku: 'SKU2', price: 200, description: '', package: '');

  final t1 = Transaction(
    id: 'TX1',
    date: DateTime(2026, 4, 25),
    items: const [TransactionItem(product: p1, quantity: 1)],
    status: 'Completed',
  );

  final t2 = Transaction(
    id: 'TX2',
    date: DateTime(2026, 3, 10),
    items: const [TransactionItem(product: p2, quantity: 1)],
    status: 'Pending',
  );

  final transactions = [t1, t2];

  setUp(() {
    getTransactionsUseCase = MockGetTransactionsUseCase();
  });

  TransactionBloc buildBloc() => TransactionBloc(getTransactionsUseCase: getTransactionsUseCase);

  group('TransactionBloc', () {
    test('initial state should be TransactionInitial', () {
      expect(buildBloc().state, equals(const TransactionInitial()));
    });

    blocTest<TransactionBloc, TransactionState>(
      'emits [TransactionLoading, TransactionLoaded] when LoadTransactions succeeds',
      build: () {
        when(() => getTransactionsUseCase(any())).thenAnswer((_) async => transactions);
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadTransactions(memberId: 'MB001')),
      expect: () => [
        const TransactionLoading(),
        TransactionLoaded(
          allTransactions: [t1, t2],
          filteredTransactions: [t1, t2],
          availableMonths: const ['Apr 2026', 'Mar 2026'],
          availableCategories: const ['Skincare', 'Supplements'], // skincare -> Skincare, supplements -> Supplements
          availableStatuses: const ['Completed', 'Pending'],
        ),
      ],
    );

    blocTest<TransactionBloc, TransactionState>(
      'emits [TransactionLoading, TransactionError] when LoadTransactions fails',
      build: () {
        when(() => getTransactionsUseCase(any())).thenThrow(Exception('Error loading transactions'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadTransactions(memberId: 'MB001')),
      expect: () => [
        const TransactionLoading(),
        const TransactionError(message: 'Error loading transactions'),
      ],
    );

    blocTest<TransactionBloc, TransactionState>(
      'emits filtered transactions when FilterChanged is called',
      build: () {
        when(() => getTransactionsUseCase(any())).thenAnswer((_) async => transactions);
        return buildBloc();
      },
      seed: () => TransactionLoaded(
        allTransactions: [t1, t2],
        filteredTransactions: [t1, t2],
        availableMonths: const ['Apr 2026', 'Mar 2026'],
        availableCategories: const ['Skincare', 'Supplements'],
        availableStatuses: const ['Completed', 'Pending'],
      ),
      act: (bloc) => bloc.add(const FilterChanged(selectedStatus: 'Pending')),
      expect: () => [
        TransactionLoaded(
          allTransactions: [t1, t2],
          filteredTransactions: [t2],
          availableMonths: const ['Apr 2026', 'Mar 2026'],
          availableCategories: const ['Skincare', 'Supplements'],
          availableStatuses: const ['Completed', 'Pending'],
          selectedStatus: 'Pending',
        ),
      ],
    );

    blocTest<TransactionBloc, TransactionState>(
      'emits all transactions when ClearFilters is called',
      build: () {
        when(() => getTransactionsUseCase(any())).thenAnswer((_) async => transactions);
        return buildBloc();
      },
      seed: () => TransactionLoaded(
        allTransactions: [t1, t2],
        filteredTransactions: [t2],
        availableMonths: const ['Apr 2026', 'Mar 2026'],
        availableCategories: const ['Skincare', 'Supplements'],
        availableStatuses: const ['Completed', 'Pending'],
        selectedStatus: 'Pending',
      ),
      act: (bloc) => bloc.add(const ClearFilters()),
      expect: () => [
        TransactionLoaded(
          allTransactions: [t1, t2],
          filteredTransactions: [t1, t2],
          availableMonths: const ['Apr 2026', 'Mar 2026'],
          availableCategories: const ['Skincare', 'Supplements'],
          availableStatuses: const ['Completed', 'Pending'],
        ),
      ],
    );
    blocTest<TransactionBloc, TransactionState>(
      'filters multi-category transaction correctly',
      build: () {
        final tMulti = Transaction(
          id: 'TX_MULTI',
          date: DateTime(2026, 4, 25),
          items: const [
            TransactionItem(product: p1, quantity: 1), // SP
            TransactionItem(product: p2, quantity: 1), // SC
          ],
          status: 'Completed',
        );
        when(() => getTransactionsUseCase(any())).thenAnswer((_) async => [tMulti]);
        return buildBloc();
      },
      seed: () {
        final tMulti = Transaction(
          id: 'TX_MULTI',
          date: DateTime(2026, 4, 25),
          items: const [
            TransactionItem(product: p1, quantity: 1),
            TransactionItem(product: p2, quantity: 1),
          ],
          status: 'Completed',
        );
        return TransactionLoaded(
          allTransactions: [tMulti],
          filteredTransactions: [tMulti],
          availableMonths: const ['Apr 2026'],
          availableCategories: const ['Skincare', 'Supplements'],
          availableStatuses: const ['Completed'],
        );
      },
      act: (bloc) => bloc.add(const FilterChanged(selectedCategory: 'Skincare')),
      expect: () => [
        isA<TransactionLoaded>().having((s) => s.filteredTransactions.length, 'length', 1)
            .having((s) => s.filteredTransactions.first.id, 'id', 'TX_MULTI'),
      ],
    );
  });
}
