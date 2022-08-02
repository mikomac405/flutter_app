import 'package:flutter/material.dart';
import 'package:inzynierka/pages/loadingPage.dart';
import 'package:inzynierka/pages/mqttTestPage.dart';
import 'connection.dart';
import 'pages/fansPage.dart';
import 'pages/lightsPage.dart';
import 'pages/homePage.dart';
import 'pages/wifiPage.dart';
import 'globals.dart' as globals;

void main() {
  globals.connection = ConnectionManager();
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
        '/wifipage': (BuildContext context) =>
            const WifiPage(title: "WifiPage"),
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
