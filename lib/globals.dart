import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inzynierka/connection.dart';
import 'farm.dart';

Farm farm = Farm();

late ConnectionManager connection;
late FlutterBluePlus androidClient;
late BluetoothDevice androidDevice;

bool disconnectRequest = false;
