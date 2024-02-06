import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:student_app/Constants/app_colors.dart';

import '../../custom_button.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/methods.dart';
import '../../services/password_services.dart';
import '../../services/validator.dart';
import '../../utils/appImages.dart';
import '../spinner.dart';
import 'login.dart';

class ForgotNextScreen extends StatefulWidget {
  final String phone;
  ForgotNextScreen({Key? key, required this.phone}) : super(key: key);

  @override
  State<ForgotNextScreen> createState() => _ForgotNextScreenState();
}

class _ForgotNextScreenState extends State<ForgotNextScreen> {
  final _key = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  final _passwordService = PasswordServices();

  late String code;

  late String newPassword;

  late String confirmNewPassword;

  bool showPassword = false;
  bool showConfirmPassword = false;

  FocusNode _codeFocusNode = FocusNode();

  FocusNode _newPasswordFocusNode = FocusNode();

  FocusNode _confirmNewPasswordFocusNode = FocusNode();

  showValidationDialog(BuildContext context, String message) {
    //print("valid");
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Smart Theory Test'),
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
        // Future.delayed(const Duration(seconds: 3), () {
        //   //Navigator.popUntil(context,ModalRoute.withName(routes.LoginRoute));
        //   Navigator.of(context).pop();
        //   Navigator.of(context).pop();
        //   // Navigator.of(context).pop();
        //   // Navigator.of(context).push(
        //   //   MaterialPageRoute(
        //   //     builder: (context) => ForgotNextScreen(),
        //   //   ),
        //   // );
        //   //Navigator.of(context).popAndPushNamed(StudentView.routeName);
        // });
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => SignInForm(),
                    ),
                    (route) => false);
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  Future<void> submit(BuildContext context) async {
    final form = _formKey.currentState;
    print("form state : ${form!.validate()}");
    if (form.validate()) {
      Map data = {
        //'email': widget.email,
        'phone': widget.phone,

        'password': newPassword,
        'password_confirmation': confirmNewPassword,
        'user_type': '2',
      };
      print("Data: $data");
      if (newPassword != confirmNewPassword) {
        showValidationDialog(context, "Confirm password doesn't match");
      }

      Spinner.showSpinner(context, "Saving");
      Future.delayed(Duration(seconds: 2));
      _passwordService.resetForgotPassword(data).then((res) {
        if (res["success"] == false) {
          Spinner.close(context);
          //showValidationDialog(context, res["message"]);
        } else {
          Spinner.close(context);
          showSuccessDialog(context, res["message"]);
        }
        print("Response: $res");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.email);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return PopScope(
      onPopInvoked: (didPop) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignInForm(),
          )),
      child: Scaffold(
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
                  Image.asset(
                    AppImages.bgLogin,
                    //height: 300,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                  ),
                  // Positioned(
                  //     left: 25,
                  //     top: SizeConfig.blockSizeVertical * 8,
                  //     child: backArrowCustom()),
                  Positioned(
                    top: SizeConfig.blockSizeVertical * 18,
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
                    height: SizeConfig.blockSizeVertical * 54,
                    //color: Colors.black12,
                    margin: EdgeInsets.fromLTRB(
                      SizeConfig.blockSizeHorizontal * 7.5,
                      SizeConfig.blockSizeVertical * 40,
                      SizeConfig.blockSizeHorizontal * 7.5,
                      0.0,
                    ),
                    child: ListView(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // CustomTextField(
                            //   label: 'Enter Verification Code',
                            //   heading: 'Enter Code',
                            //   validator: (value) {
                            //     code = value!.trim();
                            //     return Validate.requiredField(
                            //         code, "Code is required");
                            //   },
                            //   onChange: (val) {
                            //     if (!_formKey.currentState!.validate()) {
                            //       Validate.requiredField(val, "Code is required");
                            //     }
                            //   },
                            //   onFieldSubmitted: (_) {
                            //     setFocus(context,
                            //         focusNode: _newPasswordFocusNode);
                            //   },
                            //   focusNode: _codeFocusNode,
                            //   keyboardType: TextInputType.number,
                            //   textInputAction: TextInputAction.next,
                            // ),
                            CustomTextField(
                              label: 'New Password',
                              heading: 'New Password',
                              suffixIcon: Icon(
                                showPassword ? Icons.remove_red_eye_outlined : Icons.visibility_off,
                                // color: Dark,
                              ),
                              suffixOnTap: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              obscureText: !showPassword,
                              validator: (value) {
                                newPassword = value!.trim();
                                return Validate.requiredField(newPassword, "Password is required");
                              },
                              onChange: (val) {
                                if (!_formKey.currentState!.validate()) {
                                  Validate.requiredField(val, "Password is required");
                                }
                              },
                              onFieldSubmitted: (_) {
                                setFocus(context, focusNode: _confirmNewPasswordFocusNode);
                              },
                              focusNode: _newPasswordFocusNode,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                            ),
                            CustomTextField(
                              label: 'Reset Password',
                              heading: 'Reset Password',
                              suffixIcon: Icon(
                                showConfirmPassword ? Icons.remove_red_eye_outlined : Icons.visibility_off,
                                // color: Dark,
                              ),
                              suffixOnTap: () {
                                setState(() {
                                  showConfirmPassword = !showConfirmPassword;
                                });
                              },
                              obscureText: !showConfirmPassword,
                              validator: (value) {
                                confirmNewPassword = value!.trim();
                                return Validate.requiredField(confirmNewPassword, "Confirm password is required");
                              },
                              onChange: (val) {
                                if (!_formKey.currentState!.validate()) {
                                  Validate.requiredField(val, "confirm password is required");
                                }
                              },
                              onFieldSubmitted: (_) {
                                setFocus(context, focusNode: null);
                                submit(context);
                              },
                              focusNode: _confirmNewPasswordFocusNode,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                            ),
                            SizedBox(height: 40),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 60),
                              child: CustomButton(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                title: 'Reset Password',
                                onTap: () {
                                  submit(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
    path0.quadraticBezierTo(size.width * 0.15, size.height * 0.52, size.width, size.height * 0.25);
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
