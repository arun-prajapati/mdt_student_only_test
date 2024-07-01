import 'dart:convert';
import 'dart:developer';

import 'package:Smart_Theory_Test/Constants/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:Smart_Theory_Test/Constants/app_colors.dart';
import 'package:Smart_Theory_Test/custom_button.dart';
import 'package:Smart_Theory_Test/responsive/percentage_mediaquery.dart';
import 'package:Smart_Theory_Test/routing/route_names.dart' as routes;
import 'package:Smart_Theory_Test/services/password_services.dart';
import 'package:Smart_Theory_Test/views/Login/login.dart';
import 'package:Smart_Theory_Test/views/Login/register.dart';
import 'package:toast/toast.dart';

import '../../enums/Autentication_status.dart';
import '../../locater.dart';
import '../../responsive/size_config.dart';
import '../../services/auth.dart';
import '../../services/methods.dart';
import '../../services/navigation_service.dart';
import '../../services/validator.dart';
import '../../utils/appImages.dart';
import '../../utils/app_colors.dart';

class SocialLoginEmailRegister extends StatefulWidget {
  @override
  _SocialLoginEmailRegister createState() => _SocialLoginEmailRegister();
}

class _SocialLoginEmailRegister extends State<SocialLoginEmailRegister> {
  final NavigationService _navigationService = locator<NavigationService>();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  late String email;
  late String phone = ' ';
  late Map paramArguments;
  late FocusNode _emailFocusNode;
  late FocusNode _phoneFocusNode;
  String userType = '2'; //1=adi, 2=driver
  bool isSocialEmail = false;
  bool isSocialPhone = false;
  final TextEditingController emailTextControl = TextEditingController();
  final TextEditingController phoneTextControl = TextEditingController();
  var mobile = '';
  var countryCode = '+44';
  final _passwordService = PasswordServices();

  Future<void> submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final form = _formKey.currentState;
    var authData = context.read<UserProvider>();
    if (form!.validate() && phoneTextControl.text.isNotEmpty) {
      authData.isSocialLogin = true;
      Map data = {
        'phone': '${countryCode}${phoneTextControl.text}',
        'user_type': '2',
        "email": emailTextControl.text,
      };
      _passwordService.checkNumber(data).then((res) {
        authData.phoneNumber = phoneTextControl.text;
        authData.countryCode = countryCode;
        authData.email = emailTextControl.text;
        authData.socialToken = paramArguments['token'];
        authData.socialSiteId = paramArguments['social_site_id'];
        authData.socialType = paramArguments['social_type'];
        print("RESPONSE OF CHECK NUMBER ======== ${res}");
        setState(() {});
        authData.printData();
        if (res['success'] == false) {
          showValidationDialog(context, res['message']);
        } else {
          Provider.of<UserProvider>(context, listen: false)
              .verifyPhone(context, phoneTextControl.text);
          print(" 7777${res['success']}");
        }
      });
    }
  }

  goForAnotherMethod() {
    _navigationService.navigateToReplacement(routes.WelcomeRoute);
  }

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    print('DID CHANGE */////////////////////////        ');
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    print('ARGUE 1 ******************       $arguments');
    try {
      print('ARGUE 2 /////////////////////////    $arguments');
      if (arguments.isNotEmpty && arguments['email'] != '')
        this.emailTextControl.text = arguments['email'];
      if (arguments.isNotEmpty && arguments['phone'] != null)
        this.phoneTextControl.text = arguments['phone'];
      setState(() {
        emailTextControl.text = arguments['email'];
        print(
            'ARGUE +++++++++ /////////////////////////    ${emailTextControl.text}');
        paramArguments = arguments;
        if (arguments.isNotEmpty &&
            arguments['email'] != '' &&
            arguments['email'] != null)
          isSocialEmail = true;
        else
          isSocialEmail = false;
        if (arguments.isNotEmpty &&
            arguments['phone'] != '' &&
            arguments['phone'] != null)
          isSocialPhone = true;
        else
          isSocialPhone = false;
      });
    } catch (e) {
      print("ELSE ///***/// $e");
    } finally {
      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TextStyle defaultStyle = TextStyle(
    //     fontFamily: 'Poppins',
    //     fontSize: 50.0,
    //     fontWeight: FontWeight.w600,
    //     color: Color.fromRGBO(42, 8, 69, 1.0));
    // TextStyle linkStyle = TextStyle(color: Colors.blue);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: new Scaffold(
        backgroundColor: Colors.white,
        key: _key,
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Image.asset(
              //   AppImages.bgLogin,
              //   //height: 300,
              //   width: MediaQuery.of(context).size.width,
              //   fit: BoxFit.fitWidth,
              // ),
              Stack(
                children: [
                  Image.asset(
                    "assets/bg.png",
                    // height: 290,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                  ),
                  Positioned(
                      left: 25,
                      top: SizeConfig.blockSizeVertical * 8,
                      child: backArrowCustom()),
                ],
              ),
              // Positioned(
              //   top: SizeConfig.blockSizeVertical * 18,
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
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return ListView(
                      padding: EdgeInsets.all(0),
                      children: <Widget>[
                        if (isSocialEmail)
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Container(
                                //   width: constraints.maxWidth * 0.6,
                                //   height: constraints.maxHeight * 0.06,
                                //   margin: EdgeInsets.fromLTRB(0.0,
                                //       constraints.maxHeight * 0.01, 0.0, 0.0),
                                //   child: FittedBox(
                                //     fit: BoxFit.contain,
                                //     child: Consumer<UserProvider>(
                                //       builder: (context, provider, child) =>
                                //           provider.notification,
                                //     ),
                                //   ),
                                // ),
                                Text(
                                  "SignUp With " +
                                      (paramArguments.isEmpty
                                          ? 'Social Site'
                                          : (capitalize(
                                              paramArguments['social_type']))),
                                  style: AppTextStyle.titleStyle,
                                ),
                                SizedBox(height: 20),
                                if (!isSocialPhone)
                                  Container(
                                    alignment: Alignment.center,
                                    width: constraints.maxWidth * 0.92,
                                    margin: EdgeInsets.only(
                                        bottom:
                                            2 * SizeConfig.blockSizeVertical),
                                    child: Text(
                                      " Please enter mobile number to complete registration.",
                                      style: AppTextStyle.disStyle.copyWith(
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                CustomTextField(
                                  label: 'Enter email',
                                  controller: emailTextControl,
                                  readOnly: true,
                                  // prefixIcon: Icon(Icons.mail,
                                  //     color: Dark, size: 20),
                                  validator: (value) {
                                    email = value!.trim();
                                    return Validate.validateEmail(value);
                                  },
                                  onFieldSubmitted: (_) => setFocus(context,
                                      focusNode: _phoneFocusNode),
                                  focusNode: _emailFocusNode,
                                  enabled: !isSocialEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                ),
                                // Container(
                                //   width:
                                //       SizeConfig.blockSizeHorizontal *
                                //           80,
                                //   margin: EdgeInsets.only(
                                //     top: SizeConfig.blockSizeVertical *
                                //         1,
                                //   ),
                                //   // width: constraints.maxWidth * 0.9,
                                //   // margin: EdgeInsets.fromLTRB(
                                //   //     0.0,
                                //   //     constraints.maxHeight * 0.02,
                                //   //     0.0,
                                //   //     0.0),
                                //   child: TextFormField(
                                //     controller: emailTextControl,
                                //     decoration: InputDecoration(
                                //       contentPadding:
                                //           EdgeInsets.symmetric(
                                //               vertical: constraints
                                //                       .maxHeight *
                                //                   0.01),
                                //       border: OutlineInputBorder(
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(
                                //                 constraints.maxHeight)),
                                //         borderSide: BorderSide(
                                //             color: Dark,
                                //             width:
                                //                 constraints.maxHeight),
                                //       ),
                                //       enabledBorder: OutlineInputBorder(
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(
                                //                 constraints.maxHeight)),
                                //         borderSide: BorderSide(
                                //             color: Dark, width: 2),
                                //       ),
                                //       disabledBorder:
                                //           OutlineInputBorder(
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(
                                //                 constraints.maxHeight)),
                                //         borderSide: BorderSide(
                                //             color: Dark, width: 2),
                                //       ),
                                //       labelText: 'Enter email',
                                //       errorStyle: TextStyle(
                                //         fontSize:
                                //             constraints.maxWidth * 0.04,
                                //         decorationColor: Dark,
                                //       ),
                                //       prefixIcon: Icon(
                                //         Icons.mail,
                                //         color: Dark,
                                //         size: 20,
                                //       ),
                                //       errorBorder: OutlineInputBorder(
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(
                                //                 constraints.maxHeight)),
                                //         borderSide: BorderSide(
                                //             color: Dark, width: 2),
                                //       ),
                                //       focusedErrorBorder:
                                //           OutlineInputBorder(
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(
                                //                 constraints.maxHeight)),
                                //         borderSide: BorderSide(
                                //             color: Dark, width: 2),
                                //       ),
                                //     ),
                                //     style: TextStyle(
                                //         fontSize: constraints.maxWidth *
                                //             0.05),
                                //     validator: (value) {
                                //       email = value!.trim();
                                //       return Validate.validateEmail(
                                //           value);
                                //     },
                                //     onFieldSubmitted: (_) => setFocus(
                                //         context,
                                //         focusNode: _phoneFocusNode),
                                //     focusNode: _emailFocusNode,
                                //     enabled: !isSocialEmail,
                                //     keyboardType:
                                //         TextInputType.emailAddress,
                                //     textInputAction:
                                //         TextInputAction.next,
                                //   ),
                                // ),
                                Container(
                                  width: SizeConfig.blockSizeHorizontal * 85,
                                  margin: EdgeInsets.only(
                                    top: SizeConfig.blockSizeVertical * 1,
                                  ),
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
                                    onCountryChanged: (val) {
                                      countryCode = "+${val.dialCode}";
                                      setState(() {});
                                      print(';;;; $countryCode');
                                    },
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
                                    keyboardType: TextInputType.phone,
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
                                SizedBox(height: 20),
                                Provider.of<UserProvider>(context).status ==
                                        Status.Authenticating
                                    ? Center(child: CircularProgressIndicator())
                                    : Padding(
                                        padding: EdgeInsets.only(
                                            top: 20,
                                            left: 30,
                                            right: 30,
                                            bottom: 10),
                                        child: CustomButton(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12),
                                          title: 'SignUp',
                                          onTap: () {
                                            submit();
                                          },
                                        ),
                                      ),
                              ]),
                        if (!isSocialEmail)
                          Column(
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  width: constraints.maxWidth * 0.90,
                                  margin: EdgeInsets.only(
                                      bottom: 2 * SizeConfig.blockSizeVertical),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Note:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              2 * SizeConfig.blockSizeVertical,
                                          color: Colors.redAccent),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: " Your " +
                                                (paramArguments == null
                                                    ? 'Social'
                                                    : paramArguments[
                                                        'social_type']) +
                                                " privacy setting are not allowing login using " +
                                                (paramArguments == null
                                                    ? 'social site'
                                                    : paramArguments[
                                                        'social_type']) +
                                                ". Please complete signup procedure to use the app.",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 2 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  )),
                              Container(
                                height: constraints.maxHeight * 0.11,
                                width: constraints.maxWidth * 0.65,
                                margin: EdgeInsets.only(
                                    top: constraints.maxHeight * 0.05,
                                    bottom: constraints.maxHeight * 0.05),
                                child: Material(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(
                                        constraints.maxHeight * 0.5),
                                    topRight: Radius.circular(
                                        constraints.maxHeight * 0.5),
                                    bottomLeft: Radius.circular(
                                        constraints.maxHeight * 0.5),
                                  ),
                                  color: Color.fromRGBO(14, 155, 207, 1.0),
                                  elevation: 5.0,
                                  child: MaterialButton(
                                    onPressed: goForAnotherMethod,
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return Container(
                                          //color: Colors.black26,
                                          width: constraints.maxWidth * 0.95,
                                          child: Text(
                                            'Use Another Method',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 2 *
                                                  SizeConfig.blockSizeVertical,
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1.0),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  String capitalize(String word) {
    return "${word[0].toUpperCase()}${word.substring(1)}";
  }
}

// if (isSocialEmail)
//   Container(
//       alignment: Alignment.center,
//       width: constraints.maxWidth * 0.90,
//       margin: EdgeInsets.only(
//           bottom: 2 *
//               SizeConfig
//                   .blockSizeVertical),
//       child: RichText(
//         text: TextSpan(
//           text: 'Note:',
//           style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 2 *
//                   SizeConfig
//                       .blockSizeVertical,
//               color: Colors.redAccent),
//           children: <TextSpan>[
//             TextSpan(
//                 text: "Due to security reason we are not able to get email with " +
//                     (paramArguments ==
//                             null
//                         ? 'social'
//                         : paramArguments[
//                             'social_type']) +
//                     " login method. So please enter valid email Which you used with in " +
//                     (paramArguments ==
//                             null
//                         ? 'social'
//                         : paramArguments[
//                             'social_type']) +
//                     " login",
//                 style: TextStyle(
//                     fontWeight:
//                         FontWeight.w300,
//                     fontSize: 2 *
//                         SizeConfig
//                             .blockSizeVertical,
//                     color: Colors.grey)),
//           ],
//         ),
//       )),
