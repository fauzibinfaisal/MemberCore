import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/mock_data_source.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final MockDataSource _dataSource;

  TransactionRepositoryImpl({required MockDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<Transaction>> getTransactions(String memberId) {
    return _dataSource.getTransactions(memberId);
  }
}
