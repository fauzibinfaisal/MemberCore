import '../../domain/entities/transaction.dart';
import 'transaction_item_model.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.date,
    required List<TransactionItemModel> super.items,
    required super.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => TransactionItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'items': (items as List<TransactionItemModel>).map((e) => e.toJson()).toList(),
      'status': status,
    };
  }
}
