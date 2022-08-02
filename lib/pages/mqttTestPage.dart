import 'package:flutter/material.dart';

class MqttTestPage extends StatefulWidget {
  const MqttTestPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MqttTestPage> createState() => _MqttTestPageState();
}

class _MqttTestPageState extends State<MqttTestPage> {
  final GlobalKey<FormState> _mqttRequestForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT test page'),
      ),
      body: Center(
          child: Form(
        key: _mqttRequestForm,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 350,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Routing key',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Routing key can\'t be null/empty!';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              width: 350,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Message',
                ),
                validator: (String? value) {
                  if (value == null) {
                    return 'Message can\'t be null!';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_mqttRequestForm.currentState!.validate()) {
                      // Send data

                    }
                  },
                  child: const Text("Send request"),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
