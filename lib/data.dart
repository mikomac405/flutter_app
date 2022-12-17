import 'package:flutter/material.dart';

class ChartData with ChangeNotifier {
  List<dynamic> apiData = [];

  ChartData();

  void updateData(List<dynamic> data) {
    apiData = data;
    notifyListeners();
  }

  void clearData() {
    apiData.clear();
    notifyListeners();
  }
}
