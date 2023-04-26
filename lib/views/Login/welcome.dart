import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:student_app/Constants/app_colors.dart';
import 'package:student_app/views/Login/register.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/social_login.dart';
import 'dart:ui' as ui;

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
  late final SocialLoginService _socialLoginService;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    _socialLoginService = SocialLoginService(context);
    var width = MediaQuery.of(context).size.width;
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomPaint(
            size: Size(
              width,
              height,
            ),
            painter: LandingPagePainter(),
          ),
          Positioned(
            top: SizeConfig.blockSizeVertical * 22,
            left: SizeConfig.blockSizeHorizontal * 30,
            child: CircleAvatar(
              radius: SizeConfig.blockSizeHorizontal * 20,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: SizeConfig.blockSizeHorizontal * 18,
                child: Container(
                  child: Image.asset(
                    "assets/logo_app.png",
                    height: SizeConfig.blockSizeVertical * 33,
                    width: SizeConfig.blockSizeHorizontal * 33,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              top: SizeConfig.blockSizeVertical * 50,
            ),
            //color: Colors.black12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Material(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                      color: Dark,
                      elevation: 5.0,
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Register('2'),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: SizeConfig.blockSizeHorizontal * 4.8,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(255, 255, 255, 1.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                      borderOnForeground: true,
                      color: Dark,
                      elevation: 5.0,
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SignInForm(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: SizeConfig.blockSizeHorizontal * 4.8,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 30,
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
                  //color: Colors.black12,
                  child: Row(
                    children: [
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 11,
                        child: Divider(
                          thickness: 2,
                          color: Dark,
                        ),
                      ),
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 8,
                        child: Center(
                          child: Text(
                            "or",
                            style: TextStyle(
                                letterSpacing: 2,
                                fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 11,
                        child: Divider(
                          thickness: 2,
                          color: Dark,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // width: SizeConfig.blockSizeHorizontal * 50,
                  margin: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical * 5,
                  ),
                  child: Center(
                    child: Text(
                      "Connect with",
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 50,
                  margin: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical * 2,
                  ),
                  //color: Colors.black12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          _socialLoginService.googleSignIn();
                          print(
                              'Click ***********************************     ---------------- ');
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: SizeConfig.blockSizeHorizontal * 5,
                          child: SvgPicture.asset(
                            "assets/google-color.svg",
                          ),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 6,
                      ),
                      InkWell(
                        onTap: () {
                          _socialLoginService.signInWithApple(context);
                        },
                        child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 23,
                            child: Icon(
                              FontAwesomeIcons.apple,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LandingPagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      //..color = TestColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;
    paint0.shader = ui.Gradient.linear(
      Offset(size.width * 0.5, -size.height * 0.05),
      Offset(size.width, size.height * 0.10),
      [Light, Dark],
      [0.00, 0.70],
    );

    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.lineTo(0, size.height * 0.21);
    path0.quadraticBezierTo(
        size.width * 0.15, size.height * 0.52, size.width, size.height * 0.25);
    path0.quadraticBezierTo(size.width, size.height * 0.15, size.width, 0);
    //path0.lineTo(0,0);
    path0.close();

    canvas.drawPath(path0, paint0);

    Paint paint1 = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    paint1.shader = ui.Gradient.linear(
      Offset(size.width * 0.5, -size.height * 0.05),
      Offset(size.width, size.height * 0.10),
      [Light, Dark],
      [0.00, 0.70],
    );

    Path path1 = Path();
    path1.moveTo(0, 0);
    path1.lineTo(0, size.height * 0.20);
    path1.quadraticBezierTo(
        size.width * 0.2, size.height * 0.35, size.width, size.height * 0.13);
    path1.quadraticBezierTo(size.width, size.height * 0.22, size.width, 0);
    path1.lineTo(0, 0);
    path1.close();

    canvas.drawPath(path1, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
