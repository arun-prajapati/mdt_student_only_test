import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Constants/global.dart';

class BookingService {
  late Map data;
  late List userData;
  late String _type = 'upcoming';

  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal() {
    _type = 'upcoming';
  }

  String get type => _type;
  void setType(String x) => this._type = x;

  //static const String api = 'https://mockdrivingtest.com';
  Future<Map?> getFutureBookings(int pageNumber, String filterType) async {
    final url = Uri.parse("$api/api/adi/booking/future?page=" +
        pageNumber.toString() +
        "&filter=" +
        filterType);
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final response = await http.get(url, headers: header);
    data = jsonDecode(response.body);
    if (data['success'] == true) {
      return data['message'];
    } else {
      return null;
    }
  }

  //filterType = accepted,rejected,report submitted,assigned,completed
  Future<Map?> getPastBookings(int pageNumber, String filterType) async {
    final url = Uri.parse("$api/api/adi/booking/past?page=" +
        pageNumber.toString() +
        "&filter=" +
        filterType);
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final response = await http.get(url, headers: header);
    data = jsonDecode(response.body);
    if (data['success'] == true) {
      return data['message'];
    } else {
      return null;
    }
  }

  Future<List> getRecentBookings() async {
    final url = Uri.parse("$api/api/recent-booking?count=4");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final response = await http.get(url, headers: header);
    data = jsonDecode(response.body);
    if (data['success'] == true) {
      return data['message'];
    } else {
      return [];
    }
  }

  Future<List> getSuggestions(String search_address) async {
    final url = Uri.parse(
        "https://api.ideal-postcodes.co.uk/v1/autocomplete/addresses?api_key=ak_k41f2aq4g8ZR73bUurtrPz5cetIND&query=" +
            search_address);
    final response = await http.get(url);
    data = json.decode(response.body);
    if (data['code'] == 2000) {
      List addresses = data["result"]['hits'];
      return addresses;
    } else {
      List blankArray = [];
      return blankArray;
    }
  }

  Future<Map?> getAddress(String udprn) async {
    final url = Uri.parse("https://api.ideal-postcodes.co.uk/v1/udprn/" +
        udprn +
        "?api_key=ak_k41f2aq4g8ZR73bUurtrPz5cetIND");
    SharedPreferences storage = await SharedPreferences.getInstance();
    final response = await http.get(url);
    data = json.decode(response.body);
    print(data);
    if (data['code'] == 2000) {
      Map addresses = data["result"];
      print("Adress from api...$addresses");
      return addresses;
    } else {
      return null;
    }
  }

  Future<Map> getDynamicRate(Map parms) async {
    final url = Uri.parse("$api/api/get-dynamic-rate?postcode=" +
        parms['postcode'] +
        "&car_type=" +
        parms['car_type'] +
        "&vehicle_preference=" +
        parms['vehicle_preference'] +
        "&type=" +
        parms['type'] +
        "&course_id=" +
        parms['course_id']);
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    print("getDynamicRate.." + url.toString());
    final response = await http.get(url, headers: header);
    print("getDynamicRate......");
    print(response.body);
    data = json.decode(response.body);
    return data;
  }

  Future<List> getInstructorName(String instrucor_name) async {
    final url = Uri.parse("$api/api/get-instructor");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final response = await http.get(url, headers: header);
    data = json.decode(response.body);
    if (data['success'] == true) {
      List addresses = data["data"];
      return addresses;
    } else {
      List blankArray = [];
      return blankArray;
    }
  }

  Future<List> getCoursesNameList(String instrucor_name) async {
    final url = Uri.parse("$api/api/courses");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final response = await http.get(url, headers: header);
    data = json.decode(response.body);
    if (data['success'] == true) {
      List addresses = data["data"];
      return addresses;
    } else {
      List blankArray = [];
      return blankArray;
    }
  }

  Future<Map> postBookLesson(Map formData) async {
    final url = Uri.parse("$api/api/save-lesson");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {'token': token};
    print("request data..");
    print(formData);
    final response = await http.post(url, headers: header, body: formData);
    data = jsonDecode(response.body);
    return data;
  }

  Future<Map> postBookTest(Map formData) async {
    final url = Uri.parse("$api/api/save-test");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {'token': token};
    final response = await http.post(url, headers: header, body: formData);
    data = jsonDecode(response.body);
    return data;
  }

  Future<Map> postPassAssistLesson(Map formData) async {
    final url = Uri.parse("$api/api/save-pass-assist-lesson");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {'token': token};
    final response = await http.post(url, headers: header, body: formData);
    data = jsonDecode(response.body);
    return data;
  }

  Future<Map> postPayLessonFee(Map formData) async {
    final url = Uri.parse("$api/api/pay-lesson-fee");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {'token': token};
    final response = await http.post(url, headers: header, body: formData);
    data = jsonDecode(response.body);
    return data;
  }

  Future<Map> postPayTestFee(Map formData) async {
    final url = Uri.parse("$api/api/pay-test-fee");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {'token': token};
    final response = await http.post(url, headers: header, body: formData);
    data = jsonDecode(response.body);
    print("Booking res: $data");
    return data;
  }

  Future<Map> applyDiscountCode(Map formData) async {
    final url = Uri.parse("$api/api/check-code");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {'token': token};
    final response = await http.post(url, headers: header, body: formData);
    data = jsonDecode(response.body);
    return data;
  }

  //Get count on each date of calender
  Future<List> getCalenderBookingCount(String startDate, String endDate) async {
    final url = Uri.parse(
        "$api/calender-booking-count?from=" + startDate + "&to=" + endDate);
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final response = await http.get(url, headers: header);
    data = json.decode(response.body);
    if (data['success'] == true) {
      List addresses = data["data"];
      return addresses;
    } else {
      List blankArray = [];
      return blankArray;
    }
  }
}
