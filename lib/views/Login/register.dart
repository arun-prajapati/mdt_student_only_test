import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:platform_device_id/platform_device_id.dart';
import 'package:student_app/Constants/app_colors.dart';
import 'package:student_app/views/Login/login.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/auth.dart';
import '../../services/methods.dart';
import '../../services/navigation_service.dart';
import '../../services/validator.dart';

class Register extends StatefulWidget {
  late String user;
  Register(this.user);
  @override
  _RegisterState createState() => _RegisterState(this.user);
}

class _RegisterState extends State<Register> {
  final NavigationService _navigationService = locator<NavigationService>();
  _RegisterState(this.user);

//  TextEditingController _name;
//  TextEditingController _email;
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmpassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  late FocusNode _emailPhoneFocusNode;
  late FocusNode _nameFocusNode;
  late FocusNode _passwordFocusNode;
  late FocusNode _confirmPasswordFocusNode;
  late String name;
  late String email;
  late String password;
  late String passwordConfirm;
  late String message = '';
  late String deviceType;
  String? deviceId;
  // Declare this variable
  String user;
  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Map response = new Map();

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
                  if (Provider.of<AuthProvider>(context, listen: false).notification.text == 'Registration successful, please verify your account.') {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => SignInForm(),
                      ),
                    );
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(color: Dark, fontSize: 18),
                ),
              ),
            ],
          );
        });
  }

  Future<void> submit() async {
    print('good');
    final form = _formKey.currentState;
    if (form!.validate()) {
      //response = await Provider.of<AuthProvider>(context, listen: false).register(name, email, password, passwordConfirm, user, deviceType, deviceId!);
      response = await Provider.of<AuthProvider>(context, listen: false)
          .register(
          name: name,
          email: email,
          password: password,
          passwordConfirm: passwordConfirm,
          userType: "2",
          deviceType: deviceType,
          deviceId: deviceId!);
      if (Provider.of<AuthProvider>(context, listen: false).notification.text != '') {
        // Spinner.close(context);
        showValidationDialog(context, Provider.of<AuthProvider>(context, listen: false).notification.text);
      }
    }
  }

  Map deviceData = {};

  Future<Map> getDeviceInfo() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    return androidInfo.toMap();
  }

  Future<String?> getId() async {
    //  deviceId = await PlatformDeviceId.getDeviceId;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = await iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = await androidDeviceInfo.id; // unique ID on Android
    }

    //deviceId = Uuid().v4();

    return deviceId;
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      print("android");
      deviceType = "android";
      getDeviceInfo().then((value) => log('Running on ${jsonEncode(value['androidId'])}'));
      getId().then((value) => log('Running on ${value}'));
    }
    if (Platform.isIOS) {
      print("iOS");
      deviceType = "iOS";
      getId().then((value) => log('Running on ${value}'));
    }
    //deviceType = "";
    _nameFocusNode = new FocusNode();
    _emailPhoneFocusNode = new FocusNode();
    _passwordFocusNode = new FocusNode();
    _confirmPasswordFocusNode = new FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    print("Register through $deviceType");
    SizeConfig().init(context);

    TextStyle validationStyle = TextStyle(fontSize: 16, color: Colors.red);
    TextStyle defaultStyle = const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
    TextStyle linkStyle = const TextStyle(color: Dark, fontSize: 16, fontWeight: FontWeight.w500);
/*
reg data
{name: newww, email_phone: new@gmail.com, password: 123456, password_confirmation: 123456, user_type: 2, device_type: android, device_id: e5d24768ae0746ea}
*/
    return new Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            height: Responsive.height(100, context),
            //color: Colors.transparent,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                CustomPaint(
                  size: Size(width, height),
                  painter: RegisterHeaderPainter(),
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
                //   top: SizeConfig.blockSizeVertical * 37,
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
                Positioned(
                  top: SizeConfig.blockSizeVertical * 42,
                  child: Container(
                    //alignment: Alignment.centerLeft,
                    child: Text(
                      'Welcome!',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 23, fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 85,
                  height: SizeConfig.blockSizeVertical * 53,
                  margin: EdgeInsets.fromLTRB(
                    SizeConfig.blockSizeHorizontal * 7.5,
                    SizeConfig.blockSizeVertical * 46,
                    SizeConfig.blockSizeHorizontal * 7.5,
                    0.0,
                  ),
                  //color: Colors.black12,
                  // padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*2),
                  child: Column(
                    children: [
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 85,
                        height: SizeConfig.blockSizeVertical * 43,
                        //SizeConfig.blockSizeVertical * 55,
                        child: ListView(
                          padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 0.5, bottom: SizeConfig.blockSizeVertical * 1),
                          children: [
                            Column(
                              children: [
                                //Field 1
                                Container(
                                  width: SizeConfig.blockSizeHorizontal * 80,
                                  margin: EdgeInsets.only(
                                    top: SizeConfig.blockSizeVertical * 1,
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
                                      errorStyle: validationStyle,
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        borderSide: const BorderSide(color: Colors.black, width: 2),
                                      ),
                                      labelText: 'Full Name',
                                      labelStyle: TextStyle(
                                        color: Colors.blueGrey,
                                      ),
                                      floatingLabelStyle: TextStyle(color: Dark),
                                      // errorStyle: TextStyle(
                                      //     fontSize: constraints.maxWidth * 0.05),
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: Dark,
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        borderSide: const BorderSide(color: Dark, width: 2),
                                      ),
                                      focusColor: Dark,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        borderSide: const BorderSide(color: Dark, width: 2),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        borderSide: const BorderSide(color: Colors.black, width: 2),
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                    validator: (value) {
                                      name = value!.trim();
                                      return Validate.nameValidation(name);
                                    },
                                    onChanged: (val) {
                                      if (!_formKey.currentState!.validate()) {
                                        Validate.nameValidation(val);
                                      }
                                    },
                                    onFieldSubmitted: (_) => setFocus(context, focusNode: _emailPhoneFocusNode),
                                    focusNode: _nameFocusNode,
                                    keyboardType: TextInputType.text,
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
                                      errorStyle: validationStyle,
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
                                        borderSide: const BorderSide(color: Colors.black, width: 2),
                                      ),
                                      labelText: 'Email',
                                      labelStyle: TextStyle(
                                        color: Colors.blueGrey,
                                      ),
                                      floatingLabelStyle: TextStyle(color: Dark),
                                      // errorStyle: TextStyle(
                                      //     fontSize: constraints.maxWidth * 0.05),
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Dark,
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        borderSide: const BorderSide(color: Dark, width: 2),
                                      ),
                                      focusColor: Dark,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        borderSide: const BorderSide(color: Dark, width: 2),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        borderSide: const BorderSide(color: Dark, width: 2),
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                    validator: (value) {
                                      email = value!.trim();
                                      return Validate.emailValidation(value);
                                    },
                                    onChanged: (val) {
                                      if (!_formKey.currentState!.validate()) {
                                        Validate.emailValidation(val);
                                      }
                                    },
                                    onFieldSubmitted: (_) => setFocus(context, focusNode: _passwordFocusNode),
                                    focusNode: _emailPhoneFocusNode,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    //textAlignVertical: TextAlignVertical.center,
                                  ),
                                ),
                                //Field 3
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
                                        borderSide: const BorderSide(color: Colors.black, width: 2),
                                      ),
                                      labelText: 'Password',
                                      labelStyle: TextStyle(
                                        color: Colors.blueGrey,
                                      ),
                                      floatingLabelStyle: TextStyle(color: Dark),
                                      // errorStyle: TextStyle(
                                      //     fontSize: constraints.maxWidth * 0.05),
                                      prefixIcon: const Icon(
                                        Icons.password,
                                        color: Dark,
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        borderSide: const BorderSide(color: Dark, width: 2),
                                      ),
                                      errorStyle: validationStyle,
                                      focusColor: Dark,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        borderSide: const BorderSide(color: Dark, width: 2),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        borderSide: const BorderSide(color: Colors.black, width: 2),
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                    validator: (value) {
                                      password = value!.trim();
                                      return Validate.passwordValidation(value);
                                    },
                                    onChanged: (val) {
                                      if (!_formKey.currentState!.validate()) {
                                        Validate.passwordValidation(val);
                                      }
                                    },
                                    obscureText: true,
                                    onFieldSubmitted: (_) => setFocus(context, focusNode: _confirmPasswordFocusNode),
                                    focusNode: _passwordFocusNode,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    //textAlignVertical: TextAlignVertical.center,
                                  ),
                                ),
                                //Field 4
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
                                        borderSide: const BorderSide(color: Colors.black, width: 2),
                                      ),
                                      labelText: 'Confirm Password',
                                      labelStyle: TextStyle(
                                        color: Colors.blueGrey,
                                      ),
                                      floatingLabelStyle: TextStyle(color: Dark),
                                      // errorStyle: TextStyle(
                                      //     fontSize: constraints.maxWidth * 0.05),
                                      prefixIcon: const Icon(
                                        Icons.password,
                                        color: Dark,
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        borderSide: const BorderSide(color: Dark, width: 2),
                                      ),
                                      errorStyle: validationStyle,
                                      focusColor: Dark,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        borderSide: const BorderSide(color: Dark, width: 2),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        borderSide: const BorderSide(color: Colors.black, width: 2),
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                    validator: (value) {
                                      passwordConfirm = value!.trim();
                                      return Validate.confirmPasswordValidation(value, password);
                                    },
                                    onChanged: (val) {
                                      if (!_formKey.currentState!.validate()) {
                                        Validate.confirmPasswordValidation(val, password);
                                      }
                                    },
                                    obscureText: true,
                                    onFieldSubmitted: (_) => submit(),
                                    focusNode: _confirmPasswordFocusNode,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    //textAlignVertical: TextAlignVertical.center,
                                  ),
                                ),
                                Container(
                                  // height: constraints.maxHeight * 0.11,
                                  width: SizeConfig.blockSizeHorizontal * 50,
                                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
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
                                        'Register',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          color: Color.fromRGBO(255, 255, 255, 1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
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
                            text: 'Already have an account?',
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
                              text: 'Login here',
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => SignInForm(),
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

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailPhoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }
}

class RegisterHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      //..color = Dark
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
