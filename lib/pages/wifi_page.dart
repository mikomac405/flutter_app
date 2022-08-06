import 'package:bluez/bluez.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inzynierka/widgets/bt_widget.dart';
import 'package:inzynierka/widgets/wifi_form.dart';
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
  final _formKey = GlobalKey<FormState>();
  List<String> devicesNames = [];
  List<String> devicesSsids = [];

  late BlueZClient linuxClient;
  late FlutterBluePlus androidClient;

  Future refresh() async {
    if (Platform.isAndroid) {
      // Zinicjalizuj androidClient
    } else if (Platform.isLinux) {
      linuxClient = BlueZClient();
      await linuxClient.connect();
      if (kDebugMode) {
        print('Start scan');
      }
      setState(() {
        devicesNames.clear();
        devicesSsids.clear();
      });

      if (linuxClient.adapters.isEmpty) {
        setState(() {
          devicesNames.add('No Bluetooth adapters found');
          devicesSsids.add('0');
        });
        if (kDebugMode) {
          print('No Bluetooth adapters found');
        }
        await linuxClient.close();
        return;
      }

      var adapter = linuxClient.adapters[0];
      if (kDebugMode) {
        print('Searching for devices on ${adapter.name}...');
      }
      setState(() {
        for (final device in linuxClient.devices) {
          devicesNames.add(device.name.isNotEmpty ? device.name : "No name");
          devicesSsids.add(device.address);
        }
      });

      linuxClient.deviceAdded.listen((device) => {
            setState(() {
              devicesNames
                  .add(device.name.isNotEmpty ? device.name : "No name");
              devicesSsids.add(device.address);
              if (kDebugMode) {
                print('  ${device.address} ${device.name}');
              }
            })
          });

      await adapter.startDiscovery();

      await Future.delayed(const Duration(seconds: 5));

      await adapter.stopDiscovery();

      if (kDebugMode) {
        print('Stop scan');
      }

      await linuxClient.close();
    } else {
      setState(() {
        devicesNames = ['a', 'b', 'c'];
        devicesSsids = ['1', '2', '3'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("WiFi form"),
        ),
        body: isConnected
            ? wifiForm(context, _formKey)
            : btWidget(context, devicesNames, devicesSsids, refresh));
  }
}
