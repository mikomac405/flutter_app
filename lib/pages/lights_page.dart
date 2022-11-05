import 'package:flutter/material.dart';
import 'package:inzynierka/globals.dart';

class LightsPage extends StatefulWidget {
  const LightsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LightsPage> createState() => _LightsPageState();
}

class _LightsPageState extends State<LightsPage> {
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
                    onPressed: () => connection.data.setConfig("led", "on", ""),
                    child: const Text(
                      'On',
                      style: TextStyle(fontSize: 72),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => connection.data.setConfig("led", "off", ""),
                    child: const Text(
                      'Off',
                      style: TextStyle(fontSize: 72),
                    ),
                  )
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
            )
          ],
        ),
      ),
    );
  }
}
