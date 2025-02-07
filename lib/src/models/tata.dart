import 'package:scrape_supermarkets_uruguay/src/models/models.dart';

class Tata implements Supermarket {
  @override
  String get domain => 'https://www.tata.com.uy';

  @override
  String get url => '$domain/api/graphql';
}
