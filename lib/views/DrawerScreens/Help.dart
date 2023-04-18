import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_app/views/DrawerScreens/FAQ.dart';
import 'package:student_app/views/WebView.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/global.dart';
import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/navigation_service.dart';
import '../../widget/CustomAppBar.dart';
import 'PrivacyPolicy.dart';
import 'adiFAQ.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Help();
}

class _Help extends State<Help> {
  final NavigationService _navigationService = locator<NavigationService>();

  late String _termConditionUrl;
  late int _userType = 2;
  void _launchURL(String _url) async {
    print("hello");
    try {
      await launch(_url);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomAppBar(
              title: 'Help',
              textWidth: Responsive.width(18, context),
              iconLeft: FontAwesomeIcons.arrowLeft,
              preferedHeight: Responsive.height(16, context),
              onTap1: () {
                _navigationService.goBack();
              },
              iconRight: null),
          LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _termConditionUrl =
                        "$api/static/terms-and-conditions-of-use";
                    print(_termConditionUrl);
                    _launchURL(_termConditionUrl);
                  },
                  child: Container(
                    width: constraints.maxWidth * 0.99,
                    margin: EdgeInsetsDirectional.fromSTEB(
                        constraints.maxWidth * 0.04,
                        constraints.maxHeight * 0.21,
                        constraints.maxWidth * 0.01,
                        0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: constraints.maxWidth * 0.54,
                          child: Text(
                            'Terms and Conditions',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 2.5 * SizeConfig.blockSizeVertical,
                              color: const Color(0xad060606),
                              letterSpacing: 0.132,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth * 0.13,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: IconButton(
                              icon: Icon(Icons.keyboard_arrow_right),
                              onPressed: () {
                                _termConditionUrl =
                                    "$api/static/terms-and-conditions-of-use";
                                print(_termConditionUrl);
                                _launchURL(_termConditionUrl);
                              },
                              color: Color.fromRGBO(0, 0, 0, 0.34),
                              iconSize: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: constraints.maxWidth * 0.95,
                  child: Divider(
                      height: constraints.maxHeight * 0.03, color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewContainer('https://mockdrivingtest.com/static/privacy-policy', 'Privacy Policy')
                      ),
                    );
                  },
                  child: Container(
                    width: constraints.maxWidth * 0.99,
                    margin: EdgeInsetsDirectional.fromSTEB(
                        constraints.maxWidth * 0.04,
                        0,
                        constraints.maxWidth * 0.01,
                        0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: constraints.maxWidth * 0.55,
                          child: Text(
                            'Privacy Policy',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 2.5 * SizeConfig.blockSizeVertical,
                              color: const Color(0xad060606),
                              letterSpacing: 0.132,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth * 0.13,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: IconButton(
                              icon: Icon(Icons.keyboard_arrow_right),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WebViewContainer('https://mockdrivingtest.com/static/privacy-policy', 'Privacy Policy')
                                  ),
                                );
                              },
                              color: Color.fromRGBO(0, 0, 0, 0.34),
                              iconSize: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: constraints.maxWidth * 0.95,
                  child: Divider(
                      height: constraints.maxHeight * 0.03, color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    print("userType....$_userType");
                    _userType == 2
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TileApp(),
                            ),
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdiFaq(),
                            ),
                          );
                  },
                  child: Container(
                    width: constraints.maxWidth * 0.99,
                    margin: EdgeInsetsDirectional.fromSTEB(
                        constraints.maxWidth * 0.04,
                        0,
                        constraints.maxWidth * 0.01,
                        0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: constraints.maxWidth * 0.34,
                          child: Text(
                            'FAQs',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 2.5 * SizeConfig.blockSizeVertical,
                              color: const Color(0xad060606),
                              letterSpacing: 0.132,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth * 0.13,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: IconButton(
                              icon: Icon(Icons.keyboard_arrow_right),
                              onPressed: () {
                                print("userType....$_userType");
                                _userType == 2
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TileApp(),
                                        ),
                                      )
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AdiFaq(),
                                        ),
                                      );
                              },
                              color: Color.fromRGBO(0, 0, 0, 0.34),
                              iconSize: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: constraints.maxWidth * 0.95,
                  child: Divider(
                      height: constraints.maxHeight * 0.03, color: Colors.grey),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Container(
                      width: constraints.maxWidth * 0.55,
                      margin: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.045),
                      child: Text(
                        'Version',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 2.5 * SizeConfig.blockSizeVertical,
                          color: const Color(0xad060606),
                          letterSpacing: 0.132,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    );
                  }),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Container(
                      width: constraints.maxWidth * 0.55,
                      margin: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.06),
                      child: Text(
                        '1.0.0',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 2 * SizeConfig.blockSizeVertical,
                          color: const Color(0xad060606),
                          letterSpacing: 0.132,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    );
                  }),
                ),
              ],
            );
          })
        ],
      ),
    );
  }
}
