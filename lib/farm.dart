import 'dart:convert';
import 'dart:core';

Map<String, dynamic> status = jsonDecode(
    "{\"led\":{\"state\":1,\"lightsOn\":\"10:0\",\"lightsOff\":\"22:0\"},\"board\":\"\",\"waterLvl\":{\"state\":0}}");

///This function is responsible for printing farm components status
void testFarm(status) {
  var farm = Farm(status);
  print(farm.board.name);
  print(farm.leds.lightsOn);
  print(farm.waterLvl.state);
}

class Farm {
  late Leds leds;
  late Board board;
  late WaterLevel waterLvl;

  Farm(config) {
    var ledConfig = config["led"];
    leds = Leds(ledConfig["state"], ledConfig["lightsOnStr"],
        ledConfig["lightsOffStr"]);

    var boardConfig = config["board"];
    board = Board("empty");

    var waterLvlConfig = config["waterLvl"];
    waterLvl = WaterLevel(waterLvlConfig["state"]);
  }
}

class Leds {
  bool state;
  String lightsOn = "00:00";
  String lightsOff = "00:00";

  Leds(this.state, String lightsOnStr, String lightsOffStr) {
    lightsOn = lightsOnStr.length > 1 ? lightsOnStr : "0 $lightsOnStr";
    lightsOff = lightsOffStr.length > 1 ? lightsOffStr : "0 $lightsOffStr";
  }
}

class Board {
  final String name;
  Board(this.name);
}

class WaterLevel {
  bool state;

  WaterLevel(this.state);

  void update(bool state) {
    this.state = state;
  }
}
