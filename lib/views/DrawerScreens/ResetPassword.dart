import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../responsive/percentage_mediaquery.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ResetPassword();
}

class _ResetPassword extends State<ResetPassword> {
  late TextEditingController _name;
  late TextEditingController _currentpassword;
  late TextEditingController _newpassword;
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: Responsive.width(100, context),
            height: Responsive.height(100, context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.0, -1.0),
                end: Alignment(0.0, 1.0),
                colors: [const Color(0xff0e9bcf), const Color(0xff78e6c8)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          // Adobe XD layer: 'pngflow.com' (shape)
          Container(
            width: Responsive.width(20, context),
            height: Responsive.height(20, context),
            child: FittedBox(
              fit: BoxFit.contain,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {},
                iconSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                Responsive.width(27.5, context),
                Responsive.height(10, context),
                Responsive.width(27.5, context),
                0.0),
            width: Responsive.width(45, context),
            height: Responsive.height(25, context),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/Lock.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
                width: Responsive.width(100, context),
                height: Responsive.height(60, context),
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(Responsive.width(4, context)),
                      topLeft: Radius.circular(Responsive.width(4, context))),
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
                child: LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: constraints.maxWidth * 0.5,
                          margin: EdgeInsets.only(
                              top: constraints.maxHeight * 0.05),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'Reset Password',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                color: const Color(0xff040404),
                                letterSpacing: 0.56,
                                fontWeight: FontWeight.w600,
                                height: 0.9,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(
                                0.0, constraints.maxHeight * 0.03, 0.0, 0.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(14, 155, 207, 1.0),
                                style: BorderStyle.solid,
                                width: constraints.maxWidth * 0.005,
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(constraints.maxHeight * 0.5)),
                            ),
                            width: constraints.maxWidth * 0.9,
                            height: constraints.maxHeight * 0.12,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Material(
                                  elevation: 2.0,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          constraints.maxHeight * 0.5)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          decoration: BoxDecoration(
                                              //color: Colors.red,
                                              borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(
                                                constraints.maxHeight * 0.5),
                                            topRight: Radius.circular(
                                                constraints.maxHeight * 0.5),
                                          )),
                                          width: constraints.maxWidth * 1,
                                          height: constraints.maxHeight,
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              return Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0,
                                                    constraints.maxHeight *
                                                        0.13,
                                                    constraints.maxWidth * 0.07,
                                                    0),
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  textAlignVertical:
                                                      TextAlignVertical.top,
                                                  controller: _name,
                                                  validator: (value) =>
                                                      (value!.isEmpty)
                                                          ? "Please Enter Email"
                                                          : null,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText:
                                                        'Current Password',
                                                    hintStyle: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Color.fromRGBO(
                                                          42, 8, 69, 1.0),
                                                      //fontSize: constraints.maxWidth*0.08,
                                                    ),
                                                    //contentPadding: EdgeInsets.fromLTRB(0, 5, 0, constraints.maxHeight*0.32),
                                                    fillColor: Colors.white,
                                                    //filled: true,
                                                  ),
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize:
                                                        constraints.maxWidth *
                                                            0.07,
                                                  ),
                                                ),
                                              );
                                            },
                                          ))
                                    ],
                                  ),
                                );
                              },
                            )),
                        Container(
                            margin: EdgeInsets.fromLTRB(
                                0.0, constraints.maxHeight * 0.03, 0.0, 0.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(14, 155, 207, 1.0),
                                style: BorderStyle.solid,
                                width: constraints.maxWidth * 0.005,
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(constraints.maxHeight * 0.5)),
                            ),
                            width: constraints.maxWidth * 0.9,
                            height: constraints.maxHeight * 0.12,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Material(
                                  elevation: 2.0,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          constraints.maxHeight * 0.5)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          decoration: BoxDecoration(
                                              //color: Colors.red,
                                              borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(
                                                constraints.maxHeight * 0.5),
                                            topRight: Radius.circular(
                                                constraints.maxHeight * 0.5),
                                          )),
                                          width: constraints.maxWidth * 1,
                                          height: constraints.maxHeight,
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              return Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0,
                                                    constraints.maxHeight *
                                                        0.13,
                                                    constraints.maxWidth * 0.07,
                                                    0),
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  textAlignVertical:
                                                      TextAlignVertical.top,
                                                  controller: _currentpassword,
                                                  validator: (value) =>
                                                      (value!.isEmpty)
                                                          ? "Please Enter Email"
                                                          : null,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: 'New Password',
                                                    hintStyle: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Color.fromRGBO(
                                                          42, 8, 69, 1.0),
                                                      //fontSize: constraints.maxWidth*0.08,
                                                    ),
                                                    //contentPadding: EdgeInsets.fromLTRB(0, 5, 0, constraints.maxHeight*0.32),
                                                    fillColor: Colors.white,
                                                    //filled: true,
                                                  ),
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize:
                                                        constraints.maxWidth *
                                                            0.07,
                                                  ),
                                                ),
                                              );
                                            },
                                          ))
                                    ],
                                  ),
                                );
                              },
                            )),
                        Container(
                            margin: EdgeInsets.fromLTRB(
                                0.0, constraints.maxHeight * 0.03, 0.0, 0.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(14, 155, 207, 1.0),
                                style: BorderStyle.solid,
                                width: constraints.maxWidth * 0.005,
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(constraints.maxHeight * 0.5)),
                            ),
                            width: constraints.maxWidth * 0.9,
                            height: constraints.maxHeight * 0.12,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Material(
                                  elevation: 2.0,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          constraints.maxHeight * 0.5)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          decoration: BoxDecoration(
                                              //color: Colors.red,
                                              borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(
                                                constraints.maxHeight * 0.5),
                                            topRight: Radius.circular(
                                                constraints.maxHeight * 0.5),
                                          )),
                                          width: constraints.maxWidth * 1,
                                          height: constraints.maxHeight,
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              return Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0,
                                                    constraints.maxHeight *
                                                        0.13,
                                                    constraints.maxWidth * 0.07,
                                                    0),
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  textAlignVertical:
                                                      TextAlignVertical.top,
                                                  controller: _newpassword,
                                                  validator: (value) =>
                                                      (value!.isEmpty)
                                                          ? "Please Enter Email"
                                                          : null,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText:
                                                        'Confirm New Password',
                                                    hintStyle: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Color.fromRGBO(
                                                          42, 8, 69, 1.0),
                                                      //fontSize: constraints.maxWidth*0.08,
                                                    ),
                                                    //contentPadding: EdgeInsets.fromLTRB(0, 5, 0, constraints.maxHeight*0.32),
                                                    fillColor: Colors.white,
                                                    //filled: true,
                                                  ),
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize:
                                                        constraints.maxWidth *
                                                            0.07,
                                                  ),
                                                ),
                                              );
                                            },
                                          ))
                                    ],
                                  ),
                                );
                              },
                            )),
                        Container(
                            height: constraints.maxHeight * 0.14,
                            width: constraints.maxWidth * 0.6,
                            margin: EdgeInsets.only(
                                top: constraints.maxHeight * 0.08),
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return Material(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(
                                      constraints.maxWidth * 0.12),
                                  topRight: Radius.circular(
                                      constraints.maxWidth * 0.12),
                                  bottomLeft: Radius.circular(
                                      constraints.maxWidth * 0.12),
                                ),
                                color: Color.fromRGBO(14, 155, 207, 1.0),
                                elevation: 5.0,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Center(
                                    child: Container(
                                      width: constraints.maxWidth * 0.33,
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          'Update',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })),
                      ],
                    ),
                  );
                })),
          ),
        ],
      ),
    );
  }
}
