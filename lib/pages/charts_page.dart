import 'package:flutter/material.dart';
import 'package:inzynierka/globals.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
          const Text('someday, there will be a chart')
        ])));
  }
}
