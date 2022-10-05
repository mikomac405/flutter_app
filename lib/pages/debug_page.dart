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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [Text("LIGHTS")],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Currently "),
                    if (farm.leds.state == 0) ...[
                      const Text("On"),
                    ] else ...[
                      const Text("Off"),
                    ],
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Turning on at ${farm.leds.lightsOn}"),
                    Text("Turning off at ${farm.leds.lightsOff}")
                  ]),
              //const Text("BOARD"),
              //Text("Name: ${farm.board.name}\n"),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("WATER LEVEL"),
                          if (farm.waterLvl.state == 0) ...[
                            const Text("Doesn't requier filling up"),
                          ] else ...[
                            const Text("Requiers filling up"),
                          ],
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("AERATION"),
                          Row(
                            children: [
                              const Text("Currently "),
                              if (farm.leds.state == 0) ...[
                                const Text("On"),
                              ] else ...[
                                const Text("Off"),
                              ],
                            ],
                          )
                        ]),
                  ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [Text("DHT11")],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Humidity: ${farm.dht11.humidity}"),
                  Text("Temperature: ${farm.dht11.temperature}")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [Text("Fan")],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Max humidity: ${farm.fan.maxHumidity}"),
                  Text("Max temperature: ${farm.fan.maxTemp}")
                ],
              ),
            ]));
  }
}
