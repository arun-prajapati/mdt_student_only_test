import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Constants/global.dart';
import '../enums/Api_status.dart';

class CalendarService {
  late Map data;
  late Map userData;
  Status _status = Status.NoThing;
  Status get status => _status;

  //Get count on each date of calender
  Future<List> getCalenderBookingCount(String startDate, String endDate) async {
    try {
      final url = Uri.parse("$api/api/calender-booking-count?from=" +
          startDate +
          "&to=" +
          endDate);
      SharedPreferences storage = await SharedPreferences.getInstance();
      String token = storage.getString('token').toString();
      Map<String, String> header = {
        'token': token,
      };
      final response = await http.get(url, headers: header);
      data = json.decode(response.body);
      if (data['success'] == true) {
        List list_ = data["message"];
        return list_;
      } else {
        List blankArray = [];
        return blankArray;
      }
    } catch (e) {
      print("ERROR.......$e");
      List blankArray = [];
      return blankArray;
    }
  }

  //Get events list on date of calender
  Future<Map?> getDayEvents(String startDate, int page) async {
    try {
      final url = Uri.parse("$api/api/calender-date?date=" +
          startDate +
          "&page=" +
          page.toString());
      SharedPreferences storage = await SharedPreferences.getInstance();
      String token = storage.getString('token').toString();
      Map<String, String> header = {
        'token': token,
      };
      final response = await http.get(url, headers: header);
      data = json.decode(response.body);
      if (data['success'] == true) {
        Map data_ = data["message"];
        return data_;
      } else {
        return null;
      }
    } catch (e) {
      print("ERROR.......$e");
      return null;
    }
  }

  Future<Map?> saveCalenderDate(Map formData) async {
    try {
      final url = Uri.parse("$api/api/update/calender");
      SharedPreferences storage = await SharedPreferences.getInstance();
      String token = storage.getString('token').toString();
      Map<String, String> header = {
        'token': token,
      };
      print("Printing form data.....$formData");
      final response = await http.post(url, headers: header, body: formData);
      print("Re-Scheduling....");
      print(response.body);
      data = jsonDecode(response.body);
      return data;
    } catch (e) {
      print(e);
    }
  }
}
