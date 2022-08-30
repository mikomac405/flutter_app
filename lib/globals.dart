import 'package:bluez/bluez.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'farm.dart';

Farm farm = Farm();

var connection;
late BlueZClient linuxClient;
late BlueZDevice linuxDevice;
late FlutterBluePlus androidClient;
late BluetoothDevice androidDevice;
