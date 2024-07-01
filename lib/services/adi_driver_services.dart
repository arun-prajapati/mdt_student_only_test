import 'dart:convert';

import 'package:Smart_Theory_Test/services/auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/global.dart';

class AdiDriverCommonAPI {
  late Map data;

  Future<Map> submitContactUsMessage(Map<String, String> formData) async {
    final url = Uri.parse('$api/api/contact-us');
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {'token': token, 'App-Version': appVersion};
    final response = await http.post(url, headers: header, body: formData);
    data = jsonDecode(response.body);
    print('contact-us ${response.body}');
    return data;
  }
}
