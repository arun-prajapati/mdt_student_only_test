import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:student_app/Constants/app_colors.dart';

import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/methods.dart';
import '../../services/password_services.dart';
import '../../services/validator.dart';
import '../spinner.dart';

class ForgotNextScreen extends StatefulWidget {
  final String email;
  ForgotNextScreen({Key? key, required this.email}) : super(key: key);

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
          //Navigator.popUntil(context,ModalRoute.withName(routes.LoginRoute));
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => ForgotNextScreen(),
          //   ),
          // );
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

  Future<void> submit(BuildContext context) async {
    final form = _formKey.currentState;
    print("form state : ${form!.validate()}");
    if (form.validate()) {
      Map data = {
        'email': widget.email,
        'code': code,
        'password': newPassword,
        'confirm_password': confirmNewPassword,
        'user_type': '2',
      };
      print("Data: $data");
      if (newPassword != confirmNewPassword) {
        showValidationDialog(context, "Confirm password doesn't match");
      }

      Spinner.showSpinner(context, "Saving");
      // //print(data);
      Future.delayed(Duration(seconds: 2));
      _passwordService.verifyCode(data).then((res) {
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

  @override
  Widget build(BuildContext context) {
    //print(widget.email);
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
                CustomPaint(
                  size: Size(width, height),
                  painter: HeaderPainter(),
                ),
                Positioned(
                  top: SizeConfig.blockSizeVertical * 20,
                  left: SizeConfig.blockSizeHorizontal * 30,
                  child: CircleAvatar(
                    radius: SizeConfig.blockSizeHorizontal * 20,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: SizeConfig.blockSizeHorizontal * 18,
                      child: Container(
                          child: Image.asset(
                        "assets/logo_app.png",
                        height: SizeConfig.blockSizeVertical * 33,
                        width: SizeConfig.blockSizeHorizontal * 33,
                        fit: BoxFit.contain,
                      )),
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
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 80,
                            margin: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 3,
                            ),
                            child: TextFormField(
                              cursorColor: Dark,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.blockSizeVertical * 2,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  borderSide: BorderSide(
                                    color: Dark,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  borderSide: const BorderSide(
                                    color: Dark,
                                    width: 2,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 2),
                                ),
                                labelText: 'Enter Verification Code',
                                labelStyle: TextStyle(
                                  color: Colors.blueGrey,
                                ),
                                floatingLabelStyle: TextStyle(color: Dark),
                                // errorStyle: TextStyle(
                                //     fontSize: constraints.maxWidth * 0.05),
                                prefixIcon: const Icon(
                                  Icons.numbers,
                                  color: Dark,
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  borderSide:
                                      const BorderSide(color: Dark, width: 2),
                                ),
                                focusColor: Dark,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  borderSide:
                                      const BorderSide(color: Dark, width: 2),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  borderSide:
                                      const BorderSide(color: Dark, width: 2),
                                ),
                                errorStyle: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                              ),
                              validator: (value) {
                                code = value!.trim();
                                return Validate.requiredField(
                                    code, "Code is required");
                              },
                              onFieldSubmitted: (_) {
                                setFocus(context,
                                    focusNode: _newPasswordFocusNode);
                              },
                              focusNode: _codeFocusNode,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              //textAlignVertical: TextAlignVertical.center,
                            ),
                          ),
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 80,
                            margin: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 2,
                            ),
                            child: TextFormField(
                              cursorColor: Dark,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Dark,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.blockSizeVertical * 2,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  borderSide: BorderSide(
                                    color: Dark,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  borderSide: const BorderSide(
                                    color: Dark,
                                    width: 2,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 2),
                                ),
                                labelText: 'New Password',
                                labelStyle: TextStyle(
                                  color: Colors.blueGrey,
                                ),
                                floatingLabelStyle: TextStyle(color: Dark),
                                // errorStyle: TextStyle(
                                //     fontSize: constraints.maxWidth * 0.05),
                                prefixIcon: const Icon(
                                  Icons.key,
                                  color: Dark,
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  borderSide:
                                      const BorderSide(color: Dark, width: 2),
                                ),
                                focusColor: Dark,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  borderSide:
                                      const BorderSide(color: Dark, width: 2),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  borderSide:
                                      const BorderSide(color: Dark, width: 2),
                                ),
                                errorStyle: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              obscureText: !showPassword,
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                              ),
                              validator: (value) {
                                newPassword = value!.trim();
                                return Validate.requiredField(
                                    newPassword, "Password is required");
                              },
                              onFieldSubmitted: (_) {
                                setFocus(context,
                                    focusNode: _confirmNewPasswordFocusNode);
                              },
                              focusNode: _newPasswordFocusNode,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              //textAlignVertical: TextAlignVertical.center,
                            ),
                          ),
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 80,
                            margin: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 2,
                            ),
                            child: TextFormField(
                              cursorColor: Dark,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    showConfirmPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Dark,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showConfirmPassword =
                                          !showConfirmPassword;
                                    });
                                  },
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.blockSizeVertical * 2,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  borderSide: BorderSide(
                                    color: Dark,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  borderSide: const BorderSide(
                                    color: Dark,
                                    width: 2,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 2),
                                ),
                                labelText: 'Confirm new password',
                                labelStyle: TextStyle(
                                  color: Colors.blueGrey,
                                ),
                                floatingLabelStyle: TextStyle(color: Dark),
                                // errorStyle: TextStyle(
                                //     fontSize: constraints.maxWidth * 0.05),
                                prefixIcon: const Icon(
                                  Icons.key,
                                  color: Dark,
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  borderSide:
                                      const BorderSide(color: Dark, width: 2),
                                ),
                                focusColor: Dark,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  borderSide:
                                      const BorderSide(color: Dark, width: 2),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  borderSide:
                                      const BorderSide(color: Dark, width: 2),
                                ),
                                errorStyle: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              obscureText: !showConfirmPassword,
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                              ),
                              validator: (value) {
                                confirmNewPassword = value!.trim();
                                return Validate.requiredField(
                                    confirmNewPassword,
                                    "Confirm password is required");
                              },
                              onFieldSubmitted: (_) {
                                setFocus(context, focusNode: null);
                                submit(context);
                              },
                              focusNode: _confirmNewPasswordFocusNode,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              //textAlignVertical: TextAlignVertical.center,
                            ),
                          ),
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 55,
                            margin: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 5,
                            ),
                            //color: Colors.black12,
                            child: Material(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(25),
                                topRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                              ),
                              borderOnForeground: true,
                              color: Dark,
                              elevation: 5.0,
                              child: MaterialButton(
                                onPressed: () {
                                  submit(context);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Text(
                                    'Reset password',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4.5,
                                      //fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
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
    path0.quadraticBezierTo(
        size.width * 0.15, size.height * 0.52, size.width, size.height * 0.25);
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
