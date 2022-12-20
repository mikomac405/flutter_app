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

  Timer.periodic(const Duration(seconds: 10), (timer) {
    connection.checkConnectionStatus();
  });

  Timer.periodic(const Duration(seconds: 30), (timer) {
    var status = connection.data.getComponentsStatus();
    status.then((value) => farm.update(jsonDecode(value)));
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
    isLogged();
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
        if (loggedIn == AppLoginStatus.notLoggedIn) {
          return const LoginPage();
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
