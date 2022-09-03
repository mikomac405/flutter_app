import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum ConnectionStatus {
  none,
  internet,
  noInternet,
  noRestApi,
  noEsp,
  restApi,
  bluetooth
}

class ConnectionManager with ChangeNotifier {
  static final ConnectionManager _instance = ConnectionManager._internal();
  ConnectionStatus _connectionStatus = ConnectionStatus.none;

  ConnectionStatus get connectionStatus => _connectionStatus;
  set connectionStatus(ConnectionStatus newState) {
    _connectionStatus = newState;
    notifyListeners();
  }

  factory ConnectionManager() {
    return _instance;
  }

  // Constructor
  ConnectionManager._internal() {
    checkConnectionStatus();
    // ignore: avoid_print
    print(connectionStatus);
  }

  /// Responsible for checking if app has
  /// connection to ESP32 through Rest API or needs to use
  /// Bluetooth protocol.
  void checkConnectionStatus() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (connectionStatus == ConnectionStatus.noInternet ||
            connectionStatus == ConnectionStatus.none) {
          connectionStatus = ConnectionStatus.internet;
        }
      }
    } on SocketException catch (_) {
      connectionStatus = ConnectionStatus.noInternet;
      return;
    }

    checkConnectionWithEsp().then((value) => {connectionStatus = value});
  }

  Future<List<String>> getWifiList() async {
    var result =
        await Process.run('nmcli', ['-f', 'SSID', 'd', 'wifi', 'list']);
    var list = result.stdout.split('\n');
    return list.sublist(1, list.length - 2);
  }

  void connectToWifi(String ssid, String password) async {
    await Process.run(
        'nmcli', ['d', 'wifi', 'connect', ssid, 'password', password]);
    checkConnectionStatus();
  }

  Future<String> getComponentsStatus() async {
    var status = await http.get(Uri.parse("http://srv08.mikr.us:20364/status"));
    return status.body;
  }

  ///This function is responsible for sending commands to ESP
  Future<void> setConfig(component, command, args) async {
    var url =
        Uri.parse("http://srv08.mikr.us:20364/config/" + component + "/set/");
    Map jsonbody = {'command': command, 'args': args};
    var jsonbody1 = json.encode(jsonbody);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: jsonbody1);
    if (kDebugMode) {
      print(response.body);
    }
  }

  ///This function is responsible for checking if connection with ESP is up
  Future<ConnectionStatus> checkConnectionWithEsp() async {
    var url = Uri.parse('http://srv08.mikr.us:20364/heartbeat/');
    try {
      var response = await http.get(url);
      if (kDebugMode) {
        print(response.body);
      }
      if (response.body == "Got heartbeat") {
        return ConnectionStatus.restApi;
      }
      return ConnectionStatus.noEsp;
    } catch (error) {
      if (kDebugMode) {
        print("error");
      }
      return ConnectionStatus.noRestApi;
    }
  }
}
