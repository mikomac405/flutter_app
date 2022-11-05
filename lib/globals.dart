import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inzynierka/connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'farm.dart';

Farm farm = Farm();

late ConnectionManager connection;
late FlutterBluePlus androidClient;
late BluetoothDevice androidDevice;

bool disconnectRequest = false;

// String login = "";
// String password = "";
// String token = "";