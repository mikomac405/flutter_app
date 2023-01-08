import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inzynierka/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'connection.dart';
import 'pages/fans_and_lights_page.dart';
import 'pages/charts_page.dart';
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

  Timer.periodic(const Duration(seconds: 60), (timer) {
    connection.checkConnectionStatus();
  });

  Timer.periodic(const Duration(seconds: 20), (timer) {
    var status = connection.data.getComponentsStatus();
    status.then((value) {
      print(value);
      farm.update(jsonDecode(value));
    });
  });

  Timer.periodic(const Duration(seconds: 1000), (timer) async {
    await isLogged();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.black,
          secondary: Colors.black,
        ),
      ),
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
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  ConnectionStatus connectionStatus = ConnectionStatus.none;
  //late final prefs;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    connection.addListener(_connectionChecker);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCredentials();
    });
    //isLogged();
  }

  _getCredentials() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    loginController.text = prefs.getString('login') ?? "";
    passwordController.text = prefs.getString('password') ?? "";
  }

  ///This function is responsible for setting states of app based on
  ///ConnectionType
  void _connectionChecker() {
    setState(() {
      connectionStatus = connection.connectionStatus;
      if (kDebugMode) {
        if (connectionStatus == ConnectionStatus.restApi) {
          var status = connection.data.getComponentsStatus();
          status.then((value) => farm.update(jsonDecode(value)));
        }
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
        if (loggedIn == AppLoginStatus.notLoggedIn) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("App"),
            ),
            body: Center(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                children: [
                  const Text("API Credentials:"),
                  TextField(
                      controller: loginController,
                      decoration: const InputDecoration(labelText: "Login"),
                      onTap: () {
                        !kIsWeb ||
                                !(defaultTargetPlatform ==
                                        TargetPlatform.android ||
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
                      obscureText: true,
                      decoration: const InputDecoration(labelText: "Password"),
                      onTap: () {
                        !kIsWeb ||
                                !(defaultTargetPlatform ==
                                        TargetPlatform.android ||
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
                                              type: VirtualKeyboardType
                                                  .Alphanumeric,
                                              textController:
                                                  passwordController)
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
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Empty password"),
                          ));
                          break;
                        case LoginStatus.noUsername:
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Empty username"),
                          ));
                          break;
                        case LoginStatus.wrongPassword:
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Wrong password"),
                          ));
                          break;
                        case LoginStatus.wrongUsername:
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Wrong username"),
                          ));
                          break;
                        default:
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Login successful"),
                          ));
                          loggedIn = AppLoginStatus.loggedIn;
                          setState(() {});
                        //await isLogged();
                      }
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          );
        } else if (loggedIn == AppLoginStatus.loggingIn) {
          return const LoadingPage();
        }
        if (connectionStatus == ConnectionStatus.restApi &&
            loggedIn == AppLoginStatus.loggedIn) {
          return Scaffold(
            appBar: AppBar(
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  const Text("Hydro"),
                  SizedBox(width: 10),
                  Image.asset(
                    "assets/images/farmIcon.png",
                    scale: 5,
                  ),
                  SizedBox(width: 50)
                ])),
            body: PageView(
              controller: _controller,
              children: const [
                FansAndLightsPage(title: "Fans"),
                HomePage(title: "Home"),
                ChartsPage(title: "Lights"),
              ],
            ),
            // drawer: Drawer(
            //   //width: !kIsWeb ? MediaQuery.of(context).size.width * 0.8 : 800,
            //     child: Container(
            //       margin: const EdgeInsets.all(10),
            //       child: const Text("Be soon"),
            //   ),
            // )
          );
        } else {
          return Column(children: const [Text("Something gone wrong!")]);
        }
    }
  }
}
