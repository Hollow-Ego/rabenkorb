import 'package:codenic_logger/codenic_logger.dart';

import 'app_version_enricher.dart';
import 'device_info_enricher.dart';

class EnrichedMessageLog extends MessageLog {
  EnrichedMessageLog({required id, message, Map<String, dynamic>? data}) : super(id: id, message: message, data: data) {
    if (data == null) {
      this.data = {};
    }
    enrichWithAppVersion(this.data);
    enrichWithDeviceInfo(this.data);
  }
}
