import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:student_app/Constants/app_colors.dart';
import 'package:student_app/custom_button.dart';
import 'package:student_app/services/auth.dart';
import 'package:student_app/utils/app_colors.dart';
import 'package:student_app/views/Login/forgot_next_screen.dart';
import 'package:student_app/views/Login/register.dart';

import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/methods.dart';
import '../../services/password_services.dart';
import '../../services/validator.dart';
import '../../utils/appImages.dart';
import '../spinner.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _key = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  final _passwordService = PasswordServices();

  final TextEditingController phoneTextControl = TextEditingController();
  final TextEditingController code = TextEditingController();

  String? email;

  var mobile = '';
  var countryCode = '+91';
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

  showValidationDialog(BuildContext context, String message) {
    //print("valid");
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Mock Driving Test'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }

  showSuccessDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 3), () {
          //Spinner.close(context);
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ForgotNextScreen(email: email ?? ""),
            ),
          );
          //Navigator.of(context).popAndPushNamed(StudentView.routeName);
        });
        return AlertDialog(
          titlePadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          title: SizedBox(
            child: Image.asset('assets/tick.gif'),
            width: 100,
            height: 100,
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // submit(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            height: Responsive.height(100, context),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Stack(children: [
                  Image.asset(
                    AppImages.bgLogin,
                    //height: 300,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                  ),
                  Positioned(left: 25, top: SizeConfig.blockSizeVertical * 8, child: backArrowCustom()),
                  Positioned(
                    top: SizeConfig.blockSizeVertical * 15,
                    left: SizeConfig.blockSizeHorizontal * 28,
                    child: CircleAvatar(
                      radius: SizeConfig.blockSizeHorizontal * 22,
                      backgroundColor: Colors.white,
                      child: Container(
                        child: Image.asset(
                          "assets/stt_Logo.png",
                          height: 180,
                          width: 182,
                          //fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
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
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 40),
                        /*   CustomTextField(
                            label: 'Email',
                            // prefixIcon: const Icon(
                            //   Icons.mail,
                            //   color: Dark,
                            // ),
                            validator: (value) {
                              email = value!.trim();
                              print('VALL  //////      $value');
                              return Validate.validateEmail(email);
                            },
                            onChange: (val) {
                              if (!_formKey.currentState!.validate()) {
                                Validate.validateEmail(val);
                              }
                            },
                            onFieldSubmitted: (_) {
                              setFocus(context, focusNode: null);
                              submit(context);
                            },
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                          ),*/
                        authData.isSendOtp
                            ? Center(
                                child: Pinput(
                                  controller: code,
                                  autofocus: true,
                                  length: 6,
                                  defaultPinTheme: submittedPinTheme,
                                  submittedPinTheme: submittedPinTheme,
                                  focusedPinTheme: focusPinTheme,
                                  androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
                                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                                  showCursor: true,
                                  onSubmitted: (pin) async {},
                                ),
                              )
                            : IntlPhoneField(
                                onCountryChanged: (c) {
                                  countryCode = c.dialCode;
                                  print("Code :: ${countryCode}");
                                },
                                autofocus: false,
                                textAlign: TextAlign.left,
                                dropdownIcon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
                                dropdownIconPosition: IconPosition.trailing,
                                flagsButtonMargin: EdgeInsets.only(left: 10),
                                //disableLengthCheck: true,
                                autovalidateMode: AutovalidateMode.disabled,
                                //disableLengthCheck: true,
                                controller: phoneTextControl,
                                cursorColor: Dark,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  counterText: "",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(color: AppColors.black.withOpacity(0.5), width: 1.1),
                                  ),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: AppColors.black.withOpacity(0.5), width: 1.1)),
                                  disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: AppColors.black.withOpacity(0.5), width: 1.1)),
                                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: AppColors.black.withOpacity(0.5), width: 1.1)),
                                  focusColor: Dark,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(color: AppColors.black.withOpacity(0.5), width: 1.1),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(color: AppColors.black.withOpacity(0.5), width: 1.1),
                                  ),
                                  hintStyle: AppTextStyle.disStyle.copyWith(color: AppColors.grey, fontWeight: FontWeight.w400),
                                  hintText: 'Enter Mobile Number',
                                  errorStyle: AppTextStyle.textStyle.copyWith(color: AppColors.red1),
                                  floatingLabelStyle: TextStyle(color: Dark),
                                  // errorStyle: TextStyle(
                                  //     fontSize: constraints.maxWidth * 0.05),
                                ),
                                initialCountryCode: 'IN',
                                // showCountryFlag: false,
                                keyboardType: TextInputType.phone,
                                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                style: AppTextStyle.textStyle,
                                onSubmitted: (_) {
                                  setFocus(context, focusNode: null);
                                  submit(context);
                                },

                                // onSubmitted: (_) {
                                //   setFocus(context, focusNode: _addressFocusNode);
                                // },
                                onChanged: (phone) {
                                  print(phone);

                                  Validate.validateEmail(phoneTextControl.text);
                                  setState(() {
                                    mobile = phone.completeNumber;
                                    phoneTextControl.selection = TextSelection.fromPosition(TextPosition(offset: phoneTextControl.text.length));
                                    countryCode = phone.countryCode;
                                  });
                                },
                              ),
                        Container(
                          width: SizeConfig.blockSizeHorizontal * 80,
                          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 4.8),
                          //color: Colors.black12,
                          child: loadingValue
                              ? Center(child: CircularProgressIndicator(color: Dark))
                              : CustomButton(
                                  title: authData.isSendOtp ? 'Verify Code' : 'Send Code',
                                  onTap: () {
                                    submit(context);
                                  }),
                          // Material(
                          //   borderRadius: BorderRadius.circular(25),
                          //   borderOnForeground: true,
                          //   color: Dark,
                          //   elevation: 5.0,
                          //   child: MaterialButton(
                          //     onPressed: () {
                          //       submit(context);
                          //     },
                          //     child: Padding(
                          //       padding: EdgeInsets.symmetric(
                          //           horizontal: 15, vertical: 10),
                          //       child: Text(
                          //         'Send Code',
                          //         style: TextStyle(
                          //           fontFamily: 'Poppins',
                          //           fontSize: SizeConfig.blockSizeHorizontal * 5,
                          //           fontWeight: FontWeight.w700,
                          //           color: Colors.white,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool loadingValue = false;

  Future<void> submit(BuildContext context) async {
    Map<String, dynamic> formData = {
      "phone": phoneTextControl.text.trim(),
      "user_type": "2",
    };

    /// https://mdt.developersforflutter.com/api/verify-mobile

    final form = _formKey.currentState;
    print("form state : ${form!.validate()}");
    var authData = context.read<UserProvider>();

    if (form.validate() && phoneTextControl.text.isNotEmpty) {
      if (!authData.isSendOtp) {
        print('PPPPPPPPPPPPPP');
        Provider.of<UserProvider>(context, listen: false).verifyPhone(context, countryCode, phoneTextControl.text);
      } else {
        try {
          loadingValue = true;
          setState(() {});
          final PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: authData.verificationCode, smsCode: code.text);
          FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
            if (value.user != null) {
              loadingValue = false;
              setState(() {});
              Map data = {
                'email': code.text,
                'user_type': '2',
              };
              Spinner.showSpinner(context, "Sending code");
              //print(data);
//              Future.delayed(Duration(seconds: 2));

              // _passwordService.forgotPassword(data).then((res) {
              //   log("!!!!!!!!!!!!!! $res");
              //
              //   if (res["success"] == false) {
              //     Spinner.close(context);
              //     showValidationDialog(context, res["error"]);
              //   } else {
              //     Spinner.close(context);
              //     showSuccessDialog(context, res["error"]);
              //   }
              //   print("Response: $res");
              // });
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ForgotNextScreen(email: '${countryCode} ${phoneTextControl.text}')));
            }
          }).catchError((e) {
            loadingValue = false;
            setState(() {});
            print('HHHHHHH ${e.code}');
            if (e.code == "invalid-verification-code") {
              authData.showErrorDialog(context, "Invalid OTP");
            } else {
              authData.showErrorDialog(context, e.code.toString().replaceAll("-", " "));
            }
          });
        } catch (e) {
          loadingValue = false;
          setState(() {});
        }
      }
    }

    /* Future.delayed(Duration(seconds: 2));
    _passwordService.verifyNumber(formData).then((res) {
      if (res["success"] == false) {
        Spinner.close(context);
        print("ERROE");
        showValidationDialog(context, res["message"]);
      } else {
        Spinner.close(context);
        showSuccessDialog(context, res["message"]);
        print("SUCCESS");

      }
    });*/

    /*if (response.body == false) {
      print("LOGIN");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The phone must be a valid phone number.'),
        ),
      );
    } else {
      print("FAILED");




    }*/
  }
}

class HeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      //..color = TestColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;
    paint0.shader = ui.Gradient.linear(
      Offset(size.width * 0.5, -size.height * 0.05),
      Offset(size.width, size.height * 0.10),
      [Light, Dark],
      [0.00, 0.70],
    );

    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.lineTo(0, size.height * 0.21);
    path0.quadraticBezierTo(size.width * 0.15, size.height * 0.42, size.width, size.height * 0.25);
    path0.quadraticBezierTo(size.width, size.height * 0.15, size.width, 0);
    //path0.lineTo(0,0);
    path0.close();

    canvas.drawPath(path0, paint0);

    Paint paint1 = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    paint1.shader = ui.Gradient.linear(
      Offset(size.width * 0.5, -size.height * 0.05),
      Offset(size.width, size.height * 0.10),
      [Light, Dark],
      [0.00, 0.70],
    );

    Path path1 = Path();
    path1.moveTo(0, 0);
    path1.lineTo(0, size.height * 0.20);
    path1.quadraticBezierTo(size.width * 0.2, size.height * 0.35, size.width, size.height * 0.13);
    path1.quadraticBezierTo(size.width, size.height * 0.22, size.width, 0);
    path1.lineTo(0, 0);
    path1.close();

    canvas.drawPath(path1, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
