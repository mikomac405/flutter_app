import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inzynierka/widgets/wifi_form.dart';

class WifiConnectionPage extends StatefulWidget {
  const WifiConnectionPage({Key? key}) : super(key: key);

  @override
  State<WifiConnectionPage> createState() => _WifiConnectionPageState();
}

class _WifiConnectionPageState extends State<WifiConnectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Connect your device to Wifi")),
        body: defaultTargetPlatform == TargetPlatform.linux
            ? const WifiForm()
            : const Text("Plese connect your device to the wifi network."));
  }
}
