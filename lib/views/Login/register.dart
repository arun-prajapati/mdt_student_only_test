import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

//import 'package:platform_device_id/platform_device_id.dart';
import 'package:student_app/Constants/app_colors.dart';
import 'package:student_app/custom_button.dart';
import 'package:student_app/enums/Autentication_status.dart';
import 'package:student_app/external.dart';
import 'package:student_app/views/Login/login.dart';
import 'package:toast/toast.dart';

import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/auth.dart';
import '../../services/methods.dart';
import '../../services/navigation_service.dart';
import '../../services/validator.dart';
import '../../utils/appImages.dart';
import '../../utils/app_colors.dart';

class Register extends StatefulWidget {
  late String user;

  Register(this.user);

  @override
  _RegisterState createState() => _RegisterState(this.user);
}

class _RegisterState extends State<Register> {
  final NavigationService _navigationService = locator<NavigationService>();

  _RegisterState(this.user);

  final TextEditingController phoneTextControl = TextEditingController();
  final TextEditingController code = TextEditingController();
  var mobile = '';
  var countryCode = '+44';
  late FocusNode _phoneFocusNode;

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
  bool phoneIsEmpty = false;
  bool loadingValue = false;
  late String password;
  late String passwordConfirm;
  late String message = '';
  late String deviceType;
  String? deviceId = '';

  //'TP1A.220624.014';
  // Declare this variable
  String user;
  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Map response = new Map();
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
                  if (Provider.of<UserProvider>(context, listen: false)
                          .notification
                          .text ==
                      'Registration successful, please verify your account.') {
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
    phoneIsEmpty = true;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {});
    var authData = context.read<UserProvider>();
    final form = _formKey.currentState;
    if (form!.validate() && phoneTextControl.text.isNotEmpty) {
      if (!authData.isSendOtp) {
        print('PPPPPPPPPPPPPP');
        Provider.of<UserProvider>(context, listen: false)
            .verifyPhone(context, countryCode, phoneTextControl.text);
      } else {
        try {
          loadingValue = true;
          setState(() {});
          final PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: authData.verificationCode, smsCode: code.text);
          FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              loadingValue = false;
              setState(() {});
              response = await Provider.of<UserProvider>(context, listen: false)
                  .register(
                      name: name,
                      email: email,
                      password: password,
                      passwordConfirm: passwordConfirm,
                      userType: "2",
                      deviceType: deviceType,
                      deviceId: deviceId!);
              // 'TP1A.220624.014'!);
              if (Provider.of<UserProvider>(context, listen: false)
                      .notification
                      .text !=
                  '') {
                // Spinner.close(context);
                showValidationDialog(
                    context,
                    Provider.of<UserProvider>(context, listen: false)
                        .notification
                        .text);
              }
            }
          }).catchError((e) {
            loadingValue = false;
            setState(() {});
            if (e.code == "invalid-verification-code") {
              authData.showErrorDialog(context, "Invalid OTP");
            } else {
              authData.showErrorDialog(
                  context, e.code.toString().replaceAll("-", " "));
            }
          });
        } catch (e) {
          loadingValue = false;
          setState(() {});
        }
      }

      print('good $countryCode');
    } else {
      print('bad');
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
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = await iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = await androidDeviceInfo.id; // unique ID on Android
    }

    //deviceId = Uuid().v4();

    return deviceId;
  }

  @override
  void didChangeDependencies() {
    log("++++++++++++++++++++++= $secondsRemaining");
    if (context.read<UserProvider>().isSendOtp) {
      // timer = Timer.periodic(Duration(seconds: 1), (_) {
      //   if (secondsRemaining != 0) {
      //     setState(() {
      //       secondsRemaining--;
      //     });
      //   } else {
      //     setState(() {
      //       enableResend = true;
      //     });
      //   }
      // });
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      print("android");
      deviceType = "android";
      getDeviceInfo()
          .then((value) => log('Running on ${jsonEncode(value['androidId'])}'));
      getId().then((value) => log('Running on ${value}'));
    }
    if (Platform.isIOS) {
      print("iOS");
      deviceType = "iOS";
      getId().then((value) => log('Running on ${value}'));
    }
    //deviceType = "";
    _phoneFocusNode = new FocusNode();
    _nameFocusNode = new FocusNode();
    _emailPhoneFocusNode = new FocusNode();
    _passwordFocusNode = new FocusNode();
    _confirmPasswordFocusNode = new FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    Duration clockTimer = Duration(seconds: secondsRemaining);

    String timerText =
        '0${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    var width = MediaQuery.of(context).size.width;
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    print("Register through $deviceType");
    SizeConfig().init(context);

    TextStyle validationStyle = TextStyle(fontSize: 16, color: Colors.red);
    TextStyle defaultStyle = const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
    TextStyle linkStyle =
        const TextStyle(color: Dark, fontSize: 16, fontWeight: FontWeight.w500);
/*
reg data
{name: newww, email_phone: new@gmail.com, password: 123456, password_confirmation: 123456, user_type: 2, device_type: android, device_id: e5d24768ae0746ea}
*/
    return PopScope(
      onPopInvoked: (val) {
        context.read<UserProvider>().isSendOtp = false;
      },
      child: new Scaffold(
        key: _key,
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            //color: Colors.transparent,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Image.asset(
                  AppImages.bgWelcome,
                  //height: 300,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                ),
                Positioned(
                    left: 25,
                    top: SizeConfig.blockSizeVertical * 10,
                    child: backArrowCustom()),
                Positioned(
                  top: SizeConfig.blockSizeVertical * 10,
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
                // CustomPaint(
                //   size: Size(width, height),
                //   painter: RegisterHeaderPainter(),
                // ),
                // Positioned(
                //   top: SizeConfig.blockSizeVertical * 20,
                //   left: SizeConfig.blockSizeHorizontal * 28,
                //   child: CircleAvatar(
                //     radius: SizeConfig.blockSizeHorizontal * 22,
                //     backgroundColor: Colors.white,
                //     child: Container(
                //       child: Image.asset(
                //         "assets/stt_s_logo.png",
                //         height: SizeConfig.blockSizeVertical * 45,
                //         width: SizeConfig.blockSizeHorizontal * 45,
                //         fit: BoxFit.contain,
                //       ),
                //     ),
                //   ),
                // ),
                /*   Positioned(
                  top: SizeConfig.blockSizeVertical * 31,
                  // left: SizeConfig.blockSizeHorizontal * 28,
                  child:
                      Consumer<UserProvider>(builder: (context, authData, _) {
                    return authData.isSendOtp
                        ? Column(
                            children: [
                              Text('OTP Verification',
                                  style: AppTextStyle.titleStyle),
                              Text(
                                  'Digit code has been sent to ${countryCode} ${phoneTextControl.text}',
                                  style: AppTextStyle.textStyle),
                            ],
                          )
                        : SizedBox();
                  }),
                ),*/
                Container(
                  // width: SizeConfig.blockSizeHorizontal * 90,
                  // height: SizeConfig.blockSizeVertical * 50,
                  margin: EdgeInsets.fromLTRB(
                    SizeConfig.blockSizeHorizontal * 4.5,
                    SizeConfig.blockSizeVertical * 30,
                    SizeConfig.blockSizeHorizontal * 4.5,
                    0.0,
                  ),
                  //color: Colors.black12,
                  // padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*2),
                  child:
                      Consumer<UserProvider>(builder: (context, authData, _) {
                    return authData.isSendOtp
                        ? SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('OTP Verification',
                                    style: AppTextStyle.titleStyle),
                                Text(
                                    'Digit code has been sent to ${countryCode} ${phoneTextControl.text}',
                                    style: AppTextStyle.textStyle),
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
                                        AndroidSmsAutofillMethod
                                            .smsRetrieverApi,
                                    pinputAutovalidateMode:
                                        PinputAutovalidateMode.onSubmit,
                                    showCursor: true,
                                    onSubmitted: (pin) async {},
                                  ),
                                ),
                                SizedBox(
                                    height: SizeConfig.blockSizeVertical * 38),
                                Consumer<UserProvider>(
                                    builder: (context, authData, _) {
                                  return Container(
                                    color: AppColors.white,
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 20,
                                          bottom: 10),
                                      child: loadingValue
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                  color: Dark))
                                          : CustomButton(
                                              title: authData.isSendOtp
                                                  ? 'Register'
                                                  : "Send Code",
                                              onTap: submit,
                                            ),
                                    ),
                                  );
                                }),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Already have an account? ',
                                        style: AppTextStyle.textStyle,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            //left: SizeConfig.blockSizeHorizontal * 2.5,
                                            // top: SizeConfig.blockSizeVertical * 0.5,
                                            ),
                                        child: RichText(
                                          text: TextSpan(
                                              text: 'Login here',
                                              style: AppTextStyle.textStyle
                                                  .copyWith(
                                                      color: Dark,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      decoration: TextDecoration
                                                          .underline),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SignInForm(),
                                                    ),
                                                  );
                                                }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //SizedBox(height: 2),
                                /*  Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  secondsRemaining == 0
                                      ? ''
                                      : timerText,
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
                                        }
                                      : null,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don’t receive the Code? ",
                                      ),
                                      Text(
                                        "Resend Code",
                                      ),
                                    ],
                                  ),
                                ),
                              ),*/
                                // SizedBox(height: 15),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                Text('Register Here',
                                    style: AppTextStyle.titleStyle),
                                Text('Fill up your details below to register',
                                    style: AppTextStyle.textStyle),
                                SizedBox(height: 40),
                                CustomTextField(
                                  label: 'Enter Full Name',
                                  heading: 'Full Name',
                                  // prefixIcon: Icon(Icons.person, color: Dark),
                                  validator: (value) {
                                    name = value!.trim();
                                    return Validate.nameValidation(name);
                                  },
                                  onChange: (val) {
                                    if (!_formKey.currentState!.validate()) {
                                      Validate.nameValidation(val);
                                    }
                                  },
                                  onFieldSubmitted: (_) => setFocus(context,
                                      focusNode: _emailPhoneFocusNode),
                                  focusNode: _nameFocusNode,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  textAlignVertical: TextAlignVertical.center,
                                ),
                                //Field 2
                                CustomTextField(
                                  label: 'Enter Email',
                                  heading: 'Email',
                                  // prefixIcon: Icon(
                                  //   Icons.email,
                                  //   color: Dark,
                                  // ),
                                  validator: (value) {
                                    email = value!.trim();
                                    return Validate.emailValidation(value);
                                  },
                                  onChange: (val) {
                                    if (!_formKey.currentState!.validate()) {
                                      Validate.emailValidation(val);
                                    }
                                  },
                                  onFieldSubmitted: (_) => setFocus(context,
                                      focusNode: _passwordFocusNode),
                                  focusNode: _emailPhoneFocusNode,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                ),
                                // SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, bottom: 5),
                                    child: Text("Mobile number",
                                        style: AppTextStyle.textStyle),
                                  ),
                                ),
                                Container(
                                  width: SizeConfig.blockSizeHorizontal * 85,
                                  // margin: EdgeInsets.only(
                                  //   top: SizeConfig.blockSizeVertical * 1.5,
                                  // ),
                                  child: IntlPhoneField(
                                    autofocus: false,
                                    textAlign: TextAlign.left,
                                    dropdownIcon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black),
                                    dropdownIconPosition: IconPosition.trailing,
                                    flagsButtonMargin:
                                        EdgeInsets.only(left: 10),
                                    //disableLengthCheck: true,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    //disableLengthCheck: true,
                                    controller: phoneTextControl,
                                    focusNode: _phoneFocusNode,
                                    cursorColor: Dark,

                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: AppColors.black
                                                .withOpacity(0.5),
                                            width: 1.1),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              color: AppColors.black
                                                  .withOpacity(0.5),
                                              width: 1.1)),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              color: AppColors.black
                                                  .withOpacity(0.5),
                                              width: 1.1)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              color: AppColors.black
                                                  .withOpacity(0.5),
                                              width: 1.1)),
                                      focusColor: Dark,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: AppColors.black
                                                .withOpacity(0.5),
                                            width: 1.1),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: AppColors.black
                                                .withOpacity(0.5),
                                            width: 1.1),
                                      ),
                                      hintStyle: AppTextStyle.disStyle.copyWith(
                                          color: AppColors.grey,
                                          fontWeight: FontWeight.w400),

                                      hintText: 'Enter Mobile Number',
                                      errorStyle: AppTextStyle.textStyle
                                          .copyWith(color: AppColors.red1),

                                      floatingLabelStyle:
                                          TextStyle(color: Dark),
                                      // errorStyle: TextStyle(
                                      //     fontSize: constraints.maxWidth * 0.05),
                                    ),
                                    initialCountryCode: 'GB',
                                    // showCountryFlag: false,
                                    keyboardType: TextInputType.text,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    style: AppTextStyle.textStyle,
                                    onSubmitted: (_) {
                                      setFocus(context, focusNode: null);
                                      submit();
                                    },

                                    // onSubmitted: (_) {
                                    //   setFocus(context, focusNode: _addressFocusNode);
                                    // },
                                    onChanged: (phone) {
                                      print(phone);

                                      Validate.validateEmail(
                                          phoneTextControl.text);
                                      setState(() {
                                        mobile = phone.completeNumber;
                                        phoneTextControl.selection =
                                            TextSelection.fromPosition(
                                                TextPosition(
                                                    offset: phoneTextControl
                                                        .text.length));
                                        countryCode = phone.countryCode;
                                      });
                                    },
                                  ),
                                ),
                                phoneTextControl.text.isEmpty && phoneIsEmpty
                                    ? Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Text(
                                              "Please enter phone number",
                                              style: AppTextStyle.textStyle
                                                  .copyWith(
                                                      height: 2.4,
                                                      color: AppColors.red1)),
                                        ),
                                      )
                                    : SizedBox(),
                                SizedBox(height: 5),
                                CustomTextField(
                                  label: 'Enter Password',
                                  heading: 'Password',
                                  // prefixIcon:
                                  //     const Icon(Icons.password, color: Dark),
                                  suffixIcon:
                                      Icon(Icons.remove_red_eye_outlined),
                                  validator: (value) {
                                    password = value!.trim();
                                    return Validate.passwordValidation(value);
                                  },
                                  onChange: (val) {
                                    if (!_formKey.currentState!.validate()) {
                                      Validate.passwordValidation(val);
                                    }
                                  },
                                  obscureText: true,
                                  onFieldSubmitted: (_) => setFocus(context,
                                      focusNode: _confirmPasswordFocusNode),
                                  focusNode: _passwordFocusNode,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                ),
                                CustomTextField(
                                  label: 'Confirm Password',
                                  heading: 'Confirm Password',
                                  // prefixIcon: Icon(
                                  //   Icons.password,
                                  //   color: Dark,
                                  // ),
                                  validator: (value) {
                                    passwordConfirm = value!.trim();
                                    return Validate.confirmPasswordValidation(
                                        value, password);
                                  },
                                  onChange: (val) {
                                    if (!_formKey.currentState!.validate()) {
                                      Validate.confirmPasswordValidation(
                                          val, password);
                                    }
                                  },
                                  obscureText: true,
                                  onFieldSubmitted: (_) => submit(),
                                  focusNode: _confirmPasswordFocusNode,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                ),

                                Consumer<UserProvider>(
                                    builder: (context, authData, _) {
                                  return Container(
                                    color: AppColors.white,
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 20,
                                          bottom: 10),
                                      child: loadingValue
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                  color: Dark))
                                          : CustomButton(
                                              title: authData.isSendOtp
                                                  ? 'Register'
                                                  : "Send Code",
                                              onTap: submit,
                                            ),
                                    ),
                                  );
                                }),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Already have an account? ',
                                        style: AppTextStyle.textStyle,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            //left: SizeConfig.blockSizeHorizontal * 2.5,
                                            // top: SizeConfig.blockSizeVertical * 0.5,
                                            ),
                                        child: RichText(
                                          text: TextSpan(
                                              text: 'Login here',
                                              style: AppTextStyle.textStyle
                                                  .copyWith(
                                                      color: Dark,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      decoration: TextDecoration
                                                          .underline),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SignInForm(),
                                                    ),
                                                  );
                                                }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Container(
                                //   // height: constraints.maxHeight * 0.11,
                                //   width:
                                //       SizeConfig.blockSizeHorizontal * 50,
                                //   margin: EdgeInsets.only(
                                //       top: SizeConfig.blockSizeVertical *
                                //           3),
                                //   child: Material(
                                //     borderRadius:
                                //         BorderRadius.circular(10),
                                //     color: Dark,
                                //     elevation: 5.0,
                                //     child: MaterialButton(
                                //       onPressed: submit,
                                //       child: Text(
                                //         'Register',
                                //         style: TextStyle(
                                //           fontFamily: 'Poppins',
                                //           fontSize: 22,
                                //           fontWeight: FontWeight.w700,
                                //           color: Color.fromRGBO(
                                //               255, 255, 255, 1.0),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
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

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailPhoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _phoneFocusNode.dispose();
    timer?.cancel();
    secondsRemaining = 60;
    super.dispose();
  }
}

class backArrowCustom extends StatelessWidget {
  const backArrowCustom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.black.withOpacity(0.1))),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: GestureDetector(
              onTap: () {
                if (context.read<UserProvider>().isSendOtp) {
                  print('${context.read<UserProvider>().isSendOtp}');
                  context.read<UserProvider>().isSendOtp = false;
                }
                FocusManager.instance.primaryFocus?.unfocus();
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back)),
        ));
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
