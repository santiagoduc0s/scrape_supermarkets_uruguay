import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:scrape_supermarkets_uruguay/src/enums/enums.dart';
import 'package:scrape_supermarkets_uruguay/src/models/models.dart';

class DeviceInfoHelper {
  final deviceInfo = DeviceInfoPlugin();

  Future<DeviceInfo> getInfo() async {
    if (Platform.isAndroid) {
      return _getAndroidInfo();
    } else if (Platform.isIOS) {
      return _getIosInfo();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  Future<DeviceInfo> _getAndroidInfo() async {
    final androidInfo = await deviceInfo.androidInfo;

    return DeviceInfo.empty(
      id: androidInfo.id,
      model: androidInfo.model,
      platform: PlatformType.android,
    );
  }

  Future<DeviceInfo> _getIosInfo() async {
    final iosInfo = await deviceInfo.iosInfo;

    return DeviceInfo.empty(
      id: iosInfo.identifierForVendor!,
      model: iosInfo.modelName,
      platform: PlatformType.ios,
    );
  }
}
