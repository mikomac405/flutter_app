import 'dart:core';
import 'dart:math';

import 'package:flutter/cupertino.dart';

class Farm with ChangeNotifier {
  Leds leds = Leds();
  Board board = Board();
  WaterLevel waterLvl = WaterLevel();
  Oxygenator oxygenator = Oxygenator();
  DHT11 dht11 = DHT11();
  Fan fan = Fan();

  Farm();

  void update(config) {
    leds.update(config["led"]);
    waterLvl.update(config["waterLvl"]);
    oxygenator.update(config["oxygenator"]);
    dht11.update(config["dht11"]);
    fan.update(config["fan"]);
    notifyListeners();
  }

  void randHum() {
    dht11.humidity = Random().nextInt(90) + 10;
    notifyListeners();
  }
}

class Leds {
  int state = 0;
  String lightsOn = "00:00";
  String lightsOff = "00:00";

  void update(var newConfig) {
    state = newConfig["status"];
    lightsOff = newConfig["lightOff"];
    lightsOn = newConfig["lightOn"];
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
    state = newConfig["status"];
  }
}

class Oxygenator {
  int state = 0;

  Oxygenator();

  void update(var newConfig) {
    state = newConfig["status"];
  }
}

class DHT11 {
  int humidity = 0;
  int temperature = 0;

  DHT11();

  void update(var newConfig) {
    humidity = newConfig["hum"];
    temperature = newConfig["temp"];
  }
}

class Fan {
  int state = 0;
  int maxTemp = 0;
  int maxHumidity = 0;

  void update(var newConfig) {
    maxTemp = newConfig["max_temp"];
    maxHumidity = newConfig["max_hum"];
  }
}
