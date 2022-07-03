import 'package:flutter/material.dart';

class MqttTestPage extends StatefulWidget {
  const MqttTestPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MqttTestPage> createState() => _MqttTestPageState();
}

class _MqttTestPageState extends State<MqttTestPage> {
  double _value = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FansPage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: null,
              child: const Text(
                'On/Off',
                style: TextStyle(fontSize: 72),
              ),
            ),
            Column(
              children: <Widget>[
                Text(
                  "Power",
                  style: TextStyle(fontSize: 48),
                ),
                Slider(
                  min: 0.0,
                  max: 100.0,
                  value: _value,
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
                Text(
                  _value.toInt().toString() + "%",
                  style: TextStyle(fontSize: 48),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
