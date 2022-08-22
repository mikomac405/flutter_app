import 'dart:convert';

import 'package:bluez/bluez.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

var connection;
late BlueZClient linuxClient;
late BlueZDevice linuxDevice;
late FlutterBluePlus androidClient;
late BluetoothDevice androidDevice;

Future<void> setConfig(component, command, args) async {
  var url =
      Uri.parse("http://srv08.mikr.us:20364/config/" + component + "/set/");
  Map jsonbody = {'command': command, 'args': args};
  var jsonbody1 = json.encode(jsonbody);
  var response = await http.post(url,
      headers: {"Content-Type": "application/json"}, body: jsonbody1);
  print(response.body);
}
