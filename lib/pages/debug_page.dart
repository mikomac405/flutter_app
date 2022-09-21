import 'package:flutter/material.dart';
import 'package:inzynierka/farm.dart';
import '../globals.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({Key? key, required String title}) : super(key: key);

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  int leds_state = farm.leds.state;
  String leds_on = farm.leds.lightsOn;
  String leds_off = farm.leds.lightsOff;
  String board = farm.board.name;
  int water_lvl = farm.waterLvl.state;
  int oxyg = farm.oxygenator.state;
  int humidity = farm.dht11.humidity;
  int temp = farm.dht11.temperature;

  @override
  void initState() {
    super.initState();
    farm.addListener(update);
  }

  void update() {
    setState(() {
      leds_state = farm.leds.state;
      leds_on = farm.leds.lightsOn;
      leds_off = farm.leds.lightsOff;
      board = farm.board.name;
      water_lvl = farm.waterLvl.state;
      oxyg = farm.oxygenator.state;
      humidity = farm.dht11.humidity;
      temp = farm.dht11.temperature;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Debug Page'),
        ),
        body: Column(children: [
          Row(
            children: [
              Column(
                children: [
                  const Text("LEDS"),
                  Text("State: ${farm.leds.state}"),
                  Text("LightsOn: ${farm.leds.lightsOn}"),
                  Text("LightsOff: ${farm.leds.lightsOff}")
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  const Text("BOARD"),
                  Text("Name: ${farm.board.name}")
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  const Text("WATER LEVEL"),
                  Text("State: ${farm.waterLvl.state}")
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  const Text("OXYG"),
                  Text("State: ${farm.oxygenator.state}")
                ],
              ),
            ],
          ),
          Row(children: [
            Column(
              children: [
                const Text("DHT11"),
                Text("Humidity: ${farm.dht11.humidity}"),
                Text("Temperature: ${farm.dht11.temperature}")
              ],
            ),
          ])
        ]));
  }
}
