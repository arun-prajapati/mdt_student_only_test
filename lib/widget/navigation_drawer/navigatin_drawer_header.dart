//import 'dart:html';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';

// ignore: must_be_immutable
class NavigationDrawerHeader extends StatelessWidget {
  //const NavigationDrawerHeader({Key key}) : super(key: key);

  Future<String> getUserName() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String userName = storage.getString('userName').toString();
    return userName;
  }

  Future<String> getEMail() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String userEMail = storage.getString('eMail').toString();
    return userEMail;
  }

  late Future<String> _userName;
  late Future<String> _userEMail;

  @override
  Widget build(BuildContext context) {
    _userName = getUserName();
    _userEMail = getEMail();
    return Container(
      width: Responsive.width(100, context),
      height: Responsive.height(23, context),
      decoration: BoxDecoration(
        color: Color(0xff76DECD),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(Responsive.width(5, context)),
          bottomRight: Radius.circular(Responsive.width(5, context)),
        ),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: constraints.maxWidth * 0.3,
                  margin:
                      EdgeInsets.fromLTRB(constraints.maxWidth * 0.05, 0, 0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: constraints.maxWidth * 0.12,
                      child: Container(
                        width: constraints.maxWidth * 0.17,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Icon(
                            Icons.person,
                            size: 50.0,
                            color: Color(0xff0e9bcf),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                FutureBuilder(
                    future: _userName,
                    builder: (context, snapshot) {
                      Object name = snapshot.data ?? "";
                      return Container(
                        width: constraints.maxWidth * 0.6,
                        //color: Colors.black12,
                        padding: EdgeInsets.fromLTRB(
                            constraints.maxWidth * 0.01, 0, 0, 0),
                        child: Text(
                          name.toString(),
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      );
                    }),
              ],
            ),
//
            Container(
              width: constraints.maxWidth * 0.99,
              margin: EdgeInsets.fromLTRB(0.0, constraints.maxHeight * 0.8, 0.0,
                  constraints.maxHeight * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: constraints.maxWidth * 0.03,
                  ),
                  FutureBuilder(
                      future: _userEMail,
                      builder: (context, snapshot) {
                        Object? email = snapshot.data;
                        return Container(
                          width: constraints.maxWidth * 0.8,
                          child: AutoSizeText(
                            email.toString(),
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 3 * SizeConfig.blockSizeVertical,
                                color: Colors.white),
                          ),
                        );
                      }),
                  // Container(
                  //   width: constraints.maxWidth * 0.15,
                  //   child: FittedBox(
                  //     fit: BoxFit.contain,
                  //     child: Icon(
                  //       Icons.arrow_forward_ios,
                  //       size: 14.0,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
