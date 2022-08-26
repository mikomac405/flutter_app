import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum ConnectionType { none, restApi, bluetooth }

class ConnectionManager with ChangeNotifier {
  static final ConnectionManager _instance = ConnectionManager._internal();
  ConnectionType _connectionType = ConnectionType.none;

  ConnectionType get connectionType => _connectionType;
  set connectionType(ConnectionType newType) {
    _connectionType = newType;
    notifyListeners();
  }

  factory ConnectionManager() {
    return _instance;
  }

  // Constructor
  ConnectionManager._internal() {
    checkConnectionType();
    // ignore: avoid_print
    print(connectionType);
  }

  /// Responsible for checking if app has
  /// connection to ESP32 through Rest API or needs to use
  /// Bluetooth protocol.
  void checkConnectionType() {
    checkConnectionWithEsp().then((value) => {
          connectionType =
              value ? ConnectionType.restApi : ConnectionType.bluetooth
        });
  }

  Future<void> getComponentsStatus() async {
    Map json_map = {'command': 'get_status', 'args': ''};
    var status = await http.post(
        Uri.parse("http://srv08.mikr.us:20364/config/manager/set/"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(json_map));
    print(status.body);
    //return status.body;
  }

  Future<void> setConfig(component, command, args) async {
    var url =
        Uri.parse("http://srv08.mikr.us:20364/config/" + component + "/set/");
    Map jsonbody = {'command': command, 'args': args};
    var jsonbody1 = json.encode(jsonbody);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: jsonbody1);
    print(response.body);
  }

  Future<bool> checkConnectionWithEsp() async {
    var url = Uri.parse('http://srv08.mikr.us:20364/heartbeat/');
    try {
      var response = await http.get(url);
      // ignore: avoid_print
      print(response.body);
      if (response.body == "Got heartbeat") {
        return true;
      }
      return false;
    } catch (error) {
      // ignore: avoid_print
      print("error");
      return false;
    }
  }
}
