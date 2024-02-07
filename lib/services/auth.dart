import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_app/Constants/app_colors.dart';
import 'package:student_app/external.dart';
import 'package:student_app/utils/app_colors.dart';
import 'package:student_app/views/Login/otp_screen.dart';

import '../Constants/global.dart';
import '../enums/Autentication_status.dart';
import '../locater.dart';
import 'navigation_service.dart';
import 'notification_text/notification_text.dart';

class UserProvider with ChangeNotifier {
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

  bool changeView = false;

//  loginRoutes() async {
//    _status = Status.RouteLogin;
//    notifyListeners();
//  }
  Future<bool> login(
      {required String email,
      required String password,
      required String usertype,
      required String deviceId}) async {
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
    print(url);
    final response = await http.get(url);
    final responseParse = json.decode(response.body);
    if (responseParse['success'] == false) {
      print('$_status----------------------Status');
      if (params['accessType'] == 'register') {
        _status = Status.Unauthenticated;
        notifyListeners();
      }
      log('RESPONSE PARRRRRRRRRRRRRRRRRRRRRRR       *****************        $responseParse');
      return responseParse;
    } else {
      if (response.statusCode == 200) {
        print('$_status----------------------Status');
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

  String name = "";
  String email = "";
  String password = "";
  String phoneNumber = "";
  String countryCode = "";
  String passwordConfirm = "";

  Future<Map> register({required String deviceId}) async {
    //print(userType);
    final url = Uri.parse('$api/api/register');
    Map<String, String> body = {
      'name': name,
      'email_phone': email,
      'password': password,
      'password_confirmation': passwordConfirm,
      'user_type': "2",
      'device_type': Platform.isAndroid ? "android" : "iOS",
      'device_id': deviceId,
      "phone": "$countryCode${phoneNumber}",
    };
    print("-------- REGISTER BODY ---------- ${jsonEncode(body)}");
    final response = await http.post(
      url,
      body: body,
    );
    Map apiResponse = json.decode(response.body);
    print("Registration: $apiResponse");
    if (apiResponse["success"] == true) {
      isSendOtp = false;
      notifyListeners();
      _notification = NotificationText(apiResponse['message'].toString(), '');
      notifyListeners();
    } else {
      if (apiResponse['message'].contains('email')) {
        _notification = NotificationText(apiResponse['message'], '');
        notifyListeners();
      }
      if (apiResponse['message'].contains('password')) {
        _notification =
            NotificationText(apiResponse['message']['password'], '');
        notifyListeners();
      }
      if (apiResponse['message'].contains('phone')) {
        _notification = NotificationText(apiResponse['message'], '');
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
    log('Response....... ${response.body}');
    Map data = jsonDecode(response.body);
    try {
      if (response.statusCode == 200) {
        print('.....200............');
        Map userDetails = data['message'];
        return userDetails;
      } else {
        print('.....500............');
        return {};
      }
    } catch (e) {
      print(e);
      return {};
    }
  }

  storeUserData(apiResponse) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('token', apiResponse['token']);
    await storage.setInt('userType', apiResponse['user_type']);
    await storage.setString('userName',
        apiResponse['user_name'] == null ? '' : apiResponse['user_name']);
    await storage.setString('eMail', apiResponse['e_mail']);
  }

  /// SEND OTP ///
  String verificationCode = "";
  int _resendToken = 0;
  bool isSendOtp = false;

  verifyPhone(BuildContext context, String countryCode, String phoneNumber,
      {bool isResend = false}) async {
    loading(value: true);

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "$countryCode$phoneNumber",
        verificationCompleted: (PhoneAuthCredential credential) {
          loading(value: false);
          _onVerificationCompletedRegister(credential, context);
          notifyListeners();
        },
        verificationFailed: (FirebaseAuthException exception) {
          loading(value: false);

          showErrorDialog(context, exception.message.toString());
          notifyListeners();
        },
        codeSent: (String verificationId, int? resendToken) {
          loading(value: false);
          verificationCode = verificationId;
          _resendToken = resendToken ?? 0;
          isSendOtp = true;
          _navigationService.navigatorKey.currentState?.push(MaterialPageRoute(
              builder: (_) => OTPVerificationScreen(
                    phone: phoneNumber,
                    CountryCode: countryCode,
                  )));
          // print("${}");
          if (isResend == true) {
            loading(value: false);
            // _navigationService.navigatorKey.currentState?.push(MaterialPageRoute(
            //     builder: (_) => const OTPVerificationScreen()));
          } else {
            loading(value: false);
          }
          notifyListeners();
        },
        forceResendingToken: _resendToken,
        codeAutoRetrievalTimeout: (String verificationId) {
          loading(value: false);
          verificationCode = verificationId;
          notifyListeners();
        },
        timeout: const Duration(minutes: 2));
  }

  bool isForgotPassword = false;

  void _onVerificationCompletedRegister(
      PhoneAuthCredential phoneAuthCredential, BuildContext context) async {
    loading(value: true);
    FirebaseAuth.instance
        .signInWithCredential(phoneAuthCredential)
        .then((value) async {
      if (value.user != null) {
        loading(value: false);
        if (isForgotPassword) {
          // AppRoutes.pushAndRemoveUntil(
          //   context,
          //   ChangePasswordScreen(isForgotPassword: true),
          // );
        } else {
          // userRegister(context);
        }
      }
    }).catchError((e) {
      loading(value: false);
      print("@@@@@@@@@ $e");
      if (e.code == "invalid-verification-code") {
        showErrorDialog(context, "Invalid OTP");
      } else {
        showErrorDialog(context, e.code.toString().replaceAll("-", " "));
      }
    });
  }

  validateOTP(
    String code,
    BuildContext context, {
    bool isForgotPassword = false,
  }) async {
    // loading(value: true);
    try {
      // loading(value: false);
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationCode, smsCode: code);
      _onVerificationCompletedRegister(credential, context);
    } catch (e) {
      // loading(value: false);
      showErrorDialog(context, "Invalid OTP");
    }
  }

  showErrorDialog(BuildContext context, String message) {
    //print("valid");
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Smart Theory Test', style: AppTextStyle.titleStyle),
            content: Text(message,
                style: AppTextStyle.textStyle
                    .copyWith(fontWeight: FontWeight.w400)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(color: Dark),
                ),
              ),
            ],
          );
        });
  }

  /// ========///

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
