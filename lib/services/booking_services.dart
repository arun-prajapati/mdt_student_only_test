import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Constants/global.dart';
import 'auth.dart';

class Service with ChangeNotifier {
  late UserProvider authProvider;
  late String token;
  late Map apiResponse;
  late List bookingList;

  Service(UserProvider authProvider) {
    this.authProvider = authProvider;
  }

  //static const String api = 'https://mockdrivingtest.com';

  Future<List?> getFutureBookings() async {
    final url = Uri.parse('$api/api/adi/booking/future');
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();

    Map<String, String> header = {'token': token, 'App-Version': appVersion};

    final response = await http.get(url, headers: header);
    apiResponse = json.decode(response.body);
    bookingList = apiResponse["message"];
    if (response.statusCode == 200) {
      return bookingList;
    } else {
      //print('fail');
      return null;
    }
  }
}
