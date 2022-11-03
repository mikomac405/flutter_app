import 'package:flutter/material.dart';
import 'package:inzynierka/globals.dart';
import 'package:numberpicker/numberpicker.dart';

class FansPage extends StatefulWidget {
  const FansPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<FansPage> createState() => _FansPageState();
}

class _FansPageState extends State<FansPage> {
  int _temperatureValue = farm.fan.maxTemp;
  int _humidityValue = 50;
  double _fanPowerValue = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () => connection.setConfig(
                        'vent', 'on', _fanPowerValue.toString()),
                    child: const Text(
                      'On',
                      style: TextStyle(fontSize: 72),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => connection.setConfig(
                        'vent', 'off', _fanPowerValue.toString()),
                    child: const Text(
                      'Off',
                      style: TextStyle(fontSize: 72),
                    ),
                  ),
                ]),
            Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Power",
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                          width: 500,
                          child: (Slider(
                            min: 0.0,
                            max: 100.0,
                            thumbColor: Colors.blueGrey,
                            value: _fanPowerValue,
                            onChanged: (value) {
                              setState(() {
                                _fanPowerValue = value;
                              });
                            },
                          ))),
                      Text(
                        _fanPowerValue.toInt().toString() + "%",
                        style: const TextStyle(fontSize: 30),
                      ),
                    ])
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Humidity",
                    style: TextStyle(fontSize: 30, height: 3.5),
                  ),
                  SizedBox(
                      child: FittedBox(
                          fit: BoxFit.contain,
                          child: NumberPicker(
                            value: _humidityValue,
                            minValue: 0,
                            maxValue: 100,
                            onChanged: (value) =>
                                setState(() => _humidityValue = value),
                          ))),
                  const Text(
                    "%",
                    style: TextStyle(fontSize: 30, height: 3.5),
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  const Text(
                    "Temperature",
                    style: TextStyle(fontSize: 30, height: 3.5),
                  ),
                  NumberPicker(
                    value: _temperatureValue,
                    minValue: 0,
                    maxValue: 100,
                    onChanged: (value) =>
                        setState(() => _temperatureValue = value),
                  ),
                  const Text(
                    "°C",
                    style: TextStyle(fontSize: 30, height: 3.5),
                  )
                ])
          ],
        ),
      ),
    );
  }
}
