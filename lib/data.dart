import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartData with ChangeNotifier {
  List<dynamic> apiData = [];
  List<FlSpot> tempSpots = [];
  List<FlSpot> humSpots = [];
  ChartData();

  void updateData(List<dynamic> data) {
    apiData = data;
    for (int i = 0; i < apiData.length; i++) {
      tempSpots.add(FlSpot(i.toDouble(), apiData[i]["temperature"].toDouble()));
      humSpots.add(FlSpot(i.toDouble(), apiData[i]["humidity"].toDouble()));
    }
    notifyListeners();
  }

  void clearData() {
    apiData.clear();
    tempSpots.clear();
    humSpots.clear();
    notifyListeners();
  }
}
