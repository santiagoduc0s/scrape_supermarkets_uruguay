import 'package:scrape_supermarkets_uruguay/src/models/product/product.dart';

class ProductMapper {
  Product fromTata(Map<String, dynamic> data) {
    return Product(
      id: data['id'] as String,
      name: data['name'] as String,
      brand: data['brand']['name'] as String?,
      price: (data['offers']['lowPrice'] as num).toDouble(),
      imageUrl: data['image']?[0]?['url'] as String?,
    );
  }

  Product fromDisco(Map<String, dynamic> data) {
    print('asdfasf');
    return Product(
      id: data['productId'] as String,
      name: data['productName'] as String,
      brand: data['brand'] as String?,
      price: (data['priceRange']['sellingPrice']['lowPrice'] as num).toDouble(),
      imageUrl: data['items']?[0]?['images']?[0]?['imageUrl'] as String?,
    );
  }
}
