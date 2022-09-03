import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
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
        body: Platform.isLinux
            ? const WifiForm()
            : const Text("Plese connect your device to the wifi network."));
  }
}
