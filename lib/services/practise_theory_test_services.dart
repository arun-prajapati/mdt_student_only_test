import 'dart:convert';
import 'dart:developer';
import 'package:Smart_Theory_Test/routing/route.dart';
import 'package:Smart_Theory_Test/services/subsciption_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
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
    print('URL getCategories ****************** $api/api/get-categories');
    final response = await http.get(url, headers: header);
    data = jsonDecode(response.body);
    userData = data["data"];
    print('CATEGORY ****************** $token');
    return userData;
  }

  Future<List> getTheoryContent(BuildContext context) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final url = Uri.parse(
        '$api/api/ai_get_theory_content/${context.read<SubscriptionProvider>().entitlement == Entitlement.unpaid ? "no" : "yes"}');
    final response = await http.get(url, headers: header);
    print("URL +++++++ $url");
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      userData = data["message"];
    } else {
      log('ERORRRR ${response.body}');
    }

    return userData;
  }

  Future<List> getTestQuestions(int _categoryId) async {
    String URL = "$api/api/get-questions?category_id=" + _categoryId.toString();
    final url = Uri.parse(URL);
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final response = await http.get(url, headers: header);
    data = jsonDecode(response.body);
    print("getTestQuestions URL ${URL}");
    log("RESPONSE getTestQuestions ++++++++++++++++ ${response.body}");

    userData = data["data"];

    return userData;
  }

  Future<Map> getAllRecords(int _userType, int _userId) async {
    String URL = "$api/api/get-all-data?id=" +
        _userId.toString() +
        "&user_type=" +
        _userType.toString();
    final url = Uri.parse(URL);
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final response = await http.get(url, headers: header);
    data = jsonDecode(response.body);
    Map recordData = data["data"];
    print("getAllRecords URL ${URL}");

    return recordData;
  }

  Future<Map> submitTest(
      int _userType, int _userId, List test_question, int _category_id) async {
    var URL = "$api/api/save-theory-test?id=" +
        _userId.toString() +
        "&user_type=" +
        _userType.toString() +
        "&category_id=" +
        (_category_id == null ? "0" : _category_id.toString());
    final url = Uri.parse(URL);
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    Map<String, String> formData = {'responses': jsonEncode(test_question)};
    print("Test Submitting... $URL");
    log("Test Submitting BODY... ${jsonEncode(test_question)}");
    final response = await http.post(url, headers: header, body: formData);
    data = jsonDecode(response.body);
    print(data);
    return data;
  }
}
