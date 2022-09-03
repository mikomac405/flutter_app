// ignore_for_file: unnecessary_new

import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:inzynierka/globals.dart';
import 'package:vk/vk.dart';
import 'package:network_info_plus/network_info_plus.dart';

class WifiForm extends StatefulWidget {
  const WifiForm({Key? key}) : super(key: key);

  @override
  State<WifiForm> createState() => _WifiFormState();
}

class _WifiFormState extends State<WifiForm> {
  String ssid = "";
  String pass = "";
  List<String> ssids = ["Empty"];
  late TextEditingController _controllerText;

  void getWifisList() async {
    List<String> tempList = await connection.getWifiList();
    setState(() {
      if (tempList.isNotEmpty) {
        ssids = tempList;
      } else {
        ssids = ["Smth", "gone", "wrong"];
      }
      print(ssids);
    });
  }

  void getWifiName() async {
    var wifiName = await NetworkInfo().getWifiName();
    setState(() {
      ssid = wifiName as String;
    });
  }

  final _fk = GlobalKey<FormState>();

  @override
  void initState() {
    _controllerText = TextEditingController();
    super.initState();
    if (Platform.isAndroid) {
      getWifiName();
    } else if (Platform.isLinux) {
      getWifisList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _fk,
      child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Platform.isAndroid
                  ? TextFormField(
                      controller: _controllerText,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.wifi),
                        hintText: 'Enter your SSID',
                        labelText: 'SSID',
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Please enter your SSID";
                        }
                        ssid = "0;0;" + val;
                        return null;
                      },
                    )
                  : DropdownButton(
                      value: ssids.first,
                      items:
                          ssids.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        ssid = value!;
                      }),
              TextFormField(
                controller: _controllerText,
                decoration: const InputDecoration(
                  icon: Icon(Icons.tag),
                  hintText: 'Enter a password',
                  labelText: 'Password',
                ),
                onChanged: (val) {
                  _controllerText.selection = new TextSelection.fromPosition(
                      new TextPosition(offset: val.length));
                },
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Please enter your password";
                  }
                  pass = "0;1;" + val;
                  return null;
                },
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_fk.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Sending data to EPS... Waiting for server response')),
                      );

                      if (Platform.isLinux) {
                        connection.connectToWifi(ssid, pass);
                      } else if (Platform.isAndroid) {
                        var services = androidDevice.discoverServices();
                        services.then((value) => {
                              for (var el in value) {print(el)}
                            });
                      }
                      // TODO: Add logic for Android
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
              Expanded(
                child: Platform.isLinux
                    ? Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: VirtualKeyboard(
                          type: VirtualKeyboardType.Alphanumeric,
                          textController: _controllerText,
                        ),
                      )
                    : Container(),
              )
            ],
          )),
    );
  }
}
