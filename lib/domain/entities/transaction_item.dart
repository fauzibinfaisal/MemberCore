import 'package:equatable/equatable.dart';
import 'product.dart';

class TransactionItem extends Equatable {
  final Product product;
  final int quantity;

  const TransactionItem({
    required this.product,
    required this.quantity,
  });

  double get total => product.price * quantity;

  @override
  List<Object?> get props => [product, quantity];
}
