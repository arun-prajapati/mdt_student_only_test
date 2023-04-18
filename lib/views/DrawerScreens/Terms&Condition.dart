import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../services/navigation_service.dart';
import '../../widget/CustomAppBar.dart';

class TermsCondition extends StatefulWidget {
  const TermsCondition({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TermsCondition();
}

class _TermsCondition extends State<TermsCondition> {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomAppBar(
              title: 'Terms & Conditions',
              textWidth: Responsive.width(60, context),
              iconLeft: FontAwesomeIcons.arrowLeft,
              preferedHeight: Responsive.height(16, context),
              onTap1: () {
                _navigationService.goBack();
              },
              iconRight: null),
          LayoutBuilder(builder: (context, constraints) {
            return Container(
                height: constraints.maxHeight,
                margin: EdgeInsets.fromLTRB(
                    0.0, constraints.maxHeight * 0.2, 0.0, 0.0),
                child: LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: constraints.maxWidth * 0.4,
                            margin: EdgeInsets.fromLTRB(
                                constraints.maxWidth * 0.03,
                                constraints.maxHeight * 0.03,
                                0.0,
                                0.0),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                'Introduction',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 24,
                                  color: const Color(0xff0e9bcf),
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.02),
                          child: Text(
                            'These terms and conditions apply between you, the User of this Website (including any sub-domains, unless expressly excluded by their own terms and conditions), and Vin Solutions Ltd,nT/A MockDrivingTest.com, the owner and operator of this Website. Please read these terms and conditions carefully, as they affect your legal rights. Your agreement to comply with and be bound by these terms and conditions is deemed to occur upon your first use of the Website. If you do not agree to be bound by these terms and conditions, you should stop using the Website immediately.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              color: const Color(0xad060606),
                              letterSpacing: 0.16499999999999998,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.03,
                        ),
                        Container(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: constraints.maxWidth * 0.8,
                              margin: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * 0.04),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  'Intellectual property and \nacceptable use',
                                  style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 24,
                                    color: const Color(0xff0e9bcf),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.03),
                          child: Text(
                            '1. All Content included on the Website, unless up loaded by Users, is the property of vin Solutions Ltd, T/A MockDrivingTest.com,our affiliates or other relevant third parties. In these terms and conditions, Content means any text, graphics, images, audio, video, software, data compilations, page layout, underlying code and software and any other form of information capable of being stored in a computer that appears on or forms part of this Website, including any such content uploaded by Users. By continuing to use the Website you acknowledge that such Content is protected by copyright, trademarks, database rights and other intellectual property rights. Nothing on this site shall be construed as granting, by implication, estoppel, or otherwise, any license or right to use any trademark, logo or service mark displayed on the site without the owners prior written permission',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              color: const Color(0xad060606),
                              letterSpacing: 0.16499999999999998,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.03),
                          child: Text(
                            '2. You may, for your own personal, non-commercial use only, do the following:',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              color: const Color(0xad060606),
                              letterSpacing: 0.16499999999999998,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.03),
                          child: Text(
                            'a. retrieve, display and view the Content on a computer screen',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              color: const Color(0xad060606),
                              letterSpacing: 0.16499999999999998,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.03),
                          child: Text(
                            'b. download and store the Content in electronic form on a disk (but not on any server or other storage device connected to a network)',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              color: const Color(0xad060606),
                              letterSpacing: 0.16499999999999998,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.03),
                          child: Text(
                            'c. print one copy of the Content',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              color: const Color(0xad060606),
                              letterSpacing: 0.16499999999999998,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.03),
                          child: Text(
                            '3. You must not otherwise reproduce, modify, copy, distribute or use for commercial purposes any Content without the written permission of Vin Solutions Ltd, T/A MockDrivingTest.com.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              color: const Color(0xad060606),
                              letterSpacing: 0.16499999999999998,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  );
                }));
          }),
        ],
      ),
    );
  }
}
