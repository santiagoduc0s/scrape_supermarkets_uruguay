import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrape_supermarkets_uruguay/src/enums/enums.dart';
import 'package:scrape_supermarkets_uruguay/src/models/models.dart';

class DeviceMapper {
  Device fromDocumentSnapshot(DocumentSnapshot<Object?> snapshot) {
    final data = snapshot.data()! as Map<String, dynamic>;
    return Device(
      id: snapshot.id,
      model: data['model'] as String,
      platform: PlatformType.fromValue(data['platform'] as String?),
      fcmToken: data['fcmToken'] as String?,
      lastActivityAt: (data['lastActivityAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
