// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:Smart_Theory_Test/Constants/app_colors.dart';
// import 'package:Smart_Theory_Test/views/Login/register.dart';
// import 'package:mdt/services/social_login.dart';
// import 'dart:io' show Platform;
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//
// class welcome_register extends StatelessWidget {
//   final NavigationService _navigationService = locator<NavigationService>();
//   late String user;
//   late SocialLoginService _socialLoginService;
//
//   @override
//   Widget build(BuildContext context) {
//     _socialLoginService = new SocialLoginService(context);
//     return new LayoutBuilder(builder: (context, constraints) {
//       return Container(child: LayoutBuilder(builder: (context, constraints) {
//         return ListView(
//           children: <Widget>[
//             Container(
//                 width: constraints.maxWidth * 0.85,
//                 height: constraints.maxHeight * 0.2,
//                 margin: EdgeInsets.fromLTRB(constraints.maxWidth * 0.075, 0,
//                     constraints.maxWidth * 0.075, 0.0),
//                 child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     return Material(
//                       borderRadius:
//                           BorderRadius.circular(constraints.maxHeight * 0.5),
//                       color: Color.fromRGBO(255, 255, 255, 0.6),
//                       elevation: 7.0,
//                       child: GestureDetector(
//                         onTap: () {
//                           user = '2';
//                           Navigator.pop(context);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => Register(user),
//                             ),
//                           );
//                         },
//                         child: Row(
//                           children: <Widget>[
//                             Container(
//                               width: constraints.maxWidth * 0.17,
//                               height: constraints.maxHeight * 0.6,
//                               //color: Colors.cyanAccent,
//                               child: FittedBox(
//                                 fit: BoxFit.contain,
//                                 child: Icon(
//                                   MdiIcons.email,
//                                   color: Color.fromRGBO(42, 8, 69, 1.0),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               width: constraints.maxWidth * 0.4,
//                               height: constraints.maxHeight * 0.7,
//                               margin: EdgeInsets.fromLTRB(
//                                   constraints.maxWidth * 0.13, 0.0, 0.0, 0.0),
//                               //color: Colors.cyanAccent,
//                               child: FittedBox(
//                                 fit: BoxFit.contain,
//                                 child: Text(
//                                   'Create Account',
//                                   style: TextStyle(
//                                       fontFamily: 'Poppins',
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w700,
//                                       color: Color.fromRGBO(42, 8, 69, 1.0)),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 )),
//             if (Platform.isIOS)
//               Container(
//                 width: constraints.maxWidth * 0.85,
//                 height: constraints.maxHeight * 0.2,
//                 margin: EdgeInsets.fromLTRB(
//                     constraints.maxWidth * 0.075,
//                     constraints.maxHeight * 0.05,
//                     constraints.maxWidth * 0.075,
//                     constraints.maxHeight * 0.0),
//                 child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     return Material(
//                       borderRadius:
//                           BorderRadius.circular(constraints.maxHeight * 0.5),
//                       color: Color.fromRGBO(255, 255, 255, 0.6),
//                       elevation: 7.0,
//                       child: GestureDetector(
//                         //onTap: _socialLoginService.appleSignIn,
//                         onTap: _socialLoginService.googleSignIn,
//
//                         child: Row(
//                           children: <Widget>[
//                             Container(
//                               width: constraints.maxWidth * 0.17,
//                               height: constraints.maxHeight * 0.6,
//                               //color: Colors.cyanAccent,
//                               child: FittedBox(
//                                 fit: BoxFit.contain,
//                                 child: Icon(
//                                   MdiIcons.apple,
//                                   color: Color.fromRGBO(42, 8, 69, 1.0),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               width: constraints.maxWidth * 0.55,
//                               height: constraints.maxHeight * 0.7,
//                               margin: EdgeInsets.fromLTRB(
//                                   constraints.maxWidth * 0.06, 0.0, 0.0, 0.0),
//                               //color: Colors.cyanAccent,
//                               child: FittedBox(
//                                 fit: BoxFit.contain,
//                                 child: Text(
//                                   'SignUp with Apple',
//                                   style: TextStyle(
//                                       fontFamily: 'Poppins',
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w700,
//                                       color: Color.fromRGBO(42, 8, 69, 1.0)),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             Container(
//               width: constraints.maxWidth * 0.85,
//               height: constraints.maxHeight * 0.2,
//               margin: EdgeInsets.fromLTRB(
//                   constraints.maxWidth * 0.075,
//                   constraints.maxHeight * 0.05,
//                   constraints.maxWidth * 0.075,
//                   0.0),
//               child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   return Material(
//                     borderRadius:
//                         BorderRadius.circular(constraints.maxHeight * 0.5),
//                     color: Color.fromRGBO(255, 255, 255, 0.6),
//                     elevation: 7.0,
//                     child: GestureDetector(
//                       onTap: _socialLoginService.googleSignIn,
//                       child: Row(
//                         children: <Widget>[
//                           Container(
//                             width: constraints.maxWidth * 0.17,
//                             height: constraints.maxHeight * 0.6,
//                             //color: Colors.cyanAccent,
//                             child: FittedBox(
//                               fit: BoxFit.contain,
//                               child: Icon(
//                                 MdiIcons.google,
//                                 color: Color.fromRGBO(42, 8, 69, 1.0),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             width: constraints.maxWidth * 0.55,
//                             height: constraints.maxHeight * 0.7,
//                             margin: EdgeInsets.fromLTRB(
//                                 constraints.maxWidth * 0.06, 0.0, 0.0, 0.0),
//                             //color: Colors.cyanAccent,
//                             child: FittedBox(
//                               fit: BoxFit.contain,
//                               child: Text(
//                                 'SignUp with Google',
//                                 style: TextStyle(
//                                     fontFamily: 'Poppins',
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w700,
//                                     color: Color.fromRGBO(42, 8, 69, 1.0)),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             /*   Container(
//               width: constraints.maxWidth * 0.85,
//               height: constraints.maxHeight * 0.2,
//               margin: EdgeInsets.fromLTRB(
//                   constraints.maxWidth * 0.075,
//                   constraints.maxHeight * 0.05,
//                   constraints.maxWidth * 0.075,
//                   constraints.maxWidth * 0.10),
//               child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   return Material(
//                     borderRadius:
//                         BorderRadius.circular(constraints.maxHeight * 0.5),
//                     color: Color.fromRGBO(255, 255, 255, 0.6),
//                     elevation: 7.0,
//                     child: GestureDetector(
//                       onTap: _socialLoginService.facebookSignIn,
//                       child: Row(
//                         children: <Widget>[
//                           Container(
//                             width: constraints.maxWidth * 0.17,
//                             height: constraints.maxHeight * 0.6,
//                             //color: Colors.cyanAccent,
//                             child: FittedBox(
//                               fit: BoxFit.contain,
//                               child: Icon(
//                                 MdiIcons.facebook,
//                                 color: Color.fromRGBO(42, 8, 69, 1.0),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             width: constraints.maxWidth * 0.63,
//                             height: constraints.maxHeight * 0.7,
//                             margin: EdgeInsets.fromLTRB(
//                                 constraints.maxWidth * 0.04, 0.0, 0.0, 0.0),
//                             //color: Colors.cyanAccent,
//                             child: FittedBox(
//                               fit: BoxFit.contain,
//                               child: Text(
//                                 'SignUp with Facebook',
//                                 style: TextStyle(
//                                     fontFamily: 'Poppins',
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w700,
//                                     color: Color.fromRGBO(42, 8, 69, 1.0)),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ), */
//           ],
//         );
//       }));
//
//       // return Container(
//       //   //color: Colors.black26,
//       //   child: Stack(
//       //     children: <Widget>[
//       //       LayoutBuilder(builder: (context, constraints) {
//       //         return
//       //       }),
//       //
//       //     ],
//       //   ),
//       // );
//     });
//   }
//
//   Widget _buildPopupDialog(BuildContext context) {
//     return Container(
//       //color: Colors.black12,
//       // width: MediaQuery.of(context).size.width*0.9,
//       child: AlertDialog(
//           title: Center(child: const Text('Create Student')),
//           titlePadding: EdgeInsets.only(top: 10.0, bottom: 2.0),
//           content: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             // crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Container(
//                   width: Responsive.width(25, context),
//                   height: Responsive.height(15, context),
//                   decoration: BoxDecoration(
//                       border: Border.all(width: 2.0, color: Dark),
//                       borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                   padding: EdgeInsets.fromLTRB(0.0, 10, 0.0, 10),
//                   //color: Colors.red,
//                   child: GestureDetector(onTap: () {
//                     user = '1';
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Register(user),
//                       ),
//                     );
//                   }, child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       return Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Text(
//                             "Student",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 18.0),
//                           ),
//                           Container(
//                               width: constraints.maxWidth * 0.9,
//                               height: constraints.maxHeight * 0.5,
//                               //color: Colors.black12,
//                               child: FittedBox(
//                                   fit: BoxFit.contain,
//                                   child: Icon(
//                                     FontAwesomeIcons.userAlt,
//                                     color: Dark,
//                                   )))
//                         ],
//                       );
//                     },
//                   ))),
//             ],
//           )),
//     );
//   }
// }
