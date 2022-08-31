import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:inzynierka/globals.dart';
import 'package:vk/vk.dart';

TextEditingController _controllerText = TextEditingController();

Widget wifiForm(BuildContext context, _formKey) {
  String ssid = "";
  String pass = "";
  return Form(
    key: _formKey,
    child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
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
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.tag),
                hintText: 'Enter a password',
                labelText: 'Password',
              ),
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
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Sending data to EPS... Waiting for server response')),
                    );

                    if (Platform.isLinux) {
                      for (var service in linuxDevice.gattServices) {
                        if (service.uuid.toString() ==
                            "3ec15674-a3a8-4522-992b-8e77552e15d1") {
                          for (var char in service.characteristics) {
                            if (char.uuid.toString() ==
                                "3ec15675-a3a8-4522-992b-8e77552e15d1") {
                              await char.writeValue(ssid.runes.toList());
                              await Future.delayed(const Duration(seconds: 2));
                              await char.writeValue(pass.runes.toList());
                              await Future.delayed(const Duration(seconds: 2));
                              await char.writeValue("0;2;".runes.toList());
                            }
                          }
                        }
                      }
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              color: Colors.grey.shade900,
              child: VirtualKeyboard(
                height: 170,
                type: VirtualKeyboardType.Alphanumeric,
                textController: _controllerText,
              ),
            )
          ],
        )),
  );
}
