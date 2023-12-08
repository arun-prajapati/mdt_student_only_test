import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../Constants/global.dart';
import '../enums/Autentication_status.dart';
import '../locater.dart';
import 'navigation_service.dart';
import 'notification_text/notification_text.dart';

class AuthProvider with ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();
  Status _status = Status.Uninitialized;
  late String _token;
  late String _userName;
  late String _eMail;
  late String _contact;
  late int _userType;
  NotificationText _notification = NotificationText('', '');
  int get userType => _userType;
  Status get status => _status;
  String get token => _token;
  String get userName => _userName;
  String get eMail => _eMail;
  String get contact => _contact;
  NotificationText get notification => _notification;
  //final String api = 'https://mockdrivingtest.com';
  initAuthProvider() async {
    String? token = await getToken();
    if (token != null) {
      _token = token;
      print(_token);
      _status = Status.Authenticated;
    } else {
      _status = Status.Unauthenticated;
    }

    notifyListeners();
  }

//  loginRoutes() async {
//    _status = Status.RouteLogin;
//    notifyListeners();
//  }
  Future<bool> login(
      String email, String password, String usertype, String deviceId) async {
    _status = Status.Authenticating;
    _notification = NotificationText('', '');
    notifyListeners();

    final url = Uri.parse('$api/api/login');
    Map<String, String> body = {
      'email': email,
      'password': password,
      'user_type': usertype,
      'device_id': deviceId,
    };


    print(url);


    print(jsonEncode(body));

    final response = await http.post(
      url,
      body: body,
    );
    print(response);
    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = json.decode(response.body);
      print("userData ${jsonEncode(body)}");
      print("RESSS **************************           $apiResponse");
      _status = Status.Authenticated;
      _token = apiResponse['token'];
      _userType = apiResponse['user_type'];
      _userName = apiResponse['user_name'];
      _eMail = apiResponse['e_mail'];
      //print(_token);
      await storeUserData(apiResponse);
      _navigationService.goBack();
      notifyListeners();
      return true;
    } else {
      Map<String, dynamic> apiResponse = json.decode(response.body);
      _status = Status.Unauthenticated;
      _notification = NotificationText(apiResponse['message'], '');
      if (apiResponse.containsKey('contact')) {
        _contact = apiResponse['contact'][0]['number'];
        _userName = apiResponse['user_name'];
      }
      log("Api res : $apiResponse");
      notifyListeners();
      return false;
    }
  }

  Future<Map?> socialLoginWithMdtRegister(Map params) async {
    print("hello");
    if (params['accessType'] == 'register') {
      _status = Status.Authenticating;
      // _notification =null;
      notifyListeners();
    }
    String email_ = params['email'] == null ? '' : params['email'];
    String phone_ = params['phone'] == null ? '' : params['phone'];
    var url = null;
    if (params['accessType'] == 'register')
      url = Uri.parse("$api/api/social-login?token=" +
          params['token'] +
          "&social_type=" +
          params['social_type'] +
          "&id=" +
          params['social_site_id'] +
          "&email=" +
          email_ +
          "&user_type=" +
          params['user_type'] +
          "&phone=" +
          phone_);
    else
      url = Uri.parse("$api/api/social-login?token=" +
          params['token'] +
          "&social_type=" +
          params['social_type'] +
          "&id=" +
          params['social_site_id'] +
          "&email=" +
          email_);
    final response = await http.get(url);
    final responseParse = json.decode(response.body);
    if (responseParse['success'] == false) {
      if (params['accessType'] == 'register') {
        _status = Status.Unauthenticated;
        notifyListeners();
      }
      log('RESPONSE PARRRRRRRRRRRRRRRRRRRRRRR       *****************        $responseParse');
      return responseParse;
    } else {
      if (response.statusCode == 200) {
        Map<String, dynamic> apiResponse = json.decode(response.body);
        print("Api response social login : $apiResponse");
        _status = Status.Authenticated;

        _token = apiResponse['token'];
        _userType = apiResponse['user_type'];
        _userName =
            apiResponse['user_name'] == null ? '' : apiResponse['user_name'];
        _eMail = apiResponse['e_mail'];
        await storeUserData(apiResponse);
        //check why this condition is implemented??
        if (params['accessType'] == 'register') _navigationService.goBack();
        notifyListeners();
        return null;
      } else {
        // Map<String, dynamic> apiResponse = json.decode(response.body);
        // _status = Status.Unauthenticated;
        // _notification = NotificationText(apiResponse['message']);
        // notifyListeners();
        print('ELSE **************           ');
        return responseParse;
      }
    }
  }

  Future<Map> register(
      String name,
      String email,
      String password,
      String passwordConfirm,
      String userType,
      String deviceType,
      String deviceId) async {
    //print(userType);
    final url = Uri.parse('$api/api/register');
    Map<String, String> body = {
      'name': name,
      'email_phone': email,
      'password': password,
      'password_confirmation': passwordConfirm,
      'user_type': userType,
      'device_type': deviceType,
      'device_id': deviceId,
    };
    print(body);
    final response = await http.post(
      url,
      body: body,
    );
    Map apiResponse = json.decode(response.body);
    print("Registration: $apiResponse");
    if (apiResponse["success"] == true) {
      _notification = NotificationText(apiResponse['message'].toString(), '');
      notifyListeners();
    } else {
      if (apiResponse['message'].containsKey('email')) {
        _notification =
            NotificationText(apiResponse['message']['email'][0].toString(), '');
        notifyListeners();
      }
      if (apiResponse['message'].containsKey('password')) {
        _notification = NotificationText(
            apiResponse['message']['password'][0].toString(), '');
        notifyListeners();
      }
      if (apiResponse['message'].containsKey('phone')) {
        _notification =
            NotificationText(apiResponse['message']['phone'][0].toString(), '');
        notifyListeners();
      }
    }
    return apiResponse;
    //return {};
  }

  Future<bool> passwordReset(String email) async {
    final url = Uri.parse('$api/forgot-password');
    Map<String, String> body = {
      'email': email,
    };
    final response = await http.post(
      url,
      body: body,
    );
    if (response.statusCode == 200) {
      _notification =
          NotificationText('Reset sent. Please check your inbox.', 'info');
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<Map> getUserData() async {
    final url = Uri.parse('$api/api/user');
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? token = storage.getString('token');
    Map<String, String> header = {
      'token': token.toString(),
    };
    final response = await http.get(
      url,
      headers: header,
    );
    Map data = jsonDecode(response.body);
    Map userDetails = data['message'];
    return userDetails;
  }

  storeUserData(apiResponse) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('token', apiResponse['token']);
    await storage.setInt('userType', apiResponse['user_type']);
    await storage.setString('userName',
        apiResponse['user_name'] == null ? '' : apiResponse['user_name']);
    await storage.setString('eMail', apiResponse['e_mail']);
  }

  Future<String?> getToken() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? token = storage.getString('token');
    return token;
  }

  logOut([bool tokenExpired = false]) async {
    _status = Status.Unauthenticated;
    if (tokenExpired == true) {
      _notification =
          NotificationText('Session expired. Please log in again.', 'info');
    }
    notifyListeners();
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.clear();
  }
}
