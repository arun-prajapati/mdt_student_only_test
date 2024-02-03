import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
//import 'package:platform_device_id/platform_device_id.dart';
import 'package:student_app/Constants/app_colors.dart';
import 'package:student_app/custom_button.dart';
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
import '../../utils/appImages.dart';
import '../../utils/app_colors.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final NavigationService _navigationService = locator<NavigationService>();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  late String email;
  bool isSecure = false;
  // late String password;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String usertype = '2';
  String? deviceId = "";

  Future<Map> getDeviceInfo() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print("deviceId $deviceId");
    return androidInfo.toMap();
  }

  TextEditingController password = TextEditingController(text: "Diya@123");
  TextEditingController emailController =
      TextEditingController(text: "diya.saurabhinfosys@gmail.com");

  Future<String?> getId() async {
    //  deviceId = await PlatformDeviceId.getDeviceId;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = await iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      print("deviceId $deviceId");
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = deviceId;
      //"TP1A.220624.014"; // unique ID on Android
    }

    //deviceId = Uuid().v4();

    return deviceId;
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
                  Navigator.of(context).pop();
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

  showDeviceExistDialog(BuildContext context, String userName, String contact) {
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
                  'You seem to have changed your phone. Please contact our'
                  ' support team to connect your new phone to the app.',
                  style: AppTextStyle.textStyle.copyWith(
                      fontSize: 16, color: Dark, fontWeight: FontWeight.w600),
                ),
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
                child: Text(
                  'Ok',
                  style: AppTextStyle.textStyle.copyWith(
                      fontSize: 16, color: Dark, fontWeight: FontWeight.w600),
                ),
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
    FocusManager.instance.primaryFocus?.unfocus();
    final form = _formKey.currentState;
    if (form!.validate()) {
      //await Provider.of<AuthProvider>(context, listen: false).login(email, password.text, usertype, deviceId!);
      await Provider.of<UserProvider>(context, listen: false).login(
          deviceId: deviceId!,
          email: email,
          usertype: "2",
          password: password.text);
      if (Provider.of<UserProvider>(context, listen: false).notification.text !=
              'device-exist' &&
          Provider.of<UserProvider>(context, listen: false).notification.text !=
              '') {
        showValidationDialog(
            context,
            Provider.of<UserProvider>(context, listen: false)
                .notification
                .text);
      }
      if (Provider.of<UserProvider>(context, listen: false).notification.text ==
          'device-exist') {
        showDeviceExistDialog(
            context,
            Provider.of<UserProvider>(context, listen: false).userName,
            Provider.of<UserProvider>(context, listen: false).contact);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _emailFocusNode = new FocusNode();
    _passwordFocusNode = new FocusNode();
    if (Platform.isAndroid) {
      getDeviceInfo()
          .then((value) => log('Running on ${jsonEncode(value['androidId'])}'));
    }
    getId().then((value) => log('Running on ${value}'));
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  LinearGradient textColorLiner = LinearGradient(colors: [
    Color(0xff78E6C9),
    Color(0xff0E9BD0),
  ]);

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserRepository>(context);
    //var width = MediaQuery.of(context).size.width;
    //var height = MediaQuery.of(context).size.height;
    TextStyle defaultStyle = AppTextStyle.textStyle;
    TextStyle linkStyle = AppTextStyle.textStyle;
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
                Image.asset(
                  AppImages.bgLogin,
                  //height: 300,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                ),
                Positioned(
                    left: 25,
                    top: SizeConfig.blockSizeVertical * 8,
                    child: backArrowCustom()),
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
                // CustomPaint(
                //   size: Size(width, height),
                //   painter: HeaderPainter(),
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
                SizedBox(height: 20),
                Container(
                  // width: SizeConfig.blockSizeHorizontal * 85,
                  height: SizeConfig.blockSizeVertical * 80,
                  margin: EdgeInsets.fromLTRB(
                    25,
                    SizeConfig.blockSizeVertical * 34,
                    25,
                    0.0,
                  ),
                  //color: Colors.black12,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: ListView(
                      children: [
                        Center(
                          child: Text('Welcome back!',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black)),
                        ),
                        SizedBox(height: 5),
                        Center(
                          child: Text('Fill Up Your Details below to login',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black)),
                        ),
                        SizedBox(height: 35),
                        //Field 1
                        CustomTextField(
                          controller: emailController,
                          heading: 'Email / Mobile Number',
                          label: 'Enter Email / Mobile Number',
                          //prefixIcon: Icon(Icons.mail, color: Dark),
                          validator: (value) {
                            email = value!.trim();
                            return Validate.validateEmail(value);
                          },
                          onChange: (val) {
                            if (!_formKey.currentState!.validate()) {
                              Validate.validateEmail(val);
                            }
                          },
                          onFieldSubmitted: (_) =>
                              setFocus(context, focusNode: _passwordFocusNode),
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                        //Field 2
                        CustomTextField(
                          label: 'Enter Password',
                          heading: 'Password',
                          controller: password,
                          // prefixIcon: Icon(Icons.key, color: Dark),
                          validator: (value) {
                            password.text = value!.trim();
                            return Validate.passwordValidation(value);
                          },
                          onChange: (val) {
                            if (!_formKey.currentState!.validate()) {
                              Validate.passwordValidation(val);
                            }
                          },
                          suffixOnTap: () {
                            setState(() {
                              isSecure = !isSecure;
                            });
                          },
                          suffixIcon: Icon(
                            isSecure
                                ? Icons.remove_red_eye_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.black38,
                          ),
                          obscureText: !isSecure,
                          onFieldSubmitted: (_) => submit(),
                          focusNode: _passwordFocusNode,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                        ),
                        // SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          // child: InkWell(
                          //   onTap: () {
                          //     Navigator.of(context).push(
                          //       MaterialPageRoute(
                          //         builder: (context) => ForgotPassword(),
                          //       ),
                          //     );
                          //     print('FORGOT T*/////');
                          //     password.clear();
                          //   },
                          child: GestureDetector(
                            onTap: () {
                              context.read<UserProvider>().isSendOtp = false;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ForgotPassword(),
                                ),
                              );
                              print('FORGOT T*/////');
                              password.clear();
                            },
                            child: GradientText('Forgot password?',
                                colors: [
                                  AppColors.blueGrad7,
                                  AppColors.blueGrad6,
                                  AppColors.blueGrad5,
                                  AppColors.blueGrad4,
                                  AppColors.blueGrad3,
                                  AppColors.blueGrad1,
                                ],
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                    decorationThickness:
                                        2) /*AppTextStyle.textStyle.copyWith(
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline)*/
                                ),
                          ),
                        ),
                        SizedBox(height: 50),
                        Provider.of<UserProvider>(context).status ==
                                Status.Authenticating
                            ? Center(child: CircularProgressIndicator())
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: CustomButton(
                                  title: 'Login',
                                  onTap: submit,
                                ),
                              ),
                        // Container(
                        //         // height: constraints.maxHeight * 0.11,
                        //         width: SizeConfig.blockSizeHorizontal * 50,
                        //         margin: EdgeInsets.only(
                        //             top: SizeConfig.blockSizeVertical * 5),
                        //         child: Material(
                        //           borderRadius: BorderRadius.circular(10),
                        //           color: Dark,
                        //           elevation: 5.0,
                        //           child: MaterialButton(
                        //             onPressed: submit,
                        //             child: Text(
                        //               'Login',
                        //               style: TextStyle(
                        //                 fontFamily: 'Poppins',
                        //                 fontSize:
                        //                     SizeConfig.blockSizeHorizontal * 5,
                        //                 fontWeight: FontWeight.w700,
                        //                 color:
                        //                     Color.fromRGBO(255, 255, 255, 1.0),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 0,
                              child: Text('Don\'t have an account yet? ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.black)),
                            ),
                            Expanded(
                              flex: 0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => Register('1'),
                                    ),
                                  );
                                },
                                child: ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (bounds) =>
                                      textColorLiner.createShader(
                                    Rect.fromLTWH(
                                        0, 0, bounds.width, bounds.height),
                                  ),
                                  child: Text("Register here",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.white,
                                          decoration:
                                              TextDecoration.underline)),
                                ),
                                /* child: Text(
                                  'Register here',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2),
                                ),*/
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
// Container(
//     child: TextFormField(
//   cursorColor: Dark,
//   decoration: InputDecoration(
//     contentPadding: EdgeInsets.symmetric(
//       vertical: SizeConfig.blockSizeVertical * 1,
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
//       borderSide:
//           const BorderSide(color: Colors.black, width: 2),
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
//       borderSide: const BorderSide(color: Dark, width: 2),
//     ),
//     // errorStyle: validationStyle,
//     focusColor: Dark,
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.all(
//         Radius.circular(25),
//       ),
//       borderSide: const BorderSide(color: Dark, width: 2),
//     ),
//     focusedErrorBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.all(
//         Radius.circular(25),
//       ),
//       borderSide: const BorderSide(color: Dark, width: 2),
//     ),
//   ),
//   style: TextStyle(
//     fontSize: 20,
//   ),
// )
//     // TextFormField(
//     //   cursorColor: Dark,
//     //   controller: password,
//     //   decoration: InputDecoration(
//     //     contentPadding: EdgeInsets.symmetric(
//     //       vertical: SizeConfig.blockSizeVertical * 2,
//     //     ),
//     //     border: OutlineInputBorder(
//     //       borderRadius: BorderRadius.all(
//     //         Radius.circular(25),
//     //       ),
//     //       borderSide: BorderSide(
//     //         color: Dark,
//     //         width: 2,
//     //       ),
//     //     ),
//     //     enabledBorder: OutlineInputBorder(
//     //       borderRadius: BorderRadius.all(
//     //         Radius.circular(25),
//     //       ),
//     //       borderSide: const BorderSide(
//     //         color: Dark,
//     //         width: 2,
//     //       ),
//     //     ),
//     //     disabledBorder: OutlineInputBorder(
//     //       borderRadius: BorderRadius.all(
//     //         Radius.circular(25),
//     //       ),
//     //       borderSide: const BorderSide(
//     //           color: Colors.black, width: 2),
//     //     ),
//     //     labelText: 'Password',
//     //     labelStyle: TextStyle(
//     //       color: Colors.blueGrey,
//     //     ),
//     //     floatingLabelStyle: TextStyle(color: Dark),
//     //     // errorStyle: TextStyle(
//     //     //     fontSize: constraints.maxWidth * 0.05),
//     //     prefixIcon: const Icon(
//     //       Icons.key,
//     //       color: Dark,
//     //     ),
//     //     errorBorder: OutlineInputBorder(
//     //       borderRadius: BorderRadius.all(
//     //         Radius.circular(25),
//     //       ),
//     //       borderSide:
//     //           const BorderSide(color: Dark, width: 2),
//     //     ),
//     //     focusColor: Dark,
//     //     focusedBorder: OutlineInputBorder(
//     //       borderRadius: BorderRadius.all(
//     //         Radius.circular(25),
//     //       ),
//     //       borderSide:
//     //           const BorderSide(color: Dark, width: 2),
//     //     ),
//     //     focusedErrorBorder: OutlineInputBorder(
//     //       borderRadius: BorderRadius.all(
//     //         Radius.circular(25),
//     //       ),
//     //       borderSide:
//     //           const BorderSide(color: Dark, width: 2),
//     //     ),
//     //   ),
//     //   style: TextStyle(
//     //     fontSize: SizeConfig.blockSizeHorizontal * 4.5,
//     //   ),
//     //   validator: (value) {
//     //     password.text = value!.trim();
//     //     return Validate.passwordValidation(password.text);
//     //   },
//     //   onChanged: (val) {
//     //     if (!_formKey.currentState!.validate()) {
//     //       Validate.passwordValidation(val);
//     //     }
//     //   },
//     //   onFieldSubmitted: (_) => submit(),
//     //   focusNode: _passwordFocusNode,
//     //   obscureText: true,
//     //   keyboardType: TextInputType.text,
//     //   textInputAction: TextInputAction.done,
//     //   //textAlignVertical: TextAlignVertical.center,
//     // ),
//     ),
//Forgot Password
}

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? heading;
  final ValueChanged? onChange;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final FocusNode? focusNode;
  final TextAlignVertical? textAlignVertical;
  final Null Function(dynamic _)? onSubmitted;
  final List<dynamic>? inputFormatters;
  final bool? showCountryFlag;
  final String? initialCountryCode;
  final TextEditingController? controller;
  final bool? enabled;
  final VoidCallback? suffixOnTap;

  const CustomTextField({
    super.key,
    required this.label,
    this.onChange,
    this.validator,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.obscureText,
    this.textAlignVertical,
    this.onSubmitted,
    this.inputFormatters,
    this.showCountryFlag,
    this.initialCountryCode,
    this.controller,
    this.enabled,
    this.heading,
    this.suffixIcon,
    this.suffixOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading == null
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("$heading", style: AppTextStyle.textStyle),
              ),
        Container(
          width: SizeConfig.blockSizeHorizontal * 85,
          margin: EdgeInsets.only(top: 3, bottom: 10),
          child: TextFormField(
              validator: validator,
              onChanged: onChange,
              obscureText: obscureText ?? false,
              cursorColor: Dark,
              onFieldSubmitted: onFieldSubmitted,
              keyboardType: keyboardType ?? TextInputType.text,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    vertical: SizeConfig.blockSizeVertical * 1, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                      color: AppColors.black.withOpacity(0.5), width: 1.1),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: AppColors.black.withOpacity(0.5), width: 1.1)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: AppColors.black.withOpacity(0.5), width: 1.1)),
                // labelText: label,
                // labelStyle: TextStyle(
                //     color: Colors.blueGrey,
                //     fontSize: 16,
                //     fontWeight: FontWeight.w400),
                hintText: label,
                hintStyle: AppTextStyle.disStyle.copyWith(
                    color: AppColors.grey, fontWeight: FontWeight.w400),
                floatingLabelStyle: TextStyle(color: Dark),
                errorStyle: AppTextStyle.textStyle
                    .copyWith(color: AppColors.red1, height: 1, fontSize: 14),
                prefixIcon: prefixIcon,
                suffixIcon: Container(
                    height: 50,
                    width: 50,
                    child:
                        GestureDetector(onTap: suffixOnTap, child: suffixIcon)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.5), width: 1.1)),
                focusColor: Dark,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.5), width: 1.1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.5), width: 1.1),
                ),
              ),
              style:
                  AppTextStyle.textStyle.copyWith(fontWeight: FontWeight.w400)),
        ),
      ],
    );
  }
}
