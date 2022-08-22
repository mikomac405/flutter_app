import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inzynierka/globals.dart';

class LightsPage extends StatefulWidget {
  const LightsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LightsPage> createState() => _LightsPageState();
}

class _LightsPageState extends State<LightsPage> {
  double _value = 20;

  final controllerStart = TextEditingController();
  final controllerStop = TextEditingController();

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
              onPressed: () => setConfig(
                  "led", "on", controllerStart.text + controllerStop.text),
              child: Text(
                'On',
                style: TextStyle(fontSize: 72),
              ),
            ),
            ElevatedButton(
              onPressed: () => setConfig(
                  "led", "off", controllerStart.text + controllerStop.text),
              child: Text(
                'Off',
                style: TextStyle(fontSize: 72),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Start time",
                      style: TextStyle(fontSize: 36),
                    ),
                    SizedBox(
                        width: 100,
                        child: TextField(
                          controller: controllerStart,
                        )),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "Stop time",
                      style: TextStyle(fontSize: 36),
                    ),
                    SizedBox(
                        width: 100,
                        child: TextField(
                          controller: controllerStop,
                        )),
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
