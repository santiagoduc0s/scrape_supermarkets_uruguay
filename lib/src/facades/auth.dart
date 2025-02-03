import 'dart:async';
import 'package:scrape_supermarkets_uruguay/src/models/user/user_model.dart';

class Auth {
  Auth._singleton();

  static final Auth instance = Auth._singleton();

  User? _user;

  final _streamController = StreamController<Auth>.broadcast();

  Stream<Auth> get stream => _streamController.stream;

  String? id() => '1';

  User? user() => _user;

  void setUser(User? user) {
    _user = user;
    _streamController.add(this);
  }

  bool check() => _user != null;

  Future<void> dispose() async {
    await _streamController.close();
  }
}
