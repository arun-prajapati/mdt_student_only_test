import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:Smart_Theory_Test/datamodels/user_location.dart';
import 'package:Smart_Theory_Test/main.dart';
import 'package:Smart_Theory_Test/responsive/size_config.dart';
import 'package:Smart_Theory_Test/routing/route.dart';
import 'package:Smart_Theory_Test/services/subsciption_provider.dart';
import 'package:Smart_Theory_Test/views/Home/home_content_mobile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Smart_Theory_Test/Constants/app_colors.dart';
import 'package:Smart_Theory_Test/external.dart';
import 'package:Smart_Theory_Test/utils/app_colors.dart';
import 'package:Smart_Theory_Test/views/Login/otp_screen.dart';

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
  String userId = "";
  String _deviceId = "";
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
    print('))))))))))))))))))');
    String? token = await getToken();
    fetchUser();
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
  login(BuildContext context,
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
    _deviceId = deviceId;
    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = json.decode(response.body);
      print("userData ${jsonEncode(body)}");
      print("RESSS **************************           $apiResponse");

      googleNavigate = false;
      // _status = Status.Authenticated;
      _token = apiResponse['token'];
      _userType = apiResponse['user_type'];
      _userName = apiResponse['user_name'];
      _eMail = apiResponse['e_mail'];

      //print(_token);
      await storeUserData(context, apiResponse);
      _navigationService.navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
      // _navigationService.goBack();
      notifyListeners();
      return response;
    } else {
      Map<String, dynamic> apiResponse = json.decode(response.body);

      _status = Status.Unauthenticated;
      _notification = NotificationText(apiResponse['message'], '');

      if (apiResponse.containsKey('contact')) {
        _contact = apiResponse['contact'][0]['number'];
        _userName = apiResponse['user_name'];
      }
      if (apiResponse['message'] == "device-exist") {
        showDeviceExistDialog(context, userName, contact);
      }
      log("Api res : $apiResponse");
      userId = apiResponse['user_id'].toString();
      print("RESSS **************************           ${userId}");
      notifyListeners();
      return response;
    }
  }

  Future<Map?> socialLoginWithMdtRegister(
      BuildContext context, Map params) async {
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
      url = Uri.parse(
        "$api/api/social-login?token=" +
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
            phone_ +
            "&device_id=" +
            params['device_id'],
      );
    else
      url = Uri.parse(
        "$api/api/social-login?token=" +
            params['token'] +
            "&social_type=" +
            params['social_type'] +
            "&id=" +
            params['social_site_id'] +
            "&email=" +
            email_ +
            "&device_id=" +
            params['device_id'],
      );
    print("SOCIAL LOGIN URL $url");
    _deviceId = params['device_id'];
    final response = await http.get(url);
    final responseParse = json.decode(response.body);

    if (responseParse['success'] == false) {
      userId = responseParse['user_id'].toString();
      print('$_status----------------------Status');
      if (params['accessType'] == 'register') {
        _status = Status.Unauthenticated;

        notifyListeners();
      }

      return responseParse;
    } else {
      if (response.statusCode == 200) {
        print('$_status----------------------Status');
        Map<String, dynamic> apiResponse = json.decode(response.body);
        print("Api response social login : $apiResponse");
        // _status = Status.Authenticated;

        _token = apiResponse['token'];
        _userType = apiResponse['user_type'];
        _userName =
            apiResponse['user_name'] == null ? '' : apiResponse['user_name'];
        _eMail = apiResponse['e_mail'];
        await storeUserData(context, apiResponse);
        print('NAVIGATE ==================== ');
        _navigationService.navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
        //check why this condition is implemented??
        // if (params['accessType'] == 'register') _navigationService.goBack();
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
  String socialToken = "";
  String socialType = "";
  String socialSiteId = "";

  printData() {
    print("email: $email");
    print("firstName: $name");
    print("phone: $phoneNumber");
    print("password: $password");
    print("confirmPass: $passwordConfirm");
    print("countryCode: $countryCode");
    print("socialType: $socialType");
    print("socialToken: $socialToken");
    print("socialSiteId: $socialSiteId");
  }

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
    print("-------- REGISTER URL ---------- $api/api/register");
    final response = await http.post(
      url,
      body: body,
    );
    Map apiResponse = json.decode(response.body);
    print("Registration: $apiResponse");
    if (apiResponse["success"] == true) {
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

  updateDeviceID() async {
    final url = Uri.parse('$api/api/update_device_id');
    Map<String, String> body = {
      'id': userId,
      'device_id': _deviceId,
    };
    print('UPDATE DEVICE_ID URL $url');
    print('UPDATE DEVICE_ID ${jsonEncode(body)}');
    final response = await http.post(
      url,
      body: body,
    );
    if (response.statusCode == 200) {
      print('UPDATE ${response.body}');
      var data = jsonDecode(response.body);
      Fluttertoast.showToast(msg: data['message'], gravity: ToastGravity.TOP);
      notifyListeners();
      return true;
    } else {
      print('UPDATE ${response.body}');
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
    // log('Response....... ${response.body}');
    Map data = jsonDecode(response.body);
    try {
      if (response.statusCode == 200) {
        Map userDetails = data['message'];
        AppConstant.userModel = UserModel.fromJson(
          {
            'success': data['success'],
            'token': token,
            'user_id': data['message']['id'].toString(),
            'user_type': data['message']['user_type'],
            'user_name': data['message']['first_name'],
            'e_mail': data['message']['email'],
            'plan_type': data['message']['plan_type'],
          },
        );
        print(
            '.....200............ ${jsonEncode(AppConstant.userModel?.toJson())}');
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

  storeUserData(BuildContext context, apiResponse) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('token', apiResponse['token']);
    await storage.setInt('userType', apiResponse['user_type']);
    await storage.setString('userName',
        apiResponse['user_name'] == null ? '' : apiResponse['user_name']);
    await storage.setString('eMail', apiResponse['e_mail']);
    await storage.setString('userId', apiResponse['user_id'].toString());
    await storage.setString('user_data', jsonEncode(apiResponse));
    AppConstant.userModel = UserModel.fromJson(apiResponse);

    UserData.userId = apiResponse['user_id'].toString();
    // Future.delayed(Duration());

    print('Plan type ======== ${AppConstant.userModel?.planType}');
  }

  /// SEND OTP ///
  String verificationCode = "";
  int _resendToken = 0;

  // bool isSendOtp = false;

  verifyPhone(BuildContext context, String phoneNumber,
      {bool isResend = false}) async {
    loading(value: true);

    await FirebaseAuth.instance
        .verifyPhoneNumber(
            phoneNumber: "$countryCode$phoneNumber",
            verificationCompleted: (PhoneAuthCredential credential) {
              loading(value: false);
              _onVerificationCompletedRegister(credential, context);
              notifyListeners();
            },
            verificationFailed: (FirebaseAuthException exception) {
              loading(value: false);

              showErrorDialog(context, exception.message.toString());
              print('ERROR  $exception');
              notifyListeners();
            },
            codeSent: (String verificationId, int? resendToken) {
              loading(value: false);
              verificationCode = verificationId;
              _resendToken = resendToken ?? 0;

              if (isResend == true) {
                loading(value: false);
                // _navigationService.navigatorKey.currentState?.push(MaterialPageRoute(
                //     builder: (_) => const OTPVerificationScreen()));
              } else {
                loading(value: false);
                _navigationService.navigatorKey.currentState
                    ?.push(MaterialPageRoute(
                        builder: (_) => OTPVerificationScreen(
                              phone: phoneNumber,
                              CountryCode: countryCode,
                            )));
              }
              notifyListeners();
            },
            forceResendingToken: _resendToken,
            codeAutoRetrievalTimeout: (String verificationId) {
              loading(value: false);
              verificationCode = verificationId;
              notifyListeners();
            },
            timeout: const Duration(minutes: 2))
        .catchError((e) {
      print('$e');
    });
  }

  bool isForgotPassword = false;
  bool isSocialLogin = false;
  bool googleNavigate = false;

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

  fetchUser() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? data = storage.getString('user_data');

    if (data != null) {
      AppConstant.userModel = UserModel.fromJson(jsonDecode(data));
      print('+++++++++DATA  ${AppConstant.userModel?.planType}');
    }
  }

  logOut(BuildContext context, [bool tokenExpired = false]) async {
    _status = Status.Unauthenticated;
    if (tokenExpired == true) {
      _notification =
          NotificationText('Session expired. Please log in again.', 'info');
    }
    notifyListeners();
    SharedPreferences storage = await SharedPreferences.getInstance();
    // Purchases.logOut().then((value) {
    //   log('UUUUUIIIIII ${value.entitlements.active} ${SubscriptionProvider().entitlement}');
    //   // context.read<SubscriptionProvider>().entitlement = Entitlement.unpaid;
    //   // notifyListeners();
    //   // if (value.entitlements.active == {}) {
    //   // log('value.entitlements ${jsonEncode(value.entitlements)} ${context.read<SubscriptionProvider>().entitlement}');
    //   // context.read<SubscriptionProvider>().entitlement = Entitlement.unpaid;
    //   // }
    // });
    await storage.clear();
  }

  showDeviceExistDialog(
    BuildContext context,
    String userName,
    String contact,
  ) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Smart Theory Test', style: AppTextStyle.appBarStyle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hey there ${userName.substring(0, 1).toUpperCase() + userName.substring(1)}",
                  style: AppTextStyle.textStyle.copyWith(
                      fontSize: 16, color: Dark, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 1.5,
                ),
                Text(
                  'You seem to have changed your phone. Would you like to'
                  ' move your app to your new phone?',
                  style: AppTextStyle.textStyle.copyWith(
                      fontSize: 16, color: Dark, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 1.5,
                ),
                // Text('Thanks'),
              ],
            ),
            //Text('${userName.substring(0,1).toUpperCase()+userName.substring(1)} $contact'),
            actions: [
              TextButton(
                onPressed: () {
                  updateDeviceID();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Ok',
                  style: AppTextStyle.textStyle.copyWith(
                      fontSize: 16, color: Dark, fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // launchUrl(
                  //   Uri(
                  //     scheme: 'tel',
                  //     path: '$contact',
                  //   ),
                  //   mode: LaunchMode.externalApplication,
                  // );
                },
                child: Text(
                  'Cancel',
                  style: AppTextStyle.textStyle.copyWith(
                      fontSize: 16, color: Dark, fontWeight: FontWeight.w600),
                ),
              ),
            ],
            actionsAlignment: MainAxisAlignment.start,
            contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 1.0),
          );
        });
  }

  deleteAccount() async {
    final url = Uri.parse("$api/api/delete-account");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final response = await http.post(url, headers: header);
    log("++++++++++++++++= $url");
    log("++++++++++++++++= ${response.body} $header");
    if (response.statusCode == 200) {
      var parsedData = jsonDecode(response.body);
      if (parsedData['success'] == true) {
        Fluttertoast.showToast(
            msg: "Your account is deleted successfully",
            gravity: ToastGravity.TOP);
        await GoogleSignIn().signOut();
        _navigationService.navigateToReplacement('/Authorization');
      } else {}
    } else {
      Fluttertoast.showToast(msg: "-----------", gravity: ToastGravity.TOP);
    }
  }
}
