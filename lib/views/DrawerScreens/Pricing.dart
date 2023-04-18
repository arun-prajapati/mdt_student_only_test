import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../services/navigation_service.dart';
import '../../widget/CustomAppBar.dart';

class Pricing extends StatefulWidget {
  @override
  _PricingState createState() => _PricingState();
}

class _PricingState extends State<Pricing> {
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
              title: 'Pricing',
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
                                      width: constraints.maxWidth,
                                      //color: Colors.black26,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: constraints.maxHeight *
                                                    0.01),
                                            child: Text(
                                              'MockDrivingTest.com provides end to end support and mentoring for the learner drivers to obtain their driving license.',
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
                                                    0.02),
                                            child: Text(
                                              'We are giving away the following freebies for all the courses booked before 31st of May 2021:',
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
                                                      0.02),
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
                                                      'Free Calendar Management',
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: 'Poppins',
                                                          height: 1.2),
                                                    ),
                                                  )
                                                ],
                                              )),
                                          Container(
                                              child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width:
                                                    constraints.maxWidth * 0.02,
                                              ),
                                              Container(
                                                width:
                                                    constraints.maxWidth * 0.05,
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
                                                    constraints.maxWidth * 0.92,
                                                //color: Colors.black26,
                                                child: Text(
                                                  'Free detailed feedback after every lesson',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: 'Poppins',
                                                      height: 1.2),
                                                ),
                                              )
                                            ],
                                          )),
                                          Container(
                                              child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width:
                                                    constraints.maxWidth * 0.02,
                                              ),
                                              Container(
                                                width:
                                                    constraints.maxWidth * 0.05,
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
                                                    constraints.maxWidth * 0.92,
                                                //color: Colors.black26,
                                                child: Text(
                                                  'Free Recommendations generated by our AI algorithm',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: 'Poppins',
                                                      height: 1.2),
                                                ),
                                              )
                                            ],
                                          )),
                                          Container(
                                              child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width:
                                                    constraints.maxWidth * 0.02,
                                              ),
                                              Container(
                                                width:
                                                    constraints.maxWidth * 0.05,
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
                                                    constraints.maxWidth * 0.92,
                                                //color: Colors.black26,
                                                child: Text(
                                                  'Free lesson route tracking',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: 'Poppins',
                                                      height: 1.2),
                                                ),
                                              )
                                            ],
                                          )),
                                          Container(
                                              child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width:
                                                    constraints.maxWidth * 0.02,
                                              ),
                                              Container(
                                                width:
                                                    constraints.maxWidth * 0.05,
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
                                                    constraints.maxWidth * 0.92,
                                                //color: Colors.black26,
                                                child: Text(
                                                  'Free use of our mobile app',
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
                                              'The following is a list of courses that the learner drivers can book through our website. If you have any queries we will be pleased to help and mentor you.',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontFamily: 'Poppins',
                                                  height: 1.2),
                                              softWrap: true,
                                            ),
                                          ),
                                          //Data Table
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: constraints.maxHeight *
                                                      0.02),
                                              width: constraints.maxWidth * 1,
                                              //color: Colors.black12,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: DataTable(
                                                  dataRowHeight:
                                                      constraints.maxWidth *
                                                          0.12,
                                                  headingRowHeight:
                                                      constraints.maxWidth *
                                                          0.1,
                                                  columnSpacing:
                                                      constraints.maxWidth *
                                                          0.05,
                                                  horizontalMargin:
                                                      constraints.maxWidth *
                                                          0.02,
                                                  columns: const <DataColumn>[
                                                    DataColumn(
                                                      label: Text(
                                                        'Course',
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'Duration',
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'Rates',
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'Driving Experience',
                                                      ),
                                                    ),
                                                  ],
                                                  rows: const <DataRow>[
                                                    DataRow(
                                                      cells: <DataCell>[
                                                        DataCell(Text(
                                                            'Practical Mock\nDriving Test')),
                                                        DataCell(
                                                            Text('1 hour')),
                                                        DataCell(
                                                            Text('£ 50.00')),
                                                        DataCell(Text(
                                                            'Ready For Driving Test')),
                                                      ],
                                                    ),
                                                    DataRow(
                                                      cells: <DataCell>[
                                                        DataCell(Text(
                                                            'Refresher\nDriving Course')),
                                                        DataCell(
                                                            Text('3 hour')),
                                                        DataCell(
                                                            Text('£ 120.00')),
                                                        DataCell(Text(
                                                            'Ready For Driving Test')),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )),
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
