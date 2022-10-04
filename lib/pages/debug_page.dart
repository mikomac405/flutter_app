import 'package:flutter/material.dart';
import '../globals.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({Key? key, required String title}) : super(key: key);

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  @override
  void initState() {
    super.initState();
    farm.addListener(update);
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Debug Page'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("LEDS"),
              Text("State: ${farm.leds.state}"),
              Text("LightsOn: ${farm.leds.lightsOn}"),
              Text("LightsOff: ${farm.leds.lightsOff}\n"),
              const Text("BOARD"),
              Text("Name: ${farm.board.name}\n"),
              const Text("WATER LEVEL"),
              Text("State: ${farm.waterLvl.state}\n"),
              const Text("OXYG"),
              Text("State: ${farm.oxygenator.state}\n"),
              const Text("DHT11"),
              Text("Humidity: ${farm.dht11.humidity}"),
              Text("Temperature: ${farm.dht11.temperature}\n"),
              const Text("Fan"),
              Text("Max humidity: ${farm.fan.maxHumidity}"),
              Text("Max temperature: ${farm.fan.maxTemp}")
            ]));
  }
}
