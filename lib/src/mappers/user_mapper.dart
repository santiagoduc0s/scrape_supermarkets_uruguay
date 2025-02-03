import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrape_supermarkets_uruguay/src/enums/enums.dart';
import 'package:scrape_supermarkets_uruguay/src/models/user/user_model.dart';

class UserMapper {
  User fromDocumentSnapshot(DocumentSnapshot<Object?> snapshot) {
    final data = snapshot.data()! as Map<String, dynamic>;
    return User(
      id: snapshot.id,
      firstName: data['firstName'] as String,
      lastName: data['lastName'] as String,
      email: data['email'] as String,
      photo: data['photo'] as String?,
      roles: (data['roles'] as Map<String, dynamic>)
          .entries
          .where((e) => e.value as bool)
          .where((e) => UserRole.values.map((e) => e.value).contains(e.key))
          .map((e) => UserRole.fromString(e.key))
          .toList(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
