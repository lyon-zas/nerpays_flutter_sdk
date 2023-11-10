import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nearpays_flutter_sdk/nearpays_flutter_sdk_method_channel.dart';

void main() {
  MethodChannelNearpaysFlutterSdk platform = MethodChannelNearpaysFlutterSdk();
  const MethodChannel channel = MethodChannel('nearpays_flutter_sdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
