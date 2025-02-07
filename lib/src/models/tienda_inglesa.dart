import 'package:scrape_supermarkets_uruguay/src/models/models.dart';

class TiendaInglesa implements Supermarket {
  @override
  String get domain => 'https://www.tiendainglesa.com.uy';

  @override
  String get url => '$domain/supermercado/';
}
