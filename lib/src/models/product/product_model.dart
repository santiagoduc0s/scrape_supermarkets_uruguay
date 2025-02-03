import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    /// The product's id.
    required String id,

    /// The product's name.
    required String name,

    /// The product's brand.
    required String? brand,

    /// The product's price.
    required double price,

    /// The product's image URL.
    required String? imageUrl,
  }) = _Product;

  factory Product.fromJson(Map<String, Object?> json) => _$ProductFromJson(json);

  const Product._();

  factory Product.empty({
    String id = '',
    String name = '',
    String? brand,
    double price = 0.0,
    String? imageUrl,
  }) {
    return Product(
      id: id,
      name: name,
      brand: brand,
      price: price,
      imageUrl: imageUrl,
    );
  }
}
