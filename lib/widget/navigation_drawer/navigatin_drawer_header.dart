//import 'dart:html';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../responsive/percentage_mediaquery.dart';
import '../../utils/app_colors.dart';

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
      height: Responsive.height(20, context),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          colors: [
            Color(0xFF79e6c9).withOpacity(0.5),
            Color(0xFF38b8cd).withOpacity(0.5),
          ],
          stops: [0.0, 1.0],
        ),
        // color: Color(0xff76DECD),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  //width: constraints.maxWidth * 0.3,
                  margin:
                      EdgeInsets.fromLTRB(constraints.maxWidth * 0.05, 0, 0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: constraints.maxWidth * 0.07,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Icon(Icons.person,
                            size: 30, color: Color(0xff0e9bcf)),
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
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text(
                          name.toString(),
                          style: AppTextStyle.appBarStyle,
                        ),
                      );
                    }),
              ],
            ),
//
            Container(
              width: constraints.maxWidth * 0.99,
              margin:
                  EdgeInsets.fromLTRB(0.0, constraints.maxHeight * 0.7, 0.0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // SizedBox(width: constraints.maxWidth * 0.03),
                  FutureBuilder(
                      future: _userEMail,
                      builder: (context, snapshot) {
                        Object? email = snapshot.data;
                        return Container(
                          width: constraints.maxWidth * 0.85,
                          child: AutoSizeText(
                            email.toString(),
                            style: AppTextStyle.titleStyle.copyWith(
                                fontSize: 16,
                                height: 1.2,
                                fontWeight: FontWeight.w400),
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
