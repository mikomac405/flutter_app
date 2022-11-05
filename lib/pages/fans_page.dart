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
  int _humidityValue = farm.fan.maxHumidity;
  int _fanPowerValue = farm.fan.speed;
  String _isPressed = "On";
  Widget portraitMode() {
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
                      onPressed: () {
                        if (_isPressed == "On") {
                          setState(() {
                            _isPressed = "Off";
                          });
                          connection.data.setConfig(
                              'vent', 'on', _fanPowerValue.toString());
                        } else {
                          connection.data.setConfig(
                              'vent', 'off', _fanPowerValue.toString());
                          setState(() {
                            _isPressed = "On";
                          });
                        }
                      },
                      child: Text(
                        _isPressed,
                        style: const TextStyle(fontSize: 52),
                      )),
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
                      NumberPicker(
                        value: _humidityValue,
                        minValue: 0,
                        maxValue: 100,
                        onChanged: (value) =>
                            setState(() => _temperatureValue = value),
                      ),
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
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                ]),
          ],
        ),
      ),
    );
  }

  Widget landscapeMode() {
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
                      onPressed: () {
                        if (_isPressed == "On") {
                          setState(() {
                            _isPressed = "Off";
                          });

                          connection.data.setConfig(
                              'vent', 'on', _fanPowerValue.toString());
                        } else {
                          connection.data.setConfig(
                              'vent', 'off', _fanPowerValue.toString());
                          setState(() {
                            _isPressed = "On";
                          });
                        }
                      },
                      child: Text(
                        _isPressed,
                        style: const TextStyle(fontSize: 52),
                      )),
                ]),
            Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Power",
                        style: TextStyle(fontSize: 30, height: 3.5),
                      ),
                      SizedBox(
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: NumberPicker(
                                value: _fanPowerValue,
                                minValue: 0,
                                maxValue: 100,
                                onChanged: (value) =>
                                    setState(() => _fanPowerValue = value),
                              ))),
                      Text(
                        _fanPowerValue.toInt().toString() + "%",
                        style: TextStyle(fontSize: 30, height: 3.5),
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
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
