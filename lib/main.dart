import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
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
  const PageViewDemo({Key? key}) : super(key: key);

  @override
  _PageViewDemoState createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {
  final PageController _controller = PageController(
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
      children: const [
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          child: PageViewDemo(),
        ),
      ),
    );
  }
}
