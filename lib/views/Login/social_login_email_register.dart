import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:student_app/Constants/app_colors.dart';
import 'package:student_app/routing/route_names.dart' as routes;
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../../enums/Autentication_status.dart';
import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/auth.dart';
import '../../services/methods.dart';
import '../../services/navigation_service.dart';
import '../../services/validator.dart';
import '../../widget/Header/Login_RegisterHeader.dart';

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
  Future<void> submit() async {
    final form = _formKey.currentState;

    if (form!.validate()) {
      Map formParams = {
        'token': paramArguments['token'],
        'social_type': paramArguments['social_type'],
        'social_site_id': paramArguments['social_site_id'],
        'email': email,
        'phone': mobile,
        'user_type': userType,
        'accessType': 'register'
      };
      print("Data on submit : $formParams");
      ToastContext().init(context);

      Map? apiResponse = await Provider.of<AuthProvider>(context, listen: false)
          .socialLoginWithMdtRegister(formParams);
      print("Response from registrant 1: $apiResponse");
      if (apiResponse != null && apiResponse['success'] == false) {
        print("Response from registrant 2 : $apiResponse");
        Toast.show(apiResponse['message'],
            duration: Toast.lengthLong, gravity: Toast.center);
      }
    }
  }

  goForAnotherMethod() {
    _navigationService.navigateToReplacement(routes.WelcomeRoute);
  }

  @override
  void initState() {
    super.initState();
    // KeyboardVisibilityNotification().addNewListener(
    //   onChange: (bool visible) {
    //     if (!visible) {
    //       FocusScopeNode currentFocus = FocusScope.of(context);
    //       if (!currentFocus.hasPrimaryFocus) {
    //         currentFocus.unfocus();
    //       }
    //     }
    //   },
    // );
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
    TextStyle defaultStyle = TextStyle(
        fontFamily: 'Poppins',
        fontSize: 50.0,
        fontWeight: FontWeight.w600,
        color: Color.fromRGBO(42, 8, 69, 1.0));
    TextStyle linkStyle = TextStyle(color: Colors.blue);
    return new Scaffold(
      key: _key,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            height: Responsive.height(100, context),
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  child: Header(),
                ),
                Container(
                  width: Responsive.width(85, context),
                  height: Responsive.height(53, context),
                  margin: EdgeInsets.fromLTRB(
                      Responsive.width(7.5, context),
                      Responsive.height(40, context),
                      Responsive.width(7.5, context),
                      0.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        Responsive.height(53, context) * 0.07),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                        blurRadius: 6.0, // soften the shadow
                        spreadRadius: 5.0, //extend the shadow
                        offset: Offset(
                          0.0, // Move to right 10  horizontally
                          3.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Center(
                        child: Container(
                          width: constraints.maxWidth * 0.9,
                          height: constraints.maxHeight,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return ListView(
                                children: <Widget>[
                                  if (isSocialEmail)
                                    Column(children: <Widget>[
                                      Container(
                                        width: constraints.maxWidth * 0.6,
                                        height: constraints.maxHeight * 0.06,
                                        margin: EdgeInsets.fromLTRB(
                                            0.0,
                                            constraints.maxHeight * 0.01,
                                            0.0,
                                            0.0),
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Consumer<AuthProvider>(
                                            builder:
                                                (context, provider, child) =>
                                                    provider.notification,
                                          ),
                                        ),
                                      ),
                                      Container(
                                          alignment: Alignment.center,
                                          width: constraints.maxWidth * 0.99,
                                          margin: EdgeInsets.only(
                                              bottom: 2 *
                                                  SizeConfig.blockSizeVertical),
                                          child: Text(
                                            "SignUp With " +
                                                (paramArguments == null
                                                    ? 'Social Site'
                                                    : (capitalize(
                                                        paramArguments[
                                                            'social_type']))),
                                            style: TextStyle(
                                                fontSize: 2.5 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                fontWeight: FontWeight.w600),
                                          )),
                                      if (!isSocialPhone)
                                        Container(
                                            alignment: Alignment.center,
                                            width: constraints.maxWidth * 0.90,
                                            margin: EdgeInsets.only(
                                                bottom: 2 *
                                                    SizeConfig
                                                        .blockSizeVertical),
                                            child: RichText(
                                              text: TextSpan(
                                                text: 'Note:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 2 *
                                                        SizeConfig
                                                            .blockSizeVertical,
                                                    color: Colors.redAccent),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          " Please enter mobile number to complete registration.",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: 2 *
                                                              SizeConfig
                                                                  .blockSizeVertical,
                                                          color: Colors.grey)),
                                                ],
                                              ),
                                            )),
                                      Container(
                                        width: constraints.maxWidth * 0.9,
                                        margin: EdgeInsets.fromLTRB(
                                            0.0,
                                            constraints.maxHeight * 0.02,
                                            0.0,
                                            0.0),
                                        child: TextFormField(
                                          controller: emailTextControl,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical:
                                                        constraints.maxHeight *
                                                            0.04),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      constraints.maxHeight)),
                                              borderSide: BorderSide(
                                                  color: Dark,
                                                  width: constraints.maxHeight),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      constraints.maxHeight)),
                                              borderSide: BorderSide(
                                                  color: Dark, width: 2),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      constraints.maxHeight)),
                                              borderSide: BorderSide(
                                                  color: Dark, width: 2),
                                            ),
                                            labelText: 'Enter email',
                                            errorStyle: TextStyle(
                                              fontSize:
                                                  constraints.maxWidth * 0.05,
                                              decorationColor: Dark,
                                            ),
                                            prefixIcon: Icon(
                                              Icons.mail,
                                              color: Dark,
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      constraints.maxHeight)),
                                              borderSide: BorderSide(
                                                  color: Dark, width: 2),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      constraints.maxHeight)),
                                              borderSide: BorderSide(
                                                  color: Dark, width: 2),
                                            ),
                                          ),
                                          style: TextStyle(
                                              fontSize:
                                                  constraints.maxWidth * 0.07),
                                          validator: (value) {
                                            email = value!.trim();
                                            return Validate.validateEmail(
                                                value);
                                          },
                                          onFieldSubmitted: (_) => setFocus(
                                              context,
                                              focusNode: _phoneFocusNode),
                                          focusNode: _emailFocusNode,
                                          enabled: !isSocialEmail,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textInputAction: TextInputAction.next,
                                        ),
                                      ),
                                      Container(
                                        width: constraints.maxWidth * 0.9,
                                        margin: EdgeInsets.fromLTRB(
                                            0.0,
                                            constraints.maxHeight * 0.03,
                                            0.0,
                                            0.0),
                                        child: IntlPhoneField(
                                          autofocus: false,
                                          textAlign: TextAlign.left,
                                          dropdownIcon: Icon(
                                            Icons.arrow_drop_down,
                                            color: Dark,
                                          ),
                                          autovalidateMode:
                                              AutovalidateMode.disabled,
                                          //disableLengthCheck: true,
                                          controller: phoneTextControl,
                                          focusNode: _phoneFocusNode,
                                          cursorColor: Dark,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical:
                                                        constraints.maxHeight *
                                                            0.04),
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
                                                  color: Dark, width: 2),
                                            ),
                                            labelText: 'Mobile',
                                            errorStyle: TextStyle(
                                              fontSize:
                                                  constraints.maxWidth * 0.05,
                                              decorationColor: Dark,
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25)),
                                              borderSide: const BorderSide(
                                                  color: Dark, width: 2),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25)),
                                              borderSide: const BorderSide(
                                                  color: Dark, width: 2),
                                            ),
                                            floatingLabelStyle:
                                                TextStyle(color: Dark),
                                            // errorStyle: TextStyle(
                                            //     fontSize: constraints.maxWidth * 0.05),
                                            focusColor: Dark,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(25),
                                              ),
                                              borderSide: const BorderSide(
                                                  color: Dark, width: 2),
                                            ),
                                          ),
                                          initialCountryCode: 'GB',
                                          showCountryFlag: false,
                                          keyboardType: TextInputType.text,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          style: TextStyle(
                                              fontSize:
                                                  constraints.maxWidth * 0.07),
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
                                                          offset:
                                                              phoneTextControl
                                                                  .text
                                                                  .length));
                                              countryCode = phone.countryCode;
                                            });
                                          },
                                        ),
                                      ),
                                      Provider.of<AuthProvider>(context)
                                                  .status ==
                                              Status.Authenticating
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : Container(
                                              height:
                                                  constraints.maxHeight * 0.11,
                                              width:
                                                  constraints.maxWidth * 0.65,
                                              margin: EdgeInsets.only(
                                                  top: constraints.maxHeight *
                                                      0.05,
                                                  bottom:
                                                      constraints.maxHeight *
                                                          0.05),
                                              child: Material(
                                                borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(
                                                      constraints.maxHeight *
                                                          0.5),
                                                  topRight: Radius.circular(
                                                      constraints.maxHeight *
                                                          0.5),
                                                  bottomLeft: Radius.circular(
                                                      constraints.maxHeight *
                                                          0.5),
                                                ),
                                                color: Color.fromRGBO(
                                                    14, 155, 207, 1.0),
                                                elevation: 5.0,
                                                child: MaterialButton(
                                                  onPressed: submit,
                                                  child: LayoutBuilder(
                                                    builder:
                                                        (context, constraints) {
                                                      return Container(
                                                        //color: Colors.black26,
                                                        width: constraints
                                                                .maxWidth *
                                                            0.35,
                                                        child: FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: Text(
                                                            'SignUp',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 50,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      1.0),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
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
                                                bottom: 2 *
                                                    SizeConfig
                                                        .blockSizeVertical),
                                            child: RichText(
                                              text: TextSpan(
                                                text: 'Note:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 2 *
                                                        SizeConfig
                                                            .blockSizeVertical,
                                                    color: Colors.redAccent),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: " Your " +
                                                          (paramArguments ==
                                                                  null
                                                              ? 'Social'
                                                              : paramArguments[
                                                                  'social_type']) +
                                                          " privacy setting are not allowing login using " +
                                                          (paramArguments ==
                                                                  null
                                                              ? 'social site'
                                                              : paramArguments[
                                                                  'social_type']) +
                                                          ". Please complete signup procedure to use the app.",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w300,
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
                                              bottom:
                                                  constraints.maxHeight * 0.05),
                                          child: Material(
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(
                                                  constraints.maxHeight * 0.5),
                                              topRight: Radius.circular(
                                                  constraints.maxHeight * 0.5),
                                              bottomLeft: Radius.circular(
                                                  constraints.maxHeight * 0.5),
                                            ),
                                            color: Color.fromRGBO(
                                                14, 155, 207, 1.0),
                                            elevation: 5.0,
                                            child: MaterialButton(
                                              onPressed: goForAnotherMethod,
                                              child: LayoutBuilder(
                                                builder:
                                                    (context, constraints) {
                                                  return Container(
                                                    //color: Colors.black26,
                                                    width:
                                                        constraints.maxWidth *
                                                            0.95,
                                                    child: Text(
                                                      'Use Another Method',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 2 *
                                                            SizeConfig
                                                                .blockSizeVertical,
                                                        fontWeight:
                                                            FontWeight.w700,
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
                      );
                    },
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
