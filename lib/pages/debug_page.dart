import 'package:flutter/material.dart';
import 'package:inzynierka/farm.dart';
import '../globals.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({Key? key, required String title}) : super(key: key);

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  Farm debugFarm = farm;
  @override
  void initState() {
    super.initState();
    farm.addListener(_farmUpdate);
  }

  void _farmUpdate() {
    setState(() {
      debugFarm = farm;
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
                  Text("State: ${debugFarm.leds.state}"),
                  Text("LightsOn: ${debugFarm.leds.lightsOn}"),
                  Text("LightsOff: ${debugFarm.leds.lightsOff}")
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  const Text("BOARD"),
                  Text("Name: ${debugFarm.board.name}")
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  const Text("WATER LEVEL"),
                  Text("State: ${debugFarm.waterLvl.state}")
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  const Text("OXYG"),
                  Text("State: ${debugFarm.oxygenator.state}")
                ],
              ),
            ],
          ),
          Row(children: [
            Column(
              children: [
                const Text("DHT11"),
                Text("Humidity: ${debugFarm.dht11.humidity}"),
                Text("Temperature: ${debugFarm.dht11.temperature}")
              ],
            ),
          ])
        ]));
  }
}
