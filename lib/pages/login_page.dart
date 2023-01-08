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

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      appBar: AppBar(
        title: const Text("App"),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          children: [
            const Text("API Credentials:"),
            TextField(
                controller: loginController,
                decoration: const InputDecoration(labelText: "Login"),
                onTap: () {
                  !kIsWeb ||
                          !(defaultTargetPlatform == TargetPlatform.android ||
                              defaultTargetPlatform == TargetPlatform.iOS)
                      ? showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: const Text("Login Dialog"),
                                content: SingleChildScrollView(
                                  child: ListBody(children: [
                                    TextField(
                                      controller: loginController,
                                      decoration: const InputDecoration(
                                          labelText: "Login"),
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
            TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
                onTap: () {
                  !kIsWeb ||
                          !(defaultTargetPlatform == TargetPlatform.android ||
                              defaultTargetPlatform == TargetPlatform.iOS)
                      ? showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: const Text("Password Dialog"),
                                content: SingleChildScrollView(
                                  child: ListBody(children: [
                                    TextField(
                                      controller: passwordController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                          labelText: "Password"),
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
                      content: Text("Empty password"),
                    ));
                    break;
                  case LoginStatus.noUsername:
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Empty username"),
                    ));
                    break;
                  case LoginStatus.wrongPassword:
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Wrong password"),
                    ));
                    break;
                  case LoginStatus.wrongUsername:
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Wrong username"),
                    ));
                    break;
                  default:
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Login successful"),
                    ));
                    loggedIn = AppLoginStatus.loggedIn;
                  //await isLogged();
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
