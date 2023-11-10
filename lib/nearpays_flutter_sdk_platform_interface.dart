import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'nearpays_flutter_sdk_method_channel.dart';

abstract class NearpaysFlutterSdkPlatform extends PlatformInterface {
  /// Constructs a NearpaysFlutterSdkPlatform.
  NearpaysFlutterSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static NearpaysFlutterSdkPlatform _instance = MethodChannelNearpaysFlutterSdk();

  /// The default instance of [NearpaysFlutterSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelNearpaysFlutterSdk].
  static NearpaysFlutterSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NearpaysFlutterSdkPlatform] when
  /// they register themselves.
  static set instance(NearpaysFlutterSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
