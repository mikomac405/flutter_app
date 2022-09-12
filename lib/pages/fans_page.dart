import 'package:flutter/material.dart';
import 'package:inzynierka/globals.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

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
            ElevatedButton(
              onPressed: () =>
                  connection.setConfig('vent', 'on', _value.toString()),
              child: const Text(
                'On',
                style: TextStyle(fontSize: 72),
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  connection.setConfig('vent', 'off', _value.toString()),
              child: const Text(
                'Off',
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
            ),
            NumberInputWithIncrementDecrement(
              controller: TextEditingController(),
              min: 0,
              max: 100,
            ),
            const Text(
              "Wilgotność",
              style: TextStyle(fontSize: 48),
            ),
            NumberInputWithIncrementDecrement(
              controller: TextEditingController(),
              min: 0,
              max: 100,
            ),
            const Text(
              "Temperatura",
              style: TextStyle(fontSize: 48),
            ),
          ],
        ),
      ),
    );
  }
}
