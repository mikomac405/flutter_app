import 'package:bluez/bluez.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inzynierka/widgets/bt_widget.dart';
import 'package:inzynierka/widgets/wifi_form.dart';
import 'package:inzynierka/globals.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:location/location.dart';
import 'dart:io' show Platform;

// Create a Form widget.
class WifiAuthForm extends StatefulWidget {
  const WifiAuthForm({super.key});

  @override
  WifiAuthFormState createState() {
    return WifiAuthFormState();
  }
}

class WifiAuthFormState extends State<WifiAuthForm> {
  bool isConnected = false;
  bool isConnecting = false;
  final _formKey = GlobalKey<FormState>();

  Future refresh() async {
    setState(() {
      isConnecting = true;
    });

    // ================== ANDROID ==================

    if (Platform.isAndroid) {
      const AndroidIntent(
        action: 'android.bluetooth.adapter.action.REQUEST_ENABLE',
      ).launch();

      Location location = new Location();

      location.requestService();

      androidClient = FlutterBluePlus.instance;
      androidClient.startScan(timeout: Duration(seconds: 4));

      var subscription = androidClient.scanResults.listen((results) {
        for (ScanResult r in results) {
          if (r.device.id.toString() == "40:91:51:B2:A2:DE") {
            androidDevice = r.device;
            androidDevice.connect();
            setState(() {
              isConnected = true;
            });
          }
        }
      });
      androidClient.stopScan();

      // ================== LINUX ==================

    } else if (Platform.isLinux) {
      linuxClient = BlueZClient();
      await linuxClient.connect();

      if (linuxClient.adapters.isEmpty) {
        if (kDebugMode) {
          print('No Bluetooth adapters found');
        }
        await linuxClient.close();
        return;
      }

      var adapter = linuxClient.adapters[0];
      var foundEsp = false;

      for (var device in linuxClient.devices) {
        if (device.address == "40:91:51:B2:A2:DE") {
          print("esp detected");
          linuxDevice = device;
          if (!linuxDevice.paired) await linuxDevice.pair();
          if (!linuxDevice.connected) await linuxDevice.connect();
          setState(() {
            isConnected = true;
          });
          foundEsp = true;
          continue;
        }
      }

      linuxClient.deviceAdded.listen((device) async {
        print("found device | ${device.address}");
        if (device.address == "E0:E2:E6:D1:03:E6") {
          print("esp detected");
          linuxDevice = device;
          if (!linuxDevice.paired) await linuxDevice.pair();
          if (!linuxDevice.connected) await linuxDevice.connect();
          setState(() {
            isConnected = true;
          });
        }
      });

      if (!foundEsp) {
        await adapter.startDiscovery();

        await Future.delayed(const Duration(seconds: 5));

        await adapter.stopDiscovery();
      }
      // ================== ELSE ==================
    } else {
      setState(() {
        isConnected = true;
      });
    }

    setState(() {
      isConnecting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("WiFi form"),
        ),
        body: isConnected && !isConnecting
            ? wifiForm(context, _formKey)
            : btWidget(context, isConnecting, refresh));
  }
}
