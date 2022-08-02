import 'package:flutter/material.dart';

class FansPage extends StatefulWidget {
  const FansPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<FansPage> createState() => _FansPageState();
}

class _FansPageState extends State<FansPage> {
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
            const ElevatedButton(
              onPressed: null,
              child: Text(
                'On/Off',
                style: TextStyle(fontSize: 72),
              ),
            ),
            Column(
              children: <Widget>[
                const Text(
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
                  style: const TextStyle(fontSize: 48),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
