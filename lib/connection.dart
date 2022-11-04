import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:inzynierka/globals.dart';

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
  static bool get _isOffline => const bool.hasEnvironment("OFFLINE")
      ? const bool.fromEnvironment("OFFLINE")
      : false;

  static String get _baseUrl => const bool.hasEnvironment("IP")
      ? const String.fromEnvironment("IP")
      : "http://srv08.mikr.us:20364";

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
    if (kIsWeb) {
      if (connectionStatus == ConnectionStatus.noInternet ||
          connectionStatus == ConnectionStatus.none) {
        connectionStatus = ConnectionStatus.internet;
      }
    } else {
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
    }

    checkConnectionWithEsp().then((value) => {connectionStatus = value});
  }

  Future<List<String>> getWifiList() async {
    var result =
        await Process.run('nmcli', ['-f', 'SSID', 'd', 'wifi', 'list']);
    var list = result.stdout.split('\n');
    return list.sublist(1, list.length - 2);
  }

  Future<void> connectToWifi(String ssid, String password) async {
    await Process.run('nmcli',
        ['d', 'wifi', 'connect', ssid.trim(), 'password', password.trim()]);
    // TODO: Check when Hydro available
    // connect.then((val) {
    //   print(ssid);
    //   print(password);
    //   print(val.pid);
    //   print(val.stdout);
    //   print(val.stderr);
    //   print(val.exitCode);
    // });
    checkConnectionStatus();
  }

  Future<String> getToken() async {
    var url = Uri.parse("$_baseUrl/auth");
    Map jsonBody = {'username': login, 'password': password};
    var jsonBodyEnocoded = json.encode(jsonBody);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: jsonBodyEnocoded);
    if (kDebugMode) {
      print(response.body);
    }
    return response.body;
  }

  Future<String> testToken() async {
    var url = Uri.parse("$_baseUrl/token/test");
    var response =
        await http.post(url, headers: {"Authorization": "Bearer $token"});
    if (kDebugMode) {
      print(response.body);
    }
    return response.body;
  }

  Future<String> getComponentsStatus() async {
    var url = _isOffline
        ? Uri.parse("$_baseUrl/status/test")
        : Uri.parse("$_baseUrl/status");
    var status = await http.get(url);
    return status.body;
  }

  ///This function is responsible for sending commands to ESP
  Future<void> setConfig(component, command, args) async {
    if (_isOffline) {
      return;
    }
    var url = Uri.parse("$_baseUrl/config/" + component + "/set/");
    Map jsonbody = {'command': command, 'args': args};
    var jsonbody1 = json.encode(jsonbody);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: jsonbody1);
    if (kDebugMode) {
      print(response.body);
    }
  }

  ///This function is responsible for checking if connection with ESP is up
  // TODO: No internet check
  Future<ConnectionStatus> checkConnectionWithEsp() async {
    var url = _isOffline
        ? Uri.parse('$_baseUrl/heartbeat/test')
        : Uri.parse('$_baseUrl/heartbeat');
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
