import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Smart_Theory_Test/Constants/app_colors.dart';
import 'package:Smart_Theory_Test/custom_button.dart';
import 'package:Smart_Theory_Test/services/auth.dart';
import 'package:Smart_Theory_Test/views/Login/register.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/social_login.dart';
import '../../utils/appImages.dart';
import '../../utils/app_colors.dart';
import 'login.dart';

class Tabs extends StatefulWidget {
  @override
  TabsState createState() => new TabsState();
}

class TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  //final PermissionHandler permissionHandler = PermissionHandler();
  //Map<PermissionGroup, PermissionStatus> permissions;

  /*Future<bool> _requestPermission(PermissionGroup permission) async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }*/
/*Checking if your App has been Given Permission*/
  // Future<bool> requestLocationPermission({Function? onPermissionDenied}) async {
  //   //var granted = await _requestPermission(PermissionGroup.locationAlways);
  //
  //   var granted = await Permission.location.request().isGranted;
  //   if (granted != true) {
  //     requestLocationPermission();
  //   }
  //   debugPrint('requestContactsPermission $granted');
  //   return granted;
  // }

/*Show dialog if GPS not enabled and open settings location*/
  // Future _checkGps() async {
  //   if (!(await Geolocator.isLocationServiceEnabled())) {
  //     if (Theme.of(context).platform == TargetPlatform.android) {
  //       showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: Text("Can't get current location"),
  //               content:
  //                   const Text('Please make sure you enable GPS and try again'),
  //               actions: <Widget>[
  //                 TextButton(
  //                     child: Text('Ok'),
  //                     onPressed: () {
  //                       // final AndroidIntent intent = AndroidIntent(
  //                       //     action:
  //                       //         'android.settings.LOCATION_SOURCE_SETTINGS');
  //                       // intent.launch();
  //                       // Navigator.of(context, rootNavigator: true).pop();
  //                       // _gpsService();
  //                     })
  //               ],
  //             );
  //           });
  //     }
  //   }
  // }

/*Check if gps service is enabled or not*/
  // Future _gpsService() async {
  //   if (!(await Geolocator.isLocationServiceEnabled())) {
  //     _checkGps();
  //     return null;
  //   } else
  //     return true;
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //requestLocationPermission();
    //_gpsService();
  }

  @override
  Widget build(BuildContext context) {
    //var height = MediaQuery.of(context).size.height;
    //var width = MediaQuery.of(context).size.width;
//    height: screenHeight,
//    width: screenWidth,
    return DefaultTabController(
      length: 2,
      child: new Container(
        width: Responsive.width(100, context),
        height: Responsive.height(40, context),
        //color: Colors.black26,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: <Widget>[
                Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 0.17,
                  //color: Colors.redAccent,
                  child: TabBar(
                      indicatorColor: Colors.white,
                      indicatorWeight: constraints.maxHeight * 0.01,
                      labelPadding: EdgeInsets.only(bottom: 0.0),
                      tabs: <Tab>[
                        Tab(
                          child: Container(
                            width: constraints.maxWidth * 0.23,
                            height: constraints.maxHeight * 0.2,
                            //color: Colors.redAccent,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            width: constraints.maxWidth * 0.18,
                            height: constraints.maxHeight * 0.2,
                            //color: Colors.redAccent,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
                Container(
                  color: Colors.transparent,
                  height: constraints.maxHeight * 0.8,
                  child: new TabBarView(
                    children: <Widget>[
                      // new welcome_register(),
                      // new welcome_signin(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class Welcome extends StatelessWidget {
  late String _facebookUrl;

  void _launchURL(String _url) async {
    print("hello");
    try {
      await launchUrl(Uri.parse(_url));
    } catch (e) {
      print(e);
    }
  }

  // late final SocialLoginService socialLoginService;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // _socialLoginService = SocialLoginService(context);
    var width = MediaQuery.of(context).size.width;
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: [
                Image.asset(
                  "assets/bg1.png",
                  //height: 300,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                ),
                // Positioned(
                //   top: SizeConfig.blockSizeVertical * 21,
                //   left: SizeConfig.blockSizeHorizontal * 28,
                //   child: CircleAvatar(
                //     radius: SizeConfig.blockSizeHorizontal * 22,
                //     backgroundColor: Colors.white,
                //     child: Container(
                //       child: Image.asset(
                //         "assets/s_logo.png",
                //         height: 180,
                //         width: 182,
                //         //fit: BoxFit.contain,
                //       ),
                //     ),
                //   ),
                // ),
                // Positioned(
                //   top: 415,
                //   left: 25,
                //   right: 25,
                //   child: SizedBox(
                //     height: 400,
                //     child: Padding(
                //       padding: EdgeInsets.all(20),
                //       child: Container(
                //         decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius: BorderRadius.circular(20),
                //             boxShadow: [
                //               BoxShadow(
                //                   color: Colors.black.withOpacity(0.1),
                //                   blurRadius: 15,
                //                   spreadRadius: 0),
                //             ]),
                //         child: Padding(
                //           padding: EdgeInsets.all(20),
                //           child: Column(
                //             children: [
                //               CustomButton(
                //                   onTap: () {
                //                     Navigator.of(context).push(
                //                       MaterialPageRoute(
                //                         builder: (context) => Register('2'),
                //                       ),
                //                     );
                //                   },
                //                   gradient: LinearGradient(
                //                       end: Alignment.centerLeft,
                //                       begin: Alignment.centerRight,
                //                       colors: [
                //                         AppColors.blueGrad1,
                //                         AppColors.blueGrad2,
                //                         AppColors.blueGrad3,
                //                         AppColors.blueGrad4,
                //                         AppColors.blueGrad5,
                //                         AppColors.blueGrad6,
                //                         AppColors.blueGrad7,
                //                       ])),
                //               CustomButton(
                //                   gradient: LinearGradient(
                //                       end: Alignment.centerLeft,
                //                       begin: Alignment.centerRight,
                //                       colors: [
                //                     AppColors.primary,
                //                     AppColors.secondary,
                //                   ])),
                //               // Row(
                //               //   children: [
                //               //     Expanded(
                //               //       child: GestureDetector(
                //               //         onTap: () {
                //               //           Navigator.of(context).push(
                //               //             MaterialPageRoute(
                //               //               builder: (context) => Register('2'),
                //               //             ),
                //               //           );
                //               //         },
                //               //         child: Container(
                //               //           decoration: BoxDecoration(
                //               //               borderRadius: BorderRadius.circular(10),
                //               //               gradient: LinearGradient(
                //               //                   end: Alignment.centerLeft,
                //               //                   begin: Alignment.centerRight,
                //               //                   colors: [
                //               //                     AppColors.blueGrad1,
                //               //                     AppColors.blueGrad2,
                //               //                     AppColors.blueGrad3,
                //               //                     AppColors.blueGrad4,
                //               //                     AppColors.blueGrad5,
                //               //                     AppColors.blueGrad6,
                //               //                     AppColors.blueGrad7,
                //               //                   ])),
                //               //           child: Padding(
                //               //             padding: EdgeInsets.symmetric(vertical: 15),
                //               //             child: Text('Register',
                //               //                 textAlign: TextAlign.center,
                //               //                 style: TextStyle(
                //               //                   fontFamily: 'Poppins',
                //               //                   fontSize: 15,
                //               //                   color: AppColors.white,
                //               //                   fontWeight: FontWeight.w600,
                //               //                 )),
                //               //           ),
                //               //         ),
                //               //       ),
                //               //     ),
                //               //   ],
                //               // ),
                //               SizedBox(height: 10),
                //               Material(
                //                 borderRadius: BorderRadius.circular(10),
                //                 borderOnForeground: true,
                //                 color: Dark,
                //                 elevation: 5.0,
                //                 child: MaterialButton(
                //                   onPressed: () {
                //                     Navigator.of(context).push(
                //                       MaterialPageRoute(
                //                         builder: (context) => SignInForm(),
                //                       ),
                //                     );
                //                   },
                //                   child: Padding(
                //                     padding: EdgeInsets.symmetric(
                //                         horizontal: 15, vertical: 10),
                //                     child: Text(
                //                       'Login',
                //                       style: TextStyle(
                //                         fontFamily: 'Poppins',
                //                         fontSize: SizeConfig.blockSizeHorizontal * 4.8,
                //                         fontWeight: FontWeight.w700,
                //                         color: Colors.white,
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               Row(
                //                 children: [
                //                   Container(
                //                     width: SizeConfig.blockSizeHorizontal * 11,
                //                     child: Divider(
                //                       thickness: 2,
                //                       color: AppColors.grey,
                //                     ),
                //                   ),
                //                   Center(
                //                     child: Text(
                //                       "Or connect with",
                //                       style: TextStyle(
                //                           letterSpacing: 2,
                //                           fontSize: 15,
                //                           color: AppColors.grey,
                //                           fontWeight: FontWeight.w400),
                //                     ),
                //                   ),
                //                   Divider(
                //                     thickness: 2,
                //                     color: Dark,
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ]),
              // SizedBox(height: 25),
              Padding(
                padding:
                    EdgeInsets.only(top: 0, bottom: 5, left: 20, right: 20),
                child: Container(
                  height: 390,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.black.withOpacity(0.1),
                          offset: Offset(0, 0),
                          blurRadius: 15,
                          spreadRadius: 0),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Let\'s Get Started',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      AppColors.blueGrad7,
                                      AppColors.blueGrad6,
                                      AppColors.blueGrad5,
                                      AppColors.blueGrad4,
                                      AppColors.blueGrad3,
                                      AppColors.blueGrad2,
                                      AppColors.blueGrad1,
                                    ]),
                                title: 'Register',
                                onTap: () {
                                  log('Open Registration');
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Register('2'),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                gradient: null,
                                title: 'Login',
                                onTap: () {
                                  print('Open Login Page');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignInForm()));
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.line,
                              width: 50,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text("Or connect with",
                                  style: AppTextStyle.textStyle.copyWith(
                                      color: AppColors.grey,
                                      fontSize: 15,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w400)),
                            ),
                            Image.asset(AppImages.line, width: 50),
                            // Divider(
                            //   endIndent: 70,
                            //   thickness: 1,
                            //   color: AppColors.grey,
                            // ),
                          ],
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 25, right: 25, top: 35),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              socialIconCustom(
                                image: AppImages.google,
                                onTap: () {
                                  print('Click GOOGLE BUTTON');
                                  SocialLoginService(context).googleSignIn();
                                  print(
                                      'Click ***********************----------- ');
                                },
                              ),
                              SizedBox(width: Platform.isIOS ? 30 : 0),
                              Platform.isIOS
                                  ? socialIconCustom(
                                      image: AppImages.apple,
                                      onTap: () {
                                        SocialLoginService(context)
                                            .signInWithApple(context);
                                        print(
                                            'apple******************----------- ');
                                      },
                                    )
                                  : SizedBox(),
                              SizedBox(width: 30),
                              socialIconCustom(
                                image: AppImages.facebook,
                                onTap: () {
                                  SocialLoginService(context).facebookSignIn();
                                  // _facebookUrl =
                                  //     "https://www.facebook.com/mockdrivingtest/";
                                  // print(_facebookUrl);
                                  //   _launchURL(_facebookUrl);
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
    // Stack(children: [
    //   CustomPaint(
    //     size: Size(
    //       width,
    //       height,
    //     ),
    //     painter: LandingPagePainter(),
    //   ),
    //   Positioned(
    //     top: SizeConfig.blockSizeVertical * 20,
    //     left: SizeConfig.blockSizeHorizontal * 28,
    //     child: CircleAvatar(
    //       radius: SizeConfig.blockSizeHorizontal * 22,
    //       backgroundColor: Colors.white,
    //       child: Container(
    //         child: Image.asset(
    //           "assets/stt_s_logo.png",
    //           height: SizeConfig.blockSizeVertical * 45,
    //           width: SizeConfig.blockSizeHorizontal * 45,
    //           fit: BoxFit.contain,
    //         ),
    //       ),
    //     ),
    //   ),
    //   Container(
    //     width: double.infinity,
    //     margin: EdgeInsets.only(
    //       top: SizeConfig.blockSizeVertical * 50,
    //     ),
    //     //color: Colors.black12,
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 40),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Expanded(
    //                 child: Material(
    //                   borderRadius: BorderRadius.circular(10),
    //                   color: Dark,
    //                   elevation: 5.0,
    //                   child: MaterialButton(
    //                     onPressed: () {
    //                       Navigator.of(context).push(
    //                         MaterialPageRoute(
    //                           builder: (context) => Register('2'),
    //                         ),
    //                       );
    //                     },
    //                     child: Padding(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: 15, vertical: 10),
    //                       child: Text(
    //                         'Register',
    //                         style: TextStyle(
    //                           fontFamily: 'Poppins',
    //                           fontSize:
    //                               SizeConfig.blockSizeHorizontal * 4.8,
    //                           fontWeight: FontWeight.w700,
    //                           color: Color.fromRGBO(255, 255, 255, 1.0),
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(width: 10),
    //               Expanded(
    //                 child: Material(
    //                   borderRadius: BorderRadius.circular(10),
    //                   borderOnForeground: true,
    //                   color: Dark,
    //                   elevation: 5.0,
    //                   child: MaterialButton(
    //                     onPressed: () {
    //                       Navigator.of(context).push(
    //                         MaterialPageRoute(
    //                           builder: (context) => SignInForm(),
    //                         ),
    //                       );
    //                     },
    //                     child: Padding(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: 15, vertical: 10),
    //                       child: Text(
    //                         'Login',
    //                         style: TextStyle(
    //                           fontFamily: 'Poppins',
    //                           fontSize:
    //                               SizeConfig.blockSizeHorizontal * 4.8,
    //                           fontWeight: FontWeight.w700,
    //                           color: Colors.white,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //
    //         Container(
    //           width: SizeConfig.blockSizeHorizontal * 50,
    //           margin: EdgeInsets.only(
    //             top: SizeConfig.blockSizeVertical * 2,
    //           ),
    //           //color: Colors.black12,
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Container(
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(30),
    //                     color: Colors.white,
    //                     boxShadow: [
    //                       BoxShadow(
    //                           color: Colors.black.withOpacity(0.5),
    //                           blurRadius: 6,
    //                           offset: Offset(4, 2))
    //                     ]),
    //                 child: InkWell(
    //                   onTap: () async {
    //                     SocialLoginService(context).googleSignIn();
    //                     print(
    //                         'Click ***********************************     ---------------- ');
    //                   },
    //                   child: CircleAvatar(
    //                     backgroundColor: Colors.white,
    //                     radius: SizeConfig.blockSizeHorizontal * 5,
    //                     child: SvgPicture.asset(
    //                       "assets/google-color.svg",
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(width: 10),
    //               Container(
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(30),
    //                     color: Colors.white,
    //                     boxShadow: [
    //                       BoxShadow(
    //                           color: Colors.black.withOpacity(0.5),
    //                           blurRadius: 6,
    //                           offset: Offset(4, 2))
    //                     ]),
    //                 child: InkWell(
    //                   onTap: () {
    //                     SocialLoginService(context)
    //                         .signInWithApple(context);
    //                   },
    //                   child: CircleAvatar(
    //                       backgroundColor: Colors.blue,
    //                       radius: 20,
    //                       child: Icon(
    //                         FontAwesomeIcons.apple,
    //                         color: Colors.white,
    //                         size: 25,
    //                       )),
    //                 ),
    //               ),
    //               SizedBox(width: 10),
    //               Container(
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(30),
    //                     color: Colors.white,
    //                     boxShadow: [
    //                       BoxShadow(
    //                           color: Colors.black.withOpacity(0.5),
    //                           blurRadius: 6,
    //                           offset: Offset(4, 2))
    //                     ]),
    //                 child: InkWell(
    //                     onTap: () {
    //                       _facebookUrl =
    //                           "https://www.facebook.com/mockdrivingtest/";
    //                       print(_facebookUrl);
    //                       _launchURL(_facebookUrl);
    //                     },
    //                     child: Icon(
    //                       FontAwesomeIcons.facebook,
    //                       color: Colors.blue,
    //                       size: 38,
    //                     )
    //                     // CircleAvatar(
    //                     //     backgroundColor: Colors.transparent,
    //                     //     radius: 18,
    //                     //     child: ),
    //                     ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // ]));
  }
}

class socialIconCustom extends StatelessWidget {
  final VoidCallback? onTap;
  final String? image;

  const socialIconCustom({
    super.key,
    this.onTap,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.black.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: GestureDetector(
          onTap: onTap,
          child: Image.asset(
            '${image}',
            height: 25,
            width: 25,
          ),
        ),
      ),
    );
  }
}

callDialog() async {
  var sharedPref = await SharedPreferences.getInstance();
  sharedPref.setBool('theoryTestPractice', true);
  print(sharedPref);
}

// class LandingPagePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint0 = Paint()
//       //..color = TestColor
//       ..style = PaintingStyle.fill
//       ..strokeWidth = 1.0;
//     paint0.shader = ui.Gradient.linear(
//       Offset(size.width * 0.5, -size.height * 0.06),
//       Offset(size.width, size.height * 0.10),
//       [Light, Dark],
//       [0.00, 0.70],
//     );
//
//     Path path0 = Path();
//     path0.moveTo(0, 0);
//     path0.lineTo(0, size.height * 0.21);
//     path0.quadraticBezierTo(
//         size.width * 0.15, size.height * 0.42, size.width, size.height * 0.25);
//     path0.quadraticBezierTo(size.width, size.height * 0.15, size.width, 0);
//     //path0.lineTo(0,0);
//     path0.close();
//
//     canvas.drawPath(path0, paint0);
//
//     Paint paint1 = Paint()
//       ..style = PaintingStyle.fill
//       ..strokeWidth = 1.0;
//
//     paint1.shader = ui.Gradient.linear(
//       Offset(size.width * 0.5, -size.height * 0.05),
//       Offset(size.width, size.height * 0.10),
//       [Light, Dark],
//       [0.00, 0.70],
//     );
//
//     Path path1 = Path();
//     path1.moveTo(0, 0);
//     path1.lineTo(0, size.height * 0.20);
//     path1.quadraticBezierTo(
//         size.width * 0.2, size.height * 0.35, size.width, size.height * 0.13);
//     path1.quadraticBezierTo(size.width, size.height * 0.22, size.width, 0);
//     path1.lineTo(0, 0);
//     path1.close();
//
//     canvas.drawPath(path1, paint1);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
