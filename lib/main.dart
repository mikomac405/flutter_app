import 'package:flutter/material.dart';
import 'package:inzynierka/pages/mqtt_test_page.dart';
import 'pages/fans_page.dart';
import 'pages/lights_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: <String, WidgetBuilder>{
        '/lightspage': (BuildContext context) =>
            new LightsPage(title: "LightsPage"),
        '/fanspage': (BuildContext context) => new FansPage(title: "FansPage"),
        '/mqtttestpage': (BuildContext context) =>
            new MqttTestPage(title: "MqttPage")
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final bool _isDeveloperMode = const bool.hasEnvironment("DEV")
      ? const bool.fromEnvironment("DEV")
      : false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isDeveloperMode ? Text("App_dev") : Text("App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
                child: Text(
                  "Lights",
                  style: TextStyle(fontSize: 72),
                ),
                onPressed: () =>
                    Navigator.of(context).pushNamed('/lightspage')),
            ElevatedButton(
                child: Text(
                  "Fans",
                  style: TextStyle(fontSize: 72),
                ),
                onPressed: () => Navigator.of(context).pushNamed('/fanspage')),
            const ElevatedButton(
              child: Text(
                "Photos",
                style: TextStyle(fontSize: 72),
              ),
              onPressed: null,
            ),
            if (_isDeveloperMode) ...[
              ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/mqtttestpage'),
                  child: Text(
                    "MQTT Test",
                    style: TextStyle(fontSize: 72),
                  ))
            ]
          ],
        ),
      ),
    );
  }
}
