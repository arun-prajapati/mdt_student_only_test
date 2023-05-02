import 'dart:convert';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:student_app/Constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:student_app/views/Login/ForgotPassword.dart';
import 'package:student_app/views/Login/register.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../enums/Autentication_status.dart';
import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/auth.dart';
import '../../services/methods.dart';
import '../../services/navigation_service.dart';
import '../../services/validator.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final NavigationService _navigationService = locator<NavigationService>();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  late String email;
  // late String password;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String usertype = '2';
  String? deviceId;
  Future<Map> getDeviceInfo() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    return androidInfo.toMap();
  }

  TextEditingController password = TextEditingController();

  Future<String?> getId() async {
    deviceId = await PlatformDeviceId.getDeviceId;
    return deviceId;
  }

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

  showDeviceExistDialog(BuildContext context, String userName, String contact) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Mock Driving Test'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Hey there ${userName.substring(0, 1).toUpperCase() + userName.substring(1)}"),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 1.5,
                ),
                Text(
                    'You seem to have changed your phone. Please contact our support team to connect your new phone to the app.'),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 1.5,
                ),
                Text('Thanks'),
              ],
            ),
            //Text('${userName.substring(0,1).toUpperCase()+userName.substring(1)} $contact'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
              TextButton(
                onPressed: () {
                  launchUrl(
                    Uri(
                      scheme: 'tel',
                      path: '$contact',
                    ),
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: const Text('CALL NOW'),
              ),
            ],
            actionsAlignment: MainAxisAlignment.start,
            contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 1.0),
          );
        });
  }

  Future<void> submit() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      await Provider.of<AuthProvider>(context, listen: false)
          .login(email, password.text, usertype, deviceId!);
      if (Provider.of<AuthProvider>(context, listen: false).notification.text !=
              'device-exist' &&
          Provider.of<AuthProvider>(context, listen: false).notification.text !=
              '') {
        showValidationDialog(
            context,
            Provider.of<AuthProvider>(context, listen: false)
                .notification
                .text);
      }
      if (Provider.of<AuthProvider>(context, listen: false).notification.text ==
          'device-exist') {
        showDeviceExistDialog(
            context,
            Provider.of<AuthProvider>(context, listen: false).userName,
            Provider.of<AuthProvider>(context, listen: false).contact);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _emailFocusNode = new FocusNode();
    _passwordFocusNode = new FocusNode();
    getDeviceInfo()
        .then((value) => log('Running on ${jsonEncode(value['androidId'])}'));
    getId().then((value) => log('Running on ${value}'));
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserRepository>(context);
    //var width = MediaQuery.of(context).size.width;
    //var height = MediaQuery.of(context).size.height;
    TextStyle defaultStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: SizeConfig.blockSizeHorizontal * 4.5,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
    TextStyle linkStyle = TextStyle(
      color: Dark,
      fontSize: SizeConfig.blockSizeHorizontal * 4.2,
      fontWeight: FontWeight.w500,
    );
    var width = MediaQuery.of(context).size.width;
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return new Scaffold(
      backgroundColor: Colors.white,
      key: _key,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            height: Responsive.height(100, context),
            //color: Colors.black12,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
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
                //       style:
                //           // GoogleFonts.caveat(
                //           //   fontSize: SizeConfig.blockSizeHorizontal * 8,
                //           //   color: Colors.black,
                //           //   fontWeight: FontWeight.bold,
                //           //   letterSpacing: 1.0,
                //           // ),
                //           TextStyle(
                //         letterSpacing: 1.0,
                //         fontFamily: 'Poppins',
                //         fontSize: SizeConfig.blockSizeHorizontal * 6,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.black,
                //       ),
                //     ),
                //   ),
                // ),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 85,
                  height: SizeConfig.blockSizeVertical * 54,
                  margin: EdgeInsets.fromLTRB(
                    SizeConfig.blockSizeHorizontal * 7.5,
                    SizeConfig.blockSizeVertical * 40,
                    SizeConfig.blockSizeHorizontal * 7.5,
                    0.0,
                  ),
                  //color: Colors.black12,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        //alignment: Alignment.centerLeft,
                        child: Text(
                          'Welcome back!',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: SizeConfig.blockSizeHorizontal * 5.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      //Field 1
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
                              borderSide:
                                  const BorderSide(color: Dark, width: 2),
                            ),
                            labelText: 'Email/Phone Number',
                            labelStyle: TextStyle(
                              color: Colors.blueGrey,
                            ),
                            floatingLabelStyle: TextStyle(color: Dark),
                            // errorStyle: TextStyle(
                            //     fontSize: constraints.maxWidth * 0.05),
                            prefixIcon: const Icon(
                              Icons.mail,
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
                          ),
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                          ),
                          validator: (value) {
                            email = value!.trim();
                            return Validate.validateEmail(value);
                          },
                          onChanged: (val) {
                            if (!_formKey.currentState!.validate()) {
                              Validate.validateEmail(val);
                            }
                          },
                          onFieldSubmitted: (_) =>
                              setFocus(context, focusNode: _passwordFocusNode),
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          //textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                      //Field 2
                      Container(
                          width: SizeConfig.blockSizeHorizontal * 80,
                          margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 2,
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
                              labelText: 'Password',
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
                              // errorStyle: validationStyle,
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
                            ),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            validator: (value) {
                              password.text = value!.trim();
                              return Validate.passwordValidation(value);
                            },
                            onChanged: (val) {
                              if (!_formKey.currentState!.validate()) {
                                Validate.passwordValidation(val);
                              }
                            },
                            obscureText: true,
                            onFieldSubmitted: (_) => submit(),
                            focusNode: _passwordFocusNode,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                          )
                          // TextFormField(
                          //   cursorColor: Dark,
                          //   controller: password,
                          //   decoration: InputDecoration(
                          //     contentPadding: EdgeInsets.symmetric(
                          //       vertical: SizeConfig.blockSizeVertical * 2,
                          //     ),
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.all(
                          //         Radius.circular(25),
                          //       ),
                          //       borderSide: BorderSide(
                          //         color: Dark,
                          //         width: 2,
                          //       ),
                          //     ),
                          //     enabledBorder: OutlineInputBorder(
                          //       borderRadius: BorderRadius.all(
                          //         Radius.circular(25),
                          //       ),
                          //       borderSide: const BorderSide(
                          //         color: Dark,
                          //         width: 2,
                          //       ),
                          //     ),
                          //     disabledBorder: OutlineInputBorder(
                          //       borderRadius: BorderRadius.all(
                          //         Radius.circular(25),
                          //       ),
                          //       borderSide: const BorderSide(
                          //           color: Colors.black, width: 2),
                          //     ),
                          //     labelText: 'Password',
                          //     labelStyle: TextStyle(
                          //       color: Colors.blueGrey,
                          //     ),
                          //     floatingLabelStyle: TextStyle(color: Dark),
                          //     // errorStyle: TextStyle(
                          //     //     fontSize: constraints.maxWidth * 0.05),
                          //     prefixIcon: const Icon(
                          //       Icons.key,
                          //       color: Dark,
                          //     ),
                          //     errorBorder: OutlineInputBorder(
                          //       borderRadius: BorderRadius.all(
                          //         Radius.circular(25),
                          //       ),
                          //       borderSide:
                          //           const BorderSide(color: Dark, width: 2),
                          //     ),
                          //     focusColor: Dark,
                          //     focusedBorder: OutlineInputBorder(
                          //       borderRadius: BorderRadius.all(
                          //         Radius.circular(25),
                          //       ),
                          //       borderSide:
                          //           const BorderSide(color: Dark, width: 2),
                          //     ),
                          //     focusedErrorBorder: OutlineInputBorder(
                          //       borderRadius: BorderRadius.all(
                          //         Radius.circular(25),
                          //       ),
                          //       borderSide:
                          //           const BorderSide(color: Dark, width: 2),
                          //     ),
                          //   ),
                          //   style: TextStyle(
                          //     fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                          //   ),
                          //   validator: (value) {
                          //     password.text = value!.trim();
                          //     return Validate.passwordValidation(password.text);
                          //   },
                          //   onChanged: (val) {
                          //     if (!_formKey.currentState!.validate()) {
                          //       Validate.passwordValidation(val);
                          //     }
                          //   },
                          //   onFieldSubmitted: (_) => submit(),
                          //   focusNode: _passwordFocusNode,
                          //   obscureText: true,
                          //   keyboardType: TextInputType.text,
                          //   textInputAction: TextInputAction.done,
                          //   //textAlignVertical: TextAlignVertical.center,
                          // ),
                          ),
                      //Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ForgotPassword(),
                              ),
                            );
                            print('FORGOT T*/////');
                            password.clear();
                          },
                          child: Container(
                            //color: Colors.red,
                            //width: constraints.maxWidth * 0.45,
                            margin: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 1,
                              right: SizeConfig.blockSizeHorizontal * 5,
                            ),
                            //alignment: Alignment.bottomRight,
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: SizeConfig.blockSizeHorizontal * 4.8,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Provider.of<AuthProvider>(context).status ==
                              Status.Authenticating
                          ? const Center(child: CircularProgressIndicator())
                          : Container(
                              // height: constraints.maxHeight * 0.11,
                              width: SizeConfig.blockSizeHorizontal * 50,
                              margin: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 5),
                              child: Material(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                ),
                                color: Dark,
                                elevation: 5.0,
                                child: MaterialButton(
                                  onPressed: submit,
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 5,
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromRGBO(255, 255, 255, 1.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      Container(
                        //color: Colors.black26,
                        //width: constraints.maxWidth * 0.8,
                        margin: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 2.5,
                          top: SizeConfig.blockSizeVertical * 3,
                        ),
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account yet?',
                            style: defaultStyle,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 2.5,
                          top: SizeConfig.blockSizeVertical * 0.5,
                        ),
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                              text: 'Register here',
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => Register('1'),
                                    ),
                                  );
                                }),
                        ),
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
