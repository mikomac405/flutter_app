import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inzynierka/globals.dart';

Future<dynamic> getDailyData(String startDate, String endDate) async {
  var url = Uri.parse("${connection.baseUrl}/data/by_date");
  var jsonBodyEncoded = json.encode({"start":startDate, "end":endDate});
    
  var response = await http.post(
      url,
      headers: {"Content-Type": "application/json", "Authorization" : "Bearer $token"},
      body: jsonBodyEncoded
      );
  return jsonDecode(response.body);
}

Future<dynamic> getHourlyData(String startDateTime, String endDateTime) async {
  var url = Uri.parse("${connection.baseUrl}/data/by_datetime");
  var jsonBodyEncoded = json.encode({"start":startDateTime, "end":endDateTime});
    
  var response = await http.post(
      url,
      headers: {"Content-Type": "application/json", "Authorization" : "Bearer $token"},
      body: jsonBodyEncoded
      );
  
  return jsonDecode(response.body);
}