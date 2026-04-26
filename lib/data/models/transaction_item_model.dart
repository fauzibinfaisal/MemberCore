import '../../domain/entities/transaction_item.dart';
import 'product_model.dart';

class TransactionItemModel extends TransactionItem {
  const TransactionItemModel({
    required ProductModel super.product,
    required super.quantity,
  });

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) {
    return TransactionItemModel(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': (product as ProductModel).toJson(),
      'quantity': quantity,
    };
  }
}
