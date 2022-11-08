import 'package:flutter/material.dart';
import 'package:inzynierka/globals.dart';
import 'package:numberpicker/numberpicker.dart';

class FansAndLightsPage extends StatefulWidget {
  const FansAndLightsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<FansAndLightsPage> createState() => _FansAndLightsState();
}

class _FansAndLightsState extends State<FansAndLightsPage> {
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

  int _temperatureValue = farm.fan.maxTemp;
  int _humidityValue = farm.fan.maxHumidity;
  int _fanPowerValue = farm.fan.speed;
  int _lightsStartMinutes = 30;
  int _lightsStopMinutes = 30;
  RangeValues _currentRangeValues = const RangeValues(4, 12);
  String _isPressedLights = "ON";
  String _isPressedFans = "ON";
  Widget portraitMode() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "LIGHTS",
                    style: TextStyle(fontSize: 30),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_isPressedLights == "ON") {
                          setState(() {
                            _isPressedLights = "OFF";
                          });
                          connection.data.setConfig("led", "on", "");
                        } else {
                          connection.data.setConfig("led", "off", "");
                          setState(() {
                            _isPressedLights = "ON";
                          });
                        }
                      },
                      child: Text(
                        _isPressedLights,
                        style: const TextStyle(fontSize: 30),
                      )),
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(_currentRangeValues.start.round().toString()),
                      const Text(":"),
                      Text("$_lightsStartMinutes"),
                      SizedBox(width: 20),
                      Text(_currentRangeValues.end.round().toString()),
                      const Text(":"),
                      Text("$_lightsStopMinutes")
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("Hours"),
                      Container(
                          width: 300,
                          child: RangeSlider(
                            values: _currentRangeValues,
                            max: 23,
                            divisions: 23,
                            onChanged: (RangeValues values) {
                              setState(() {
                                _currentRangeValues = values;
                              });
                            },
                          ))
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("Minutes start"),
                      NumberPicker(
                        itemHeight: 25,
                        itemWidth: 50,
                        value: _lightsStartMinutes,
                        minValue: 0,
                        maxValue: 59,
                        onChanged: (value) =>
                            setState(() => _lightsStartMinutes = value),
                      ),
                      Text("Minutes ends"),
                      NumberPicker(
                        itemHeight: 25,
                        itemWidth: 50,
                        value: _lightsStopMinutes,
                        minValue: 0,
                        maxValue: 59,
                        onChanged: (value) =>
                            setState(() => _lightsStopMinutes = value),
                      )
                    ])
                  ],
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "FANS",
                        style: TextStyle(fontSize: 30),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_isPressedFans == "ON") {
                              setState(() {
                                _isPressedFans = "OFF";
                              });

                              connection.data.setConfig(
                                  'vent', 'on', _fanPowerValue.toString());
                            } else {
                              connection.data.setConfig(
                                  'vent', 'off', _fanPowerValue.toString());
                              setState(() {
                                _isPressedFans = "ON";
                              });
                            }
                          },
                          child: Text(
                            _isPressedFans,
                            style: const TextStyle(fontSize: 30),
                          )),
                    ])
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Humidity",
                    style: TextStyle(fontSize: 20, height: 1),
                  ),
                  NumberPicker(
                    itemHeight: 25,
                    itemWidth: 50,
                    value: _humidityValue,
                    minValue: 0,
                    maxValue: 100,
                    onChanged: (value) =>
                        setState(() => _humidityValue = value),
                  ),
                  const Text(
                    "%",
                    style: TextStyle(fontSize: 20, height: 1),
                  ),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Temperature",
                    style: TextStyle(fontSize: 20, height: 1),
                  ),
                  NumberPicker(
                    itemHeight: 25,
                    itemWidth: 50,
                    value: _temperatureValue,
                    minValue: 0,
                    maxValue: 100,
                    onChanged: (value) =>
                        setState(() => _temperatureValue = value),
                  ),
                  const Text(
                    "°C",
                    style: TextStyle(fontSize: 20, height: 1),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 20),
                                  const Text(
                                    "FANS",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  SizedBox(width: 10),
                                  ElevatedButton(
                                      onPressed: () {
                                        if (_isPressedFans == "ON") {
                                          setState(() {
                                            _isPressedFans = "OFF";
                                          });
                                          connection.data.setConfig('vent',
                                              'on', _fanPowerValue.toString());
                                        } else {
                                          connection.data.setConfig('vent',
                                              'off', _fanPowerValue.toString());
                                          setState(() {
                                            _isPressedFans = "ON";
                                          });
                                        }
                                      },
                                      child: Text(
                                        _isPressedFans,
                                        style: const TextStyle(fontSize: 30),
                                      ))
                                ]),
                          ])
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Humidity",
                          style: TextStyle(fontSize: 30, height: 1),
                        ),
                        NumberPicker(
                          itemHeight: 25,
                          itemWidth: 50,
                          value: _humidityValue,
                          minValue: 0,
                          maxValue: 100,
                          onChanged: (value) =>
                              setState(() => _humidityValue = value),
                        ),
                        const Text(
                          "%",
                          style: TextStyle(fontSize: 30, height: 1),
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Temperature",
                          style: TextStyle(fontSize: 30, height: 1),
                        ),
                        NumberPicker(
                          itemHeight: 25,
                          itemWidth: 50,
                          value: _temperatureValue,
                          minValue: 0,
                          maxValue: 100,
                          onChanged: (value) =>
                              setState(() => _temperatureValue = value),
                        ),
                        const Text(
                          "°C",
                          style: TextStyle(fontSize: 30, height: 1),
                        ),
                        SizedBox(width: 40),
                      ])
                ]),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "LIGHTS",
                          style: TextStyle(fontSize: 30),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                            onPressed: () {
                              if (_isPressedLights == "ON") {
                                setState(() {
                                  _isPressedLights = "OFF";
                                });
                                connection.data.setConfig("led", "on", "");
                              } else {
                                connection.data.setConfig("led", "off", "");
                                setState(() {
                                  _isPressedLights = "ON";
                                });
                              }
                            },
                            child: Text(
                              _isPressedLights,
                              style: const TextStyle(fontSize: 30),
                            )),
                      ]),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_currentRangeValues.start
                                    .round()
                                    .toString()),
                                const Text(":"),
                                Text("$_lightsStartMinutes"),
                                SizedBox(width: 20),
                                Text(
                                    _currentRangeValues.end.round().toString()),
                                const Text(":"),
                                Text("$_lightsStopMinutes")
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Hours"),
                                Container(
                                    width: 300,
                                    child: RangeSlider(
                                      values: _currentRangeValues,
                                      max: 23,
                                      divisions: 23,
                                      onChanged: (RangeValues values) {
                                        setState(() {
                                          _currentRangeValues = values;
                                        });
                                      },
                                    ))
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Minutes start"),
                                NumberPicker(
                                  itemHeight: 25,
                                  itemWidth: 50,
                                  value: _lightsStartMinutes,
                                  minValue: 0,
                                  maxValue: 59,
                                  onChanged: (value) => setState(
                                      () => _lightsStartMinutes = value),
                                ),
                                Text("Minutes ends"),
                                NumberPicker(
                                  itemHeight: 25,
                                  itemWidth: 50,
                                  value: _lightsStopMinutes,
                                  minValue: 0,
                                  maxValue: 59,
                                  onChanged: (value) => setState(
                                      () => _lightsStopMinutes = value),
                                )
                              ])
                        ],
                      ),
                    ],
                  ),
                ]),
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
