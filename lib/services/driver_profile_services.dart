import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Constants/global.dart';

class DriverProfileServices {
  late Map data;
  late List userData;

  Future<Map> getProfileDetail(int _userType, int _userId) async {
    String URL = "$api/api/profile?id=" +
        _userId.toString() +
        "&user_type=" +
        _userType.toString();
    final url = Uri.parse(URL);
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    print('TOKEN ******************  $token');
    print('PROFILE DETAIL  $URL');

    Map<String, String> header = {
      'token': token,
    };
    final response = await http.get(url, headers: header);
    data = jsonDecode(response.body);
    Map recordData = data["data"];
    return recordData;
  }

  Future<Map> updateProfileDetail(Map<String, String> formData) async {
    final url = Uri.parse("$api/api/update-profile");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final response = await http.post(url, headers: header, body: formData);
    data = jsonDecode(response.body);
    print('---- URL ---- $api/api/update-profile');
    return data;
  }

  Future<Map> changePassword(Map formData) async {
    final url = Uri.parse("$api/api/save-password");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {'token': token};
    final response = await http.post(url, headers: header, body: formData);
    data = jsonDecode(response.body);
    return data;
  }
}
