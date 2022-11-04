import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inzynierka/data_mng.dart';
import 'connection.dart';
import 'pages/fans_page.dart';
import 'pages/lights_page.dart';
import 'pages/home_page.dart';
import 'globals.dart';
import 'package:vk/vk.dart';
import 'package:flutter/foundation.dart';
import 'package:inzynierka/connection.dart';
import 'package:inzynierka/pages/wifi_connection_page.dart';
import 'package:inzynierka/pages/loading_page.dart';
import 'package:inzynierka/pages/esp_connection_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
              //width: !kIsWeb ? MediaQuery.of(context).size.width * 0.8 : 800,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: ListView(
                  children: [
                    const Text("API Credentials:"),
                    TextField(
                        controller: loginController,
                        decoration: const InputDecoration(labelText: "Login"),
                        onTap: () {
                          kIsWeb || !(Platform.isAndroid || Platform.isIOS) ?
                          showDialog(
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
                                            type: VirtualKeyboardType
                                                .Alphanumeric,
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
                      decoration: const InputDecoration(labelText: "Password"),
                      onTap: () {
                          kIsWeb || !(Platform.isAndroid || Platform.isIOS) ?
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: const Text("Password Dialog"),
                                    content: SingleChildScrollView(
                                      child: ListBody(children: [
                                        TextField(
                                          controller: passwordController,
                                          decoration: const InputDecoration(
                                              labelText: "Password"),
                                        ),
                                        VirtualKeyboard(
                                            type: VirtualKeyboardType
                                                .Alphanumeric,
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
                        }
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
                    const Divider(),
                    ElevatedButton(
                      onPressed: () async {
                        var responseToken = await connection.getToken();
                        switch (responseToken) {
                          case "Username incorrect":
                            {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Username incorrect"),
                              ));
                              break;
                            }
                          case "Password incorrect":
                            {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Password incorrect"),
                              ));
                              break;
                            }
                          default:
                            {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Got token!"),
                              ));
                              token = responseToken;
                              break;
                            }
                        }
                      },
                      child: const Text('Get token'),
                    ),
                    const Divider(),
                    ElevatedButton(
                      onPressed: () async {
                        var resp = await connection.testToken();

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(resp),
                        ));
                      },
                      child: const Text('Test token'),
                    ),
                    const Divider(),
                    ElevatedButton(
                      onPressed: () async {
                        var data = await getDailyData("2020-10-15", "2020-10-18");
                        for(var el in data){
                          print(el);
                        }
                        var data2 = await getHourlyData("2020-10-15 10:00:00", "2020-10-16 15:00:00");
                        for(var el in data2){
                          print(el);
                        }
                      },
                      child: const Text('Test data by day'),
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
