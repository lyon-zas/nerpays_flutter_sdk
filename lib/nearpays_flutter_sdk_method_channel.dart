import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'nearpays_flutter_sdk_platform_interface.dart';

/// An implementation of [NearpaysFlutterSdkPlatform] that uses method channels.
class MethodChannelNearpaysFlutterSdk extends NearpaysFlutterSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('nearpays_flutter_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
