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
  //int _fanPowerStatus = farm.fan.status;
  int _lightsStartHours = int.parse(farm.leds.lightsOn.split(':')[0]);
  int _lightsStartMinutes = int.parse(farm.leds.lightsOn.split(':')[1]);
  int _lightsStopHours = int.parse(farm.leds.lightsOff.split(':')[0]);
  int _lightsStopMinutes = int.parse(farm.leds.lightsOff.split(':')[1]);
  //RangeValues _currentRangeValues = const RangeValues(4, 12);
  String _isPressedLights = farm.leds.state == 1 ? "ON" : "OFF";
  String _isPressedFans = farm.fan.status == 1 ? "ON" : "OFF";
  Widget portraitMode() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                      const SizedBox(width: 10),
                      ElevatedButton(
                          onPressed: () {
                            if (_isPressedFans == "OFF") {
                              setState(() {
                                _isPressedFans = "ON";
                              });

                              connection.data.setConfig('fan', 'start', '');
                            } else {
                              connection.data.setConfig('fan', 'stop', '');
                              setState(() {
                                _isPressedFans = "OFF";
                              });
                            }
                          },
                          child: Text(
                            _isPressedFans,
                            style: const TextStyle(fontSize: 30),
                          )),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1)),
                      ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            "AUTO",
                            style: TextStyle(fontSize: 30),
                          ))
                    ])
              ],
            ),
            const SizedBox(height: 10),
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
                    selectedTextStyle:
                        const TextStyle(fontSize: 20, color: Colors.black),
                    onChanged: (value) =>
                        setState(() => _humidityValue = value),
                  ),
                  const Text(
                    "%",
                    style: TextStyle(fontSize: 20, height: 1),
                  ),
                ]),
            const SizedBox(height: 10),
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
                    selectedTextStyle:
                        const TextStyle(fontSize: 20, color: Colors.black),
                    onChanged: (value) =>
                        setState(() => _temperatureValue = value),
                  ),
                  const Text(
                    "°C",
                    style: TextStyle(fontSize: 20, height: 1),
                  )
                ]),
            const SizedBox(height: 10),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        connection.data.setConfig("fan", "set_max_temperature",
                            _temperatureValue.toString());
                        await Future.delayed(const Duration(seconds: 2));
                        connection.data.setConfig("fan", "set_max_humidity",
                            _humidityValue.toString());
                        await Future.delayed(const Duration(seconds: 2));
                      },
                      child: const Text(
                        "SAVE",
                        style: TextStyle(fontSize: 30),
                      )),
                ]),
            const SizedBox(height: 50),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text(
                "LIGHTS",
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    if (_isPressedLights == "ON") {
                      setState(() {
                        _isPressedLights = "OFF";
                      });
                      connection.data.setConfig("led", "off", "");
                    } else {
                      connection.data.setConfig("led", "on", "");
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Row(children: [
                      const Text("Start",
                          style: TextStyle(fontSize: 20, height: 1)),
                      NumberPicker(
                        itemHeight: 25,
                        itemWidth: 40,
                        value: _lightsStartHours,
                        minValue: 0,
                        maxValue: 23,
                        selectedTextStyle:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        onChanged: (value) =>
                            setState(() => _lightsStartHours = value),
                      ),
                      const Text(":",
                          style: TextStyle(fontSize: 20, height: 1)),
                      NumberPicker(
                        itemHeight: 25,
                        itemWidth: 40,
                        value: _lightsStartMinutes,
                        minValue: 0,
                        maxValue: 59,
                        selectedTextStyle:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        onChanged: (value) =>
                            setState(() => _lightsStartMinutes = value),
                      ),
                      const SizedBox(width: 20),
                    ]),
                    Row(children: [
                      const Text("Stop",
                          style: TextStyle(fontSize: 20, height: 1)),
                      NumberPicker(
                        itemHeight: 25,
                        itemWidth: 40,
                        value: _lightsStopHours,
                        minValue: 0,
                        maxValue: 23,
                        selectedTextStyle:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        onChanged: (value) =>
                            setState(() => _lightsStopHours = value),
                      ),
                      const Text(":",
                          style: TextStyle(fontSize: 20, height: 1)),
                      NumberPicker(
                        itemHeight: 25,
                        itemWidth: 40,
                        value: _lightsStopMinutes,
                        minValue: 0,
                        maxValue: 59,
                        selectedTextStyle:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        onChanged: (value) =>
                            setState(() => _lightsStopMinutes = value),
                      )
                    ])
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        connection.data.setConfig("led", "set_time_on",
                            "${_lightsStartHours + 1}:$_lightsStartMinutes");
                        await Future.delayed(const Duration(seconds: 2));
                        connection.data.setConfig("led", "set_time_off",
                            "${_lightsStopHours + 1}:$_lightsStopMinutes");
                        await Future.delayed(const Duration(seconds: 2));
                      },
                      child: Text(
                        "SAVE",
                        style: const TextStyle(fontSize: 30),
                      )),
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
                                  const SizedBox(width: 20),
                                  const Text(
                                    "FANS",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                      onPressed: () {
                                        if (_isPressedFans == "ON") {
                                          setState(() {
                                            _isPressedFans = "OFF";
                                          });
                                          connection.data
                                              .setConfig('fan', 'stop', '');
                                        } else {
                                          connection.data
                                              .setConfig('fan', 'start', '');
                                          setState(() {
                                            _isPressedFans = "ON";
                                          });
                                        }
                                      },
                                      child: Text(
                                        _isPressedFans,
                                        style: const TextStyle(fontSize: 30),
                                      )),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10)),
                                  ElevatedButton(
                                      onPressed: () {
                                        connection.data
                                            .setConfig('fan', 'auto', '');
                                      },
                                      child: const Text(
                                        "AUTO",
                                        style: TextStyle(fontSize: 30),
                                      ))
                                ]),
                          ])
                    ],
                  ),
                  const SizedBox(height: 20),
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
                          selectedTextStyle: const TextStyle(
                              fontSize: 25, color: Colors.black),
                          onChanged: (value) =>
                              setState(() => _humidityValue = value),
                        ),
                        const Text(
                          "%",
                          style: TextStyle(fontSize: 30, height: 1),
                        ),
                      ]),
                  const SizedBox(height: 10),
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
                          selectedTextStyle: const TextStyle(
                              fontSize: 25, color: Colors.black),
                          onChanged: (value) =>
                              setState(() => _temperatureValue = value),
                        ),
                        const Text(
                          "°C",
                          style: TextStyle(fontSize: 30, height: 1),
                        ),
                        const SizedBox(width: 40),
                      ]),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              connection.data.setConfig(
                                  "fan",
                                  "set_max_temperature",
                                  _temperatureValue.toString());
                              await Future.delayed(const Duration(seconds: 2));
                              connection.data.setConfig(
                                  "fan",
                                  "set_max_humidity",
                                  _humidityValue.toString());
                              await Future.delayed(const Duration(seconds: 2));
                            },
                            child: Text(
                              "SAVE",
                              style: const TextStyle(fontSize: 30),
                            )),
                      ]),
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
                        const SizedBox(width: 10),
                        ElevatedButton(
                            onPressed: () {
                              if (_isPressedLights == "ON") {
                                setState(() {
                                  _isPressedLights = "OFF";
                                });
                                connection.data.setConfig("led", "off", "");
                              } else {
                                connection.data.setConfig("led", "on", "");
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Row(children: [
                            const Text("Start",
                                style: TextStyle(fontSize: 25, height: 1)),
                            NumberPicker(
                              itemHeight: 25,
                              itemWidth: 40,
                              value: _lightsStartHours,
                              minValue: 0,
                              maxValue: 23,
                              selectedTextStyle: const TextStyle(
                                  fontSize: 25, color: Colors.black),
                              onChanged: (value) =>
                                  setState(() => _lightsStartHours = value),
                            ),
                            const Text(":",
                                style: TextStyle(fontSize: 25, height: 1)),
                            NumberPicker(
                              itemHeight: 25,
                              itemWidth: 40,
                              value: _lightsStartMinutes,
                              minValue: 0,
                              maxValue: 59,
                              selectedTextStyle: const TextStyle(
                                  fontSize: 25, color: Colors.black),
                              onChanged: (value) =>
                                  setState(() => _lightsStartMinutes = value),
                            ),
                          ]),
                          const SizedBox(height: 20),
                          Row(children: [
                            const Text("Stop",
                                style: TextStyle(fontSize: 25, height: 1)),
                            NumberPicker(
                              itemHeight: 25,
                              itemWidth: 40,
                              value: _lightsStopHours,
                              minValue: 0,
                              maxValue: 23,
                              selectedTextStyle: const TextStyle(
                                  fontSize: 25, color: Colors.black),
                              onChanged: (value) =>
                                  setState(() => _lightsStopHours = value),
                            ),
                            const Text(":",
                                style: TextStyle(fontSize: 25, height: 1)),
                            NumberPicker(
                              itemHeight: 25,
                              itemWidth: 40,
                              value: _lightsStopMinutes,
                              minValue: 0,
                              maxValue: 59,
                              selectedTextStyle: const TextStyle(
                                  fontSize: 25, color: Colors.black),
                              onChanged: (value) =>
                                  setState(() => _lightsStopMinutes = value),
                            )
                          ])
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              connection.data.setConfig("led", "set_time_on",
                                  "${_lightsStartHours + 1}:$_lightsStartMinutes");
                              await Future.delayed(const Duration(seconds: 2));
                              connection.data.setConfig("led", "set_time_off",
                                  "${_lightsStopHours + 1}:$_lightsStopMinutes");
                              await Future.delayed(const Duration(seconds: 2));
                            },
                            child: Text(
                              "SAVE",
                              style: const TextStyle(fontSize: 30),
                            )),
                      ]),
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
