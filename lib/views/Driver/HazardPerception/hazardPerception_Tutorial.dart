import 'dart:async';

import 'package:better_player_plus/better_player_plus.dart';

// import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gif/gif.dart';
import 'package:student_app/routing/route_names.dart' as routes;

import '../../../locater.dart';
import '../../../responsive/percentage_mediaquery.dart';
import '../../../services/local_services.dart';
import '../../../services/navigation_service.dart';
import '../../../widget/CustomAppBar.dart';

class HazardPerceptionTutorial extends StatefulWidget {
  HazardPerceptionTutorial({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HazardPerceptionTutorial();
}

class _HazardPerceptionTutorial extends State<HazardPerceptionTutorial>
    with TickerProviderStateMixin {
  final NavigationService _navigationService = locator<NavigationService>();
  final PageController pageViewCtrl = new PageController();

  // List<GifController> gifControls = []..length = 3;
  late GifController controller0, controller1, controller2;
  String secondStepVideo = "", thirdStepVideo = "";

  //GifController secondStepGifControls, thirdStepGifControls;
  List<bool> isAnimationCompleted = [false, false, false];
  late int currentGifAnimationIndex;

  late double currentIndexPage;
  late int pageLength;
  late Timer secondStepTextTimer;
  String secondStepText =
      "Tap as soon as you see a hazard start to develop for max points.";
  late BetterPlayerController? secondStepVideoPlayer, thirdStepVideoPlayer;
  LocalServices _localServices = LocalServices();

  @override
  void initState() {
    controller0 = GifController(vsync: this);
    controller1 = GifController(vsync: this);
    controller2 = GifController(vsync: this);
    currentIndexPage = 0;
    pageLength = 3;

    secondStepVideoPlayer = new BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        looping: true,
        fit: BoxFit.fill,
        startAt: Duration(minutes: 0, seconds: 00),
        fullScreenAspectRatio: 1.3,
        controlsConfiguration: BetterPlayerControlsConfiguration(
            showControls: false, backgroundColor: Colors.white),
      ),
    );
    thirdStepVideoPlayer = new BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        looping: true,
        fit: BoxFit.fill,
        startAt: Duration(minutes: 0, seconds: 00),
        fullScreenAspectRatio: 1.3,
        controlsConfiguration: BetterPlayerControlsConfiguration(
            showControls: false, backgroundColor: Colors.white),
      ),
    );
    initializeFistStepAnimation();
    // initializeSecondStepAnimation();
    // initializeThirdStepAnimation();
    // secondStepGifControls = new GifController(vsync: this);
    // thirdStepGifControls = new GifController(vsync: this);
    List<String> tutorialVideos = _localServices.getTutorialVideosList();
    tutorialVideos.forEach((videoPath) {
      if ((videoPath).indexOf("tutorial_3.mp4") >= 0) {
        secondStepVideo = videoPath;
      }
      if ((videoPath).indexOf("tutorial_2.mp4") >= 0) {
        thirdStepVideo = videoPath;
      }
    });
    super.initState();
  }

  void initializeFistStepAnimation() {
    currentGifAnimationIndex = 0;
    for (int i = 0; i < isAnimationCompleted.length; i++) {
      setState(() {
        isAnimationCompleted[i] = false;
      });
    }
    if (controller0 != null && controller0.isAnimating) controller0.reset();
    if (controller1 != null && controller1.isAnimating) controller1.reset();
    if (controller2 != null && controller2.isAnimating) controller2.reset();
    // controller0 = new GifController(vsync: this);
    // controller1 = new GifController(vsync: this);
    // controller2 = new GifController(vsync: this);
    Future.delayed(Duration(milliseconds: 500), () {
      playGiOfFirstStep(controller0, 5.0, 500);
    });
  }

  void playGiOfFirstStep(
      GifController controller, double animation_time, int period_time) {
    try {
      setState(() {
        isAnimationCompleted[currentGifAnimationIndex] = true;
      });
      controller.value = 0;
      controller.animateTo(animation_time,
          duration: Duration(milliseconds: period_time), curve: Curves.linear);
      controller.addListener(() {
        if (currentIndexPage == 0) detectAnimation(controller);
      });
    } catch (e) {
      print("initializeSecondStepAnimation...");
      print(e);
    }
  }

  detectAnimation(GifController controller) {
    if (currentGifAnimationIndex < 2 && controller.isCompleted) {
      Future.delayed(Duration(milliseconds: 1000), () {
        setState(() {
          currentGifAnimationIndex += 1;
        });
        // playGiOfFirstStep(controller[currentGifAnimationIndex],
        //     currentGifAnimationIndex == 1 ? 19.0 : 16.0, 3000);
      });
    }
    if (currentGifAnimationIndex == 2 && controller.isCompleted) {
      initializeFistStepAnimation();
    }
  }

  void initializeSecondStepAnimation() {
    try {
      // secondStepGifControls = new GifController(vsync: this);
      // secondStepGifControls.value = 0;
      // secondStepGifControls.animateTo(87,
      //     duration: Duration(milliseconds: 8000), curve: Curves.linear);
      // secondStepGifControls.repeat(
      //     min: 0,
      //     max: 87,
      //     reverse: false,
      //     period: Duration(milliseconds: 8000));

      secondStepText =
          "Tap as soon as you see a hazard start to develop for max points.";
      secondStepTextTimer = Timer.periodic(new Duration(seconds: 4), (timer) {
        setState(() {
          if (secondStepText ==
              "Tap do not lose points if you tap and get it wrong.")
            secondStepText =
                "Tap as soon as you see a hazard start to develop for max points.";
          else
            secondStepText =
                "Tap do not lose points if you tap and get it wrong.";
        });
      });

      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          BetterPlayerDataSource betterPlayerDataSource =
              BetterPlayerDataSource(
                  BetterPlayerDataSourceType.file, secondStepVideo);
          secondStepVideoPlayer = BetterPlayerController(
              BetterPlayerConfiguration(
                autoPlay: true,
                looping: true,
                fit: BoxFit.fill,
                startAt: Duration(minutes: 0, seconds: 00),
                fullScreenAspectRatio: 1.3,
                controlsConfiguration: BetterPlayerControlsConfiguration(
                    showControls: false, backgroundColor: Colors.white),
              ),
              betterPlayerDataSource: betterPlayerDataSource);
          secondStepVideoPlayer?.play();
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void initializeThirdStepAnimation() {
    try {
      // thirdStepGifControls = new GifController(vsync: this);
      // thirdStepGifControls.value = 0;
      // thirdStepGifControls.animateTo(72,
      //     duration: Duration(milliseconds: 8000), curve: Curves.linear);
      // thirdStepGifControls.repeat(
      //     min: 0,
      //     max: 72,
      //     reverse: false,
      //     period: Duration(milliseconds: 8000));
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          BetterPlayerDataSource betterPlayerDataSource =
              BetterPlayerDataSource(
                  BetterPlayerDataSourceType.file, thirdStepVideo);
          thirdStepVideoPlayer = BetterPlayerController(
              BetterPlayerConfiguration(
                autoPlay: true,
                looping: true,
                fit: BoxFit.fill,
                startAt: Duration(minutes: 0, seconds: 00),
                fullScreenAspectRatio: 1.3,
                controlsConfiguration: BetterPlayerControlsConfiguration(
                    showControls: false, backgroundColor: Colors.white),
              ),
              betterPlayerDataSource: betterPlayerDataSource);
          thirdStepVideoPlayer?.play();
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    controller0.dispose();
    controller1.dispose();
    controller2.dispose();
    secondStepVideoPlayer?.dispose();
    thirdStepVideoPlayer?.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    try {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          .then((_) {
        _navigationService.goBack();
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: WillPopScope(
            onWillPop: _onBackPressed,
            child: Stack(children: <Widget>[
              CustomAppBar(
                  preferedHeight: Responsive.height(20, context),
                  title: 'How it works',
                  // textWidth: Responsive.width(70, context),
                  iconLeft:
                      currentIndexPage == 0 ? Icons.close : Icons.arrow_back,
                  onTap1: () {
                    if (currentIndexPage == 0)
                      _onBackPressed();
                    else if (currentIndexPage > 0)
                      pageViewCtrl.animateToPage((currentIndexPage).toInt() - 1,
                          duration: Duration(milliseconds: 700),
                          curve: Curves.linear);
                  },
                  // isRightBtn: true,
                  iconRight: Icons.arrow_forward_ios,
                  onTapRightbtn: () {
                    if (currentIndexPage < 2)
                      pageViewCtrl.animateToPage((currentIndexPage).toInt() + 1,
                          duration: Duration(milliseconds: 700),
                          curve: Curves.linear);
                    else
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.landscapeLeft]).then((_) {
                        _navigationService.navigateToReplacement(
                            routes.HazardPerceptionConfirmationRoute);
                      });
                  }),
              Positioned(
                child: Container(
                  height: Responsive.height(85, context),
                  width: Responsive.width(100, context),
                  margin: EdgeInsets.fromLTRB(
                      0, Responsive.height(22, context), 0, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white),
                  child: PageView(
                    controller: pageViewCtrl,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.only(
                              top: Responsive.height(5, context)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: Responsive.width(100, context),
                                height: Responsive.height(5, context),
                                alignment: Alignment.topCenter,
                                child: Text(
                                  "Look for clues that might turn into a hazard and "
                                  "force you to...",
                                  style: labelStyle(),
                                ),
                              ),
                              Container(
                                  width: Responsive.width(100, context),
                                  height: Responsive.height(65, context),
                                  alignment: Alignment.bottomCenter,
                                  padding: EdgeInsets.only(
                                      bottom: Responsive.height(10, context)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Opacity(
                                          opacity: !isAnimationCompleted[0]
                                              ? 0.3
                                              : 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Gif(
                                                width: Responsive.width(
                                                    27, context),
                                                height: Responsive.height(
                                                    30, context),
                                                controller: controller0,
                                                image: AssetImage(
                                                    "assets/stop.gif"),
                                              ),
                                              Text("stop",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black))
                                            ],
                                          )),
                                      Opacity(
                                          opacity: !isAnimationCompleted[1]
                                              ? 0.3
                                              : 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Gif(
                                                width: Responsive.width(
                                                    27, context),
                                                height: Responsive.height(
                                                    30, context),
                                                controller: controller1,
                                                image: AssetImage(
                                                    "assets/slow-down.gif"),
                                              ),
                                              Text("slow down",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black))
                                            ],
                                          )),
                                      Opacity(
                                          opacity: !isAnimationCompleted[2]
                                              ? 0.3
                                              : 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Gif(
                                                width: Responsive.width(
                                                    27, context),
                                                height: Responsive.height(
                                                    30, context),
                                                controller: controller2,
                                                image: AssetImage(
                                                    "assets/change-direction.gif"),
                                              ),
                                              Text("change direction",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black))
                                            ],
                                          ))
                                    ],
                                  ))
                            ],
                          )),
                      Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.only(
                              top: Responsive.height(5, context)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (secondStepVideoPlayer != null)
                                Container(
                                  width: Responsive.width(100, context),
                                  height: Responsive.height(5, context),
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    secondStepText,
                                    style: labelStyle(),
                                  ),
                                ),
                              if (secondStepVideoPlayer != null)
                                Container(
                                  width: Responsive.width(100, context),
                                  height: Responsive.height(65, context),
                                  alignment: Alignment.bottomCenter,
                                  child: BetterPlayer(
                                    controller: secondStepVideoPlayer!,
                                  ),
                                  // GifImage(
                                  //   width: Responsive.width(100, context),
                                  //   height: Responsive.height(57, context),
                                  //   controller: secondStepGifControls,
                                  //   image: AssetImage("assets/hazard-click.gif"),
                                  // ),
                                )
                            ],
                          )),
                      Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.only(
                              top: Responsive.height(5, context)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (thirdStepVideoPlayer != null)
                                Container(
                                  width: Responsive.width(100, context),
                                  height: Responsive.height(5, context),
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "But you will be disqualified if you tap continuously or in a pattern.",
                                    style: labelStyle(),
                                  ),
                                ),
                              if (thirdStepVideoPlayer != null)
                                Container(
                                  width: Responsive.width(100, context),
                                  height: Responsive.height(65, context),
                                  alignment: Alignment.bottomCenter,
                                  transform: Matrix4.translationValues(
                                      0, Responsive.height(3, context), 0),
                                  child: BetterPlayer(
                                    controller: thirdStepVideoPlayer!,
                                  ),
                                  // GifImage(
                                  //   width: Responsive.width(100, context),
                                  //   height: Responsive.height(57, context),
                                  //   controller: thirdStepGifControls,
                                  //   image:
                                  //       AssetImage("assets/hazard-pattern-out.gif"),
                                  // ),
                                )
                            ],
                          )),
                      Container(
                        child: Text(""),
                      )
                    ],
                    onPageChanged: (value) {
                      if (value < 3)
                        setState(() => currentIndexPage = value.toDouble());
                      if (value == 0) {
                        if (this.secondStepVideoPlayer != null) {
                          this.secondStepVideoPlayer?.dispose();
                          this.secondStepVideoPlayer = null;
                        }
                        if (this.thirdStepVideoPlayer != null) {
                          this.thirdStepVideoPlayer?.dispose();
                          this.thirdStepVideoPlayer = null;
                        }
                        if (secondStepTextTimer != null)
                          secondStepTextTimer.cancel();
                        initializeFistStepAnimation();
                      }
                      if (value == 1) {
                        if (this.thirdStepVideoPlayer != null) {
                          this.thirdStepVideoPlayer?.dispose();
                          this.thirdStepVideoPlayer = null;
                        }
                        initializeSecondStepAnimation();
                      }
                      if (value == 2) {
                        if (this.secondStepVideoPlayer != null) {
                          this.secondStepVideoPlayer?.dispose();
                          this.secondStepVideoPlayer = null;
                        }
                        if (secondStepTextTimer != null)
                          secondStepTextTimer.cancel();
                        initializeThirdStepAnimation();
                      }
                      if (value == 3)
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.landscapeLeft]).then((_) {
                          _navigationService.navigateToReplacement(
                              routes.HazardPerceptionConfirmationRoute);
                        });
                    },
                  ),
                ),
              ),
              Container(
                height: Responsive.height(10, context),
                width: Responsive.width(100, context),
                color: Colors.transparent,
                margin: EdgeInsets.fromLTRB(
                    0, Responsive.height(90, context), 0, 0),
                child: new DotsIndicator(
                    dotsCount: pageLength,
                    position: currentIndexPage,
                    decorator: DotsDecorator(
                        activeColor: Color(0xFFed1c24),
                        size: Size(15, 15),
                        activeSize: Size(15, 15),
                        color: Colors.black,
                        spacing: EdgeInsets.symmetric(horizontal: 5))),
              ),
            ])));
  }

  TextStyle labelStyle() {
    return TextStyle(
        fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500);
  }
}
