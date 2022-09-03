import 'package:bluez/bluez.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inzynierka/connection.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'farm.dart';

Farm farm = Farm();

late ConnectionManager connection;
late FlutterBluePlus androidClient;
late BluetoothDevice androidDevice;

bool disconnectRequest = false;
