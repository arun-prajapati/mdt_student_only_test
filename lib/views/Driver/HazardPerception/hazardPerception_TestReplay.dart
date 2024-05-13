import 'dart:async';

import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../Constants/hazard_perception_data.dart';
import '../../../locater.dart';
import '../../../responsive/percentage_mediaquery.dart';
import '../../../services/local_services.dart';
import '../../../services/navigation_service.dart';

const double progressBarLength = 86; //fixed value

class HazardPerceptionTestReplay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HazardPerceptionTestReplay();
}

class _HazardPerceptionTestReplay extends State<HazardPerceptionTestReplay>
    with WidgetsBindingObserver {
  final NavigationService _navigationService = locator<NavigationService>();
  late BetterPlayerController _betterPlayerController;
  LocalServices _localServices = LocalServices();
  late FToast fToast;

  List<String> videoPaths = [];
  int videoIndex = 0;
  double cursorPosition = -43;
  late Timer cursor;
  int totalTerms = 0;
  double frameWidth = 0;
  int passedTime = 0; //in milliseconds
  int videoDurationInSeconds = 0;
  bool isVideoPlaying = true;
  late BuildContext pageContext;

  List<Map<String, double>> warningSlot = [];
  List<Map<String, double>> clickDurationSlot = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState _applicationState) {
    print("_applicationState..." + _applicationState.toString());
    if (_applicationState == AppLifecycleState.paused ||
        _applicationState == AppLifecycleState.detached) {
      if (_betterPlayerController.isPlaying()!) playToggle();
    }
  }

  @override
  void initState() {
    videoPaths = _localServices.getRevVideosList();
    videoIndex = _localServices.getIndexOfVideo();
    videoDurationInSeconds = _localServices.getVideoDuration();
    String videoName = (videoPaths[videoIndex]).substring(
        videoPaths[videoIndex].lastIndexOf('/') + 1,
        videoPaths[videoIndex].lastIndexOf('rev.'));

    videosTimeSlot[videoName]!.forEach((timeSlot) {
      Map<String, double> warningSlot_ = {
        'start': (timeSlot['start'])!.toDouble(),
        'end': timeSlot['end']!.toDouble(),
        'width': 0.0,
        'width_start': 0.0,
        'warning_showing': 0
      };
      this.warningSlot.add(warningSlot_);
    });
    List<int> selectedFlags = _localServices.getSelectedFlagsList();
    selectedFlags.forEach((flagMilliseconds) {
      clickDurationSlot
          .add({'micro_time': flagMilliseconds.toDouble(), 'width_start': 0.0});
    });
    print('HazardPerceptionTestResultRoute $selectedFlags');
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fToast = FToast();
    fToast.init(context);

    totalTerms = videoDurationInSeconds * 50; //50 terms in one second
    frameWidth = progressBarLength /
        totalTerms; //one slot width in total width of progressBar
    passedTime = 0;
    for (int i = 0; i < warningSlot.length; i++) {
      double width =
          (((warningSlot[i]['end']! - warningSlot[i]['start']!)) * 0.050) *
              frameWidth;
      double widthStart =
          ((((warningSlot[i]['end'])! * 0.050) * frameWidth) - (width / 2)) +
              cursorPosition;
      setState(() {
        warningSlot[i]['width'] = width;
        warningSlot[i]['width_start'] = widthStart;
      });
    }
    double slotWithOneMicorSecond =
        progressBarLength / (videoDurationInSeconds * 1000);
    for (int i = 0; i < clickDurationSlot.length; i++) {
      double widthStart =
          (clickDurationSlot[i]['micro_time']! * slotWithOneMicorSecond) +
              cursorPosition;
      setState(() {
        clickDurationSlot[i]['width_start'] = widthStart;
      });
    }
    startCursor();
    initializeVideoPlayer(videoPaths[videoIndex]);
  }

  initializeVideoPlayer(String videoPath) {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.file,
      videoPath,
    );
    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          eventListener: getVideoEvent,
          autoPlay: true,
          fit: BoxFit.fill,
          startAt: Duration(minutes: 0, seconds: 00),
          fullScreenAspectRatio: 1.1,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enableAudioTracks: false,
            enableMute: false,
            enablePlayPause: false,
            enableQualities: false,
            enableFullscreen: false,
            enableSkips: false,
            showControlsOnInitialize: true,
            controlBarColor: Colors.black54,
            controlBarHeight: 70,
            playerTheme: BetterPlayerTheme.custom,
            // customControlsBuilder: (BetterPlayerController controller){
            //   return
            // },
          ),
          placeholder:
              Icon(Icons.arrow_circle_down, size: 70, color: Colors.white),
          // Image.asset("assets/spinner.gif",width: 100,height: 100)
        ),
        betterPlayerDataSource: betterPlayerDataSource);
    _betterPlayerController.play();
  }

  startCursor() {
    try {
      cursor = Timer.periodic(Duration(milliseconds: 20), (timer) {
        if (passedTime < videoDurationInSeconds * 1000) {
          setState(() {
            passedTime = passedTime + 20;
            cursorPosition = cursorPosition + frameWidth;
          });
          if (passedTime >= warningSlot[0]['start']! &&
              passedTime <= warningSlot[0]['end']! &&
              warningSlot[0]['warning_showing'] == 0) {
            setState(() {
              warningSlot[0]['warning_showing'] = 1;
            });
            hazardAreaIndicator(pageContext);
          }
          if (passedTime < warningSlot[0]['start']! ||
              passedTime > warningSlot[0]['end']!) {
            setState(() {
              warningSlot[0]['warning_showing'] = 0;
            });
          }
        } else {
          timer.cancel();
        }
      });
    } catch (e) {}
  }

  moveVideo() {}

  getVideoEvent(BetterPlayerEvent event) {
    if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
      _navigationService.goBack();
    }
  }

  playToggle() {
    print('PAlying ==========');
    try {
      if (_betterPlayerController.isPlaying()!) {
        _betterPlayerController.pause();
        cursor.cancel();
      } else {
        _betterPlayerController.play();
        startCursor();
      }
      setState(() {
        isVideoPlaying = !isVideoPlaying;
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    try {
      WidgetsBinding.instance.removeObserver(this);
      cursor.cancel();
      _betterPlayerController.dispose();
    } catch (e) {
    } finally {
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    pageContext = context;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Container(
          height: Responsive.height(100, context),
          width: Responsive.width(100, context),
          alignment: Alignment.center,
          child: Stack(alignment: Alignment.center, children: [
            Container(
              width: Responsive.width(85, context),
              height: Responsive.height(100, context),
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: playToggle,
                child: BetterPlayer(
                  controller: _betterPlayerController,
                ),
              ),
            ),
            if (!isVideoPlaying)
              Container(
                // transform: Matrix4.translationValues(-20, -20, 0),
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(Icons.pause_circle_outline,
                      size: 80, color: Colors.white70),
                  onPressed: () {},
                ),
              ),

            // child: Container(
            // transform: Matrix4.translationValues(
            //     -(Responsive.width(46, context)),
            //     -(Responsive.height(34, context)),
            //     0),

            ///------------------------------
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.cancel, size: 35, color: Colors.red),
                      onPressed: () {
                        print("Cancel Video");

                        // Navigator.pop(context);
                        _navigationService.goBack();
                      },
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.help, size: 35, color: Colors.white),
                      onPressed: () {
                        _betterPlayerController.pause();
                        cursor.cancel();
                        helpScreen(context);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Align(
            //   //alignment: Alignment.bottomCenter,
            //   child: Container(
            //       height: 60,
            //       width: Responsive.width(95, context),
            //       alignment: Alignment.center,
            //       color: Color.fromRGBO(191, 190, 188, .6),
            //       transform: Matrix4.translationValues(
            //           0, Responsive.height(42, context), 0),
            //       child: Container(
            //         height: 10,
            //         width: Responsive.width(progressBarLength, context),
            //         decoration: new BoxDecoration(
            //             color: Colors.white,
            //             shape: BoxShape.rectangle,
            //             borderRadius: BorderRadius.all(Radius.circular(10)),
            //             border: Border.all(width: 5, color: Colors.white)),
            //       )),
            // ),
            // ...warningSlot
            //     .map((slot) => GestureDetector(
            //           onTap: () {
            //             print('${slot['width']}.............');
            //           },
            //           child: Align(
            //             //  alignment: Alignment.bottomCenter,
            //             child: Container(
            //               transform:
            //                   Matrix4.translationValues(double.infinity, 42, 0),
            //               width: 100,
            //               height: 10,
            //               decoration: new BoxDecoration(
            //                   color: Colors.red,
            //                   shape: BoxShape.rectangle,
            //                   border: Border.all(width: 5, color: Colors.red)),
            //             ),
            //           ),
            //         ))
            //     .toList(),
            // ...clickDurationSlot
            //     .map((flag) => Container(
            //         transform: Matrix4.translationValues(
            //             Responsive.width(flag['width_start']!, context),
            //             Responsive.height(38, context),
            //             0),
            //         child: Icon(Icons.flag, size: 27, color: Colors.red)))
            //     .toList(),
            GestureDetector(
              onTap: moveVideo,
              child: Container(
                  transform: Matrix4.translationValues(
                      (Responsive.width(cursorPosition, context)),
                      Responsive.height(42, context),
                      0),
                  width: 8,
                  height: 32,
                  decoration: new BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      border: Border.all(width: 5, color: Colors.black))),
            ),
          ]),
        ));
  }

  Future<void> helpScreen(BuildContext parent_context) async {
    return showDialog<void>(
        context: parent_context,
        barrierDismissible: true,
        barrierColor: Colors.black45,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: Responsive.width(0, parent_context),
                      right: Responsive.width(0, parent_context)),
                  child: Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      insetPadding: EdgeInsets.only(
                          left: Responsive.width(0, parent_context),
                          right: Responsive.width(0, parent_context)),
                      //this right here
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            height: Responsive.height(100, parent_context),
                            width: Responsive.width(100, parent_context),
                            child: Image(
                                image: AssetImage(
                                    'assets/understanding-screen.png'),
                                fit: BoxFit.fill),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            // transform: Matrix4.translationValues(
                            //     -Responsive.width(40, context),
                            //     -Responsive.height(35, context),
                            //     0),
                            child: IconButton(
                              icon: const Icon(Icons.cancel,
                                  size: 35, color: Colors.red),
                              onPressed: () {
                                _betterPlayerController.play();
                                startCursor();
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ))));
        });
  }

  Future<void>? hazardAreaIndicator(BuildContext parent_context) {
    fToast.showToast(
        child: Container(
            padding: EdgeInsets.only(
                left: Responsive.width(0, parent_context),
                right: Responsive.width(0, parent_context)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(1)),
                color: Color.fromRGBO(191, 190, 188, .4)),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  height: Responsive.height(20, parent_context),
                  width: Responsive.width(95, parent_context),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    left: Responsive.width(1, parent_context),
                    top: Responsive.height(2, parent_context),
                    right: Responsive.width(10, parent_context),
                    bottom: Responsive.height(2, parent_context),
                  ),
                  color: Color.fromRGBO(191, 190, 188, .6),
                  child: Text(
                      "A learner driver is at the intersection ahead. Take extra care as they may be inexperienced and need special consideration. You will need to stop."),
                ),
                Container(
                  transform: Matrix4.translationValues(
                      Responsive.width(40, context),
                      Responsive.height(0, context),
                      0),
                  child: IconButton(
                    icon: const Icon(Icons.warning_amber_sharp,
                        size: 35, color: Colors.redAccent),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            )),
        toastDuration: Duration(seconds: 5),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            top: Responsive.width(32, context),
            left: Responsive.width(2.5, context),
          );
        });
  }
}
