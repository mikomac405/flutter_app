import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inzynierka/pages/mqtt_test_page.dart';
import 'connection.dart';
import 'pages/fans_page.dart';
import 'pages/lights_page.dart';
import 'pages/home_page.dart';
import 'globals.dart' as globals;

void main() {
  globals.connection = ConnectionManager();
  Timer.periodic(const Duration(minutes: 1), (timer) {
    globals.connection.checkConnectionType();
  });

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
      home: const HomePage(title: 'Flutter Home Page'),
      routes: <String, WidgetBuilder>{
        '/lightspage': (BuildContext context) =>
            const LightsPage(title: "LightsPage"),
        '/fanspage': (BuildContext context) =>
            const FansPage(title: "FansPage"),
        '/mqtttestpage': (BuildContext context) =>
            const MqttTestPage(title: "MqttPage")
      },
    );
  }
}
