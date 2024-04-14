import 'package:rabenkorb/services/core/device_info_service.dart';
import 'package:watch_it/watch_it.dart';

void enrichWithDeviceInfo(Map<String, dynamic> data) {
  var deviceInfo = di<DeviceInfoService>().deviceInfo;
  data["device"] = deviceInfo.data;
}
