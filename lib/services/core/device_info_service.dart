import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  late BaseDeviceInfo deviceInfo;

  Future<void> init() async {
    deviceInfo = await _deviceInfoPlugin.deviceInfo;
  }
}
