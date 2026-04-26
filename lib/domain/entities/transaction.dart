
import 'package:equatable/equatable.dart';
import 'transaction_item.dart';

class Transaction extends Equatable {
  final String id;
  final DateTime date;
  final List<TransactionItem> items;
  final String status; // 'Completed', 'Pending', 'Failed'

  const Transaction({
    required this.id,
    required this.date,
    required this.items,
    required this.status,
  });

  double get amount => items.fold(0.0, (sum, item) => sum + item.total);

  String get category => categories.first;

  Set<String> get categories {
    if (items.isEmpty) return {'OT'};
    return items.map((item) => _mapCategory(item.product.category)).toSet();
  }

  String _mapCategory(String cat) {
    if (cat.contains('supplements')) return 'SP';
    if (cat.contains('skincare')) return 'SC';
    if (cat.contains('personal_care')) return 'PC';
    if (cat.contains('natural_food')) return 'NF';
    if (cat.contains('kids')) return 'KD';
    return 'OT';
  }

  @override
  List<Object?> get props => [id, date, items, status];
}

