import 'package:flutter/material.dart';

class LightsPage extends StatefulWidget {
  const LightsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LightsPage> createState() => _LightsPageState();
}

class _LightsPageState extends State<LightsPage> {
  double _value = 20;

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
            const ElevatedButton(
              onPressed: null,
              child: Text(
                'On/Off',
                style: TextStyle(fontSize: 72),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: const <Widget>[
                    Text(
                      "Start time",
                      style: TextStyle(fontSize: 36),
                    ),
                    SizedBox(width: 100, child: TextField()),
                  ],
                ),
                Column(
                  children: const <Widget>[
                    Text(
                      "Stop time",
                      style: TextStyle(fontSize: 36),
                    ),
                    SizedBox(width: 100, child: TextField()),
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
