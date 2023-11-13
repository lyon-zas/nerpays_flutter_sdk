import 'nearpays_flutter_sdk_platform_interface.dart';

class NearpaysFlutterSdk {
  Future<String?> getPlatformVersion() {
    return NearpaysFlutterSdkPlatform.instance.getPlatformVersion();
  }

  Future<String?> getNfcAvailability() {
    return NearpaysFlutterSdkPlatform.instance.getNfcAvailability();
  }
}
