import 'package:scrape_supermarkets_uruguay/src/models/models.dart';

class Disco implements Supermarket {
  @override
  String get domain => 'https://www.disco.com.uy';

  @override
  String get url => '$domain/_v/segment/graphql/v1';
}
