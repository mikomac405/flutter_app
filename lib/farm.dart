import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';

Map<String, dynamic> status = jsonDecode(
    "{\"led\":{\"state\":1,\"lightsOn\":\"10:0\",\"lightsOff\":\"22:0\"},\"board\":\"\",\"waterLvl\":{\"state\":0}}");

void testFarm(status) {
  var farm = Farm();
}

class Farm with ChangeNotifier {
  Leds leds = Leds();
  Board board = Board();
  WaterLevel waterLvl = WaterLevel();
  Oxygenator oxygenator = Oxygenator();
  DHT11 dht11 = DHT11();

  Farm();

  void update(config) {
    leds.update(config["leds"]);
    waterLvl.update(config["waterLvl"]);
    oxygenator.update(config["oxygenator"]);
    dht11.update(config["dht11"]);
    notifyListeners();
  }
}

class Leds {
  int state = 0;
  String lightsOn = "00:00";
  String lightsOff = "00:00";

  void update(var newConfig) {
    state = newConfig["state"];
    lightsOff = newConfig["lightsOff"];
    lightsOn = newConfig["lightsOn"];
  }

  Leds();
}

class Board {
  String name = "Board";
  Board();
}

class WaterLevel {
  int state = 0;

  WaterLevel();

  void update(var newConfig) {
    state = newConfig["state"];
  }
}

class Oxygenator {
  int state = 0;

  Oxygenator();

  void update(var newConfig) {
    state = newConfig["state"];
  }
}

class DHT11 {
  int humidity = 0;
  int temperature = 0;

  DHT11();

  void update(var newConfig) {
    humidity = newConfig["humidity"];
    temperature = newConfig["temperature"];
  }
}
