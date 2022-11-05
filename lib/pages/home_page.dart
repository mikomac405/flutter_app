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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          const SizedBox(height: 50),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            const Text("TEMPERATURE",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            const SizedBox(height: 10),
                            Text("${farm.dht11.temperature}°C",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 100,
                                    color: Colors.black)),
                          ])
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text("HUMIDITY",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(height: 10),
                      Text("${farm.dht11.humidity}%",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 100,
                              color: Colors.black)),
                    ])
              ])
        ]));
  }

  Widget landscapeMode() {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          const SizedBox(height: 50),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("HUMIDITY",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(height: 10),
                      Text("${farm.dht11.humidity}%",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 100,
                              color: Colors.black)),
                    ]),
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
                      const Text("TEMPERATURE",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(height: 10),
                      Text("${farm.dht11.temperature}°C",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 100,
                              color: Colors.black)),
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
