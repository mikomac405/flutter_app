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

  TimeOfDay _timeOn = const TimeOfDay(hour: 7, minute: 15);
  TimeOfDay _timeOff = const TimeOfDay(hour: 18, minute: 15);

  void _selectTimeOn() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _timeOn,
    );
    if (newTime != null) {
      setState(() {
        _timeOn = newTime;
      });
    }
  }

  void _selectTimeOff() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _timeOff,
    );
    if (newTime != null) {
      setState(() {
        _timeOff = newTime;
      });
    }
  }

  int _temperatureValue = farm.fan.maxTemp;
  int _humidityValue = farm.fan.maxHumidity;
  int _fanPowerValue = farm.fan.speed;
  String _isPressedLights = "On";
  String _isPressedFans = "On";
  Widget portraitMode() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (_isPressedLights == "On") {
                          setState(() {
                            _isPressedLights = "Off";
                          });
                          connection.data.setConfig("led", "on", "");
                        } else {
                          connection.data.setConfig("led", "off", "");
                          setState(() {
                            _isPressedLights = "On";
                          });
                        }
                      },
                      child: Text(
                        _isPressedLights,
                        style: const TextStyle(fontSize: 52),
                      )),
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                        width: 100,
                        child: TextField(
                          controller: controllerStart,
                        )),
                    ElevatedButton(
                      onPressed: _selectTimeOn,
                      child: const Text('Set time on'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selected time: ${_timeOn.format(context)}',
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                        width: 100,
                        child: TextField(
                          controller: controllerStop,
                        )),
                    ElevatedButton(
                      onPressed: _selectTimeOff,
                      child: const Text('Set time off'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selected time: ${_timeOff.format(context)}',
                    )
                  ],
                ),
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (_isPressedFans == "On") {
                          setState(() {
                            _isPressedFans = "Off";
                          });
                          connection.data.setConfig(
                              'vent', 'on', _fanPowerValue.toString());
                        } else {
                          connection.data.setConfig(
                              'vent', 'off', _fanPowerValue.toString());
                          setState(() {
                            _isPressedFans = "On";
                          });
                        }
                      },
                      child: Text(
                        _isPressedFans,
                        style: const TextStyle(fontSize: 52),
                      )),
                ]),
            Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Power",
                        style: TextStyle(fontSize: 20, height: 1),
                      ),
                      SizedBox(
                          height: 100,
                          width: 75,
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: NumberPicker(
                                value: _fanPowerValue,
                                minValue: 0,
                                maxValue: 100,
                                onChanged: (value) =>
                                    setState(() => _fanPowerValue = value),
                              ))),
                      const Text(
                        "%",
                        style: TextStyle(fontSize: 20, height: 1),
                      ),
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
                  SizedBox(
                      height: 100,
                      width: 75,
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
                  SizedBox(
                      height: 100,
                      width: 75,
                      child: FittedBox(
                          fit: BoxFit.contain,
                          child: NumberPicker(
                            value: _temperatureValue,
                            minValue: 0,
                            maxValue: 100,
                            onChanged: (value) =>
                                setState(() => _temperatureValue = value),
                          ))),
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
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "FANS",
                                    style: TextStyle(fontSize: 30, height: 3),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        if (_isPressedFans == "On") {
                                          setState(() {
                                            _isPressedFans = "Off";
                                          });

                                          connection.data.setConfig('vent',
                                              'on', _fanPowerValue.toString());
                                        } else {
                                          connection.data.setConfig('vent',
                                              'off', _fanPowerValue.toString());
                                          setState(() {
                                            _isPressedFans = "On";
                                          });
                                        }
                                      },
                                      child: Text(
                                        _isPressedFans,
                                        style: const TextStyle(fontSize: 52),
                                      ))
                                ]),
                            SizedBox(width: 40),
                            const Text(
                              "Power",
                              style: TextStyle(fontSize: 30, height: 1),
                            ),
                            SizedBox(
                                height: 150,
                                width: 100,
                                child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: NumberPicker(
                                      value: _fanPowerValue,
                                      minValue: 0,
                                      maxValue: 100,
                                      onChanged: (value) => setState(
                                          () => _fanPowerValue = value),
                                    ))),
                            const Text(
                              "%",
                              style: TextStyle(fontSize: 30, height: 1),
                            ),
                          ])
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 100),
                        const Text(
                          "Humidity",
                          style: TextStyle(fontSize: 30, height: 1),
                        ),
                        SizedBox(
                            height: 150,
                            width: 100,
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
                          style: TextStyle(fontSize: 30, height: 1),
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 60),
                        const Text(
                          "Temperature",
                          style: TextStyle(fontSize: 30, height: 1),
                        ),
                        SizedBox(
                            height: 150,
                            width: 100,
                            child: FittedBox(
                                fit: BoxFit.contain,
                                child: NumberPicker(
                                  value: _temperatureValue,
                                  minValue: 0,
                                  maxValue: 100,
                                  onChanged: (value) =>
                                      setState(() => _temperatureValue = value),
                                ))),
                        const Text(
                          "°C",
                          style: TextStyle(fontSize: 30, height: 1),
                        )
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
                        ElevatedButton(
                            onPressed: () {
                              if (_isPressedLights == "On") {
                                setState(() {
                                  _isPressedLights = "Off";
                                });
                                connection.data.setConfig("led", "on", "");
                              } else {
                                connection.data.setConfig("led", "off", "");
                                setState(() {
                                  _isPressedLights = "On";
                                });
                              }
                            },
                            child: Text(
                              _isPressedLights,
                              style: const TextStyle(fontSize: 52),
                            )),
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          SizedBox(
                              width: 100,
                              child: TextField(
                                controller: controllerStart,
                              )),
                          ElevatedButton(
                            onPressed: _selectTimeOn,
                            child: const Text('Set time on'),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Selected time: ${_timeOn.format(context)}',
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
                              width: 100,
                              child: TextField(
                                controller: controllerStop,
                              )),
                          ElevatedButton(
                            onPressed: _selectTimeOff,
                            child: const Text('Set time off'),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Selected time: ${_timeOff.format(context)}',
                          )
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
