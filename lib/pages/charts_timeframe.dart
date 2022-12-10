import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:inzynierka/connection.dart';
import 'package:inzynierka/globals.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vk/vk.dart';

class ChartsTimeframe extends StatefulWidget {
  const ChartsTimeframe({Key? key}) : super(key: key);

  @override
  State<ChartsTimeframe> createState() => _ChartsTimeframeState();
}

class _ChartsTimeframeState extends State<ChartsTimeframe> {
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 150, horizontal: 300),
          children: <Widget>[
            const Text("Please provide timeframe for chart:"),
            const SizedBox(height: 15),
            const Text("End date"),
            const SizedBox(height: 5),
            TextField(
                controller: startDateController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    hintText: 'Ex. 05-09-2022'),
                onTap: () {
                  !kIsWeb || !(Platform.isAndroid || Platform.isIOS)
                      ? showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: const Text("Start Date Dialog"),
                                content: SingleChildScrollView(
                                  child: ListBody(children: [
                                    TextField(
                                      controller: startDateController,
                                      decoration: new InputDecoration.collapsed(
                                          hintText: 'Ex. 05-09-2022'),
                                    ),
                                    VirtualKeyboard(
                                        type: VirtualKeyboardType.Alphanumeric,
                                        textController: startDateController)
                                  ]),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Ok"))
                                ],
                              ))
                      : Null;
                }),
            const SizedBox(height: 15),
            const Text("End date"),
            const SizedBox(height: 5),
            TextField(
                controller: endDateController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    hintText: 'Ex. 05-10-2022'),
                onTap: () {
                  !kIsWeb || !(Platform.isAndroid || Platform.isIOS)
                      ? showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: const Text("End Date Dialog"),
                                content: SingleChildScrollView(
                                  child: ListBody(children: [
                                    TextField(
                                      controller: endDateController,
                                      decoration: const InputDecoration(
                                          labelText: "End data"),
                                    ),
                                    VirtualKeyboard(
                                        type: VirtualKeyboardType.Alphanumeric,
                                        textController: endDateController)
                                  ]),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Ok"))
                                ],
                              ))
                      : Null;
                }),
            const Divider(),
            ElevatedButton(
              onPressed: () {
                startDate = startDateController.text
                    .replaceAll("\n", "")
                    .replaceAll(" ", "");

                endDate = endDateController.text
                    .replaceAll("\n", "")
                    .replaceAll(" ", "");
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
