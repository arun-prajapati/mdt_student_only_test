import 'dart:convert';
import 'dart:developer';

import 'package:Smart_Theory_Test/services/auth.dart';
import 'package:http/http.dart' as http;

import '../constants/global.dart';

class PasswordServices {
  Map data = {};

  Future<Map> forgotPassword(Map formData) async {
    final url = Uri.parse("$api/api/verification-code");
    final response = await http.post(url, body: formData, headers: {
      'App-Version': appVersion,
    });
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
    final response = await http.post(url, body: formData, headers: {
      'App-Version': appVersion,
    });
    print("RESPONSE : ${response.body}");
    data = jsonDecode(response.body);
    return data;
  }

  Future<Map> checkNumber(Map formData) async {
    final url = Uri.parse("$api/api/verify-mobile");
    final response = await http.post(url, body: formData, headers: {
      'App-Version': appVersion,
    });
    log("URL :: ${url}");
    log("RESPONSE :: ${response.body}");
    log("BODY :: ${jsonEncode(formData)}");
    data = jsonDecode(response.body);

    return data;
  }
}
