import 'package:flutter/material.dart';
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

  Widget portraitMode() {
    return Scaffold(
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

  Widget landscapeMode() {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("AREATOR",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      if (farm.leds.state == 0) ...[
                        Image.asset('assets/images/oxygON.png',
                            width: 150, height: 105),
                      ] else ...[
                        Image.asset('assets/images/oxyOFF.png',
                            width: 150, height: 105),
                      ],
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("LIGHTS",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      if (farm.leds.state == 0) ...[
                        Image.asset('assets/images/onLights.png',
                            width: 150, height: 112.5),
                      ] else ...[
                        Image.asset('assets/images/offLights.png',
                            width: 150, height: 112.5),
                      ],
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("WATER TANK",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      if (farm.leds.state == 0) ...[
                        Image.asset('assets/images/fullTank.png',
                            width: 150, height: 105),
                      ] else ...[
                        Image.asset('assets/images/emptyTank.png',
                            width: 150, height: 105),
                      ],
                    ])
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("FANS",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      if (farm.leds.state == 0) ...[
                        Image.asset('assets/images/fanOn.png',
                            width: 150, height: 150),
                      ] else ...[
                        Image.asset('assets/images/fanOFF.png',
                            width: 150, height: 150),
                      ],
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("${farm.dht11.temperature}°C",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ])
              ]),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return portraitMode();
          } else {
            return landscapeMode();
          }
        },
      ),
    );
  }
}
