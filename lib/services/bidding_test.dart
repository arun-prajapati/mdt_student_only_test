import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Constants/global.dart';

class BiddingService {
  //static const String api = 'https://mockdrivingtest.com';
  late Map data;
  late List bidDetails;
  late String message;

  Future<Map> getAvailableBidding() async {
    final url = Uri.parse('$api/api/adi/bidding');
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();

    Map<String, String> header = {
      'token': token,
    };

    final response = await http.get(url, headers: header);
    data = jsonDecode(response.body);

    return data;
  }

  Future<String> submitBidAmount(String bookingId, String bookingType,
      String amount, String splitName) async {
    final url = Uri.parse('$api/api/adi/bidding');
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();

    Map<String, String> header = {
      'token': token,
    };

    Map<String, dynamic> body = {
      'bookingId': bookingId,
      'bookingType': bookingType,
      'amount': amount,
      'split_name': splitName,
    };
    print("Form data : $body");
    final response = await http.post(url, headers: header, body: body);
    data = jsonDecode(response.body);
    message = data["message"];
    return message;
  }
}
