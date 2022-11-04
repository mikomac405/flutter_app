import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inzynierka/globals.dart';

class DailyDataRecord{
  late String date;
  late int temperature;
  late int humidity;

  DailyDataRecord(record){
    date = record["date"];
    temperature = record["temperature"];
    humidity = record["humidity"];
  }
}
class HourlyDataRecord{
  late String date;
	late int lights;
	late int fans;
	late int oxygenatror;
	late int temperature;
	late int humidity;

  HourlyDataRecord(record){
    date = record["date"];
    lights = record["lights"];
    fans = record["fans"];
    oxygenatror = record["oxygenatror"];
    temperature = record["temperature"];
    humidity = record["humidity"];
  }
}

class DailyDataSet{
  List<DailyDataRecord> data = [];
  String error = "";

  DailyDataSet(String startDate, String endDate) {
    var url = Uri.parse("http://srv08.mikr.us:20364/data/by_date");
    var jsonBodyEncoded = json.encode({"start":startDate, "end":endDate});
    http.post(
      url,
      headers: {"Content-Type": "application/json", "Authorization" : "Bearer $token"},
      body: jsonBodyEncoded
      ).then((value) {
        var body = jsonDecode(value.body);
        if(body != "Min 2 days" && body != "Max 100 days"){
          for(var el in jsonDecode(value.body)){
            data.add(el);
          }
        } else {
          error = body;
        }
      });
  }
}

class HourlyDataSet{
  List<HourlyDataSet> data = [];
}