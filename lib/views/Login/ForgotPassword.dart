import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:student_app/Constants/app_colors.dart';
import 'package:student_app/custom_button.dart';
import 'package:student_app/views/Login/forgot_next_screen.dart';
import 'package:student_app/views/Login/login.dart';

import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/methods.dart';
import '../../services/password_services.dart';
import '../../services/validator.dart';
import '../../utils/appImages.dart';
import '../spinner.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);
  final _key = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _passwordService = PasswordServices();

  late String email;

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
              builder: (context) => ForgotNextScreen(email: email),
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
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var width = MediaQuery.of(context).size.width;
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
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
                    AppImages.bgRegister,
                    //height: 300,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                  ),
                  Positioned(
                    top: SizeConfig.blockSizeVertical * 25,
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 40),
                      CustomTextField(
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
                      ),
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 80,
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 4.8),
                        //color: Colors.black12,
                        child: CustomButton(
                            title: 'Send Code',
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submit(BuildContext context) async {
    final form = _formKey.currentState;
    print("form state : ${form!.validate()}");
    if (form.validate()) {
      Map data = {
        'email': email,
        'user_type': '2',
      };
      Spinner.showSpinner(context, "Sending code");
      //print(data);
      Future.delayed(Duration(seconds: 2));
      _passwordService.forgotPassword(data).then((res) {
        if (res["success"] == false) {
          Spinner.close(context);
          showValidationDialog(context, res["error"]);
        } else {
          Spinner.close(context);
          showSuccessDialog(context, res["message"]);
        }
        print("Response: $res");
      });
    }
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
    path0.quadraticBezierTo(
        size.width * 0.15, size.height * 0.42, size.width, size.height * 0.25);
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
    path1.quadraticBezierTo(
        size.width * 0.2, size.height * 0.35, size.width, size.height * 0.13);
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
