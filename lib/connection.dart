import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:inzynierka/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  factory ConnectionManager() {
    return _instance;
  }

  // Constructor
  ConnectionManager._internal() {
    checkConnectionStatus();
  }

  WifiManager wifi = WifiManager();
  DataManager data = DataManager();

  ConnectionStatus _connectionStatus = ConnectionStatus.none;

  static bool get _isOffline => const bool.hasEnvironment("OFFLINE")
      ? const bool.fromEnvironment("OFFLINE")
      : false;

  String get _baseUrl => const bool.hasEnvironment("IP")
      ? const String.fromEnvironment("IP")
      : "http://srv08.mikr.us:20364";

  ConnectionStatus get connectionStatus => _connectionStatus;
  set connectionStatus(ConnectionStatus newState) {
    _connectionStatus = newState;
    notifyListeners();
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

class WifiManager {
  static final WifiManager _instance = WifiManager._internal();

  factory WifiManager() {
    return _instance;
  }

  // Constructor
  WifiManager._internal();

  Future<List<String>> getWifiList() async {
    var result =
        await Process.run('nmcli', ['-f', 'SSID', 'd', 'wifi', 'list']);
    var list = result.stdout.split('\n');
    return list.sublist(1, list.length - 2);
  }

  Future<void> connectToWifi(String ssid, String password) async {
    await Process.run('nmcli',
        ['d', 'wifi', 'connect', ssid.trim(), 'password', password.trim()]);
    connection.checkConnectionStatus();
  }
}

class DataManager {
  
  static final DataManager _instance = DataManager._internal();

  factory DataManager() {
    return _instance;
  }

  // Constructor
  DataManager._internal();

  Future<void> authUser() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    String login = prefs.getString('login') ?? "";
    String password = prefs.getString('password') ?? "";
    print("Auth pass: $login $password");
    if (login.isEmpty || password.isEmpty) {
      return;
    }
    var url = Uri.parse("${connection._baseUrl}/auth");
    Map jsonBody = {'username': login, 'password': password};
    var jsonBodyEnocoded = json.encode(jsonBody);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: jsonBodyEnocoded);
    if (kDebugMode) {
      print(response.body);
    }
    switch (response.body) {
      case "Password incorrect":
        print(response.body);
        break;
      case "Username incorrect":
        print(response.body);
        break;
      default:
        prefs.setString("token", response.body);
    }
  }

  Future<void> testToken() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    var url = Uri.parse("${connection._baseUrl}/token/test");
    var response =
        await http.post(url, headers: {"Authorization": "Bearer $token"});
    if (kDebugMode) {
      print(response.body);
    }
    switch (response.body) {
      case "Token expired":
        await authUser();
        break;
      case "Token missing":
        await authUser();
        break;
      case "Inactive issuer":
        print(response.body);
        break;
      case "Unverifiable issuer":
        print(response.body);
        break;
      case "Invalid prefix":
        print(response.body);
        break;
      case "Invalid token":
        await authUser();
        break;
      default:
        if(int.parse(response.body) < 60){
          await authUser();
        }
        
    }
  }

  Future<String> getComponentsStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    if (token.isEmpty) {
      print("Empty token");
      await authUser();
    }

    if(ConnectionManager._isOffline){
      var url = Uri.parse("${connection._baseUrl}/status/test");
      var status = await http.get(url);
      return status.body;
    } 
    var url = Uri.parse("${connection._baseUrl}/status/");
    var status = await http.get(url, headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        });
    return status.body;
  }

  Future<dynamic> getDailyData(String startDate, String endDate) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    if (token.isEmpty) {
      print("Empty token");
      await authUser();
    }

    await testToken();

    var url = Uri.parse("${connection._baseUrl}/data/by_date");
    var jsonBodyEncoded = json.encode({"start": startDate, "end": endDate});

    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonBodyEncoded);
    print(response.body);
    return jsonDecode(response.body);
  }

  Future<dynamic> getHourlyData(
      String startDateTime, String endDateTime) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    if (token.isEmpty) {
      await authUser();
    }

    await testToken();

    var url = Uri.parse("${connection._baseUrl}/data/by_datetime");
    var jsonBodyEncoded =
        json.encode({"start": startDateTime, "end": endDateTime});

    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonBodyEncoded);

    return jsonDecode(response.body);
  }

  ///This function is responsible for sending commands to ESP
  Future<void> setConfig(component, command, args) async {
    if (ConnectionManager._isOffline) {
      return;
    }
    
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    if (token.isEmpty) {
      await authUser();
    }

    await testToken();

    
    var url = Uri.parse("${connection._baseUrl}/config/" + component + "/set/");
    Map jsonbody = {'command': command, 'args': args};
    var jsonbody1 = json.encode(jsonbody);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"}, body: jsonbody1);
    if (kDebugMode) {
      print(response.body);
    }
  }
}
