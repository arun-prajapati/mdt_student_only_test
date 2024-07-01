import 'package:Smart_Theory_Test/services/validator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';
//import 'package:Smart_Theory_Test/routing/route_names.dart' as routes;

import '../../custom_button.dart';
import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/adi_driver_services.dart';
import '../../services/auth.dart';
import '../../services/navigation_service.dart';
import '../../style/global_style.dart';
import '../../utils/app_colors.dart';
import '../../widget/CustomAppBar.dart';
import '../../widget/CustomSpinner.dart';

class ContactUs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContactUs();
}

class _ContactUs extends State<ContactUs> {
  final NavigationService _navigationService = locator<NavigationService>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final AdiDriverCommonAPI _adiDriverCommonAPI = new AdiDriverCommonAPI();
  bool _checkval = false;

  late Map userDetail;
  final TextEditingController name = new TextEditingController(),
      email = new TextEditingController(),
      phone = new TextEditingController(),
      message = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.initializeApi("Loading...");
    });
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
  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: CustomAppBar(
                  title: 'Contact Us',
                  textWidth: Responsive.width(40, context),
                  iconLeft: Icons.arrow_back,
                  preferedHeight: Responsive.height(11, context),
                  onTap1: () {
                    _navigationService.goBack();
                  },
                  iconRight: null),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.12,
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.88,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white),
                  // margin: EdgeInsets.fromLTRB(
                  //     Responsive.width(5, context),
                  //     Responsive.height(13, context),
                  //     Responsive.width(5, context),
                  //     0),

                  // border: Border.all(
                  //   width: Responsive.width(0.3, context),
                  //   color: Color(0xff707070),
                  // ),

                  child: LayoutBuilder(builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            TextField(
                                controller: name,
                                style: inputTextStyle(SizeConfig.inputFontSize),
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                  labelStyle: AppTextStyle.textStyle.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.grey),
                                  focusedBorder: inputFocusedBorderStyle(),
                                  enabledBorder: inputBorderStyle(),
                                  hintStyle: placeholderStyle(
                                      SizeConfig.labelFontSize),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 0, 3, 16),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {}),
                            SizedBox(height: 12),
                            TextFormField(
                                controller: phone,
                                style: inputTextStyle(SizeConfig.inputFontSize),
                                decoration: InputDecoration(
                                    labelText: 'Mobile No',
                                    labelStyle: AppTextStyle.textStyle.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.grey),
                                    focusedBorder: inputFocusedBorderStyle(),
                                    enabledBorder: inputBorderStyle(),
                                    hintStyle: placeholderStyle(
                                        SizeConfig.labelFontSize),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 0, 3, 16),
                                    counterText: ""),
                                maxLength: 11,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {}),
                            SizedBox(height: 12),
                            TextFormField(
                                controller: email,
                                style: inputTextStyle(SizeConfig.inputFontSize),
                                validator: (value) {
                                  return Validate.validateEmail(value!);
                                },
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: AppTextStyle.textStyle.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.grey),
                                  focusedBorder: inputFocusedBorderStyle(),
                                  enabledBorder: inputBorderStyle(),
                                  focusedErrorBorder: inputBorderStyle(),
                                  border: inputBorderStyle(),
                                  errorBorder: inputBorderStyle(),
                                  hintStyle: placeholderStyle(
                                      SizeConfig.labelFontSize),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 0, 3, 16),
                                ),
                                // readOnly: true,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {}),
                            SizedBox(height: 12),
                            TextFormField(
                                controller: message,
                                maxLines: 4,
                                style: inputTextStyle(SizeConfig.inputFontSize),
                                decoration: InputDecoration(
                                  labelText: 'Message',
                                  labelStyle: AppTextStyle.textStyle.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.grey),
                                  focusedBorder: inputFocusedBorderStyle(),
                                  enabledBorder: inputBorderStyle(),
                                  hintText: 'Type you message here...',
                                  hintStyle: AppTextStyle.textStyle.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.black.withOpacity(0.8)),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 0, 3, 16),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {}),
                            //SizedBox(height: 12),
                            SizedBox(height: 30),
                            // Container(
                            //   margin: EdgeInsets.symmetric(
                            //       horizontal: constraints.maxWidth * 0.02),
                            //   height: constraints.maxHeight * 0.13,
                            //   width: constraints.maxWidth * 0.8,
                            //   color: Colors.grey,
                            //   child: Row(
                            //     children: <Widget>[
                            //       Container(
                            //         width: constraints.maxWidth * 0.2,
                            //         child: FittedBox(
                            //           fit: BoxFit.contain,
                            //           child: Checkbox(
                            //             onChanged: (bool value) {
                            //               setState(() => this._checkval = value);
                            //             },
                            //             value: this._checkval,
                            //           ),
                            //         ),
                            //       ),
                            //       Container(
                            //         width: constraints.maxWidth*0.43,
                            //         child: FittedBox(
                            //           fit: BoxFit.contain,
                            //           child: Text(
                            //             'I am not a Robot.',
                            //             style: TextStyle(
                            //               fontFamily: 'Poppins',
                            //               fontSize: 15,
                            //               color: const Color(0x6f060606),
                            //               letterSpacing: 0.132,
                            //               fontWeight: FontWeight.w800,
                            //
                            //             ),
                            //             textAlign: TextAlign.left,
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: constraints.maxHeight*0.02,
                            // ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 85),
                              child: CustomButton(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                title: 'Submit',
                                onTap: () {
                                  updateUserDetail();
                                },
                              ),
                            ),
                            // SizedBox(height: 30),
                            // Padding(
                            //   padding: EdgeInsets.symmetric(horizontal: 0),
                            //   child: Column(
                            //     children: [
                            //       Row(
                            //         children: [
                            //           Text(
                            //             'Phone     :',
                            //             style: AppTextStyle.textStyle.copyWith(
                            //                 fontWeight: FontWeight.w500,
                            //                 color: AppColors.black
                            //                     .withOpacity(0.8)),
                            //           ),
                            //           SizedBox(width: 10),
                            //           Text(
                            //             '+44 203 129 7741',
                            //             style: AppTextStyle.textStyle.copyWith(
                            //                 fontWeight: FontWeight.w500,
                            //                 color: AppColors.black
                            //                     .withOpacity(0.8)),
                            //           ),
                            //         ],
                            //       ),
                            //       SizedBox(height: 10),
                            //       Row(
                            //         children: [
                            //           Text(
                            //             'Email      :',
                            //             style: AppTextStyle.textStyle.copyWith(
                            //                 fontWeight: FontWeight.w500,
                            //                 color: AppColors.black
                            //                     .withOpacity(0.8)),
                            //           ),
                            //           SizedBox(width: 10),
                            //           InkWell(
                            //             onTap: () {
                            //               // print('TAPP $gmailUrl');
                            //               // openGmailApp(gmailUrl);
                            //               openGmailApp(
                            //                   "theory@mockdrivingtest.com");
                            //             },
                            //             child: Text(
                            //               'theory@mockdrivingtest.com',
                            //               style:
                            //                   AppTextStyle.textStyle.copyWith(
                            //                 fontWeight: FontWeight.w500,
                            //                 color: const Color(0xad0e9bcf),
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //       SizedBox(height: 10),
                            //       Row(
                            //         children: [
                            //           Text(
                            //             'Address :',
                            //             style: AppTextStyle.textStyle.copyWith(
                            //                 fontWeight: FontWeight.w500,
                            //                 color: AppColors.black
                            //                     .withOpacity(0.8)),
                            //           ),
                            //           SizedBox(width: 10),
                            //           Text(
                            //             'The Long Lodge, 265-269 \nKingston Road, London, \nSW19 3NW',
                            //             style: AppTextStyle.textStyle.copyWith(
                            //                 fontWeight: FontWeight.w500,
                            //                 color: AppColors.black
                            //                     .withOpacity(0.8)),
                            //           ),
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    );
                  })),
            ),
          ],
        ),
      ),
    );
  }

  initializeApi(String loaderMessage) {
    checkInternet();
    showLoader(loaderMessage);
    getUserDetail().then((userDetail) {
      setState(() {
        // name.text = userDetail['first_name'] +
        //     ((userDetail['last_name'] != null && userDetail['last_name'] != '')
        //         ? ' ' + userDetail['last_name']
        //         : '');
        // email.text = userDetail['email'] != null ? userDetail['email'] : '';
        // phone.text = userDetail['phone'] != null ? userDetail['phone'] : '';
        print('PhoneNumber----------${userDetail['phone']}');
      });
      closeLoader();
    }).catchError((onError) => closeLoader());
  }

  //Call APi Services
  Future<Map> getUserDetail() async {
    Map response = await Provider.of<UserProvider>(context, listen: false)
        .getUserData(context);
    return response;
  }

  //call api for save form data
  Future<void> updateUserDetail() async {
    print('Updates----------');
    if (_formKey.currentState!.validate()) {
      if (name == null || name.text.trim() == '') {
        Fluttertoast.showToast(msg: 'Please Enter your name');
      } else if (email == null || email.text.trim() == '') {
        Fluttertoast.showToast(msg: 'Please Enter your email id');
      } else if (phone == null || phone.text.trim() == '') {
        Fluttertoast.showToast(msg: 'Please Enter your phone number');
      } else if (phone.text.length != 10 && phone.text.length != 11) {
        Fluttertoast.showToast(msg: 'Please Enter valid phone number');
      } else if (message == null || message.text.trim() == '') {
        Fluttertoast.showToast(msg: 'Please Type your message');
      } else {
        showLoader("Submitting...");
        try {
          Map<String, String> formData = {
            'name': name != null ? name.text : '',
            'email': email != null ? email.text : '',
            'phone': phone != null ? phone.text : '',
            'message': message != null ? message.text : '',
          };
          Map response = await _adiDriverCommonAPI
              .submitContactUsMessage(formData)
              .catchError((onError) => closeLoader());
          if (response['message'] != null) {
            Fluttertoast.showToast(msg: response['message']);
            if (response['success'] == true) {
              print('ppppopopoopopo');
              Navigator.pop(context);
              Navigator.pop(context);
              Fluttertoast.showToast(msg: response['success']);

              // _navigationService.navigateTo(routes.HomeRoute);
            }
          }
          closeLoader();
        } catch (e) {
          closeLoader();
        }
      }
    }
  }

  void showLoader(String message) {
    CustomSpinner.showLoadingDialog(context, _keyLoader, message);
  }

  void closeLoader() {
    try {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    } catch (e) {}
  }

  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  void openGmailApp(email) {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    launchUrl(emailLaunchUri);
    print("EMAIL TAP: $emailLaunchUri");
  }

// openGmailApp(Uri url) async {
//   await canLaunchUrl(url)
//       ? await launchUrl(url)
//       : Fluttertoast.showToast(msg: 'Could not open the app ');
// }
}
