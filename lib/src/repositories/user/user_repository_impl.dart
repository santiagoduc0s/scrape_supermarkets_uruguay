import 'package:result_dart/result_dart.dart';
import 'package:scrape_supermarkets_uruguay/src/datasources/user/user.dart';
import 'package:scrape_supermarkets_uruguay/src/helpers/helpers.dart';
import 'package:scrape_supermarkets_uruguay/src/models/models.dart';
import 'package:scrape_supermarkets_uruguay/src/repositories/user/user.dart';

class UserRepositoryImpl extends UserRepository {
  UserRepositoryImpl({required this.userDatasource});

  final UserDatasource userDatasource;

  @override
  Future<void> deleteById(String id) {
    return userDatasource.deleteById(id);
  }

  @override
  Future<Result<User>> findById(String id) {
    return userDatasource.findById(id);
  }

  @override
  Future<User> store({
    required String firstName,
    required String lastName,
    required String email,
    String? id,
    String? photo,
  }) {
    return userDatasource.store(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      photo: photo,
    );
  }

  @override
  Future<User> update({
    required String? id,
    String? firstName,
    String? lastName,
    String? email,
    Parameter<String?>? photo,
  }) {
    return userDatasource.update(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      photo: photo,
    );
  }
}
