import 'package:http/http.dart' as http;

enum ConnectionType { none, restApi, bluetooth }

class Connection {
  ConnectionType _connectionType = ConnectionType.none;
  var _connectionController;

  Connection() {
    checkConnectionWithEsp().then((value) => {
          _connectionController =
              value ? RestApiController() : BluetoothController()
        });
  }

  Future<bool> checkConnectionWithEsp() async {
    var url = Uri.parse('http://srv08.mikr.us:20364/heartbeat/dev');
    var response = await http.post(url);
    if (response.body == "Got heartbeat") {
      return true;
    }
    return false;
  }
}

class RestApiController {}

class BluetoothController {}
