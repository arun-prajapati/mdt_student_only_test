import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:student_app/views/Bookings/MyBookings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/auth.dart';
import '../../services/booking_test.dart';

//import '../../main.dart';

typedef StringCallback = Function(String tabType);

class CustomSwitch extends StatefulWidget {
  final Function() notifyParent;
  final StringCallback? onSwitchTap;
  CustomSwitch({Key? key, required this.notifyParent, this.onSwitchTap})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  Color pastColor = Colors.transparent;
  Color pastTextColor = Colors.white;
  Color upcomingColor = Colors.white;
  Color upcomingTextColor = Color(0xff0e9bcf);
  late AuthProvider authProvider;
  final BookingService _bookingService = BookingService();
  late String token;
  refresh() {
    setState(() {});
  }

  int Upcount = 1;
  int PastCount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print('hello');
    return Container(
      child: SizedBox(
          width: Responsive.width(40, context),
          height: Responsive.height(4.7, context),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.height / 2),
            child: Container(
              color: Colors.black87.withOpacity(0.4),
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _bookingService.setType('upcoming');
                      this.widget.onSwitchTap!('upcoming');
                      PastCount = 0;
                      Upcount++;
                      setState(() {
                        upcomingColor = Colors.white;
                        upcomingTextColor = Color(0xff0e9bcf);
                        pastColor = Colors.transparent;
                        pastTextColor = Colors.white;
                        if (Upcount == 1) {
                          widget.notifyParent();
                        }
                      });
                    },
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          margin: EdgeInsets.fromLTRB(
                              constraints.maxWidth * 0.03,
                              constraints.maxHeight * 0.1,
                              0.0,
                              0.0),
                          width: constraints.maxWidth * 0.6,
                          height: constraints.maxHeight * 0.8,
                          decoration: BoxDecoration(
                            color: upcomingColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                  MediaQuery.of(context).size.height / 2),
                            ),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Center(
                                child: Container(
                                  width: constraints.maxWidth * 0.75,
                                  child: AutoSizeText(
                                    'Upcoming',
                                    style: TextStyle(
                                      color: upcomingTextColor,
                                      fontSize:
                                          2 * SizeConfig.blockSizeVertical,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _bookingService.setType('past');
                      this.widget.onSwitchTap!('past');
                      Upcount = 0;
                      PastCount++;
                      setState(() {
                        pastColor = Colors.white;
                        pastTextColor = Color(0xff0e9bcf);
                        upcomingColor = Colors.transparent;
                        upcomingTextColor = Colors.white;
                        if (PastCount == 1) {
                          widget.notifyParent();
                        }
                      });
                    },
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          margin: EdgeInsets.fromLTRB(
                              constraints.maxWidth * 0.6,
                              constraints.maxHeight * 0.1,
                              0.0,
                              constraints.maxWidth * 0.03),
                          width: constraints.maxWidth * 0.375,
                          height: constraints.maxHeight * 0.8,
                          decoration: BoxDecoration(
                            color: pastColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                  MediaQuery.of(context).size.height / 2),
                            ),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Center(
                                child: Container(
                                  width: constraints.maxWidth * 0.52,
                                  child: AutoSizeText(
                                    'Past',
                                    style: TextStyle(
                                      color: pastTextColor,
                                      fontSize:
                                          2 * SizeConfig.blockSizeVertical,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
