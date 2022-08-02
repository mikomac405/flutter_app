import 'package:flutter/material.dart';

// Create a Form widget.
class WifiAuthForm extends StatefulWidget {
  const WifiAuthForm({super.key});

  @override
  WifiAuthFormState createState() {
    return WifiAuthFormState();
  }
}

class WifiAuthFormState extends State<WifiAuthForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("WiFi form"),
        ),
        body: Form(
            key: _formKey,
            child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.wifi),
                        hintText: 'Enter your SSID',
                        labelText: 'SSID',
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Please enter your SSID";
                        }
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
                        return null;
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ))));
  }
}
