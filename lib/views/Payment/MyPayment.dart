// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:mdt/responsive/percentage_mediaquery.dart';
// import 'package:mdt/services/navigation_service.dart';
// import 'package:mdt/widgets/Card/Home_Stats_Card.dart';
// import 'package:mdt/widgets/navigatin_bar/CustomAppBar.dart';
//
// import '../../locater.dart';
//
// class MyPayments extends StatelessWidget {
//   final NavigationService _navigationService = locator<NavigationService>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           CustomAppBar(
//             preferedHeight: Responsive.height(22, context),
//             title: 'My Payments',
//             textWidth: Responsive.width(45, context),
//             iconLeft: FontAwesomeIcons.arrowLeft,
//             onTap1: (){
//               _navigationService.goBack();
//             },
//             iconRight: null
//           ),
//           Container(
//             width: Responsive.width(100, context),
//             height: Responsive.height(90, context),
//             margin: EdgeInsets.fromLTRB(
//                 Responsive.width(5, context),
//                 Responsive.height(15, context),
//                 Responsive.width(5, context),
//                 25.0),
//             decoration: BoxDecoration(
//               color: Colors.transparent,
//               borderRadius: BorderRadius.all(
//                 Radius.circular(Responsive.width(8, context)),
//               ),
//               border: Border.all(
//                 width: Responsive.width(0.3, context),
//                 color: Color(0xff707070),
//               ),
//             ),
//             child: LayoutBuilder(builder: (context, constraints) {
//               return Column(
//                 children: <Widget>[
//                   //Stats Card
//                   Container(
//                     //color: Colors.red,
//                       width: constraints.maxWidth*0.9,
//                       height: constraints.maxHeight*0.23,
//                       margin: EdgeInsets.fromLTRB(constraints.maxWidth*0.05, constraints.maxHeight*0.03, constraints.maxWidth*0.05, constraints.maxHeight*0.03),
//                       child: LayoutBuilder(builder: (context, constraints){
//                         return HomeStatsCard();
//                       })
//                   ),
//                   //Card 1
//                   Container(
//                     width: constraints.maxWidth*0.98,
//                     height:constraints.maxHeight*0.12,
//                     margin: EdgeInsets.fromLTRB(constraints.maxWidth*0.01, 0.0, constraints.maxWidth*0.01, 0.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(constraints.maxWidth*0.025),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Color.fromRGBO(0, 0, 0, 0.16),
//                           blurRadius: 6.0, // soften the shadow
//                           spreadRadius: 1.0, //extend the shadow
//                           offset: Offset(
//                             3.0, // Move to right 10  horizontally
//                             0.0, // Move to bottom 10 Vertically
//                           ),
//                         )
//                       ],
//                     ),
//                     child: LayoutBuilder(
//                         builder: (context, constraints){
//                           return Row(
//                             children: <Widget>[
//                               SizedBox(
//                                 width: constraints.maxWidth*0.03,
//                               ),
//                               Container(
//                                 width: constraints.maxWidth*0.15,
//                                 height: constraints.maxHeight*0.75,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Color(0xff111b161),
//                                 ),
//                                 child: Center(
//                                   child: Container(
//                                     width: constraints.maxWidth*0.075,
//                                     child: FittedBox(
//                                       fit:BoxFit.contain,
//                                       child: Text(
//                                         'Test',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontFamily: 'Poppins',
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                   width: constraints.maxWidth*0.009
//                               ),
//                               Container(
//                                 width:constraints.maxWidth*0.54,
//                                 child: LayoutBuilder(
//                                     builder: (context,constraints){
//                                       return Column(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: <Widget>[
//                                           Align(
//                                             alignment: Alignment.topLeft,
//                                             child: Container(
//                                               width: constraints.maxWidth*0.77,
//                                               margin: EdgeInsets.fromLTRB(constraints.maxWidth*0.1, 0.0, 0.0, 0.0),
//                                               child: FittedBox(
//                                                 fit: BoxFit.contain,
//                                                 child: Text(
//                                                   'Mock Driving Test',
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontFamily: 'Poppins',
//                                                     fontSize: 18,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                                   textAlign: TextAlign.left,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: constraints.maxHeight*0.05,
//                                           ),
//                                           Align(
//                                             alignment: Alignment.topLeft,
//                                             child: Container(
//                                               width: constraints.maxWidth*0.7,
//                                               margin: EdgeInsets.fromLTRB(constraints.maxWidth*0.1, 0.0, 0.0, 0.0),
//                                               child: FittedBox(
//                                                 fit: BoxFit.contain,
//                                                 child: Text(
//                                                   '01-06-2020 12:00',
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontFamily: 'Poppins',
//                                                     fontSize: 15,
//                                                     fontWeight: FontWeight.w400,
//                                                   ),
//                                                   textAlign: TextAlign.left,
//                                                 ),
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       );
//                                     }
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: constraints.maxWidth*0.05,
//                               ),
//                               Container(
//                                 width:constraints.maxWidth*0.18,
//                                 child: FittedBox(
//                                   fit:BoxFit.contain,
//                                   child: Text(
//                                     '£ 25.00',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontFamily: 'Poppins',
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           );
//                         }
//                     ),
//                   ),
//                   SizedBox(
//                     height: constraints.maxHeight*0.01,
//                   ),
//                   //Card 2
//                   Container(
//                     width: constraints.maxWidth*0.98,
//                     height:constraints.maxHeight*0.12,
//                     margin: EdgeInsets.fromLTRB(constraints.maxWidth*0.01, 0.0, constraints.maxWidth*0.01,0.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(constraints.maxWidth*0.025),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Color.fromRGBO(0, 0, 0, 0.16),
//                           blurRadius: 6.0, // soften the shadow
//                           spreadRadius: 1.0, //extend the shadow
//                           offset: Offset(
//                             3.0, // Move to right 10  horizontally
//                             0.0, // Move to bottom 10 Vertically
//                           ),
//                         )
//                       ],
//                     ),
//                     child: LayoutBuilder(
//                         builder: (context, constraints){
//                           return Row(
//                             children: <Widget>[
//                               SizedBox(
//                                 width: constraints.maxWidth*0.03,
//                               ),
//                               Container(
//                                 width: constraints.maxWidth*0.15,
//                                 height: constraints.maxHeight*0.75,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Color(0xff111b161),
//                                 ),
//                                 child: Center(
//                                   child: Container(
//                                     width: constraints.maxWidth*0.12,
//                                     child: FittedBox(
//                                       fit:BoxFit.contain,
//                                       child: Text(
//                                         'Lesson',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontFamily: 'Poppins',
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                   width: constraints.maxWidth*0.009
//                               ),
//                               Container(
//                                 width:constraints.maxWidth*0.54,
//                                 child: LayoutBuilder(
//                                     builder: (context,constraints){
//                                       return Column(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: <Widget>[
//                                           Align(
//                                             alignment: Alignment.topLeft,
//                                             child: Container(
//                                               width: constraints.maxWidth*0.9,
//                                               margin: EdgeInsets.fromLTRB(constraints.maxWidth*0.1, 0.0, 0.0, 0.0),
//                                               child: FittedBox(
//                                                 fit: BoxFit.contain,
//                                                 child: Text(
//                                                   'Pass Assist Lessons',
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontFamily: 'Poppins',
//                                                     fontSize: 18,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                                   textAlign: TextAlign.left,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: constraints.maxHeight*0.05,
//                                           ),
//                                           Align(
//                                             alignment: Alignment.topLeft,
//                                             child: Container(
//                                               width: constraints.maxWidth*0.7,
//                                               margin: EdgeInsets.fromLTRB(constraints.maxWidth*0.1, 0.0, 0.0, 0.0),
//                                               child: FittedBox(
//                                                 fit: BoxFit.contain,
//                                                 child: Text(
//                                                   '01-06-2020 12:00',
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontFamily: 'Poppins',
//                                                     fontSize: 15,
//                                                     fontWeight: FontWeight.w400,
//                                                   ),
//                                                   textAlign: TextAlign.left,
//                                                 ),
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       );
//                                     }
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: constraints.maxWidth*0.05,
//                               ),
//                               Container(
//                                 width:constraints.maxWidth*0.18,
//                                 child: FittedBox(
//                                   fit:BoxFit.contain,
//                                   child: Text(
//                                     '£ 25.00',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontFamily: 'Poppins',
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           );
//                         }
//                     ),
//                   ),
//
//                 ],
//               );
//             }),
//           )
//         ],
//       ),
//     );
//   }
// }