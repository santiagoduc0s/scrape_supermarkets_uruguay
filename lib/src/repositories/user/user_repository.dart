import 'package:result_dart/result_dart.dart';
import 'package:scrape_supermarkets_uruguay/src/helpers/helpers.dart';
import 'package:scrape_supermarkets_uruguay/src/models/user/user_model.dart';

abstract class UserRepository {
  Future<Result<User>> findById(String id);

  Future<User> store({
    required String firstName,
    required String lastName,
    required String email,
    String? id,
    String? photo,
  });

  Future<User> update({
    required String? id,
    String? firstName,
    String? lastName,
    String? email,
    Parameter<String?>? photo,
  });

  Future<void> deleteById(String id);
}

class UserNotFound implements Exception {}

class PermissionDeniedUsers implements Exception {}
