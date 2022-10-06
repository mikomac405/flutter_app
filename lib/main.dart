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

class PageViewDemo extends StatefulWidget {
  @override
  _PageViewDemoState createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {
  PageController _controller = PageController(
    initialPage: 1,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        FansPage(title: "Fans"),
        HomePage(title: "Home"),
        LightsPage(title: "Lights"),
      ],
    );
  }
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
    );
  }
}
