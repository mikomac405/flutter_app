import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inzynierka/pages/debug_page.dart';
import 'package:inzynierka/pages/mqtt_test_page.dart';
import 'connection.dart';
import 'pages/fans_page.dart';
import 'pages/lights_page.dart';
import 'pages/home_page.dart';
import 'globals.dart';

void main() {
  connection = ConnectionManager();
  Timer.periodic(const Duration(seconds: 20), (timer) {
    connection.checkConnectionStatus();
  });

  Timer.periodic(const Duration(seconds: 5), (timer) {
    var status = connection.getComponentsStatus();
    status.then((value) => farm.update(jsonDecode(value)));
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
        primarySwatch: Colors.teal,

        //height: 5, fontWeight: FontWeight.bold
      ),
      home: const HomePage(title: 'Flutter Home Page'),
      routes: <String, WidgetBuilder>{
        '/lightspage': (BuildContext context) =>
            const LightsPage(title: "LightsPage"),
        '/fanspage': (BuildContext context) =>
            const FansPage(title: "FansPage"),
        '/mqtttestpage': (BuildContext context) =>
            const MqttTestPage(title: "MqttPage"),
        '/debugpage': (BuildContext context) =>
            const DebugPage(title: "DebugPage")
      },
    );
  }
}
