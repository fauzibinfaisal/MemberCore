import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String category;
  final String name;
  final String sku;
  final double price;
  final String description;
  final String package;

  const Product({
    required this.category,
    required this.name,
    required this.sku,
    required this.price,
    required this.description,
    required this.package,
  });

  @override
  List<Object?> get props => [
    category,
    name,
    sku,
    price,
    description,
    package,
  ];
}
