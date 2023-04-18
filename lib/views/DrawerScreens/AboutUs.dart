import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_app/locater.dart';

import '../../responsive/percentage_mediaquery.dart';
import '../../services/navigation_service.dart';
import '../../widget/CustomAppBar.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AboutUs();
}

class _AboutUs extends State<AboutUs> {
  final NavigationService _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomAppBar(
              title: 'About Us',
              iconLeft: FontAwesomeIcons.arrowLeft,
              textWidth: Responsive.width(33, context),
              preferedHeight: Responsive.height(15, context),
              onTap1: () {
                _navigationService.goBack();
              },
              iconRight: null),
          LayoutBuilder(builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth * 1,
              child: Column(
                children: <Widget>[
                  Container(
                    width: constraints.maxWidth * 0.99,
                    margin: EdgeInsets.fromLTRB(
                        constraints.maxWidth * 0.03,
                        constraints.maxHeight * 0.21,
                        constraints.maxWidth * 0.03,
                        0.0),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        'We are a team of IT professionals and ADIs committed\n to providing opportunities for:',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 30,
                          color: const Color(0xad060606),
                          //letterSpacing: 0.132,
                          fontWeight: FontWeight.w600,
                          //height: 1.1666666666666667,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.03,
                  ),
                  Container(
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    constraints.maxWidth * 0.02, 0, 0, 0),
                                width: constraints.maxWidth * 0.034,
                                height: 10.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.elliptical(3.5, 3.5)),
                                  color: const Color(0xff0f0e0e),
                                  border: Border.all(
                                      width: 1.0,
                                      color: const Color(0xff707070)),
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth * 0.03,
                              ),
                              Container(
                                width: constraints.maxWidth * 0.9,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    'Learner Drivers to pass their driving test \n the first time; and,',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: const Color(0xad060606),
                                      letterSpacing: 0.176,
                                      height: 1.1875,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          );
                        })),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.01,
                  ),
                  Container(
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Row(
                            children: <Widget>[
                              Container(
                                width: constraints.maxWidth * 0.034,
                                height: 10.0,
                                margin: EdgeInsets.fromLTRB(
                                    constraints.maxWidth * 0.02, 0, 0, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.elliptical(3.5, 3.5)),
                                  color: const Color(0xff0f0e0e),
                                  border: Border.all(
                                      width: 1.0,
                                      color: const Color(0xff707070)),
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth * 0.03,
                              ),
                              Container(
                                width: constraints.maxWidth * 0.9,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    'ADIs by providing new sales channels.',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 30,
                                      color: const Color(0xad060606),
                                      //letterSpacing: 0.176,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          );
                        })),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.045,
                  ),
                  Container(
                    width: constraints.maxWidth * 0.42,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        'Our Story',
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 24,
                          color: const Color(0xff0e9bcf),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.04,
                  ),
                  Container(
                    //color:Colors.black26,
                    width: constraints.maxWidth * 0.99,
                    margin: EdgeInsets.fromLTRB(constraints.maxWidth * 0.03, 0,
                        constraints.maxWidth * 0.03, 0),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Container(
//                            fit: BoxFit.contain,
                        child: Text(
                          'The idea for this web site came about when our founder saw quite a few friends getting really nervous before the driving test and failing multiple times. She advised them to take focussed lessons to cover areas where they struggled which later became Pass-assist lessons. She also helped condu0ct mock driving tests for them which proved pivotal in people passing the driving tests.',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: const Color(0xad060606),
                            //letterSpacing: 0.176,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}
