import 'dart:convert';

import 'package:app_ui/app_ui.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:scrape_supermarkets_uruguay/l10n/l10n.dart';
import 'package:scrape_supermarkets_uruguay/src/features/notifications/views/views.dart';
import 'package:scrape_supermarkets_uruguay/src/mappers/mappers.dart';
import 'package:scrape_supermarkets_uruguay/src/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  List<Product> _products = [];
  bool _isLoading = false;

  Future<void> _searchProducts() async {
    setState(() => _isLoading = true);

    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final results = await Future.wait([
        fetchProductsTata(text),
        fetchProductsDisco(text),
        fetchProductsTiendaInglesa(text),
        fetchProductsDevoto(text),
      ]);

      setState(() {
        _products = results.expand((list) => list).toList();
      });
    } catch (e) {
      debugPrint('Error: $e');
    }

    setState(() => _isLoading = false);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Search for a product',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              style: buttonsProvider.primaryFilled,
              onPressed: _isLoading ? null : _searchProducts,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Search'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.all(UISpacing.space2x),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_right_alt_sharp,
                          size: UISpacing.space10x),
                      onPressed: () {
                        launchUrl(Uri.parse(product.link!));
                      },
                    ),
                    leading: product.imageUrl.isNotEmpty
                        ? SizedBox(
                            width: UISpacing.space15x,
                            height: UISpacing.space15x,
                            child: Image.network(product.imageUrl.first),
                          )
                        : const Icon(Icons.image),
                    title: Text(product.name),
                    subtitle: Text('\$ ${product.price}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<Product>> fetchProductsTata(String text) async {
  final url = Uri.parse('${Tata().domain}/api/graphql');

  final headers = {
    'Content-Type': 'application/json',
  };

  const montevideo = 'U1cjdGF0YXV5bW9udGV2aWRlbw==';

  final requestBody = {
    'operationName': 'SearchSuggestionsQuery',
    'variables': {
      'term': text,
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

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(requestBody),
  );

  if (response.statusCode != 200) {
    throw Exception(response.body);
  }

  final dataRaw = jsonDecode(response.body) as Map<String, dynamic>;
  final data = dataRaw['data'] as Map<String, dynamic>;
  final search = data['search'] as Map<String, dynamic>;
  final suggestions = search['suggestions'] as Map<String, dynamic>;
  final productsRaw = suggestions['products'] as List<dynamic>;

  final productsMap =
      productsRaw.map((e) => e as Map<String, dynamic>).toList();

  final products =
      productsMap.map((product) => ProductMapper().fromTata(product)).toList();

  return products;
}

Future<List<Product>> fetchProductsDisco(String text) async {
  final variables = {
    'productOriginVtex': true,
    'simulationBehavior': 'default',
    'hideUnavailableItems': true,
    'advertisementOptions': {
      'showSponsored': true,
      'sponsoredCount': 2,
      'repeatSponsoredProducts': false,
      'advertisementPlacement': 'autocomplete',
    },
    'fullText': text,
    'count': 5,
    'shippingOptions': <void>[],
    'variant': null,
  };

  final encodedVariables = base64.encode(utf8.encode(jsonEncode(variables)));

  const sha256Hash =
      '0ef2c56d9518b51f912c2305ac4b07851c265b645dcbece6843c568bb91d39ff';

  final url = Uri.https(
    Disco().domain.replaceAll('https://', ''),
    '/_v/segment/graphql/v1',
    {
      'workspace': 'master',
      'maxAge': 'medium',
      'appsEtag': 'remove',
      'domain': 'store',
      'locale': 'es-UY',
      'operationName': 'productSuggestions',
      'variables': '{}',
      'extensions': jsonEncode(
        {
          'persistedQuery': {
            'version': 1,
            'sha256Hash': sha256Hash,
            'sender': 'vtex.store-resources@0.x',
            'provider': 'vtex.search-graphql@0.x',
          },
          'variables': encodedVariables,
        },
      ),
    },
  );

  final headers = {
    'Content-Type': 'application/json',
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode != 200) {
    throw Exception('Error fetching products: ${response.body}');
  }

  final dataRaw = jsonDecode(response.body) as Map<String, dynamic>;

  final data = dataRaw['data'] as Map<String, dynamic>;

  final productSuggestions = data['productSuggestions'] as Map<String, dynamic>;

  final productsRaw = productSuggestions['products'] as List<dynamic>;

  final products = productsRaw.map((product) {
    return ProductMapper().fromDisco(product as Map<String, dynamic>);
  }).toList();

  return products;
}

Future<List<Product>> fetchProductsTiendaInglesa(String text) async {
  final url = Uri.parse(
    '${TiendaInglesa().domain}/supermercado/busqueda?0,0,$text,0',
  );

  final response = await http.get(url);

  if (response.statusCode != 200) {
    throw Exception('Error fetching products: ${response.body}');
  }

  final soup = BeautifulSoup(response.body);

  final result = soup.find('input', attrs: {'name': 'GXState'});

  final content = result?.attributes['value'];

  final contentJson = jsonDecode(content!) as Map<String, dynamic>;

  final searchResponse = contentJson['vSEARCHRESPONSE'] as Map<String, dynamic>;

  final productsRaw = searchResponse['Product'] as List<dynamic>;

  final products =
      productsRaw.asMap().entries.where((entry) => entry.key <= 8).map((entry) {
    final index = entry.key;
    final product = entry.value as Map<String, dynamic>;

    final iProd = 'W0071000${index + 1}vPRODUCTUI';

    product['extra_data'] = contentJson[iProd] as Map<String, dynamic>;

    return ProductMapper().fromTiendaInglesa(product);
  }).toList();

  return products;
}

Future<List<Product>> fetchProductsDevoto(String text) async {
  final variables = {
    'productOriginVtex': false,
    'simulationBehavior': 'default',
    'hideUnavailableItems': true,
    'fullText': text,
    'count': 10,
    'shippingOptions': <void>[],
  };

  final encodedVariables = base64.encode(utf8.encode(jsonEncode(variables)));

  const sha256Hash =
      '0ef2c56d9518b51f912c2305ac4b07851c265b645dcbece6843c568bb91d39ff';

  final url = Uri.https(
    Devoto().domain.replaceAll('https://', ''),
    '/_v/segment/graphql/v1',
    {
      'workspace': 'master',
      'maxAge': 'medium',
      'appsEtag': 'remove',
      'domain': 'store',
      'locale': 'es-UY',
      'operationName': 'productSuggestions',
      'variables': '{}',
      'extensions': jsonEncode(
        {
          'persistedQuery': {
            'version': 1,
            'sha256Hash': sha256Hash,
            'sender': 'vtex.store-resources@0.x',
            'provider': 'vtex.search-graphql@0.x',
          },
          'variables': encodedVariables,
        },
      ),
    },
  );

  final headers = {
    'Content-Type': 'application/json',
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode != 200) {
    throw Exception('Error fetching products: ${response.body}');
  }

  final dataRaw = jsonDecode(response.body) as Map<String, dynamic>;

  final data = dataRaw['data'] as Map<String, dynamic>?;

  if (data == null || !data.containsKey('productSuggestions')) {
    throw Exception('Invalid response format');
  }

  final productSuggestions = data['productSuggestions'] as Map<String, dynamic>;
  final productsRaw = productSuggestions['products'] as List<dynamic>? ?? [];

  final products = productsRaw.map((product) {
    return ProductMapper().fromDevoto(product as Map<String, dynamic>);
  }).toList();

  return products;
}
