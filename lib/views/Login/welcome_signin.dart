// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:student_app/routing/route.dart' as router;
// import 'package:student_app/routing/route_names.dart' as routes;
// import 'package:mdt/services/navigation_service.dart';
// import 'package:mdt/services/social_login.dart';
// import 'package:mdt/locater.dart';
// import 'package:flutter/material.dart';
// import 'dart:io' show Platform;
//
// class welcome_signin extends StatelessWidget {
//   final NavigationService _navigationService = locator<NavigationService>();
//   late BuildContext globalContext;
//   late SocialLoginService _socialLoginService;
//
//   @override
//   Widget build(BuildContext context) {
//     globalContext = context;
//     _socialLoginService = new SocialLoginService(context);
//     return new LayoutBuilder(builder: (context, constraints) {
//       return Container(child: LayoutBuilder(builder: (context, constraints) {
//         return ListView(
//           children: <Widget>[
//             Container(
//               width: constraints.maxWidth * 0.85,
//               height: constraints.maxHeight * 0.2,
//               margin: EdgeInsets.fromLTRB(constraints.maxWidth * 0.075, 0,
//                   constraints.maxWidth * 0.075, 0.0),
//               child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   return Material(
//                     borderRadius:
//                         BorderRadius.circular(constraints.maxHeight * 0.5),
//                     color: Color.fromRGBO(255, 255, 255, 0.6),
//                     elevation: 7.0,
//                     child: GestureDetector(
//                       onTap: () {
//                         _navigationService.navigateTo(
//                           routes.LoginRoute,
//                         );
//                       },
//                       child: Row(
//                         children: <Widget>[
//                           Container(
//                             width: constraints.maxWidth * 0.17,
//                             height: constraints.maxHeight * 0.6,
//                             child: FittedBox(
//                               fit: BoxFit.contain,
//                               child: Icon(
//                                 MdiIcons.email,
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
//                                 'Sign in with Email',
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
//                                   'SignIn with Apple',
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
//                                 'SignIn with Google',
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
//                                 'SignIn with Facebook',
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
//     });
//   }
// }
//
//
//
// // if (await SignInWithApple.isAvailable()) {
// /*final credential = await SignInWithApple.getAppleIDCredential(
//           scopes: [
//             AppleIDAuthorizationScopes.email,
//             AppleIDAuthorizationScopes.fullName,
//           ],
//           webAuthenticationOptions: WebAuthenticationOptions(
//             // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
//             clientId:
//                 'app.mockdrivingtest.com',
//             redirectUri: Uri.parse(
//               'https://alabaster-bedecked-collision.glitch.me/callbacks/sign_in_with_apple ',
//             ),
//           ),
//         );
//
//         print(credential);
//
//         // This is the endpoint that will convert an authorization code obtained
//         // via Sign in with Apple into a session in your system
//         final signInWithAppleEndpoint = Uri(
//           scheme: 'https',
//           host: 'alabaster-bedecked-collision.glitch.me',
//           path: '/sign_in_with_apple',
//           queryParameters: <String, String>{
//             'code': credential.authorizationCode,
//             if (credential.givenName != null)
//               'firstName': credential.givenName,
//             if (credential.familyName != null)
//               'lastName': credential.familyName,
//             'useBundleId':
//                 Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
//             if (credential.state != null) 'state': credential.state,
//           },
//         );
//
//         final session = await http.Client().post(
//           signInWithAppleEndpoint,
//         );
//
//         // If we got this far, a session based on the Apple ID credential has been created in your system,
//         // and you can now set this as the app's session
//         print(session);*/
//
//
// /*  final rawNonce = generateNonce();
//         final nonce = sha256ofString(rawNonce);
//         final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//         print("Come for apple login");
//         final appleCredential = await SignInWithApple.getAppleIDCredential(
//           scopes: [
//             AppleIDAuthorizationScopes.email,
//             AppleIDAuthorizationScopes.fullName,
//           ],
//         );
//
//          print("appleCredential....");print(appleCredential);
//         inal oauthCredential =
//             OAuthProvider(providerId: "apple.com").getCredential(
//           idToken: appleCredential.identityToken,
//           accessToken:appleCredential.authorizationCode,
//           rawNonce: rawNonce,
//         );
//         final authResult =
//             await _firebaseAuth.signInWithCredential(oauthCredential);
//         final displayName =
//             '${appleCredential.givenName} ${appleCredential.familyName}';
//         final userEmail = '${appleCredential.email}';
//         final firebaseUser = authResult.user;
//         print("displayName.....");
//         print(displayName);
//         print("userEmail.....");
//         print(userEmail);
//         print("displayName.....");
//         print(displayName);
//         print("userEmail.....");
//         print(userEmail);*/
