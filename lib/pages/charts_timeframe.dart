import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:inzynierka/connection.dart';
import 'package:inzynierka/globals.dart';
import 'package:inzynierka/pages/loading_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vk/vk.dart';

class ChartsTimeframe extends StatefulWidget {
  const ChartsTimeframe({Key? key}) : super(key: key);

  @override
  State<ChartsTimeframe> createState() => _ChartsTimeframeState();
}

class _ChartsTimeframeState extends State<ChartsTimeframe> {
  bool downloadingData = false;
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  @override
  void initState() {
    startDateController.text = "";
    endDateController.text = "";
    super.initState();
  }

  void downloadData() async {
    setState(() {
      downloadingData = true;
    });

    if (startDateController.text.isNotEmpty &
        endDateController.text.isNotEmpty) {
      var data = await connection.data
          .getDailyData(startDateController.text, endDateController.text);
      if (data != "Not exisiting data") {
        chartsData.updateData(data);
      }
    }

    if (chartsData.apiData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No data"),
      ));
    }

    setState(() {
      downloadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (downloadingData) {
      return const LoadingPage();
    }
    return PageView(children: [
      ListView(
        padding: const EdgeInsets.symmetric(vertical: 150, horizontal: 300),
        children: <Widget>[
          const Text("Please provide timeframe for chart:"),
          const SizedBox(height: 15),
          const Text("Start date"),
          const SizedBox(height: 5),
          TextField(
              controller: startDateController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(),
                hintText: 'Ex. 05-09-2022',
              ),
              readOnly: true,
              onTap: () async {
                DateTime firstDate = DateTime(2000);
                DateTime lastDate = DateTime.now();

                if (DateTime.tryParse(endDateController.text) != null) {
                  lastDate = DateTime.parse(endDateController.text);
                  firstDate = lastDate.subtract(const Duration(days: 14));
                }

                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: lastDate,
                  firstDate: firstDate,
                  lastDate: lastDate,
                );

                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    startDateController.text = formattedDate;
                  });
                } else {
                  setState(() {
                    startDateController.text = "";
                  });
                }
              }),
          const SizedBox(height: 15),
          const Text("End date"),
          const SizedBox(height: 5),
          TextField(
              controller: endDateController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(),
                hintText: 'Ex. 05-10-2022',
              ),
              readOnly: true,
              onTap: () async {
                DateTime firstDate = DateTime(2000);
                DateTime lastDate = DateTime.now();

                if (DateTime.tryParse(startDateController.text) != null) {
                  firstDate = DateTime.parse(startDateController.text);

                  if (firstDate
                      .add(const Duration(days: 14))
                      .isBefore(DateTime.now())) {
                    lastDate = firstDate.add(const Duration(days: 14));
                  }
                }

                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: lastDate,
                  firstDate: firstDate,
                  lastDate: lastDate,
                );

                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    endDateController.text = formattedDate;
                  });
                } else {
                  setState(() {
                    endDateController.text = "";
                  });
                }
              }),
          const Divider(),
          ElevatedButton(
            onPressed: () async {
              downloadData();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    ]);
  }
}
