import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inzynierka/connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'farm.dart';

Farm farm = Farm();

late ConnectionManager connection;
late FlutterBluePlus androidClient;
late BluetoothDevice androidDevice;

bool disconnectRequest = false;

bool logged_in = false;

Future<void> isLogged() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token") ?? "";
  if(!token.isEmpty){
    await connection.data.checkToken();
  }
  logged_in = prefs.getBool("logged_in") ?? false;
}

// String login = "";
// String password = "";
// String token = "";