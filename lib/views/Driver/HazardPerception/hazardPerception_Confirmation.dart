import 'dart:developer';

import 'package:Smart_Theory_Test/provider/VideoProvider.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:flutter/services.dart';
import 'package:Smart_Theory_Test/routing/route_names.dart' as routes;
import 'package:provider/provider.dart';

import '../../../locater.dart';
import '../../../responsive/percentage_mediaquery.dart';
import '../../../services/local_services.dart';
import '../../../services/navigation_service.dart';
import '../../../utils/app_colors.dart';
import '../../../widget/CustomAppBar.dart';

class HazardPerceptionConfirmation extends StatefulWidget {
  HazardPerceptionConfirmation({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HazardPerceptionConfirmation();
}

class _HazardPerceptionConfirmation extends State<HazardPerceptionConfirmation>
    with TickerProviderStateMixin {
  final NavigationService _navigationService = locator<NavigationService>();
  LocalServices _localServices = LocalServices();

  // late GifController gifControl;

  // late GifController gifControl;

  @override
  void initState() {
    // initializeGifAnimation();
    super.initState();
  }

  void initializeGifAnimation() {
    // gifControl = GifController(vsync: this);
    // gifControl = new GifController(vsync: this);
    //  gifControl.value = 0;
    //  gifControl.animateTo(15,
    //      duration: Duration(milliseconds: 100), curve: Curves.linear);
    //  gifControl.repeat(
    //      min: 0, max: 15, reverse: false, period: Duration(milliseconds: 3000));
  }

  @override
  void dispose() {
    // gifControl.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      _navigationService.goBack();
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final videoIndexProvider =
        Provider.of<VideoIndexProvider>(context, listen: false);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: WillPopScope(
            onWillPop: _onBackPressed,
            child: Stack(children: <Widget>[
              CustomAppBar(
                  preferedHeight: Responsive.height(20, context),
                  title: 'Practice test',
                  textWidth: Responsive.width(70, context),
                  iconLeft: Icons.close,
                  onTap1: () {
                    _onBackPressed();
                  },

                  // isRightBtn: true,
                  // iconRight: Icons.arrow_forward_ios,
                  // hasIcon: true,
                  onTapRightbtn: () {
                    print('===========================');
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.landscapeLeft]).then((_) {
                      videoIndexProvider.setIndexOfVideo(0);
                      _navigationService
                          .navigateTo(routes.HazardPerceptionTestRoute);
                    });
                  }),
              Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: Responsive.height(5, context)),
                  height: Responsive.height(85, context),
                  width: Responsive.width(100, context),
                  margin: EdgeInsets.fromLTRB(
                      0, Responsive.height(23, context), 0, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Text(
                        "Now it's your turn",
                        style: labelStyle(),
                      ),
                      Container(
                        width: Responsive.width(70, context),
                        height: Responsive.height(25, context),
                        // controller: gifControl,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/road-in-eye.gif")),
                        ),
                      ),
                      // Consumer<VideoIndexProvider>(
                      //   builder: (context, valueController, child) =>
                      //    Container(
                      //     height: Responsive.height(27, context),
                      //     child: Row(
                      //       crossAxisAlignment: CrossAxisAlignment.end,
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //        valueController.indexOfVideo > 0 ? ElevatedButton(
                      //           onPressed: () {
                      //                  SystemChrome.setPreferredOrientations(
                      //                     [DeviceOrientation.landscapeLeft])
                      //                 .then((_) {
                      //           int totalVideos = _localServices.getVideosList().length;
                      //           int currentIndex = valueController.indexOfVideo;

                      //             if (currentIndex <= 0 || currentIndex >= totalVideos) {
                      //                 currentIndex = 0;
                      //               } else if (currentIndex > 0) {
                      //                 currentIndex -= 1;
                      //               } else {
                      //                 currentIndex = totalVideos - 1;
                      //               }
                      //               valueController.setIndexOfVideo(currentIndex);
                      //               _navigationService.navigateTo(
                      //                   routes.HazardPerceptionTestRoute);

                      //             });

                      //           },
                      //           style: buttonStyle(),
                      //           child: Text(
                      //             'PREVIOUS',
                      //             style: textStyle(),
                      //           ),
                      //         ) : ElevatedButton(
                      //           onPressed: () {
                      //             SystemChrome.setPreferredOrientations(
                      //                     [DeviceOrientation.landscapeLeft])
                      //                 .then((_) {
                      //               Future.delayed(Duration(milliseconds: 300),
                      //                   () {
                      //                 _navigationService.navigateToReplacement(
                      //                     routes.HazardPerceptionTutorialRoute);
                      //               });
                      //             });
                      //           },
                      //           style: buttonStyle(),
                      //           child: Text(
                      //             'WATCH TUTORIAL',
                      //             style: textStyle(),
                      //           ),
                      //         ),
                      //         SizedBox(width: Responsive.width(3, context)),
                      //         ElevatedButton(
                      //           onPressed: () {
                      //             SystemChrome.setPreferredOrientations(
                      //                     [DeviceOrientation.landscapeLeft])
                      //                 .then((_) {

                      //              int totalVideos =
                      //                   _localServices.getVideosList().length;

                      //               if (valueController.indexOfVideo <
                      //                   (totalVideos - 1))
                      //                 valueController.setIndexOfVideo(
                      //                     valueController.indexOfVideo + 1);
                      //               else
                      //                 valueController.setIndexOfVideo(0);
                      //               _navigationService.navigateTo(
                      //                   routes.HazardPerceptionTestRoute);

                      //             });

                      //           },
                      //           style: buttonStyle(),
                      //           child: Text( valueController.indexOfVideo == 0 ?
                      //             'START TEST' : "NEXT",
                      //             style: textStyle(),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Consumer<VideoIndexProvider>(
                        builder: (context, valueController, child) => Container(
                          height: Responsive.height(27, context),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Previous Button
                              valueController.indexOfVideo > 0
                                  ? ElevatedButton(
                                      onPressed: () {
                                        SystemChrome.setPreferredOrientations([
                                          DeviceOrientation.landscapeLeft
                                        ]).then((_) {
                                          int totalVideos = _localServices
                                              .getVideosList()
                                              .length;

                                          valueController
                                              .previousVideo(totalVideos);
                                          _navigationService.navigateTo(
                                              routes.HazardPerceptionTestRoute);
                                          if (valueController.indexOfVideo ==
                                                  0 &&
                                              valueController.testStarted) {
                                            valueController.startTest(
                                                valueController.testStarted);
                                          }
//////
                                          // valueController
                                          //     .previousVideo(totalVideos);
                                          // _navigationService.navigateTo(
                                          //     routes.HazardPerceptionTestRoute);
                                        });
                                      },
                                      style: buttonStyle(),
                                      child: Text(
                                        'PREVIOUS',
                                        style: textStyle(),
                                      ),
                                    )
                                  : ElevatedButton(
                                      onPressed: () {
                                        SystemChrome.setPreferredOrientations([
                                          DeviceOrientation.landscapeLeft
                                        ]).then((_) {
                                          Future.delayed(
                                              Duration(milliseconds: 300), () {
                                            _navigationService
                                                .navigateToReplacement(routes
                                                    .HazardPerceptionTutorialRoute);
                                          });
                                        });
                                      },
                                      style: buttonStyle(),
                                      child: Text(
                                        'WATCH TUTORIAL',
                                        style: textStyle(),
                                      ),
                                    ),
                              SizedBox(width: Responsive.width(3, context)),
                              // Next Button
                              ElevatedButton(
                                onPressed: () {
                                  SystemChrome.setPreferredOrientations(
                                          [DeviceOrientation.landscapeLeft])
                                      .then((_) {
                                    int totalVideos =
                                        _localServices.getVideosList().length;
                                    if (valueController.indexOfVideo == 0 &&
                                        !valueController.testStarted) {
                                      valueController.startTest(
                                          valueController.testStarted);
                                      _navigationService.navigateTo(
                                          routes.HazardPerceptionTestRoute);
                                    } else {
                                      valueController.nextVideo(totalVideos);
                                      _navigationService.navigateTo(
                                          routes.HazardPerceptionTestRoute);
                                    }
                                  });
                                },
                                style: buttonStyle(),
                                child: Text(
                                  (valueController.indexOfVideo == 0 &&
                                          !valueController.testStarted)
                                      ? 'START TEST'
                                      : 'NEXT',
                                  style: textStyle(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: Responsive.height(5, context),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _localServices.getVideosList().length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Consumer<VideoIndexProvider>(
                              builder: (context, videoIndexProvider, child) {
                                print(videoIndexProvider.indexOfVideo);
                                return Container(
                                  height: 7,
                                  width: 7,
                                  decoration: BoxDecoration(
                                    color:
                                        index == videoIndexProvider.indexOfVideo
                                            ? Colors.green
                                            : Colors.black,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
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
