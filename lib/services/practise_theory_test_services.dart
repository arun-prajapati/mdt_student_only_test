import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Constants/global.dart';

class PractiseTheoryTestServices {
  late Map data;
  late List userData;

  Future<List> getCategories() async {
    final url = Uri.parse("$api/api/get-categories");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final response = await http.get(url, headers: header);
    data = jsonDecode(response.body);
    userData = data["data"];
    return userData;
  }

  Future<List> getTestQuestions(int _categoryId) async {
    final url = Uri.parse(
        "$api/api/get-questions?category_id=" + _categoryId.toString());
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final response = await http.get(url, headers: header);
    data = jsonDecode(response.body);
    userData = data["data"];
    return userData;
  }

  Future<Map> getAllRecords(int _userType, int _userId) async {
    final url = Uri.parse("$api/api/get-all-data?id=" +
        _userId.toString() +
        "&user_type=" +
        _userType.toString());
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final response = await http.get(url, headers: header);
    data = jsonDecode(response.body);
    Map recordData = data["data"];
    return recordData;
  }

  Future<Map> submitTest(
      int _userType, int _userId, List test_question, int _category_id) async {
    final url = Uri.parse("$api/api/save-theory-test?id=" +
        _userId.toString() +
        "&user_type=" +
        _userType.toString() +
        "&category_id=" +
        (_category_id == null ? "0" : _category_id.toString()));
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    Map<String, String> formData = {'responses': jsonEncode(test_question)};
    print("Test Submitting...");
    print(test_question);
    final response = await http.post(url, headers: header, body: formData);
    data = jsonDecode(response.body);
    print(data);
    return data;
  }
}
