// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:Smart_Theory_Test/main.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:Smart_Theory_Test/Constants/app_colors.dart';
import 'package:Smart_Theory_Test/custom_button.dart';
import 'package:Smart_Theory_Test/external.dart';
import 'package:Smart_Theory_Test/responsive/size_config.dart';
import 'package:Smart_Theory_Test/services/auth.dart';
import 'package:Smart_Theory_Test/services/navigation_service.dart';
import 'package:Smart_Theory_Test/utils/appImages.dart';
import 'package:Smart_Theory_Test/utils/app_colors.dart';
import 'package:Smart_Theory_Test/views/Login/forgot_next_screen.dart';
import 'package:Smart_Theory_Test/views/Login/login.dart';
import 'package:toast/toast.dart';

import '../../locater.dart';
import 'register.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phone;
  final String CountryCode;

  const OTPVerificationScreen(
      {super.key, required this.phone, required this.CountryCode});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  TextEditingController code = TextEditingController();

  final submittedPinTheme = PinTheme(
    width: 60,
    height: 60,
    textStyle: TextStyle(
      fontSize: 28,
      color: AppColors.black,
      fontWeight: FontWeight.w700,
      decorationColor: AppColors.black,
    ),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: AppColors.black.withOpacity(0.5)),
    ),
  );
  final focusPinTheme = PinTheme(
    width: 60,
    height: 60,
    textStyle: TextStyle(
      fontSize: 22,
      color: AppColors.black,
      fontWeight: FontWeight.w700,
      decorationColor: AppColors.black,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: AppColors.black.withOpacity(0.5)),
    ),
  );
  int secondsRemaining = 1 * 60;
  bool enableResend = false;
  Timer? timer;
  Map response = new Map();
  late String deviceType;
  String deviceId = '';

  // Future<String?> getId() async {
  //   //  deviceId = await PlatformDeviceId.getDeviceId;
  //   var deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isIOS) {
  //     // import 'dart:io'
  //     var iosDeviceInfo = await deviceInfo.iosInfo;
  //     deviceId = await iosDeviceInfo.identifierForVendor; // unique ID on iOS
  //   } else if (Platform.isAndroid) {
  //     var androidDeviceInfo = await deviceInfo.androidInfo;
  //     deviceId = await androidDeviceInfo.id; // unique ID on Android
  //   }
  //   print('*************** DEVICE ID *********** $deviceId');
  //   //deviceId = Uuid().v4();
  //
  //   return deviceId;
  // }
  getDeviceId() async {
    // var platform = PlatformDeviceId.deviceInfoPlugin;
    var deviceInfo = DeviceInfoPlugin();
    String udid = await FlutterUdid.udid;
    String consistentUdid = await FlutterUdid.consistentUdid;
    log(udid, name: "UNIQUE_ID");
    log(consistentUdid, name: "consistent_Udid");
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      // String consistentUdid = await FlutterUdid.consistentUdid;
      // String udid = await FlutterUdid.udid;
      // log(udid, name: "UNIQUE_ID");
      // log(consistentUdid, name: "consistent_Udid");
      deviceId = consistentUdid;
      print(
          "========== IOS =========== ${iosDeviceInfo.identifierForVendor} ${iosDeviceInfo.data}");
      return consistentUdid;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = consistentUdid;
      print("========== ANDROID =========== ${androidDeviceInfo.id}");
      return consistentUdid;
    }
  }

  @override
  void initState() {
    // getId();
    getDeviceId();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    secondsRemaining = 60;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Duration clockTimer = Duration(seconds: secondsRemaining);

    String timerText =
        '0${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    return Scaffold(
        body: Stack(
      alignment: Alignment.topCenter,
      children: [
        Stack(children: [
          // Image.asset(
          //   AppImages.bgLogin,
          //   //height: 300,
          //   width: MediaQuery.of(context).size.width,
          //   fit: BoxFit.fitWidth,
          // ),
          Image.asset(
            "assets/bg1.png",
            height: 290,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
          ),
          Positioned(
              left: 25,
              top: SizeConfig.blockSizeVertical * 8,
              child: backArrowCustom()),
          // Positioned(
          //   top: SizeConfig.blockSizeVertical * 15,
          //   left: SizeConfig.blockSizeHorizontal * 28,
          //   child: CircleAvatar(
          //     radius: SizeConfig.blockSizeHorizontal * 22,
          //     backgroundColor: Colors.white,
          //     child: Container(
          //       child: Image.asset(
          //         "assets/s_logo.png",
          //         height: 180,
          //         width: 182,
          //         //fit: BoxFit.contain,
          //       ),
          //     ),
          //   ),
          // ),
        ]),

        // Positioned(
        //   top: 415,
        //   left: 25,
        //   right: 25,
        //   child: SizedBox(
        //     height: 400,
        //     child: Padding(
        //       padding: EdgeInsets.all(20),
        //       child: Container(
        //         decoration: BoxDecoration(
        //             color: Colors.white,
        //             borderRadius: BorderRadius.circular(20),
        //             boxShadow: [
        //               BoxShadow(
        //                   color: Colors.black.withOpacity(0.1),
        //                   blurRadius: 15,
        //                   spreadRadius: 0),
        //             ]),
        //         child: Padding(
        //           padding: EdgeInsets.all(20),
        //           child: Column(
        //             children: [
        //               CustomButton(
        //                   onTap: () {
        //                     Navigator.of(context).push(
        //                       MaterialPageRoute(
        //                         builder: (context) => Register('2'),
        //                       ),
        //                     );
        //                   },
        //                   gradient: LinearGradient(
        //                       end: Alignment.centerLeft,
        //                       begin: Alignment.centerRight,
        //                       colors: [
        //                         AppColors.blueGrad1,
        //                         AppColors.blueGrad2,
        //                         AppColors.blueGrad3,
        //                         AppColors.blueGrad4,
        //                         AppColors.blueGrad5,
        //                         AppColors.blueGrad6,
        //                         AppColors.blueGrad7,
        //                       ])),
        //               CustomButton(
        //                   gradient: LinearGradient(
        //                       end: Alignment.centerLeft,
        //                       begin: Alignment.centerRight,
        //                       colors: [
        //                     AppColors.primary,
        //                     AppColors.secondary,
        //                   ])),
        //               // Row(
        //               //   children: [
        //               //     Expanded(
        //               //       child: GestureDetector(
        //               //         onTap: () {
        //               //           Navigator.of(context).push(
        //               //             MaterialPageRoute(
        //               //               builder: (context) => Register('2'),
        //               //             ),
        //               //           );
        //               //         },
        //               //         child: Container(
        //               //           decoration: BoxDecoration(
        //               //               borderRadius: BorderRadius.circular(10),
        //               //               gradient: LinearGradient(
        //               //                   end: Alignment.centerLeft,
        //               //                   begin: Alignment.centerRight,
        //               //                   colors: [
        //               //                     AppColors.blueGrad1,
        //               //                     AppColors.blueGrad2,
        //               //                     AppColors.blueGrad3,
        //               //                     AppColors.blueGrad4,
        //               //                     AppColors.blueGrad5,
        //               //                     AppColors.blueGrad6,
        //               //                     AppColors.blueGrad7,
        //               //                   ])),
        //               //           child: Padding(
        //               //             padding: EdgeInsets.symmetric(vertical: 15),
        //               //             child: Text('Register',
        //               //                 textAlign: TextAlign.center,
        //               //                 style: TextStyle(
        //               //                   fontFamily: 'Poppins',
        //               //                   fontSize: 15,
        //               //                   color: AppColors.white,
        //               //                   fontWeight: FontWeight.w600,
        //               //                 )),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //   ],
        //               // ),
        //               SizedBox(height: 10),
        //               Material(
        //                 borderRadius: BorderRadius.circular(10),
        //                 borderOnForeground: true,
        //                 color: Dark,
        //                 elevation: 5.0,
        //                 child: MaterialButton(
        //                   onPressed: () {
        //                     Navigator.of(context).push(
        //                       MaterialPageRoute(
        //                         builder: (context) => SignInForm(),
        //                       ),
        //                     );
        //                   },
        //                   child: Padding(
        //                     padding: EdgeInsets.symmetric(
        //                         horizontal: 15, vertical: 10),
        //                     child: Text(
        //                       'Login',
        //                       style: TextStyle(
        //                         fontFamily: 'Poppins',
        //                         fontSize: SizeConfig.blockSizeHorizontal * 4.8,
        //                         fontWeight: FontWeight.w700,
        //                         color: Colors.white,
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //               Row(
        //                 children: [
        //                   Container(
        //                     width: SizeConfig.blockSizeHorizontal * 11,
        //                     child: Divider(
        //                       thickness: 2,
        //                       color: AppColors.grey,
        //                     ),
        //                   ),
        //                   Center(
        //                     child: Text(
        //                       "Or connect with",
        //                       style: TextStyle(
        //                           letterSpacing: 2,
        //                           fontSize: 15,
        //                           color: AppColors.grey,
        //                           fontWeight: FontWeight.w400),
        //                     ),
        //                   ),
        //                   Divider(
        //                     thickness: 2,
        //                     color: Dark,
        //                   ),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // Positioned(
        //   top: SizeConfig.blockSizeVertical * 38,
        //   child: Container(
        //     child: Text(
        //       'MDT Learner Driver',
        //       style: TextStyle(
        //           letterSpacing: 1.0,
        //           fontFamily: 'Poppins',
        //           fontSize: SizeConfig.blockSizeHorizontal * 6,
        //           fontWeight: FontWeight.w600,
        //           color: Colors.black),
        //     ),
        //   ),
        // ),
        Container(
          width: SizeConfig.blockSizeHorizontal * 85,
          //height: SizeConfig.blockSizeVertical * 54,
          //color: Colors.black12,
          margin: EdgeInsets.fromLTRB(
            SizeConfig.blockSizeHorizontal * 7.5,
            SizeConfig.blockSizeVertical * 45,
            SizeConfig.blockSizeHorizontal * 7.5,
            0.0,
          ),
          child: Consumer<UserProvider>(builder: (context, authData, _) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Enter OTP Verification",
                          style: AppTextStyle.titleStyle,
                        ),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          "Please type the verification code we sent to ${widget.CountryCode} ${widget.phone}",
                          style: AppTextStyle.textStyle,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: Pinput(
                          controller: code,
                          autofocus: true,
                          length: 6,
                          defaultPinTheme: submittedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          focusedPinTheme: focusPinTheme,
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.smsRetrieverApi,
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                          onSubmitted: (pin) async {},
                        ),
                      ),
                      //SizedBox(height: 2),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          secondsRemaining == 0 ? '' : timerText,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: enableResend
                              ? () {
                                  secondsRemaining = 60;
                                  enableResend = false;
                                  setState(() {});
                                  authData.verifyPhone(
                                    context,
                                    widget.phone,
                                    isResend: true,
                                  );
                                }
                              : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don’t receive the Code? ",
                                style: AppTextStyle.textStyle.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Resend Code",
                                  style: AppTextStyle.textStyle.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(height: 15),
                    ],
                  ),
                  SizedBox(height: 15),
                  CustomButton(
                    title: "Verify OTP",
                    onTap: () {
                      var authData = context.read<UserProvider>();
                      if (code.text.isNotEmpty && code.text.length == 6) {
                        // if (authData.isForgotPassword) {
                        try {
                          loading(value: true);
                          setState(() {});
                          final PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: authData.verificationCode,
                                  smsCode: code.text);
                          FirebaseAuth.instance
                              .signInWithCredential(credential)
                              .then((value) async {
                            if (value.user != null) {
                              if (authData.isForgotPassword) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ForgotNextScreen(
                                            phone: widget.phone,
                                            countryCode: widget.CountryCode)));
                              } else if (authData.isSocialLogin) {
                                Map formParams = {
                                  'token': authData.socialToken,
                                  'social_type': authData.socialType,
                                  'social_site_id': authData.socialSiteId,
                                  'email': authData.email,
                                  'phone':
                                      "${authData.countryCode}${authData.phoneNumber}",
                                  'user_type': "2",
                                  'accessType': 'register'
                                };
                                print(
                                    "Data on submit : ${jsonEncode(formParams)}");
                                ToastContext().init(context);
                                final NavigationService _navigationService =
                                    locator<NavigationService>();

                                Map? apiResponse =
                                    await Provider.of<UserProvider>(context,
                                            listen: false)
                                        .socialLoginWithMdtRegister(formParams);
                                print(
                                    "Response from registrant 1: $apiResponse");
                                if (apiResponse != null &&
                                    apiResponse['success'] == false) {
                                  print(
                                      "Response from registrant 2 : $apiResponse");
                                  Toast.show(apiResponse['message'],
                                      duration: Toast.lengthLong,
                                      gravity: Toast.center);
                                } else {
                                  authData.googleNavigate = true;
                                  print('LOGINNNNNNNNNN');
                                  // _navigationService
                                  //     .navigateToReplacement('/Authorization');
                                  setState(() {});
                                }
                              } else {
                                await Provider.of<UserProvider>(context,
                                        listen: false)
                                    .register(deviceId: deviceId);
                                loading(value: false);
                                // 'TP1A.220624.014'!);
                                if (Provider.of<UserProvider>(context,
                                            listen: false)
                                        .notification
                                        .text !=
                                    '') {
                                  // Spinner.close(context);
                                  showValidationDialog(
                                      context,
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .notification
                                          .text);
                                }
                              }

                              loading(value: false);
                              setState(() {});
                            }
                          }).catchError((e) {
                            loading(value: false);
                            setState(() {});
                            print('HHHHHHH ${e}');
                            if (e.code == "invalid-verification-code") {
                              authData.showErrorDialog(context, "Invalid OTP");
                            } else {
                              authData.showErrorDialog(context,
                                  e.code.toString().replaceAll("-", " "));
                            }
                          });
                        } catch (e) {
                          loading(value: false);
                          setState(() {});
                        }
                      } else {
                        authData.showErrorDialog(
                            context, "Please Fill The OTP");
                      }
                    },
                  )
                ],
              ),
            );
          }),
        ),
      ],
    ));
  }

  showValidationDialog(BuildContext context, String message) {
    //print("valid");
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Smart Theory Test', style: AppTextStyle.appBarStyle),
            content: Text(
              message,
              style: AppTextStyle.disStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                  color: AppColors.black,
                  height: 1.3),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (Provider.of<UserProvider>(context, listen: false)
                          .notification
                          .text ==
                      'Registration successful, please Login into your account.') {
                    // Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Ok',
                  style: AppTextStyle.textStyle.copyWith(
                      fontSize: 16, color: Dark, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        });
  }
}
