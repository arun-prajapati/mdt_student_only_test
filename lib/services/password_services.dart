import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../constants/global.dart';

class PasswordServices {
  Map data = {};

  Future<Map> forgotPassword(Map formData) async {
    final url = Uri.parse("$api/api/verification-code");
    final response = await http.post(url, body: formData);
    data = jsonDecode(response.body);
    log("WWWWWWWWWWWW $api/api/verification-code");
    log("WWWWWWWWWWWW RESPONSE  ${data}");
    return data;
  }

  // Future<Map> verifyCode(Map formData) async {
  //   final url = Uri.parse("$api/api/verify/password");
  //   final response = await http.post(url, body: formData);
  //   data = jsonDecode(response.body);
  //   return data;
  // }

  Future<Map> resetForgotPassword(Map formData) async {
    final url = Uri.parse("$api/api/verify/mobile-password");
    final response = await http.post(url, body: formData);
    print("RESPONSE : ${response.body}");
    data = jsonDecode(response.body);
    return data;
  }

  Future<Map> checkNumber(Map formData) async {
    final url = Uri.parse("$api/api/verify-mobile");
    final response = await http.post(url, body: formData);
    log("RESPONSE :: ${response.body}");
    log("BODY :: ${jsonEncode(formData)}");
    data = jsonDecode(response.body);

    return data;
  }
}
