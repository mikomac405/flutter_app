import 'dart:async';

import 'package:bluez/bluez.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inzynierka/widgets/wifi_form.dart';
import 'package:inzynierka/globals.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:location/location.dart';
import 'dart:io' show Platform;

// Create a Form widget.
class EspConnectionPage extends StatefulWidget {
  const EspConnectionPage({super.key});

  @override
  EspConnectionPageState createState() {
    return EspConnectionPageState();
  }
}

class EspConnectionPageState extends State<EspConnectionPage> {
  List<BluetoothDevice> devices = [];
  bool androidClientInitialized = false;
  bool isConnected = false;
  bool isConnecting = false;
  bool isScanning = false;

  Future refresh() async {
    setState(() {
      isScanning = true;
    });

    // ================== ANDROID ==================

    if (Platform.isAndroid) {
      const AndroidIntent(
        action: 'android.bluetooth.adapter.action.REQUEST_ENABLE',
      ).launch();

      Location location = Location();

      location.requestService();

      if (!androidClientInitialized) {
        androidClient = FlutterBluePlus.instance;
        androidClientInitialized = true;
      }

      setState(() {
        devices = [];
      });

      androidClient
          .startScan(timeout: const Duration(seconds: 4))
          .whenComplete(() => setState(() {
                androidClient.scanResults.forEach((results) {
                  for (ScanResult r in results) {
                    if (!devices.contains(r.device)) {
                      devices.add(r.device);
                    }
                  }
                });
                setState(() {
                  isScanning = false;
                });
              }));

      // androidClient.scanResults.listen((results) {
      //   for (ScanResult r in results) {
      //     if (!devices.contains(r.device)) {
      //       devices.add(r.device);
      //     }
      //   }
      // });

      androidClient.stopScan();
    }
  }

  Future connectToDevice(BluetoothDevice device) async {
    print(device.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("WiFi form"),
        ),
        body: Platform.isAndroid
            ? (isConnected && !isConnecting)
                ? const WifiForm()
                : Column(children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: devices.length,
                            itemBuilder: (context, index) {
                              final name = devices.elementAt(index).name.isEmpty
                                  ? "No name"
                                  : devices.elementAt(index).name;
                              final ssid =
                                  devices.elementAt(index).id.toString();
                              return Card(
                                  child: ListTile(
                                title: Text(name),
                                subtitle: Text(ssid),
                                leading: const Icon(Icons.bluetooth),
                                onTap: () {
                                  connectToDevice(devices.elementAt(index));
                                },
                              ));
                            })),
                    ElevatedButton(
                      onPressed: isScanning || isConnecting ? null : refresh,
                      child: const Text("Scan for devices"),
                    )
                  ])
            : const Center(
                child: Text(
                    "Please use this application on Android device to send wifi credentials through Bluetooth to the Farm."),
              ));
  }
}
