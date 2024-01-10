import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../services/navigation_service.dart';
import '../../widget/CustomAppBar.dart';

class TestStructure extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomAppBar(
              title: 'Mock Test Structure',
              textWidth: Responsive.width(48, context),
              iconLeft: FontAwesomeIcons.arrowLeft,
              preferedHeight: Responsive.height(15, context),
              onTap1: () {
                _navigationService.goBack();
              },
              iconRight: null),
          Container(
              width: Responsive.width(100, context),
              height: Responsive.height(100, context),
              margin: EdgeInsets.fromLTRB(
                  0.0, Responsive.height(19, context), 0.0, 0.0),
              child: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      testStructureCustom(constraints,
                          no: 01,
                          text:
                              'You make a test booking via www.mockdrivingtest.com '
                              'choose a date, time and test location convenient to you'),
                      testStructureCustom(constraints,
                          no: 02,
                          text:
                              'At the agreed time slot, an Approved Driving Instructor '
                              '(ADI) will meet you at the pre-agreed location.'),
                      testStructureCustom(constraints,
                          no: 03,
                          text:
                              'Student and ADI verify each other based upon the information'
                              ' provided by Mock Driving Test portal 24 hours in advance of the test'),
                      testStructureCustom(constraints,
                          no: 04,
                          text:
                              'The ADI will conduct a mock test in an environment resembling '
                              'the DVSA practical driving test.'),

                      testStructureCustom(constraints,
                          no: 05,
                          text:
                              'The ADI will give you verbal feedback after the test and a'
                              ' detailed report will be available online within 24 hours of test.'),
                      // Stack(
                      //   children: <Widget>[
                      //     Container(
                      //       width: constraints.maxWidth * 0.99,
                      //       height: constraints.maxHeight * 0.2,
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: constraints.maxWidth * 0.03),
                      //       margin: EdgeInsets.fromLTRB(
                      //           constraints.maxWidth * 0.035,
                      //           constraints.maxHeight * 0.04,
                      //           constraints.maxWidth * 0.035,
                      //           constraints.maxHeight * 0.04),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(
                      //             constraints.maxWidth * 0.07),
                      //         color: const Color(0xffffffff),
                      //         border: Border.all(
                      //             width: constraints.maxWidth * 0.005,
                      //             color: const Color(0xff0e9bcf)),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: const Color(0x29000000),
                      //             offset: Offset(0, 3),
                      //             blurRadius: 6,
                      //           ),
                      //         ],
                      //       ),
                      //       child: Container(
                      //         width: constraints.maxWidth * 0.9,
                      //         margin: EdgeInsets.fromLTRB(
                      //             constraints.maxWidth * 0.01,
                      //             constraints.maxHeight * 0.053,
                      //             0.0,
                      //             0.0),
                      //         child: Text(
                      //           'At the agreed time slot, an Approved Driving Instructor (ADI) will meet you at the pre-agreed location.',
                      //           style: TextStyle(
                      //             fontFamily: 'Poppins',
                      //             fontSize: 16,
                      //             color: const Color(0xad060606),
                      //             letterSpacing: 0.132,
                      //           ),
                      //           textAlign: TextAlign.left,
                      //         ),
                      //       ),
                      //     ),
                      //     Positioned(
                      //       top: constraints.maxHeight * 0.01,
                      //       left: constraints.maxWidth * 0.11,
                      //       child: Container(
                      //         width: constraints.maxWidth * 0.3,
                      //         height: constraints.maxHeight * 0.075,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(
                      //               constraints.maxWidth * 0.02),
                      //           color: const Color(0xff22a9ee),
                      //           border: Border.all(
                      //               width: constraints.maxWidth * 0.003,
                      //               color: const Color(0xff707070)),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: const Color(0x29000000),
                      //               offset: Offset(0, 3),
                      //               blurRadius: 6,
                      //             ),
                      //           ],
                      //         ),
                      //         child: Center(
                      //           child: Container(
                      //             width: constraints.maxWidth * 0.24,
                      //             child: FittedBox(
                      //               fit: BoxFit.contain,
                      //               child: Text(
                      //                 'Step 02',
                      //                 style: TextStyle(
                      //                   fontFamily: 'Rift Soft',
                      //                   fontSize: 17,
                      //                   color: const Color(0xffffffff),
                      //                   letterSpacing: 2.55,
                      //                   fontWeight: FontWeight.w300,
                      //                 ),
                      //                 textAlign: TextAlign.center,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Stack(
                      //   children: <Widget>[
                      //     Container(
                      //       width: constraints.maxWidth * 0.99,
                      //       height: constraints.maxHeight * 0.24,
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: constraints.maxWidth * 0.03),
                      //       margin: EdgeInsets.fromLTRB(
                      //           constraints.maxWidth * 0.035,
                      //           constraints.maxHeight * 0.04,
                      //           constraints.maxWidth * 0.035,
                      //           constraints.maxHeight * 0.04),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(
                      //             constraints.maxWidth * 0.07),
                      //         color: const Color(0xffffffff),
                      //         border: Border.all(
                      //             width: constraints.maxWidth * 0.005,
                      //             color: const Color(0xff0e9bcf)),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: const Color(0x29000000),
                      //             offset: Offset(0, 3),
                      //             blurRadius: 6,
                      //           ),
                      //         ],
                      //       ),
                      //       child: Container(
                      //         margin: EdgeInsets.fromLTRB(
                      //             constraints.maxWidth * 0.01,
                      //             constraints.maxHeight * 0.053,
                      //             0.0,
                      //             0.0),
                      //         child: Text(
                      //           'Student and ADI verify each other based upon the information provided by Mock Driving Test portal 24 hours in advance of the test',
                      //           style: TextStyle(
                      //             fontFamily: 'Poppins',
                      //             fontSize: 16,
                      //             color: const Color(0xad060606),
                      //             letterSpacing: 0.132,
                      //             height: 1.1666666666666667,
                      //           ),
                      //           textAlign: TextAlign.left,
                      //         ),
                      //       ),
                      //     ),
                      //     Positioned(
                      //       top: constraints.maxHeight * 0.01,
                      //       left: constraints.maxWidth * 0.11,
                      //       child: Container(
                      //         width: constraints.maxWidth * 0.3,
                      //         height: constraints.maxHeight * 0.075,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(
                      //               constraints.maxWidth * 0.02),
                      //           color: const Color(0xff22a9ee),
                      //           border: Border.all(
                      //               width: constraints.maxWidth * 0.003,
                      //               color: const Color(0xff707070)),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: const Color(0x29000000),
                      //               offset: Offset(0, 3),
                      //               blurRadius: 6,
                      //             ),
                      //           ],
                      //         ),
                      //         child: Center(
                      //           child: Container(
                      //             width: constraints.maxWidth * 0.24,
                      //             child: FittedBox(
                      //               fit: BoxFit.contain,
                      //               child: Text(
                      //                 'Step 03',
                      //                 style: TextStyle(
                      //                   fontFamily: 'Rift Soft',
                      //                   fontSize: 17,
                      //                   color: const Color(0xffffffff),
                      //                   letterSpacing: 2.55,
                      //                   fontWeight: FontWeight.w300,
                      //                 ),
                      //                 textAlign: TextAlign.center,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Stack(
                      //   children: <Widget>[
                      //     Container(
                      //       width: constraints.maxWidth * 0.99,
                      //       height: constraints.maxHeight * 0.2,
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: constraints.maxWidth * 0.03),
                      //       margin: EdgeInsets.fromLTRB(
                      //           constraints.maxWidth * 0.035,
                      //           constraints.maxHeight * 0.04,
                      //           constraints.maxWidth * 0.035,
                      //           constraints.maxHeight * 0.04),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(
                      //             constraints.maxWidth * 0.07),
                      //         color: const Color(0xffffffff),
                      //         border: Border.all(
                      //             width: constraints.maxWidth * 0.005,
                      //             color: const Color(0xff0e9bcf)),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: const Color(0x29000000),
                      //             offset: Offset(0, 3),
                      //             blurRadius: 6,
                      //           ),
                      //         ],
                      //       ),
                      //       child: Container(
                      //           width: constraints.maxWidth * 0.9,
                      //           margin: EdgeInsets.fromLTRB(
                      //               constraints.maxWidth * 0.01,
                      //               constraints.maxHeight * 0.053,
                      //               0.0,
                      //               0),
                      //           child: Text(
                      //             'The ADI will conduct a mock test in an environment resembling the DVSA practical driving test.',
                      //             style: TextStyle(
                      //               fontFamily: 'Poppins',
                      //               fontSize: 16,
                      //               color: const Color(0xad060606),
                      //               letterSpacing: 0.132,
                      //               height: 1.1666666666666667,
                      //             ),
                      //             textAlign: TextAlign.left,
                      //           )),
                      //     ),
                      //     Positioned(
                      //       top: constraints.maxHeight * 0.01,
                      //       left: constraints.maxWidth * 0.11,
                      //       child: Container(
                      //         width: constraints.maxWidth * 0.3,
                      //         height: constraints.maxHeight * 0.075,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(
                      //               constraints.maxWidth * 0.02),
                      //           color: const Color(0xff22a9ee),
                      //           border: Border.all(
                      //               width: constraints.maxWidth * 0.003,
                      //               color: const Color(0xff707070)),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: const Color(0x29000000),
                      //               offset: Offset(0, 3),
                      //               blurRadius: 6,
                      //             ),
                      //           ],
                      //         ),
                      //         child: Center(
                      //           child: Container(
                      //             width: constraints.maxWidth * 0.24,
                      //             child: FittedBox(
                      //               fit: BoxFit.contain,
                      //               child: Text(
                      //                 'Step 04',
                      //                 style: TextStyle(
                      //                   fontFamily: 'Rift Soft',
                      //                   fontSize: 17,
                      //                   color: const Color(0xffffffff),
                      //                   letterSpacing: 2.55,
                      //                   fontWeight: FontWeight.w300,
                      //                 ),
                      //                 textAlign: TextAlign.center,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Stack(
                      //   children: <Widget>[
                      //     Container(
                      //       width: constraints.maxWidth * 0.99,
                      //       height: constraints.maxHeight * 0.24,
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: constraints.maxWidth * 0.03),
                      //       margin: EdgeInsets.fromLTRB(
                      //           constraints.maxWidth * 0.035,
                      //           constraints.maxHeight * 0.04,
                      //           constraints.maxWidth * 0.035,
                      //           constraints.maxHeight * 0.04),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(
                      //             constraints.maxWidth * 0.07),
                      //         color: const Color(0xffffffff),
                      //         border: Border.all(
                      //             width: constraints.maxWidth * 0.005,
                      //             color: const Color(0xff0e9bcf)),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: const Color(0x29000000),
                      //             offset: Offset(0, 3),
                      //             blurRadius: 6,
                      //           ),
                      //         ],
                      //       ),
                      //       child: Container(
                      //           //width: constraints.maxWidth * 0.9,
                      //           margin: EdgeInsets.fromLTRB(
                      //               constraints.maxWidth * 0.01,
                      //               constraints.maxHeight * 0.053,
                      //               0.0,
                      //               0),
                      //           child: Text(
                      //             'The ADI will give you verbal feedback after the test and a detailed report will be available online within 24 hours of test.',
                      //             style: TextStyle(
                      //               fontFamily: 'Poppins',
                      //               fontSize: 16,
                      //               color: const Color(0xad060606),
                      //               letterSpacing: 0.132,
                      //               height: 1.1666666666666667,
                      //             ),
                      //             textAlign: TextAlign.left,
                      //           )),
                      //     ),
                      //     Positioned(
                      //       top: constraints.maxHeight * 0.01,
                      //       left: constraints.maxWidth * 0.11,
                      //       child: Container(
                      //         //width: constraints.maxWidth * 0.3,
                      //         height: constraints.maxHeight * 0.075,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(
                      //               constraints.maxWidth * 0.02),
                      //           color: const Color(0xff22a9ee),
                      //           border: Border.all(
                      //               width: constraints.maxWidth * 0.003,
                      //               color: const Color(0xff707070)),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: const Color(0x29000000),
                      //               offset: Offset(0, 3),
                      //               blurRadius: 6,
                      //             ),
                      //           ],
                      //         ),
                      //         child: Center(
                      //           child: Container(
                      //             width: constraints.maxWidth * 0.24,
                      //             child: FittedBox(
                      //               fit: BoxFit.contain,
                      //               child: Text(
                      //                 'Step 05',
                      //                 style: TextStyle(
                      //                   fontFamily: 'Rift Soft',
                      //                   fontSize: 17,
                      //                   color: const Color(0xffffffff),
                      //                   letterSpacing: 2.55,
                      //                   fontWeight: FontWeight.w300,
                      //                 ),
                      //                 textAlign: TextAlign.center,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                );
              })),
        ],
      ),
    );
  }

  Stack testStructureCustom(BoxConstraints constraints,
      {required String text, required int no}) {
    return Stack(
      children: <Widget>[
        Container(
          width: constraints.maxWidth * 0.99,
          height: constraints.maxHeight * 0.20,
          padding:
              EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.02),
          margin: EdgeInsets.fromLTRB(
              constraints.maxWidth * 0.035,
              constraints.maxHeight * 0.04,
              constraints.maxWidth * 0.035,
              constraints.maxHeight * 0.04),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(constraints.maxWidth * 0.07),
            color: const Color(0xffffffff),
            border: Border.all(
                width: constraints.maxWidth * 0.005,
                color: const Color(0xff0e9bcf)),
            boxShadow: [
              BoxShadow(
                color: const Color(0x29000000),
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Container(
            width: constraints.maxWidth * 0.9,
            margin: EdgeInsets.fromLTRB(constraints.maxWidth * 0.02,
                constraints.maxHeight * 0.054, 0.0, 0.0),
            child: Text(
              text,
              //'You make a test booking via www.mockdrivingtest.com (
              // choose a date, time and test location convenient to you)',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: const Color(0xad060606),
                letterSpacing: 0.132,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Positioned(
          top: constraints.maxHeight * 0.01,
          left: constraints.maxWidth * 0.11,
          child: Container(
            width: constraints.maxWidth * 0.31,
            height: constraints.maxHeight * 0.065,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(constraints.maxWidth * 0.02),
              color: const Color(0xff22a9ee),
              border: Border.all(
                  width: constraints.maxWidth * 0.003,
                  color: const Color(0xff707070)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Step $no',
                style: TextStyle(
                  fontFamily: 'Rift Soft',
                  fontSize: 18,
                  color: const Color(0xffffffff),
                  letterSpacing: 2.55,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
