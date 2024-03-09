import 'package:flutter/material.dart';
import 'package:Smart_Theory_Test/routing/route_names.dart' as routes;
import 'package:Smart_Theory_Test/utils/app_colors.dart';

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
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: CustomAppBar(
                title: 'Settings ',
                textWidth: Responsive.width(32, context),
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
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(
                  children: <Widget>[
                    // Container(
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: constraints.maxWidth * 0.03),
                    //   margin: EdgeInsetsDirectional.fromSTEB(0.0, 10, 0.0, 0.0),
                    //   child: Align(
                    //     alignment: Alignment.topLeft,
                    //     child: LayoutBuilder(builder: (context, constraints) {
                    //       return Row(
                    //         children: [
                    //           Container(
                    //             width: constraints.maxWidth * 0.16,
                    //             child: FittedBox(
                    //               fit: BoxFit.contain,
                    //               child: IconButton(
                    //                 icon: Icon(Icons.supervised_user_circle),
                    //                 onPressed: () {},
                    //                 color: Color.fromRGBO(0, 0, 0, 0.34),
                    //                 iconSize: 26,
                    //               ),
                    //             ),
                    //           ),
                    //           Container(
                    //             width: constraints.maxWidth * 0.20,
                    //             child: FittedBox(
                    //               fit: BoxFit.contain,
                    //               child: Text(
                    //                 'Account',
                    //                 style: AppTextStyle.titleStyle.copyWith(
                    //                     color: AppColors.grey,
                    //                     fontWeight: FontWeight.w600),
                    //                 textAlign: TextAlign.left,
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       );
                    //     }),
                    //   ),
                    // ),
                    // Divider(height: constraints.maxHeight * 0.014),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.07,
                          vertical: 40),
                      child: InkWell(
                        onTap: () {
                          _navigationService.navigateToReplacement(
                            routes.ChangePasswordRoute,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Change Password',
                              style: AppTextStyle.textStyle.copyWith(
                                  height: 1.2, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                            Icon(Icons.keyboard_arrow_right, size: 26),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}

/// For V2 USE This LayoutBuilder
/*

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

 */
