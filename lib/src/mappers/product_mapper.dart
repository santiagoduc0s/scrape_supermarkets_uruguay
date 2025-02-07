import 'package:scrape_supermarkets_uruguay/src/models/models.dart';

class ProductMapper {
  Product fromTata(Map<String, dynamic> data) {
    final brandNameRaw = data['brand'] as Map<String, dynamic>;
    final brandName = brandNameRaw['name'] as String?;

    final priceRaw = data['price'] as Map<String, dynamic>;
    final price = (priceRaw['lowPrice'] as num).toDouble();

    final images = <String>[];
    final imagesRaw = data['image'] as List?;
    if (imagesRaw != null && imagesRaw.isNotEmpty) {
      for (final imageRaw in imagesRaw) {
        final imageMap = imageRaw as Map<String, dynamic>;

        final imageUrl = imageMap['url'] as String;
        images.add(imageUrl);
      }
    }

    final slug = data['slug'] as String;
    final link = '${Tata().domain}/$slug/p';

    return Product(
      id: data['id'] as String,
      name: data['name'] as String,
      brand: brandName,
      price: price,
      imageUrl: images,
      link: link,
    );
  }

  Product fromDisco(Map<String, dynamic> data) {
    final id = data['productId'] as String;

    final name = data['productName'] as String;

    final brand = data['brand'] as String;

    final itemsRaw = data['items'] as List<dynamic>;

    final item = itemsRaw.firstWhere((itemRaw) {
      final item = itemRaw as Map<String, dynamic>;
      return item['itemId'] == id;
    }) as Map<String, dynamic>;

    final imagesRaw = item['images'] as List<dynamic>;

    final images = imagesRaw.map((imageRaw) {
      final image = imageRaw as Map<String, dynamic>;

      return image['imageUrl'] as String;
    }).toList();

    final priceRange = data['priceRange'] as Map<String, dynamic>;
    final sellingPrice = priceRange['sellingPrice'] as Map<String, dynamic>;
    final lowPrice = (sellingPrice['lowPrice'] as num).toDouble();

    final linkText = data['linkText'] as String;
    final link = '${Disco().domain}/$linkText/p';

    return Product(
      id: id,
      name: name,
      brand: brand,
      price: lowPrice,
      imageUrl: images,
      link: link,
    );
  }

  Product fromTiendaInglesa(Map<String, dynamic> data) {
    final id = (data['Id'] as int).toString();
    final name = data['Name'] as String;

    final priceRaw = data['Price'] as String;
    final price = double.parse(priceRaw.replaceAll(RegExp(r'[^\d.]'), ''));

    final defaultImage = data['DefaultPicture'] as Map<String, dynamic>?;

    String? image;
    if (defaultImage != null) {
      image = defaultImage['Medium'] as String;
    }

    final images = [if (image != null) image];

    final extra = data['extra_data'] as Map<String, dynamic>;

    final extraInfo = extra['Info'] as Map<String, dynamic>;

    final uri = extraInfo['Uri'] as String;
    final brand = extraInfo['Brand'] as String;

    final link = '${TiendaInglesa().domain}$uri';

    return Product(
      id: id,
      name: name,
      brand: brand,
      price: price,
      imageUrl: images,
      link: link,
    );
  }

  Product fromDevoto(Map<String, dynamic> data) {
    final id = data['productId'] as String;

    final name = data['productName'] as String;

    final brand = data['brand'] as String?;

    final itemsRaw = data['items'] as List<dynamic>;

    final item = itemsRaw.firstWhere((itemRaw) {
      final item = itemRaw as Map<String, dynamic>;
      return item['itemId'] == id;
    }) as Map<String, dynamic>;

    final imagesRaw = item['images'] as List<dynamic>;

    final images = imagesRaw.map((imageRaw) {
      final image = imageRaw as Map<String, dynamic>;

      return image['imageUrl'] as String;
    }).toList();

    final priceRange = data['priceRange'] as Map<String, dynamic>;
    final sellingPrice = priceRange['sellingPrice'] as Map<String, dynamic>;
    final lowPrice = (sellingPrice['lowPrice'] as num).toDouble();

    final linkText = data['linkText'] as String;
    final link = '${Devoto().domain}$linkText/p';

    return Product(
      id: id,
      name: name,
      brand: brand,
      price: lowPrice,
      imageUrl: images,
      link: link,
    );
  }
}
