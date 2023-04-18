import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_app/routing/route_names.dart' as routes;

import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../services/navigation_service.dart';
import '../../widget/CustomAppBar.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Settings();
}

class _Settings extends State<Settings> {
  final NavigationService _navigationService = locator<NavigationService>();
  bool _switchVal = false;
  bool _notificationVal = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomAppBar(
              title: 'Settings ',
              textWidth: Responsive.width(32, context),
              iconLeft: FontAwesomeIcons.arrowLeft,
              preferedHeight: Responsive.height(15, context),
              onTap1: () {
                _navigationService.goBack();
              },
              iconRight: null),
          LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.03),
                  margin: EdgeInsetsDirectional.fromSTEB(
                      0.0, constraints.maxHeight * 0.23, 0.0, 0.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Container(
                        width: constraints.maxWidth * 0.25,
                        margin: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.01),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'Options',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              color: const Color(0xad060606),
                              letterSpacing: 0.132,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Divider(height: constraints.maxHeight * 0.014),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.07),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: constraints.maxWidth * 0.32,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'Theme Mode',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              color: const Color(0xad060606),
                              letterSpacing: 0.176,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        width: constraints.maxWidth * 0.16,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Switch(
                            onChanged: (bool value) {
                              setState(() => this._switchVal = value);
                            },
                            value: this._switchVal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.07),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: constraints.maxWidth * 0.31,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'Notifications',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              color: const Color(0xad060606),
                              letterSpacing: 0.176,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        width: constraints.maxWidth * 0.16,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Switch(
                            onChanged: (bool value) {
                              setState(() => this._notificationVal = value);
                            },
                            value: this._notificationVal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.02,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: constraints.maxWidth * 0.01,
                    ),
                    Container(
                      width: constraints.maxWidth * 0.16,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: IconButton(
                          icon: Icon(Icons.supervised_user_circle),
                          onPressed: () {},
                          color: Color.fromRGBO(0, 0, 0, 0.34),
                          iconSize: 26,
                        ),
                      ),
                    ),
                    Container(
                      width: constraints.maxWidth * 0.27,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Accounts',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            color: const Color(0xad060606),
                            letterSpacing: 0.176,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: constraints.maxHeight * 0.02,
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.07),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: constraints.maxWidth * 0.44,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'Change Password',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              color: const Color(0xad060606),
                              letterSpacing: 0.176,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        width: constraints.maxWidth * 0.13,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: IconButton(
                            icon: Icon(Icons.keyboard_arrow_right),
                            onPressed: () {
                              _navigationService.navigateToReplacement(
                                routes.ChangePasswordRoute,
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
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.07),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: constraints.maxWidth * 0.27,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'Save Cards',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              color: const Color(0xad060606),
                              letterSpacing: 0.176,
                              height: 1.1875,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        width: constraints.maxWidth * 0.13,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: IconButton(
                            icon: Icon(Icons.keyboard_arrow_right),
                            onPressed: () {},
                            color: Color.fromRGBO(0, 0, 0, 0.34),
                            iconSize: 26,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          })
        ],
      ),
    );
  }
}
