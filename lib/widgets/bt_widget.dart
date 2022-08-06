import 'package:flutter/material.dart';

Column btWidget(context, names, ssids, refresh) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
            child: ListView.builder(
                itemCount: names.length,
                itemBuilder: (context, index) {
                  final name = names[index];
                  final ssid = ssids[index];
                  return Card(
                      child: ListTile(
                    title: Text(name),
                    subtitle: Text(ssid),
                    leading: const Icon(Icons.bluetooth),
                  ));
                })),
        ElevatedButton(
            onPressed: refresh, child: const Text("Scan for devices")),
        const Padding(padding: EdgeInsets.only(bottom: 20.0))
      ],
    );
