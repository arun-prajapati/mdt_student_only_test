import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Constants/global.dart';

class AIRecommondationAPI {
  late List lessondetails;
  late List testdetails;
  late Map theorydetails;
  late Map data;
  late String _type = 'lesson';

  static final AIRecommondationAPI _instance = AIRecommondationAPI._internal();
  factory AIRecommondationAPI() => _instance;
  AIRecommondationAPI._internal() {
    _type = 'lesson';
  }

  String get type => _type;
  void setType(String x) => this._type = x;

  Future<List> getrecommondedlesson(int studentId) async {
    final url = Uri.parse(
        '$api/api/lesson-recommendations?student_id=' + studentId.toString());
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();

    Map<String, String> header = {
      'token': token,
    };

    final response = await http.get(url, headers: header);
    data = jsonDecode(response.body);
    lessondetails = data["data"];
    return lessondetails;
  }

  Future<List> getrecommondedtest(int studentId) async {
    final url = Uri.parse(
        '$api/api/test-recommendations?student_id=' + studentId.toString());
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();

    Map<String, String> header = {
      'token': token,
    };

    final response = await http.get(url, headers: header);
    data = jsonDecode(response.body);
    testdetails = data["data"];
    return testdetails;
  }

  Future<Map> getrecommondedtheory() async {
    final url = Uri.parse('$api/api/ai_theory_test');
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();

    Map<String, String> header = {
      'token': token,
    };

    final response = await http.get(url, headers: header);
    data = jsonDecode(response.body);
    theorydetails = data["data"];
    return theorydetails;
  }
}
