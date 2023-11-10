import 'package:flutter_test/flutter_test.dart';
import 'package:nearpays_flutter_sdk/nearpays_flutter_sdk.dart';
import 'package:nearpays_flutter_sdk/nearpays_flutter_sdk_platform_interface.dart';
import 'package:nearpays_flutter_sdk/nearpays_flutter_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNearpaysFlutterSdkPlatform
    with MockPlatformInterfaceMixin
    implements NearpaysFlutterSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NearpaysFlutterSdkPlatform initialPlatform = NearpaysFlutterSdkPlatform.instance;

  test('$MethodChannelNearpaysFlutterSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNearpaysFlutterSdk>());
  });

  test('getPlatformVersion', () async {
    NearpaysFlutterSdk nearpaysFlutterSdkPlugin = NearpaysFlutterSdk();
    MockNearpaysFlutterSdkPlatform fakePlatform = MockNearpaysFlutterSdkPlatform();
    NearpaysFlutterSdkPlatform.instance = fakePlatform;

    expect(await nearpaysFlutterSdkPlugin.getPlatformVersion(), '42');
  });
}
