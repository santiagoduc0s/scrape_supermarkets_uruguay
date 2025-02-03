import 'dart:convert';

import 'package:app_ui/app_ui.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:scrape_supermarkets_uruguay/l10n/l10n.dart';
import 'package:scrape_supermarkets_uruguay/src/features/notifications/views/views.dart';
import 'package:scrape_supermarkets_uruguay/src/mappers/mappers.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> fetchProductsTata() async {
    final url = Uri.parse('https://www.tata.com.uy/api/graphql');

    final headers = {
      'Content-Type': 'application/json',
    };

    const montevideo = 'U1cjdGF0YXV5bW9udGV2aWRlbw==';

    final requestBody = {
      'operationName': 'SearchSuggestionsQuery',
      'variables': {
        'term': 'arroz saman',
        'selectedFacets': [
          {
            'key': 'channel',
            'value': jsonEncode(
              {
                'salesChannel': '4',
                'regionId': montevideo,
              },
            ),
          },
          {
            'key': 'locale',
            'value': 'es-UY',
          }
        ],
      },
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }

      final dataRaw = jsonDecode(response.body);
      final data = dataRaw['data'];
      final search = data['search'];
      final suggestions = search['suggestions'];
      final productsRaw = suggestions['products'];

      final products = productsRaw
          .map((product) =>
              ProductMapper().fromTata(product as Map<String, dynamic>))
          .toList();

      print('asdf');
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> fetchProductsDisco() async {
    final searchTerm = 'arroz';

    Map<String, dynamic> variables = {
      "productOriginVtex": true,
      "simulationBehavior": "default",
      "hideUnavailableItems": true,
      "advertisementOptions": {
        "showSponsored": true,
        "sponsoredCount": 2,
        "repeatSponsoredProducts": false,
        "advertisementPlacement": "autocomplete"
      },
      "fullText": searchTerm,
      "count": 5,
      "shippingOptions": [],
      "variant": null
    };

    // Encode variables to Base64
    String encodedVariables = base64.encode(utf8.encode(jsonEncode(variables)));

    final url = Uri.https(
      'www.disco.com.uy',
      '/_v/segment/graphql/v1',
      {
        'workspace': 'master',
        'maxAge': 'medium',
        'appsEtag': 'remove',
        'domain': 'store',
        'locale': 'es-UY',
        'operationName': 'productSuggestions',
        'variables': '{}',
        'extensions': jsonEncode({
          "persistedQuery": {
            "version": 1,
            "sha256Hash":
                "0ef2c56d9518b51f912c2305ac4b07851c265b645dcbece6843c568bb91d39ff",
            "sender": "vtex.store-resources@0.x",
            "provider": "vtex.search-graphql@0.x"
          },
          "variables": encodedVariables
        }),
      },
    );

    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode != 200) {
        throw Exception('Error fetching products: ${response.body}');
      }

      final dataRaw = jsonDecode(response.body);
      final productsRaw =
          dataRaw['data']['productSuggestions']['products'] ?? [];

      final products = productsRaw.map((product) {
        print(product);
        return ProductMapper().fromDisco(product as Map<String, dynamic>);
      }).toList();

      print('asdf');
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> scrapeProducts() async {
    final url =
        Uri.parse('https://www.tata.com.uy/s/?q=helado+crufi&sort=score_desc');

    final headers = {'User-Agent': 'Mozilla/5.0'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final soup = BeautifulSoup(response.body);

      final products =
          soup.findAll('article', attrs: {'data-store-product-card': 'true'});

      for (final product in products) {
        final nameElement =
            product.find('h3', attrs: {'data-fs-product-card-title': 'true'});
        final name = nameElement?.text ?? 'Unknown';

        final priceElement =
            product.find('span', attrs: {'data-store-price': 'true'});
        final price = priceElement?.text ?? 'Price not found';

        final imageElement =
            product.find('img', attrs: {'data-fs-image': 'true'});
        final imageUrl = imageElement?['src'] ?? 'No image';

        final linkElement =
            product.find('a', attrs: {'data-store-link': 'true'});
        final productLink =
            'https://www.tata.com.uy${linkElement?['href'] ?? '#'}';

        debugPrint('--- Product Found ---');
        debugPrint('Name: $name');
        debugPrint('Price: $price');
        debugPrint('Image: $imageUrl');
        debugPrint('Link: $productLink');
        debugPrint('----------------------');
      }
    } else {
      debugPrint(
        'Failed to load the webpage. Status Code: ${response.statusCode}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final buttonsProvider = Theme.of(context).buttonStyles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              context.pushNamed(NotificationsScreen.path);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              style: buttonsProvider.primaryFilled,
              onPressed: fetchProductsDisco,
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
