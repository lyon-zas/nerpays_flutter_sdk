import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:nearpays_flutter_sdk/nearpays_flutter_sdk.dart';
import 'package:nearpays_flutter_sdk/nearpays_flutter_sdk_method_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _isNfcAvailable = 'Unknown';
  final _nearpaysFlutterSdkPlugin = NearpaysFlutterSdk();
  final _nearpaysFlutterSdkMethodChannel = MethodChannelNearpaysFlutterSdk();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String isNfcAvailable;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _nearpaysFlutterSdkPlugin.getPlatformVersion() ??
          'Unknown platform version';
      isNfcAvailable = await _nearpaysFlutterSdkPlugin.getNfcAvailability() ??
          'Unknown availability';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
      isNfcAvailable = 'Failed to get availability.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _isNfcAvailable = isNfcAvailable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              Text('NFC availability: $_isNfcAvailable\n'),
              ElevatedButton(
                onPressed: () {
                  _nearpaysFlutterSdkMethodChannel.swipeCard();
                },
                child: Text('Swipe Card'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
