import 'package:flutter/material.dart';
import 'package:inzynierka/globals.dart';

class LightsPage extends StatefulWidget {
  const LightsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LightsPage> createState() => _LightsPageState();
}

class _LightsPageState extends State<LightsPage> {
  final controllerStart = TextEditingController();
  final controllerStop = TextEditingController();

  @override
  void initState() {
    controllerStart.text = farm.leds.lightsOn;
    controllerStop.text = farm.leds.lightsOff;
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controllerStart.dispose();
    controllerStop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LightsPage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => connection.setConfig("led", "on", ""),
              child: const Text(
                'On',
                style: TextStyle(fontSize: 72),
              ),
            ),
            ElevatedButton(
              onPressed: () => connection.setConfig("led", "off", ""),
              child: const Text(
                'Off',
                style: TextStyle(fontSize: 72),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const Text(
                      "Start time",
                      style: TextStyle(fontSize: 36),
                    ),
                    SizedBox(
                        width: 100,
                        child: TextField(
                          controller: controllerStart,
                        )),
                    ElevatedButton(
                        onPressed: () => connection.setConfig(
                            "led", "set_time_on", controllerStart.text),
                        child: const Text("Set time on"))
                  ],
                ),
                Column(
                  children: <Widget>[
                    const Text(
                      "Stop time",
                      style: TextStyle(fontSize: 36),
                    ),
                    SizedBox(
                        width: 100,
                        child: TextField(
                          controller: controllerStop,
                        )),
                    ElevatedButton(
                        onPressed: () => connection.setConfig(
                            "led", "set_time_off", controllerStop.text),
                        child: const Text("Set time off"))
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
