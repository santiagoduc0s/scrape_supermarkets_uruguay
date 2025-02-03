import 'package:scrape_supermarkets_uruguay/src/enums/enums.dart';
import 'package:scrape_supermarkets_uruguay/src/models/models.dart';

abstract class DeviceDatasource {
  Future<Device> findById({
    required String userId,
    required String id,
  });

  Future<Device> store({
    required String userId,
    required String id,
    required String model,
    required PlatformType platform,
    String? fcmToken,
  });

  Future<Device> update({
    required String userId,
    required String id,
    String? model,
    PlatformType? platform,
    DateTime? lastActivityAt,
    String? fcmToken,
  });
}
