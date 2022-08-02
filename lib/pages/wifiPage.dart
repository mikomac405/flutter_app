import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../globals.dart' as globals;
import '../connection.dart';

class WifiPage extends StatefulWidget {
  const WifiPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<WifiPage> createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App"),
      ),
      body: Center(
        child: LoadingAnimationWidget.fourRotatingDots(
          color: Colors.red,
          size: 200,
        ),
      ),
    );
  }
}
