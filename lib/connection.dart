import 'package:http/http.dart' as http;

enum ConnectionType { none, restApi, bluetooth }

class Connection {
  ConnectionType _connectionType = ConnectionType.none;
  var _connectionController;

  Connection() {
    _connectionController =
        checkConnectionWithEsp() ? RestApiController() : BluetoothController();
  }

  bool checkConnectionWithEsp() {
    throw UnimplementedError("Work in progress");
  }
}

class RestApiController {}

class BluetoothController {}
