import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'connection.dart';
import 'pages/fans_page.dart';
import 'pages/lights_page.dart';
import 'pages/home_page.dart';
import 'globals.dart';

import 'package:flutter/foundation.dart';
import 'package:inzynierka/connection.dart';
import 'package:inzynierka/pages/wifi_connection_page.dart';
import 'package:inzynierka/pages/loading_page.dart';
import 'package:inzynierka/pages/esp_connection_page.dart';
import '../globals.dart';

void main() {
  connection = ConnectionManager();
  Timer.periodic(const Duration(seconds: 20), (timer) {
    connection.checkConnectionStatus();
  });

  Timer.periodic(const Duration(seconds: 60), (timer) {
    var status = connection.getComponentsStatus();
    status.then((value) => farm.update(jsonDecode(value)));
  });

  runApp(const MyApp());
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
          child: AppController(),
        ),
      ),
    );
  }
}

class AppController extends StatefulWidget {
  const AppController({Key? key}) : super(key: key);

  @override
  _AppControllerState createState() => _AppControllerState();
}

class _AppControllerState extends State<AppController> {
  final PageController _controller = PageController(
    initialPage: 1,
  );

  ConnectionStatus connectionStatus = ConnectionStatus.none;

  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    connection.addListener(_connectionChecker);
  }

  ///This function is responsible for setting states of app based on
  ///ConnectionType
  void _connectionChecker() {
    setState(() {
      connectionStatus = connection.connectionStatus;
      if (kDebugMode) {
        print(connectionStatus);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (connectionStatus) {
      case ConnectionStatus.none:
        return const LoadingPage();
      case ConnectionStatus.internet:
        return const LoadingPage();
      case ConnectionStatus.noInternet:
        return const WifiConnectionPage();
      case ConnectionStatus.noRestApi:
        //  return const WifiConnectionPage();
        return Scaffold(
            appBar: AppBar(title: const Text("No api")),
            body: Column(children: const [Text("Turn on API")]));
      case ConnectionStatus.noEsp:
        return const EspConnectionPage();
      default:
        if (connectionStatus == ConnectionStatus.restApi) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Hydro"),
            ),
            body: PageView(
              controller: _controller,
              children: const [
                FansPage(title: "Fans"),
                HomePage(title: "Home"),
                LightsPage(title: "Lights"),
              ],
            ),
            drawer: Drawer(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: ListView(
                  children: [
                    const Text("API Credentials:"),
                    TextField(
                      controller: loginController,
                      decoration: const InputDecoration(labelText: "Login"),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: "Password"),
                    ),
                    // Container(
                    //   margin: const EdgeInsets.all(5),
                    // ),
                    const Divider(),
                    ElevatedButton(
                      onPressed: () {
                        login = loginController.text;
                        password = passwordController.text;
                      },
                      child: const Text('Save credentials'),
                    ),
                    const Divider(),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Login: " + login + "\nPassword: " + password),
                        ));
                      },
                      child: const Text('Print credentials'),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Column(children: const [Text("Something gone wrong!")]);
        }
    }
  }
}
