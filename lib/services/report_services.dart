import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Constants/global.dart';

class ReportServices {
  late Map data;
  late List userData;

  Future<Map> submitMockTestReport(Map<String, dynamic> formData) async {
    final url = Uri.parse("$api/api/submit/report");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    print("Printing form data.....$formData");
    final response = await http
        .post(url, headers: header, body: formData)
        .timeout(Duration(minutes: 5))
        .then((res) {
      print("saving mock test report....");
      print(jsonDecode(res.body.toString()));
      data = jsonDecode(res.body);
    });

    return data;
  }

  Future<Map> submitLessonReport(Map<String, dynamic> formData) async {
    final url = Uri.parse("$api/api/submit/report");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    print("Printing form data.....$formData");
    final response = await http
        .post(url, headers: header, body: formData)
        .timeout(Duration(minutes: 5))
        .then((res) {
      print("saving mock test report....");
      print(jsonDecode(res.body.toString()));
      data = jsonDecode(res.body);
    });
    return data;
  }

  Future<Map> fetchTestReport(int student) async {
    print("$api/api/report?student_id=$student");
    final url = Uri.parse("$api/api/report?student_id=$student");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final response = await http.get(url, headers: header);
    data = jsonDecode(response.body);
    return data;
  }
}
