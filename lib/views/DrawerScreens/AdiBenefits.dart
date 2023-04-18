import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../services/navigation_service.dart';
import '../../widget/CustomAppBar.dart';

class AdiBenefits extends StatefulWidget {
  @override
  _AdiBenefitsState createState() => _AdiBenefitsState();
}

class _AdiBenefitsState extends State<AdiBenefits> {
  final NavigationService _navigationService = locator<NavigationService>();
  String bullet = "\u2022 ";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Responsive.height(100, context),
        height: Responsive.height(100, context),
        //color: Colors.black26,
        child: Stack(
          children: [
            CustomAppBar(
              preferedHeight: Responsive.height(15, context),
              title: 'Benefits',
              textWidth: Responsive.width(25, context),
              iconLeft: FontAwesomeIcons.arrowLeft,
              onTap1: () {
                _navigationService.goBack();
              },
              iconRight: null,
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                    height: Responsive.height(81, context),
                    width: Responsive.width(100, context),
                    //color: Colors.black12,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          width: constraints.maxWidth * 0.96,
                          //color: Colors.black26,
                          margin: EdgeInsets.only(
                              left: constraints.maxWidth * 0.02,
                              right: constraints.maxWidth * 0.02),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return SingleChildScrollView(
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          bottom: constraints.maxHeight * 0.02),
                                      width: constraints.maxWidth,
                                      //color: Colors.black26,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: constraints.maxHeight *
                                                    0.01),
                                            child: Text(
                                              'Welcome to our unique portal that will help you get a regular supply of learners without any franchise fees. We also provide you with a dedicated customer service team to support the smooth allocation of lessons and tests. Not only this, by joining us, you can also still remain connected to any other school or pursue your own business. We are here to help you multiply your earnings without cutting into your other earning sources!!',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontFamily: 'Poppins',
                                                  height: 1.2),
                                              softWrap: true,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            margin: EdgeInsets.only(
                                                top: constraints.maxHeight *
                                                    0.02),
                                            child: Text(
                                              'Some of the benefits of working with us:',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontFamily: 'Poppins',
                                                  height: 1.2),
                                              softWrap: true,
                                            ),
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: constraints.maxHeight *
                                                      0.01),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.02,
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.05,
                                                    alignment: Alignment.center,
                                                    //color: Colors.black12,
                                                    child: Text(
                                                      bullet,
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: 'Poppins',
                                                          height: 1.2),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.92,
                                                    //color: Colors.black26,
                                                    child: Text(
                                                      'We will approach you for your lessons as per your availability and you will have the option of accepting/rejecting the test/lesson. ',
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: 'Poppins',
                                                          height: 1.2),
                                                    ),
                                                  )
                                                ],
                                              )),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: constraints.maxHeight *
                                                      0.005),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.02,
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.05,
                                                    alignment: Alignment.center,
                                                    //color: Colors.black12,
                                                    child: Text(
                                                      bullet,
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: 'Poppins',
                                                          height: 1.2),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.92,
                                                    //color: Colors.black26,
                                                    child: Text(
                                                      'We will provide you with your own dedicated web page that you can use for advertising your services.',
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: 'Poppins',
                                                          height: 1.2),
                                                    ),
                                                  )
                                                ],
                                              )),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: constraints.maxHeight *
                                                      0.005),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.02,
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.05,
                                                    alignment: Alignment.center,
                                                    //color: Colors.black12,
                                                    child: Text(
                                                      bullet,
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: 'Poppins',
                                                          height: 1.2),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.92,
                                                    //color: Colors.black26,
                                                    child: Text(
                                                      'We will provide you with a calendar that should help you with managing your diary. This will help you become your own boss and manage your time very efficiently so that you can be socially active, give time to your family and continue earning in a smart way.',
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: 'Poppins',
                                                          height: 1.2),
                                                    ),
                                                  )
                                                ],
                                              )),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: constraints.maxHeight *
                                                    0.02),
                                            child: Text(
                                              'We also have the referral bonus option wherein you can earn without investing any time or money, just by referring your student to take the test via our portal or referring a fellow ADI to us.',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontFamily: 'Poppins',
                                                  height: 1.2),
                                              softWrap: true,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            margin: EdgeInsets.only(
                                                top: constraints.maxHeight *
                                                    0.02),
                                            child: Text(
                                              'We have the following payment models for you:',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontFamily: 'Poppins',
                                                  height: 1.2),
                                              softWrap: true,
                                            ),
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: constraints.maxHeight *
                                                      0.01),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.02,
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.05,
                                                    alignment: Alignment.center,
                                                    //color: Colors.black12,
                                                    child: Text(
                                                      '1. ',
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: 'Poppins',
                                                          height: 1.2),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.92,
                                                    //color: Colors.black26,
                                                    child: Text(
                                                      'Pay as you, this is a typical model, you finish your lesson and you will get paid at the end of it.',
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: 'Poppins',
                                                          height: 1.2),
                                                    ),
                                                  )
                                                ],
                                              )),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: constraints.maxHeight *
                                                      0.005),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.02,
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.05,
                                                    alignment: Alignment.center,
                                                    //color: Colors.black12,
                                                    child: Text(
                                                      '2. ',
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: 'Poppins',
                                                          height: 1.2),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.92,
                                                    //color: Colors.black26,
                                                    child: Text(
                                                      'Advance payment of 5 lessons at a time – Under this model, we pay you a retainer of your first lesson at the time of booking and pay you for next 4 lessons at the end of the first lesson.  And similarly, we will pay you at the end of 6 lessons for the next 5 and so on. This option is available after you have completed 50 hours of teaching through us.',
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: 'Poppins',
                                                          height: 1.2),
                                                    ),
                                                  )
                                                ],
                                              )),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: constraints.maxHeight *
                                                      0.005),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.02,
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.05,
                                                    alignment: Alignment.center,
                                                    //color: Colors.black12,
                                                    child: Text(
                                                      '3. ',
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: 'Poppins',
                                                          height: 1.2),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.92,
                                                    //color: Colors.black26,
                                                    child: Text(
                                                      'Paying you a lump sum for 20 hours: This option is available for longer courses and becomes available after you have done at least 600 hours with us.',
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: 'Poppins',
                                                          height: 1.2),
                                                    ),
                                                  )
                                                ],
                                              )),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: constraints.maxHeight *
                                                      0.005),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.02,
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.05,
                                                    alignment: Alignment.center,
                                                    //color: Colors.black12,
                                                    child: Text(
                                                      '4. ',
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: 'Poppins',
                                                          height: 1.2),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.92,
                                                    //color: Colors.black26,
                                                    child: Text(
                                                      'Bonus',
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: 'Poppins',
                                                          height: 1.2,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )
                                                ],
                                              )),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: constraints.maxHeight *
                                                      0.005),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.1,
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.05,
                                                    alignment: Alignment.center,
                                                    //color: Colors.black12,
                                                    child: Text(
                                                      'a. ',
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: 'Poppins',
                                                          height: 1.2),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.83,
                                                    //color: Colors.black26,
                                                    child: Text(
                                                      '£100 bonus at the end of teaching 600 hours.',
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontFamily: 'Poppins',
                                                        height: 1.2,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: constraints.maxHeight *
                                                      0.005),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.1,
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.05,
                                                    alignment: Alignment.center,
                                                    //color: Colors.black12,
                                                    child: Text(
                                                      'b. ',
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: 'Poppins',
                                                          height: 1.2),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.83,
                                                    //color: Colors.black26,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      '£50 bonus when you can train a student from 0 experience to first-time pass in less than 30 hours.',
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontFamily: 'Poppins',
                                                        height: 1.2,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: constraints.maxHeight *
                                                      0.005),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.1,
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.05,
                                                    alignment: Alignment.center,
                                                    //color: Colors.black12,
                                                    child: Text(
                                                      'c. ',
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: 'Poppins',
                                                          height: 1.2),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.83,
                                                    alignment: Alignment.center,
                                                    //color: Colors.black26,
                                                    child: Text(
                                                      '£5 when your student passes on the first attempt and you send us a picture of the student holding their pass-certificate.',
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontFamily: 'Poppins',
                                                        height: 1.2,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            margin: EdgeInsets.only(
                                                top: constraints.maxHeight *
                                                    0.02),
                                            child: Text(
                                              'We pride ourselves in saying that we are trying to bring in options through which you as an ADI take the most money away out of the payment that the student makes. MOREOVER, our focus will always be to create VALUE FOR MONEY for both YOU and the LEARNER Driver. ',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontFamily: 'Poppins',
                                                  height: 1.2),
                                              softWrap: true,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            margin: EdgeInsets.only(
                                                top: constraints.maxHeight *
                                                    0.02),
                                            child: Text(
                                              'Still not convinced? Call us now on 0203 129 7741.',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontFamily: 'Poppins',
                                                  height: 1.2),
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      )));
                            },
                          ),
                        );
                      },
                    )))
          ],
        ),
      ),
    );
  }
}
