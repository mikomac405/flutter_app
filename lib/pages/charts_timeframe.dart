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
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCredentials();
    });
  }

  _getCredentials() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    loginController.text = prefs.getString('login') ?? "";
    passwordController.text = prefs.getString('password') ?? "";
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
                controller: loginController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    hintText: 'Ex. 15-11-2022'),
                onTap: () {
                  !kIsWeb || !(Platform.isAndroid || Platform.isIOS)
                      ? showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: const Text("Start Date Dialog"),
                                content: SingleChildScrollView(
                                  child: ListBody(children: [
                                    TextField(
                                      controller: loginController,
                                      decoration: new InputDecoration.collapsed(
                                          hintText: 'Ex. 15-11-2022'),
                                    ),
                                    VirtualKeyboard(
                                        type: VirtualKeyboardType.Alphanumeric,
                                        textController: loginController)
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
                controller: passwordController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    hintText: 'Ex. 15-12-2022'),
                onTap: () {
                  !kIsWeb || !(Platform.isAndroid || Platform.isIOS)
                      ? showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: const Text("End Date Dialog"),
                                content: SingleChildScrollView(
                                  child: ListBody(children: [
                                    TextField(
                                      controller: passwordController,
                                      decoration: const InputDecoration(
                                          labelText: "End data"),
                                    ),
                                    VirtualKeyboard(
                                        type: VirtualKeyboardType.Alphanumeric,
                                        textController: passwordController)
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
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setString(
                    "login",
                    loginController.text
                        .replaceAll("\n", "")
                        .replaceAll(" ", ""));
                prefs.setString(
                    "password",
                    passwordController.text
                        .replaceAll("\n", "")
                        .replaceAll(" ", ""));
                final result = await connection.data.authUser();
                switch (result) {
                  case LoginStatus.noPassword:
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Empty end date"),
                    ));
                    break;
                  case LoginStatus.noUsername:
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Empty start date"),
                    ));
                    break;
                  case LoginStatus.wrongPassword:
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Wrong end date"),
                    ));
                    break;
                  case LoginStatus.wrongUsername:
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Wrong start date"),
                    ));
                    break;
                  default:
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Correct timeframe"),
                    ));
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
