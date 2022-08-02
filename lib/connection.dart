import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

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
    checkConnectionWithEsp().then((value) => {
          connectionType =
              value ? ConnectionType.restApi : ConnectionType.bluetooth
        });
    // ignore: avoid_print
    print(connectionType);
  }

  Future<bool> checkConnectionWithEsp() async {
    var url = Uri.parse('http://srv08.mikr.us:20364/heartbeat/dev/');
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
