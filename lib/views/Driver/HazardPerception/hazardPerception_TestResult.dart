import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Smart_Theory_Test/Constants/app_colors.dart';
import 'package:Smart_Theory_Test/routing/route_names.dart' as routes;
import 'package:Smart_Theory_Test/utils/app_colors.dart';

import '../../../locater.dart';
import '../../../responsive/percentage_mediaquery.dart';
import '../../../services/local_services.dart';
import '../../../services/navigation_service.dart';
import '../../../widget/CustomAppBar.dart';

class HazardPerceptionTestResult extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HazardPerceptionTestResult();
}

class _HazardPerceptionTestResult extends State<HazardPerceptionTestResult>
    with TickerProviderStateMixin {
  final NavigationService _navigationService = locator<NavigationService>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LocalServices _localServices = LocalServices();
  late Timer rattingAnimation;
  int videoIndex = 0;

  // GifController gifControl;
  bool testComplete = true;
  int totalRatting = 5;
  int gainedRating = 5; //default
  String resultMessage = "";
  List<String> messageList = [
    "Whoops! you missed the hazard", //0
    "You're nearly there. Look for clues and try to tap earlier", //1,2
    "Amazing! keep up the good work", //3,4
    "Incredible! you really aced that one" //5
  ];

  @override
  void initState() {
    videoIndex = _localServices.getIndexOfVideo();
    // initializeGifAnimation();
    super.initState();
  }

  // void initializeGifAnimation() {
  //   gifControl = new GifController(vsync: this);
  //   gifControl.value = 0;
  //   gifControl.animateTo(135,
  //       duration: Duration(milliseconds: 5000), curve: Curves.linear);
  //   gifControl.repeat(
  //       min: 0, max: 135, reverse: false, period: Duration(milliseconds: 5000));
  // }

  @override
  void dispose() {
    // gifControl.dispose();
    try {
      rattingAnimation.cancel();
    } catch (e) {}
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    try {
      // SystemChrome.setPreferredOrientations(
      //     [DeviceOrientation.portraitUp]).then((_) {
      _navigationService.goBack();
      return true;
    } catch (e) {
      return false;
    }
    // });
  }

  @override
  void didChangeDependencies() {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    try {
      this.testComplete = arguments['pattern_out'] == false ? true : false;
      num missedRatingPoint = 5 - arguments['rightClick'];
      setState(() {
        this.setResultMessage(arguments['rightClick']);
      });
      rattingAnimation = Timer.periodic(Duration(milliseconds: 700), (timer) {
        if (gainedRating == (5 - missedRatingPoint)) {
          timer.cancel();
        } else {
          setState(() {
            gainedRating -= 1;
          });
        }
      });
    } catch (e) {
      print("Exception...:" + e.toString());
    } finally {
      super.didChangeDependencies();
    }
  }

  void setResultMessage(int resultScore) {
    switch (resultScore) {
      case 0:
        resultMessage = messageList[0];
        break;
      case 1:
        resultMessage = messageList[1];
        break;
      case 2:
        resultMessage = messageList[1];
        break;
      case 3:
        resultMessage = messageList[2];
        break;
      case 4:
        resultMessage = messageList[2];
        break;
      case 5:
        resultMessage = messageList[3];
        break;
    }
  }

  // final TWO_PI = 3.2 * 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: WillPopScope(
            onWillPop: _onBackPressed,
            child: Stack(children: <Widget>[
              CustomAppBar(
                  hasIcon: true,
                  preferedHeight: Responsive.height(18, context),
                  title: 'Results - CGI Video ${videoIndex + 1}',
                  textWidth: Responsive.width(70, context),
                  iconLeft: Icons.close,
                  onTap1: () {
                    _onBackPressed();
                  },
                  // isRightBtn: true,
                  iconRight: Icons.arrow_forward_ios,
                  onTapRightbtn: () {
                    int totalVideos = _localServices.getVideosList().length;
                    if (_localServices.getIndexOfVideo() < (totalVideos - 1))
                      _localServices.setIndexOfVideo(
                          _localServices.getIndexOfVideo() + 1);
                    else
                      _localServices.setIndexOfVideo(0);
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.landscapeLeft]).then((_) {
                      _navigationService.navigateToReplacement(
                          routes.HazardPerceptionTestRoute);
                    });
                  }),
              Container(
                  alignment: Alignment.topCenter,
                  // decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: AssetImage("assets/star.gif"),
                  //         fit: BoxFit.fill)),
                  padding: EdgeInsets.only(top: Responsive.height(5, context)),
                  height: Responsive.height(85, context),
                  width: Responsive.width(100, context),
                  margin: EdgeInsets.fromLTRB(
                      0, Responsive.height(23, context), 0, 0),
                  child: Column(
                    children: [
                      if (!testComplete)
                        Text(
                          "Do not tap if there is no hazard visible or tap in pattern!",
                          style: labelStyle(),
                        ),
                      if (!testComplete)
                        Container(
                          width: Responsive.width(50, context),
                          transform: Matrix4.translationValues(
                              0, Responsive.height(10, context), 0),
                          child: Image(
                            image: AssetImage('assets/exclamation-mark.png'),
                            width: Responsive.width(90, context),
                            height: Responsive.height(40, context),
                          ),
                        ),
                      if (testComplete)
                        Text(
                          resultMessage,
                          style: labelStyle(),
                        ),

                      // GifImage(
                      //   width: Responsive.width(25, context),
                      //   height: Responsive.height(30, context),
                      //   controller: gifControl,
                      //   image: AssetImage("assets/test_result_D.gif"),
                      // ),
                      if (testComplete)
                        Container(
                            width: Responsive.width(30, context),
                            height: Responsive.height(30, context),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                                top: Responsive.height(7, context)),
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(width: 10, color: Dark)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  transform:
                                      Matrix4.translationValues(0, -10, 0),
                                  child: Text(gainedRating.toString(),
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),
                                ),
                                SizedBox(width: 2),
                                Text("/", style: TextStyle(fontSize: 50)),
                                SizedBox(width: 2),
                                Container(
                                  transform:
                                      Matrix4.translationValues(0, 10, 0),
                                  child: Text(totalRatting.toString(),
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),
                                ),
                              ],
                            )),
                      Container(
                        height: Responsive.height(20, context),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                SystemChrome.setPreferredOrientations(
                                        [DeviceOrientation.landscapeLeft])
                                    .then((_) {
                                  _navigationService.navigateToReplacement(
                                      routes.HazardPerceptionTestRoute);
                                });
                              },
                              style: buttonStyle(),
                              child: Text(
                                'RETRY CLIP',
                                style: textStyle(),
                              ),
                            ),
                            SizedBox(width: 20),
                            if (testComplete)
                              ElevatedButton(
                                onPressed: () {
                                  SystemChrome.setPreferredOrientations(
                                          [DeviceOrientation.landscapeLeft])
                                      .then((_) {
                                    Future.delayed(Duration(milliseconds: 300),
                                        () {
                                      _navigationService.navigateTo(routes
                                          .HazardPerceptionTestReplayRoute);
                                    });
                                  });
                                },
                                style: buttonStyle(),
                                child: Text(
                                  'WATCH REPLAY',
                                  style: textStyle(),
                                ),
                              ),
                            SizedBox(width: Responsive.width(3, context)),
                            ElevatedButton(
                              onPressed: () {
                                SystemChrome.setPreferredOrientations(
                                        [DeviceOrientation.landscapeLeft])
                                    .then((_) {
                                  _localServices.getRevVideosList();
                                  _navigationService.navigateTo(
                                      routes.HazardPerceptionTestReplayRoute);
                                  // _navigationService.navigateTo(
                                  //     routes.HazardPerceptionTestRoute);
                                });
                                // SystemChrome.setPreferredOrientations(
                                //         [DeviceOrientation.landscapeLeft])
                                //     .then((_) {
                                //   _localServices.setIndexOfVideo(0);
                                //   _navigationService.navigateTo(
                                //       routes.HazardPerceptionVideosListRoute);
                                // });
                              },
                              style: buttonStyle(),
                              child: Text(
                                'SEE CORRECT ANSWER',
                                style: textStyle(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // TweenAnimationBuilder(
                      //     tween: Tween(begin: 0.0, end: 1.0),
                      //     duration: Duration(seconds: 4),
                      //     builder: (context, value, child) {
                      //       // percentage to show in Center Text
                      //       int percentage = (value * 100).ceil();
                      //       return Container(
                      //         width: Responsive.width(25, context),
                      //         height: Responsive.height(25, context),
                      //         child: Stack(
                      //           children: [
                      //             ShaderMask(
                      //               shaderCallback: (rect) {
                      //                 return SweepGradient(
                      //                     startAngle: 0.0,
                      //                     endAngle: TWO_PI,
                      //                     stops: [value, value], // value from Tween Animation Builder
                      //                     // 0.0 , 0.5 , 0.5 , 1.0
                      //                     center: Alignment.center,
                      //                     colors: [Colors.blue, Colors.transparent])
                      //                     .createShader(rect);
                      //               },
                      //               child: Container(
                      //                 width: Responsive.width(25, context),
                      //                 height: Responsive.height(25, context),
                      //                 decoration: BoxDecoration(
                      //                     shape: BoxShape.circle, color: Colors.white),
                      //               ),
                      //             ),
                      //             Center(
                      //               child: Container(
                      //                 width: Responsive.width(20, context),
                      //                 height:  Responsive.height(20, context),
                      //                 decoration: BoxDecoration(
                      //                     color: Colors.white, shape: BoxShape.circle),
                      //                 child: Center(
                      //                     child: Text(
                      //                       "$percentage",
                      //                       style: TextStyle(
                      //                           fontSize: 25,
                      //                           color: Colors.blue,
                      //                           fontWeight: FontWeight.bold),
                      //                     )),
                      //               ),
                      //             )
                      //           ],
                      //         ),
                      //       );
                      //     })
                    ],
                  )),
            ])));
  }

  TextStyle labelStyle() {
    return AppTextStyle.titleStyle;
  }

  ButtonStyle buttonStyle() {
    return ButtonStyle(
      padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>((states) {
        return EdgeInsets.symmetric(vertical: 15, horizontal: 20);
      }),
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        return Colors.white;
      }),
      textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
        return TextStyle(fontSize: 14, color: Colors.black);
      }),
      minimumSize: MaterialStateProperty.resolveWith<Size>((states) {
        return Size(Responsive.width(25, context), 25);
      }),
    );
  }

  TextStyle textStyle() {
    return AppTextStyle.textStyle.copyWith(fontWeight: FontWeight.w500);
  }
}
