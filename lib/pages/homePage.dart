import 'package:flutter/material.dart';
import 'package:inzynierka/connection.dart';
import 'loadingPage.dart';
import '../globals.dart' as globals;

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  String connectionType = "None";

  final bool _isDeveloperMode = const bool.hasEnvironment("DEV")
      ? const bool.fromEnvironment("DEV")
      : false;

  @override
  void initState() {
    super.initState();
    globals.connection.addListener(_connectionChecker);
  }

  void _connectionChecker() {
    switch (globals.connection.connectionType) {
      case ConnectionType.none:
        setState(() => isLoading = true);
        break;
      case ConnectionType.restApi:
        setState(() => isLoading = false);
        setState(() => connectionType = "RestAPI");
        break;
      case ConnectionType.bluetooth:
        setState(() => isLoading = false);
        setState(() => connectionType = "Bluetooth");
        break;
      default:
        setState(() => isLoading = true);
    }
  }

  @override
  Widget build(BuildContext context) => isLoading
      ? const LoadingPage()
      : Scaffold(
          appBar: AppBar(
            title: _isDeveloperMode ? const Text("App_dev") : const Text("App"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                    child: const Text(
                      "Print conn type",
                      style: TextStyle(fontSize: 72),
                    ),
                    onPressed: () =>
                        // ignore: avoid_print
                        print(globals.connection.connectionType)),
                ElevatedButton(
                    child: const Text(
                      "Lights",
                      style: TextStyle(fontSize: 72),
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/lightspage')),
                ElevatedButton(
                    child: const Text(
                      "Fans",
                      style: TextStyle(fontSize: 72),
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/fanspage')),
                const ElevatedButton(
                  child: Text(
                    "Photos",
                    style: TextStyle(fontSize: 72),
                  ),
                  onPressed: null,
                ),
                if (_isDeveloperMode) ...[
                  ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/mqtttestpage'),
                      child: const Text(
                        "MQTT Test",
                        style: TextStyle(fontSize: 72),
                      ))
                ],
                Text(connectionType)
              ],
            ),
          ),
        );
}