// import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:student_app/my_flutter_app_icons.dart';
// import 'package:student_app/routing/route.dart' as router;
// import 'package:student_app/routing/route_names.dart' as routes;
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../Constants/app_colors.dart';
// import '../../locater.dart';
// import '../../responsive/percentage_mediaquery.dart';
// import '../../responsive/size_config.dart';
// import '../../services/navigation_service.dart';
// import '../WebView.dart';
//
// class GridViewDriver extends StatelessWidget {
//   final NavigationService _navigationService = locator<NavigationService>();
//
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     final snackBar = SnackBar(
//       content: Container(
//         //color: Colors.black26,
//         width: Responsive.width(100, context),
//         height: Responsive.height(5, context),
//         child: Center(
//           child: Text(
//             'Coming Soon..',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               fontSize: Responsive.width(100, context) * 0.05,
//             ),
//           ),
//         ),
//       ),
//       duration: Duration(seconds: 1, milliseconds: 100),
//       backgroundColor: Colors.black54,
//     );
//     return LayoutBuilder(builder: (context, constraints) {
//       return ListView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         children: <Widget>[
//           Container(
//               padding: EdgeInsets.fromLTRB(constraints.maxHeight * 0.05, 0,
//                   constraints.maxHeight * 0.05, 0),
//               height: constraints.maxHeight * 0.06,
//               child: AutoSizeText(
//                 "Theory Test",
//                 style: TextStyle(
//                     fontSize: 2.0 * SizeConfig.blockSizeVertical,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black),
//               )),
//           GridView.count(
//               primary: false,
//               shrinkWrap: true,
//               padding: EdgeInsets.fromLTRB(
//                   constraints.maxHeight * 0.05,
//                   constraints.maxHeight * 0.0,
//                   constraints.maxHeight * 0.05,
//                   constraints.maxHeight * 0.04),
//               crossAxisSpacing: constraints.maxWidth * 0.05,
//               mainAxisSpacing: constraints.maxHeight * 0.0,
//               crossAxisCount: 5,
//               children: <Widget>[
//                 /* Container(child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     return Row(
//                       children: <Widget>[
//                         Container(
//                             child: Image.asset(
//                           "assets/Start.png",
//                           height: SizeConfig.blockSizeVertical * 15,
//                           width: SizeConfig.blockSizeHorizontal * 15,
//                           // fit: BoxFit.cover,
//                         )),
//                         Container(
//                             child: Image.asset(
//                           "assets/roadstright.png",
//                           height: SizeConfig.blockSizeVertical * 8,
//                           width: SizeConfig.blockSizeHorizontal * 8,
//                           // fit: BoxFit.cover,
//                         )),
//                         Expanded(
//                           child: HomeCard(
//                             heading1: 'AI Learning:',
//                             heading2: 'To Learn Concepts  ',
//                             icon: MyFlutterApp.ai_hand,
//                             head1Width: constraints.maxWidth * 0.70,
//                             head2Width: constraints.maxWidth * 0.99,
//                             onTap: () {
//                               _navigationService.navigateTo(
//                                   routes.TheoryRecommendationsRoute);
//                             },
//                           ),
//                         ),
//                         Container(
//                             child: Image.asset(
//                           "assets/roadstright.png",
//                           height: SizeConfig.blockSizeVertical * 8,
//                           width: SizeConfig.blockSizeHorizontal * 8,
//                           // fit: BoxFit.cover,
//                         )),
//                         Expanded(
//                           child: HomeCard(
//                             heading1: 'Theory Test',
//                             heading2: 'Questions',
//                             icon: FontAwesomeIcons.clipboardCheck,
//                             head1Width: constraints.maxWidth * 0.80,
//                             head2Width: constraints.maxWidth * 0.65,
//                             onTap: () {
//                               _navigationService
//                                   .navigateTo(routes.PracticeTheoryTestRoute);
//                             },
//                           ),
//                         ),
//                         Container(
//                             child: Image.asset(
//                           "assets/roadstright.png",
//                           height: SizeConfig.blockSizeVertical * 8,
//                           width: SizeConfig.blockSizeHorizontal * 8,
//                           // fit: BoxFit.cover,
//                         )),
//                         Expanded(
//                           child: HomeCard(
//                             heading1: 'Hazard',
//                             heading2: 'Perception Test',
//                             icon: FontAwesomeIcons.car,
//                             head1Width: constraints.maxWidth * 0.40,
//                             head2Width: constraints.maxWidth * 0.90,
//                             onTap: () {
//                               _navigationService.navigateTo(
//                                   routes.HazardPerceptionOptionsRoute);
//                             },
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 )),
//                 Container(
//                     child: Row(
//                   children: <Widget>[
//                     Container(
//                         child: Image.asset(
//                       "assets/Stop.png",
//                       height: SizeConfig.blockSizeVertical * 15,
//                       width: SizeConfig.blockSizeHorizontal * 15,
//                       // fit: BoxFit.cover,
//                     )),
//                     Container(
//                         child: Image.asset(
//                       "assets/roadstright.png",
//                       height: SizeConfig.blockSizeVertical * 15,
//                       width: SizeConfig.blockSizeHorizontal * 15,
//                       // fit: BoxFit.cover,
//                     )),
//                     Expanded(
//                       child: HomeCard(
//                         heading1: 'Theory',
//                         heading2: 'Progress Report',
//                         icon: FontAwesomeIcons.graduationCap,
//                         head1Width: constraints.maxWidth * 0.45,
//                         head2Width: constraints.maxWidth * 1.0,
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ComingSoon(),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     Container(
//                         child: Image.asset(
//                       "assets/road curve.png",
//                       height: SizeConfig.blockSizeVertical * 15,
//                       width: SizeConfig.blockSizeHorizontal * 15,
//                       // fit: BoxFit.cover,
//                     )),
//                   ],
//                 )), */
//                 Container(child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     return Row(
//                       children: <Widget>[
//                         Expanded(
//                             child: Image.asset(
//                           "assets/Start.png",
//                           height: SizeConfig.blockSizeVertical * 5,
//                           width: SizeConfig.blockSizeHorizontal * 5,
//                           //fit: BoxFit.cover,
//                         )),
//                       ],
//                     );
//                   },
//                 )),
//                 Container(child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     return Row(
//                       children: <Widget>[
//                         Expanded(
//                             child: Image.asset(
//                           "assets/roadstright.png",
//                           height: SizeConfig.blockSizeVertical * 5,
//                           width: SizeConfig.blockSizeHorizontal * 5,
//                           //fit: BoxFit.cover,
//                         )),
//                       ],
//                     );
//                   },
//                 )),
//                 Container(child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     return Row(
//                       children: <Widget>[
//                         Expanded(
//                           child: HomeCard(
//                             heading1: 'AI Learning:To',
//                             heading2: 'Learn Concepts',
//                             icon: MyFlutterApp.ai_hand,
//                             head1Width: constraints.maxWidth * 0.80,
//                             head2Width: constraints.maxWidth * 0.65,
//                             onTap: () {
//                               _navigationService.navigateTo(
//                                   routes.TheoryRecommendationsRoute);
//                             },
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 )),
//                 GridTile(
//                   child: Image.asset(
//                     "assets/roadstright.png",
//                     height: SizeConfig.blockSizeVertical * 10,
//                     width: SizeConfig.blockSizeHorizontal * 10,
//                     // fit: BoxFit.cover,
//                   ),
//                 ),
//                 //Practise Theory
//                 Container(child: LayoutBuilder(builder: (context, constraints) {
//                   return Row(
//                     children: <Widget>[
//                       Expanded(
//                         child: HomeCard(
//                           heading1: 'Theory Test',
//                           heading2: 'Questions',
//                           icon: FontAwesomeIcons.clipboardCheck,
//                           head1Width: constraints.maxWidth * 0.50,
//                           head2Width: constraints.maxWidth * 0.50,
//                           onTap: () {
//                             _navigationService
//                                 .navigateTo(routes.PracticeTheoryTestRoute);
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 })),
//                 Container(child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     return Column(
//                       children: <Widget>[],
//                     );
//                   },
//                 )),
//
//                 Container(child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     return Row(
//                       children: <Widget>[
//                         Expanded(
//                           child: HomeCard(
//                             heading1: 'Theory ',
//                             heading2: 'Progress Report',
//                             icon: FontAwesomeIcons.graduationCap,
//                             head1Width: constraints.maxWidth * 0.30,
//                             head2Width: constraints.maxWidth * 0.9,
//                             // head3Width: constraints.maxWidth * 1.9,
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ComingSoon(),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 )),
//                 GridTile(
//                   child: Image.asset(
//                     "assets/roadstright.png",
//                     height: SizeConfig.blockSizeVertical * 50,
//                     width: SizeConfig.blockSizeHorizontal * 50,
//                     // fit: BoxFit.cover,
//                   ),
//                 ),
//                 Container(child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     return Row(
//                       children: <Widget>[
//                         Expanded(
//                           child: HomeCard(
//                             heading1: 'Hazard',
//                             heading2: 'Perception Test',
//                             icon: FontAwesomeIcons.car,
//                             head1Width: constraints.maxWidth * 0.30,
//                             head2Width: constraints.maxWidth * 1.90,
//                             onTap: () {
//                               _navigationService.navigateTo(
//                                   routes.HazardPerceptionOptionsRoute);
//                             },
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 )),
//                 Container(child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     return Column(
//                       children: <Widget>[
//                         Expanded(
//                             child: Image.asset(
//                           "assets/road curve2.png",
//                           height: SizeConfig.blockSizeVertical * 20,
//                           width: SizeConfig.blockSizeHorizontal * 20,
//                           // fit: BoxFit.cover,
//                         )),
//                       ],
//                     );
//                   },
//                 )),
//                 Container(child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     return Column(
//                       children: <Widget>[],
//                     );
//                   },
//                 )),
//                 Container(child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     return Column(
//                       children: <Widget>[
//                         Expanded(
//                             child: Image.asset(
//                           "assets/road curve.png",
//                           height: SizeConfig.blockSizeVertical * 20,
//                           width: SizeConfig.blockSizeHorizontal * 20,
//                           // fit: BoxFit.cover,
//                         )),
//                       ],
//                     );
//                   },
//                 )),
//                 Container(child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     return Column(
//                       children: <Widget>[
//                         Expanded(
//                             child: Image.asset(
//                           "assets/Stop.png",
//                           height: SizeConfig.blockSizeVertical * 20,
//                           width: SizeConfig.blockSizeHorizontal * 20,
//                           // fit: BoxFit.cover,
//                         )),
//                       ],
//                     );
//                   },
//                 )),
//               ]),
//           Container(
//               padding: EdgeInsets.fromLTRB(constraints.maxHeight * 0.05, 0,
//                   constraints.maxHeight * 0.05, 0),
//               height: constraints.maxHeight * 0.06,
//               child: RichText(
//                 text: TextSpan(children: [
//                   TextSpan(
//                       text: "Useful links : ", style: TextStyle(color: Dark)),
//                   TextSpan(
//                       text: "Read Highway code",
//                       style: TextStyle(
//                           color: Dark,
//                           fontWeight: FontWeight.bold,
//                           decoration: TextDecoration.underline),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           _navigationService
//                               .navigateTo(routes.HighwayCodeRoute);
//                         })
//                 ]),
//               )),
//           Container(
//               padding: EdgeInsets.fromLTRB(constraints.maxHeight * 0.05, 0,
//                   constraints.maxHeight * 0.05, 0),
//               height: constraints.maxHeight * 0.06,
//               child: RichText(
//                 text: TextSpan(children: [
//                   TextSpan(
//                       text: "                         ",
//                       style: TextStyle(color: Dark)),
//                   TextSpan(
//                       text: "Theory Test Guidence",
//                       style: TextStyle(
//                           color: Dark,
//                           fontWeight: FontWeight.bold,
//                           decoration: TextDecoration.underline),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => WebViewContainer(
//                                       'https://mockdrivingtest.com/static/theory-test-guidance',
//                                       'Theory Test Guidence')));
//                         })
//                 ]),
//               )),
//           Container(
//               padding: EdgeInsets.fromLTRB(constraints.maxHeight * 0.05, 0,
//                   constraints.maxHeight * 0.05, 0),
//               height: constraints.maxHeight * 0.06,
//               child: RichText(
//                 text: TextSpan(children: [
//                   TextSpan(
//                       text: "                         ",
//                       style: TextStyle(color: Dark)),
//                   TextSpan(
//                       text: "Book theory test",
//                       style: TextStyle(
//                           color: Dark,
//                           fontWeight: FontWeight.bold,
//                           decoration: TextDecoration.underline),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => WebViewContainer(
//                                       'https://www.gov.uk/book-theory-test',
//                                       'Book theory test')));
//                         })
//                 ]),
//               )),
//           Divider(
//             height: constraints.maxHeight * 0.02,
//             endIndent: constraints.maxWidth * 0.035,
//             indent: constraints.maxWidth * 0.035,
//             color: Colors.grey[350],
//             thickness: 2.0,
//           ),
//           Container(
//               // margin: EdgeInsets.only(top: constraints.maxHeight * 0.03),
//               padding: EdgeInsets.fromLTRB(constraints.maxHeight * 0.05, 0,
//                   constraints.maxHeight * 0.05, 0),
//               height: constraints.maxHeight * 0.06,
//               child: AutoSizeText(
//                 "Practical Test",
//                 style: TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 2.0 * SizeConfig.blockSizeVertical,
//                     color: Colors.black),
//               )),
//           GridView.count(
//             primary: false,
//             shrinkWrap: true,
//             padding: EdgeInsets.fromLTRB(
//                 constraints.maxHeight * 0.05,
//                 constraints.maxHeight * 0.0,
//                 constraints.maxHeight * 0.05,
//                 constraints.maxHeight * 0.05),
//             crossAxisSpacing: constraints.maxWidth * 0.05,
//             mainAxisSpacing: constraints.maxHeight * 0.0,
//             crossAxisCount: 3,
//             children: <Widget>[
//               //Book Lessons
//               Container(child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   return Column(
//                     children: <Widget>[
//                       Expanded(
//                         child: HomeCard(
//                           heading1: 'Book ',
//                           heading2: 'Driving Course ', //'(Pay as you go)',
//                           icon: FontAwesomeIcons.carSide,
//                           head1Width: constraints.maxWidth * 0.35,
//                           head2Width: constraints.maxWidth * 0.90,
//                           onTap: () {
//                             _navigationService
//                                 .navigateTo(routes.BookLessionFormRoute);
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               )),
//               //Book Practical
//               Container(child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   return Column(
//                     children: <Widget>[
//                       Expanded(
//                         child: HomeCard(
//                           heading1: 'Book',
//                           heading2: 'Mock Test',
//                           icon: MdiIcons.carMultiple,
//                           head1Width: constraints.maxWidth * 0.30,
//                           head2Width: constraints.maxWidth * 0.60,
//                           onTap: () {
//                             _navigationService
//                                 .navigateTo(routes.BookTestFormRoute);
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               )),
//               Container(child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   return Column(
//                     children: <Widget>[
//                       Expanded(
//                         child: HomeCard(
//                           heading1: 'Practical ',
//                           heading2: 'Progress Report',
//                           icon: FontAwesomeIcons.graduationCap,
//                           head1Width: constraints.maxWidth * 0.55,
//                           head2Width: constraints.maxWidth * 0.90,
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ComingSoon(),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               )),
//
//               Container(child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   return Column(
//                     children: <Widget>[
//                       Expanded(
//                         child: HomeCard(
//                           heading1: 'Book Pass',
//                           heading2: 'Assist Lesson',
//                           icon: MdiIcons.carConnected,
//                           head1Width: constraints.maxWidth * 0.60,
//                           head2Width: constraints.maxWidth * 0.80,
//                           onTap: () {
//                             _navigationService.navigateTo(
//                                 routes.BookPassAssistLessonsFormRoute);
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               )),
//
//               Container(child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   return Column(
//                     children: <Widget>[
//                       Expanded(
//                         child: HomeCard(
//                           heading1: 'AI Recommendations:',
//                           heading2: ' Master Driving Skills',
//                           icon: MyFlutterApp.ai_hand,
//                           head1Width: constraints.maxWidth * 1.9,
//                           head2Width: constraints.maxWidth * 0.99,
//                           onTap: () {
//                             _navigationService
//                                 .navigateTo(routes.LessonRecommendationsRoute);
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               )),
//             ],
//           )
//         ],
//       );
//     });
//   }
// }
