// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:mdt/responsive/percentage_mediaquery.dart';
// import 'package:mdt/services/navigation_service.dart';
// import 'package:mdt/widgets/navigatin_bar/CustomAppBar.dart';
// import 'package:Smart_Theory_Test/views/WebView.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// import '../../locater.dart';
//
// class PrivacyPolicy extends StatefulWidget {
//   const PrivacyPolicy({Key? key}) : super(key: key);
//   @override
//   State<StatefulWidget> createState() => _PrivacyPolicy();
// }
//
// class _PrivacyPolicy extends State<PrivacyPolicy> {
//   final NavigationService _navigationService = locator<NavigationService>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           CustomAppBar(
//               title: 'Privacy Policy',
//               textWidth: Responsive.width(48, context),
//               iconLeft: FontAwesomeIcons.arrowLeft,
//               preferedHeight: Responsive.height(15, context),
//               onTap1: () {
//                 _navigationService.goBack();
//               },
//               iconRight: null),
//           LayoutBuilder(builder: (context, constraints) {
//             return Container(
//                 height: constraints.maxHeight,
//                 margin: EdgeInsets.fromLTRB(
//                     0.0, constraints.maxHeight * 0.18, 0.0, 0.0),
//                 child: WebViewContainer()
//                 // WebView(
//                 //   initialUrl:
//                 //       'https://mockdrivingtest.com/static/privacy-policy',
//                 //   javascriptMode: JavascriptMode.unrestricted,
//                 // )
//                 // SingleChildScrollView(
//                 //   child: Column(
//                 //     children: <Widget>[
//                 //       Container(
//                 //         padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth*0.03),
//                 //         child: Text(
//                 //           'This privacy policy applies between you, the User of this Website and Vin Solutions Ltd, T/A MockDrivingTest.com, the owner and provider of this Website. Vin Solutions Ltd, T/A MockDrivingTest.com takes the privacy of your information very seriously. This privacy policy applies to our use of any and all Data collected by us or provided by you in relation to your use of the Website..',
//                 //           style: TextStyle(
//                 //             fontFamily: 'Poppins',
//                 //             fontSize: 15,
//                 //             color: const Color(0xad060606),
//                 //             letterSpacing: 0.16499999999999998,
//                 //
//                 //           ),
//                 //           textAlign: TextAlign.left,
//                 //         ),
//                 //       ),
//                 //       SizedBox(
//                 //         height: constraints.maxHeight*0.02,
//                 //       ),
//                 //       Container(
//                 //         padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth*0.03),
//                 //         child: Text(
//                 //           'This privacy policy should be read alongside, and in addition to, our Terms and Conditions, which can be found at:',
//                 //           style: TextStyle(
//                 //             fontFamily: 'Poppins',
//                 //             fontSize: 15,
//                 //             color: const Color(0xad060606),
//                 //             letterSpacing: 0.16499999999999998,
//                 //
//                 //           ),
//                 //           textAlign: TextAlign.left,
//                 //         ),
//                 //       ),
//                 //       SizedBox(
//                 //         height: constraints.maxHeight*0.02,
//                 //       ),
//                 //       Container(
//                 //         width: constraints.maxWidth*1,
//                 //         padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth*0.03),
//                 //         child: FittedBox(
//                 //           fit: BoxFit.contain,
//                 //           child: Text(
//                 //             'Please read this privacy policy \ncarefully.',
//                 //             style: TextStyle(
//                 //               fontFamily: 'Segoe UI',
//                 //               fontSize: 24,
//                 //               color: const Color(0xff0e9bcf),
//                 //               fontWeight: FontWeight.w600,
//                 //
//                 //             ),
//                 //             textAlign: TextAlign.left,
//                 //           ),
//                 //         ),
//                 //       ),
//                 //       SizedBox(height: constraints.maxHeight*0.02,),
//                 //       Align(
//                 //         alignment: Alignment.topLeft,
//                 //         child: Container(
//                 //           width: constraints.maxWidth*1,
//                 //           padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth*0.03),
//                 //           child: FittedBox(
//                 //
//                 //             child: Text(
//                 //               'Definitions and interpretation',
//                 //               style: TextStyle(
//                 //                 fontFamily: 'Segoe UI',
//                 //                 fontSize: 24,
//                 //                 color: const Color(0xff0e9bcf),
//                 //                 fontWeight: FontWeight.w600,
//                 //
//                 //               ),
//                 //               textAlign: TextAlign.left,
//                 //             ),
//                 //           ),
//                 //         ),
//                 //       ),
//                 //       SizedBox(height: constraints.maxHeight*0.02),
//                 //       Container(
//                 //         width: constraints.maxWidth*1,
//                 //         padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth*0.03),
//                 //         child: Text(
//                 //           '1.In this privacy policy, the following definitions are used:',
//                 //           style: TextStyle(
//                 //             fontFamily: 'Poppins',
//                 //             fontSize: 15,
//                 //             color: const Color(0xad060606),
//                 //             letterSpacing: 0.16499999999999998,
//                 //
//                 //           ),
//                 //           textAlign: TextAlign.left,
//                 //         ),
//                 //       ),
//                 //       SizedBox(
//                 //         height: constraints.maxHeight*0.01,
//                 //       ),
//                 //       Container(
//                 //         padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth*0.03),
//                 //         child: Text(
//                 //           '2.In this privacy policy, unless the context requires a different interpretation:',
//                 //           style: TextStyle(
//                 //             fontFamily: 'Poppins',
//                 //             fontSize: 15,
//                 //             color: const Color(0xad060606),
//                 //             letterSpacing: 0.16499999999999998,
//                 //
//                 //           ),
//                 //           textAlign: TextAlign.left,
//                 //         ),
//                 //       ),
//                 //       Container(
//                 //         padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth*.03),
//                 //         child: Text(
//                 //           'a. the singular includes the plural and vice versa;',
//                 //           style: TextStyle(
//                 //             fontFamily: 'Poppins',
//                 //             fontSize: 15,
//                 //             color: const Color(0xad060606),
//                 //             letterSpacing: 0.16499999999999998,
//                 //
//                 //           ),
//                 //           textAlign: TextAlign.left,
//                 //         ),
//                 //       ),
//                 //       Container(
//                 //         padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth*.03),
//                 //         child: Text(
//                 //           'b.references to sub-clauses, clauses, schedules or appendices are to sub-clauses, clauses, schedules or appendices of this privacy policy;',
//                 //           style: TextStyle(
//                 //             fontFamily: 'Poppins',
//                 //             fontSize: 15,
//                 //             color: const Color(0xad060606),
//                 //             letterSpacing: 0.16499999999999998,
//                 //
//                 //           ),
//                 //           textAlign: TextAlign.left,
//                 //         ),
//                 //       ),
//                 //       Container(
//                 //         padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth*.03),
//                 //         child: Text(
//                 //           'c. a reference to a person includes firms, companies, government entities, trusts and partnerships;',
//                 //           style: TextStyle(
//                 //             fontFamily: 'Poppins',
//                 //             fontSize: 15,
//                 //             color: const Color(0xad060606),
//                 //             letterSpacing: 0.16499999999999998,
//                 //
//                 //           ),
//                 //           textAlign: TextAlign.left,
//                 //         ),
//                 //       ),
//                 //       Container(
//                 //         padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth*.03),
//                 //         child: Text(
//                 //           'd. including" is understood to mean "including without limitation"',
//                 //           style: TextStyle(
//                 //             fontFamily: 'Poppins',
//                 //             fontSize: 15,
//                 //             color: const Color(0xad060606),
//                 //             letterSpacing: 0.16499999999999998,
//                 //
//                 //           ),
//                 //           textAlign: TextAlign.left,
//                 //         ),
//                 //       ),
//                 //       Container(
//                 //         padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth*.03),
//                 //         child: Text(
//                 //           'e. reference to any statutory provision includes any modification or amendment of it;',
//                 //           style: TextStyle(
//                 //             fontFamily: 'Poppins',
//                 //             fontSize: 15,
//                 //             color: const Color(0xad060606),
//                 //             letterSpacing: 0.16499999999999998,
//                 //
//                 //           ),
//                 //           textAlign: TextAlign.left,
//                 //         ),
//                 //       ),
//                 //       Container(
//                 //         padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth*.03),
//                 //         child: Text(
//                 //           'f. the headings and sub-headings do not form part of this privacy policy.;',
//                 //           style: TextStyle(
//                 //             fontFamily: 'Poppins',
//                 //             fontSize: 15,
//                 //             color: const Color(0xad060606),
//                 //             letterSpacing: 0.16499999999999998,
//                 //
//                 //           ),
//                 //           textAlign: TextAlign.left,
//                 //         ),
//                 //       ),
//                 //       Container(
//                 //         padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth*.03),
//                 //         child: Text(
//                 //           '3. You must not otherwise reproduce, modify, copy, distribute or use for commercial purposes any Content without the written permission of Vin Solutions Ltd, T/A MockDrivingTest.com.',
//                 //           style: TextStyle(
//                 //             fontFamily: 'Poppins',
//                 //             fontSize: 15,
//                 //             color: const Color(0xad060606),
//                 //             letterSpacing: 0.16499999999999998,
//                 //
//                 //           ),
//                 //           textAlign: TextAlign.left,
//                 //         ),
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//                 );
//           })
//         ],
//       ),
//     );
//   }
// }
