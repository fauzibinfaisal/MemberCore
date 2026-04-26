import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.category,
    required super.name,
    required super.sku,
    required super.price,
    required super.description,
    required super.package,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      category: json['category'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      package: json['package'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'name': name,
      'sku': sku,
      'price': price,
      'description': description,
      'package': package,
    };
  }
}
