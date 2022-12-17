import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inzynierka/connection.dart';
import 'package:inzynierka/pages/charts_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'farm.dart';
import 'data.dart';

Farm farm = Farm();

late ConnectionManager connection;
late FlutterBluePlus androidClient;
late BluetoothDevice androidDevice;

bool disconnectRequest = false;

enum AppLoginStatus {
  notLoggedIn,
  loggingIn,
  loggedIn,
}

AppLoginStatus loggedIn = AppLoginStatus.notLoggedIn;

ChartData chartsData = ChartData();

Future<void> isLogged() async {
  loggedIn = AppLoginStatus.loggingIn;
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token") ?? "";
  if (token.isNotEmpty) {
    await connection.data.checkToken();
  }
  if (prefs.getBool("logged_in") ?? false) {
    loggedIn = AppLoginStatus.loggedIn;
  } else {
    loggedIn = AppLoginStatus.notLoggedIn;
  }
}

// String login = "";
// String password = "";
// String token = "";