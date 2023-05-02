import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_app/locater.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/adi_driver_services.dart';
import '../../services/auth.dart';
import '../../services/navigation_service.dart';
import '../../style/global_style.dart';
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
      body: Stack(
        children: <Widget>[
          CustomAppBar(
              title: 'Contact Us',
              textWidth: Responsive.width(40, context),
              iconLeft: FontAwesomeIcons.arrowLeft,
              preferedHeight: Responsive.height(15, context),
              onTap1: () {
                _navigationService.goBack();
              },
              iconRight: null),
          Container(
              width: Responsive.width(100, context),
              height: Responsive.height(76, context),
              margin: EdgeInsets.fromLTRB(
                  Responsive.width(5, context),
                  Responsive.height(21, context),
                  Responsive.width(5, context),
                  0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(Responsive.width(8, context)),
                ),
                border: Border.all(
                  width: Responsive.width(0.3, context),
                  color: Color(0xff707070),
                ),
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                          width: constraints.maxWidth * 0.99,
                          height: constraints.maxHeight * 0.12,
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.05),
                          margin: EdgeInsets.fromLTRB(
                              0.0, constraints.maxHeight * 0.04, 0.0, 0.0),
                          child: TextField(
                              controller: name,
                              style: inputTextStyle(SizeConfig.inputFontSize),
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                focusedBorder: inputFocusedBorderStyle(),
                                enabledBorder: inputBorderStyle(),
                                hintStyle:
                                    placeholderStyle(SizeConfig.labelFontSize),
                                contentPadding:
                                    EdgeInsets.fromLTRB(5, 0, 3, 16),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {})),
                      Container(
                          width: constraints.maxWidth * 0.99,
                          height: constraints.maxHeight * 0.12,
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.05),
                          margin: EdgeInsets.fromLTRB(
                              0.0, constraints.maxHeight * 0.024, 0.0, 0.0),
                          child: TextField(
                              controller: phone,
                              style: inputTextStyle(SizeConfig.inputFontSize),
                              decoration: InputDecoration(
                                labelText: 'Mobile No',
                                focusedBorder: inputFocusedBorderStyle(),
                                enabledBorder: inputBorderStyle(),
                                hintStyle:
                                    placeholderStyle(SizeConfig.labelFontSize),
                                contentPadding:
                                    EdgeInsets.fromLTRB(5, 0, 3, 16),
                              ),
                              readOnly: true,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {})),
                      Container(
                          width: constraints.maxWidth * 0.99,
                          height: constraints.maxHeight * 0.12,
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.05),
                          margin: EdgeInsets.fromLTRB(
                              0.0, constraints.maxHeight * 0.024, 0.0, 0.0),
                          child: TextField(
                              controller: email,
                              style: inputTextStyle(SizeConfig.inputFontSize),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                focusedBorder: inputFocusedBorderStyle(),
                                enabledBorder: inputBorderStyle(),
                                hintStyle:
                                    placeholderStyle(SizeConfig.labelFontSize),
                                contentPadding:
                                    EdgeInsets.fromLTRB(5, 0, 3, 16),
                              ),
                              readOnly: true,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {})),
                      Card(
                          margin: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.046,
                              vertical: constraints.maxHeight * 0.02),
                          color: Colors.white,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * 0.0,
                                  vertical: constraints.maxHeight * 0.0),
                              child: TextField(
                                  controller: message,
                                  maxLines: 4,
                                  style:
                                      inputTextStyle(SizeConfig.inputFontSize),
                                  decoration: InputDecoration(
                                    labelText: 'Message',
                                    focusedBorder: inputFocusedBorderStyle(),
                                    enabledBorder: inputBorderStyle(),
                                    hintText: 'Type you message here...',
                                    hintStyle: placeholderStyle(
                                        SizeConfig.labelFontSize),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(5, 0, 3, 16),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) {}))),
                      SizedBox(
                        height: constraints.maxHeight * 0.03,
                      ),
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
                      Container(
                        height: 50,
                        width: constraints.maxWidth * 0.6,
                        margin:
                            EdgeInsets.only(top: constraints.maxHeight * 0.05),
                        child: Material(
                          borderRadius: BorderRadius.only(
                            bottomRight:
                                Radius.circular(constraints.maxWidth * 0.09),
                            topRight:
                                Radius.circular(constraints.maxWidth * 0.09),
                            bottomLeft:
                                Radius.circular(constraints.maxWidth * 0.09),
                          ),
                          color: Color.fromRGBO(14, 155, 207, 1.0),
                          elevation: 5.0,
                          child: GestureDetector(
                            onTap: updateUserDetail,
                            child: Center(
                              child: Container(
                                width: constraints.maxWidth * 0.23,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromRGBO(255, 255, 255, 1.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: constraints.maxHeight * 0.02,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.03),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: constraints.maxWidth * 0.07,
                                height: constraints.maxHeight * 0.09,
                              ),
                              Container(
                                width: constraints.maxWidth * 0.22,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    '  Phone:',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: const Color(0xad060606),
                                      letterSpacing: 0.132,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth * 0.02,
                              ),
                              Container(
                                width: constraints.maxWidth * 0.46,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    '+44 203 129 7741',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: const Color(0xad060606),
                                      letterSpacing: 0.132,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: constraints.maxHeight * 0.01,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.02),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: constraints.maxWidth * 0.074,
                            ),
                            Container(
                              width: constraints.maxWidth * 0.27,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  '  Email:     ',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: const Color(0xad060606),
                                    letterSpacing: 0.132,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // print('TAPP $gmailUrl');
                                // openGmailApp(gmailUrl);
                                openGmailApp();
                              },
                              child: Container(
                                width: constraints.maxWidth * 0.6,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    'info@mockdrivingtest.com',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      color: const Color(0xad0e9bcf),
                                      letterSpacing: 0.132,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: constraints.maxHeight * 0.02,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.06,
                            vertical: constraints.maxHeight * 0.012),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: constraints.maxWidth * 0.24,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      'Address:',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        color: const Color(0xad060606),
                                        letterSpacing: 0.132,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth * 0.04,
                                ),
                                Container(
                                  width: constraints.maxWidth * 0.6,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      'The Long Lodge, 265-269 \nKingston Road, London, \nSW19 3NW',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        color: const Color(0xad060606),
                                        letterSpacing: 0.132,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                );
              })),
        ],
      ),
    );
  }

  initializeApi(String loaderMessage) {
    checkInternet();
    showLoader(loaderMessage);
    getUserDetail().then((userDetail) {
      setState(() {
        name.text = userDetail['first_name'] +
            ((userDetail['last_name'] != null && userDetail['last_name'] != '')
                ? ' ' + userDetail['last_name']
                : '');
        email.text = userDetail['email'] != null ? userDetail['email'] : '';
        phone.text = userDetail['phone'] != null ? userDetail['phone'] : '';
      });
      closeLoader();
    }).catchError((onError) => closeLoader());
  }

  //Call APi Services
  Future<Map> getUserDetail() async {
    Map response =
        await Provider.of<AuthProvider>(context, listen: false).getUserData();
    return response;
  }

  //call api for save form data
  Future<void> updateUserDetail() async {
    if (name == null || name.text.trim() == '') {
      Fluttertoast.showToast(msg: 'Please! Enter your name.');
    } else if (email == null || email.text.trim() == '') {
      Fluttertoast.showToast(msg: 'Please! Enter your email id.');
    } else if (phone == null || phone.text.trim() == '') {
      Fluttertoast.showToast(msg: 'Please! Enter your phone number.');
    } else if (message == null || message.text.trim() == '') {
      Fluttertoast.showToast(msg: 'Please! Type your message.');
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
            _navigationService.goBack();
          }
        }
        closeLoader();
      } catch (e) {
        closeLoader();
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

  void openGmailApp() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: "feedback@geeksforgeeks.org",
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
