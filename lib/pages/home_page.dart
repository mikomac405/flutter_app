import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inzynierka/connection.dart';
import 'package:inzynierka/pages/wifi_connection_page.dart';
import 'loading_page.dart';
import 'esp_connection_page.dart';
import '../globals.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConnectionStatus connectionStatus = ConnectionStatus.none;

  final bool _isDeveloperMode = const bool.hasEnvironment("DEV")
      ? const bool.fromEnvironment("DEV")
      : false;

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
                title: const Text("Farm Stats"),
              ),
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("LIGHTS",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 0,
                                fontSize: 20))
                      ],
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Currently "),
                          if (farm.leds.state == 0) ...[
                            const Text("On"),
                          ] else ...[
                            const Text("Off"),
                          ],
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Turning on at ${farm.leds.lightsOn}"),
                          const SizedBox(width: 10),
                          Text("Turning off at ${farm.leds.lightsOff}")
                        ]),
                    //const Text("BOARD"),
                    //Text("Name: ${farm.board.name}\n"),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("WATER LEVEL",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        height: 0,
                                        fontSize: 20)),
                                const SizedBox(height: 5),
                                if (farm.waterLvl.state == 0) ...[
                                  const Text("Doesn't requier filling up"),
                                ] else ...[
                                  const Text("Requiers filling up"),
                                ],
                              ]),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("AERATION",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        height: 0,
                                        fontSize: 20)),
                                Row(
                                  children: [
                                    const Text("Currently "),
                                    if (farm.leds.state == 0) ...[
                                      const Text("On"),
                                    ] else ...[
                                      const Text("Off"),
                                    ],
                                  ],
                                )
                              ]),
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Current",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 0,
                                fontSize: 15))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text("Humidity: ${farm.dht11.humidity}%"),
                        const SizedBox(width: 10),
                        Text("Temperature: ${farm.dht11.temperature}°C")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 20),
                        Text("Level at which fans start propelling",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 0,
                                fontSize: 15))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Humidity: ${farm.fan.maxHumidity}%"),
                        const SizedBox(width: 10),
                        Text("Temperature: ${farm.fan.maxTemp}°C")
                      ],
                    ),
                  ]));
          // body: Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: <Widget>[
          //       ElevatedButton(
          //           child: const Text(
          //             "Lights",
          //             style: TextStyle(fontSize: 72),
          //           ),
          //           onPressed: () =>
          //               Navigator.of(context).pushNamed('/lightspage')),
          //       ElevatedButton(
          //           child: const Text(
          //             "Fans",
          //             style: TextStyle(fontSize: 72),
          //           ),
          //           onPressed: () =>
          //               Navigator.of(context).pushNamed('/fanspage')),
          //       const ElevatedButton(
          //         child: Text(
          //           "Photos",
          //           style: TextStyle(fontSize: 72),
          //         ),
          //         onPressed: null,
          //       ),
          //       if (_isDeveloperMode) ...[
          //         ElevatedButton(
          //             onPressed: () =>
          //                 Navigator.of(context).pushNamed('/debugpage'),
          //             child: const Text(
          //               "Debug",
          //               style: TextStyle(fontSize: 72),
          //             ))
          //       ],
          //     ],
          //   ),
          // ));
        } else {
          return Column(children: const [Text("Something gone wrong!")]);
        }
    }
  }
}
  
  /*
  isLoading
      ? const LoadingPage()
      : isBluetooth
          ? const WifiAuthForm() // Bluetooth devices selection -> WifiAuthForm()
          : Scaffold(
              appBar: AppBar(
                title: _isDeveloperMode
                    ? const Text("App_dev")
                    : const Text("App"),
              ),
              body: 
              
              
}
*/