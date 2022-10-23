import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inzynierka/connection.dart';
import '../globals.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    farm.addListener(update);
  }

  @override
  void dispose() {
    farm.removeListener(update);
    super.dispose();
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Farm Stats"),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("LIGHTS",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, height: 0, fontSize: 20))
                ],
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Turning on at ${farm.leds.lightsOn}"),
                    const SizedBox(width: 10),
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
                          const SizedBox(height: 10),
                          const Text("WATER LEVEL",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  height: 0,
                                  fontSize: 20)),
                          if (farm.waterLvl.state == 0) ...[
                            const Text("Doesn't requier filling up"),
                          ] else ...[
                            const Text("Requiers filling up"),
                          ],
                        ]),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          const Text("AERATION",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  height: 0,
                                  fontSize: 20)),
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
                children: const [
                  Text("Current",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, height: 0, fontSize: 15))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text("Humidity: ${farm.dht11.humidity}%"),
                  const SizedBox(width: 10),
                  Text("Temperature: ${farm.dht11.temperature}°C")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 20),
                  Text("Level at which fans start propelling",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, height: 0, fontSize: 15))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Humidity: ${farm.fan.maxHumidity}%"),
                  const SizedBox(width: 10),
                  Text("Temperature: ${farm.fan.maxTemp}°C")
                ],
              ),
            ]));
  }
}
