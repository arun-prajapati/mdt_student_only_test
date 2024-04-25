import 'dart:async';
import 'dart:developer';
import 'dart:io';

// import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:Smart_Theory_Test/routing/route_names.dart' as routes;
import 'package:video_player/video_player.dart';

import '../../../Constants/hazard_perception_data.dart';
import '../../../locater.dart';
import '../../../responsive/percentage_mediaquery.dart';
import '../../../services/local_services.dart';
import '../../../services/navigation_service.dart';

class HazardPerceptionTest extends StatefulWidget {
  HazardPerceptionTest({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HazardPerceptionTest();
}

class _HazardPerceptionTest extends State<HazardPerceptionTest> {
  final NavigationService _navigationService = locator<NavigationService>();
  LocalServices _localServices = LocalServices();
  late VideoPlayerController _betterPlayerController;
  List<String> videoPaths = [];
  int videoIndex = 0;
  int videoStartTime = 0;
  int videoEndTime = 0;
  List<int> flagList = [];
  bool isContinueTaped = false;
  bool isPause = false;
  bool _onTouch = false;

  Timer? _timer;

  List<Map<String, int>> clickDurationSlot = [];

  static int currentTimeInSeconds() {
    var ms = (new DateTime.now()).millisecondsSinceEpoch;
    return (ms / 1000).round();
  }

  static int currentTimeInMilliseconds() {
    var ms = (new DateTime.now()).millisecondsSinceEpoch;
    return ms;
  }

  static int getSecondsFromMilliseconds(int milliseconds) {
    var ms = Duration(milliseconds: milliseconds);
    return ms.inSeconds;
  }

  static int getMillisecondsFromSeconds(int seconds) {
    var ms = Duration(seconds: seconds);
    return ms.inMilliseconds;
  }

  void tapEvent() {
    print('TAPPPPPPP');
    _onTouch = true;
    setState(() {});
    Future.delayed(const Duration(seconds: 5), () {
      if (this.mounted) {
        setState(() {
          _onTouch = false;
        });
      }
    });

    if (!isContinueTaped) {
      setState(() {
        flagList.add(currentTimeInMilliseconds());
      });
      checkTapDurationDifference();
    }
  }

  checkTapDurationDifference() {
    int totalSlotJet = flagList.length;
    if (totalSlotJet > 5) {
      int secondDifference = 0;
      for (int slot = totalSlotJet - 1; slot > (totalSlotJet - 6); slot--) {
        secondDifference += (getSecondsFromMilliseconds(flagList[slot]) -
            getSecondsFromMilliseconds(flagList[slot - 1]));
      }
      if (secondDifference < 3) {
        setState(() {
          isContinueTaped = true;
          _betterPlayerController.pause().then((value) {
            Map params = {'pattern_out': true};
            print('99999999 $params');
            _navigationService.navigateToReplacement(
                routes.HazardPerceptionTestResultRoute,
                arguments: params);
          });
        });
      }
    }
  }

  // getVideoEvent(BetterPlayerEvent event) {
  //   if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
  //     videoEndTime = currentTimeInSeconds();
  //     List<int> flagList_ = [];
  //     flagList.forEach((int clickTime) {
  //       int milliseconds =
  //           clickTime - getMillisecondsFromSeconds(videoStartTime);
  //       flagList_.add(milliseconds);
  //     });
  //     int rightClick = 0;
  //
  //     clickDurationSlot.forEach((giveSlot) {
  //       bool isAnyClickRight = false;
  //       giveSlot as dynamic;
  //       flagList_.forEach((flag) {
  //         //flag position in milliseconds
  //         //if (getSecondsFromMilliseconds(flag) >= giveSlot['start'] && getSecondsFromMilliseconds(flag) <= giveSlot['end'] && !isAnyClickRight) {
  //         if (flag >= giveSlot['start']! &&
  //             flag <= giveSlot['end']! &&
  //             !isAnyClickRight) {
  //           isAnyClickRight = true;
  //           rightClick += 1;
  //         }
  //       });
  //     });
  //     Map params = {'pattern_out': false, 'rightClick': rightClick};
  //     _localServices.setSelectedFlagsList(flagList_);
  //     _localServices.setVideoDuration((videoEndTime - videoStartTime));
  //     _navigationService.navigateToReplacement(
  //         routes.HazardPerceptionTestResultRoute,
  //         arguments: params);
  //   }
  //   if (event.betterPlayerEventType == BetterPlayerEventType.play &&
  //       videoStartTime <= 0) {
  //     setState(() {
  //       videoStartTime = currentTimeInSeconds();
  //     });
  //   }
  // }

  @override
  void initState() {
    videoPaths = _localServices.getVideosList();
    videoIndex = _localServices.getIndexOfVideo();
    String videoName = (videoPaths[videoIndex]).substring(
        videoPaths[videoIndex].lastIndexOf('/') + 1,
        videoPaths[videoIndex].lastIndexOf('.'));
    videosTimeSlot[videoName]!.forEach((timeSlot) {
      this.clickDurationSlot.add(timeSlot);
    });
    super.initState();
    initializeVideoPlayer(videoPaths[videoIndex]);
    log("video path ${videoPaths[videoIndex]}");
  }

  initializeVideoPlayer(String videoPath) {
    _betterPlayerController = VideoPlayerController.file(File(videoPath))
      ..initialize().then((_) {
        setState(() {}); // Ensure the widget rebuilds with the video loaded
        _betterPlayerController.play();
      }).catchError((e) {
        print('--------------------- $e');
      });
    // BetterPlayerDataSource betterPlayerDataSource =
    //     BetterPlayerDataSource(BetterPlayerDataSourceType.file, videoPath);
    // _betterPlayerController = BetterPlayerController(
    //     BetterPlayerConfiguration(
    //       // eventListener: getVideoEvent,
    //       autoPlay: true,
    //       fit: BoxFit.fill,
    //       startAt: Duration(minutes: 0, seconds: 00),
    //       fullScreenAspectRatio: 1.1,
    //       controlsConfiguration: BetterPlayerControlsConfiguration(
    //         showControls: false,
    //       ),
    //       placeholder:
    //           Icon(Icons.arrow_circle_down, size: 70, color: Colors.white),
    //       // Image.asset("assets/spinner.gif",width: 100,height: 100)
    //     ),
    //     betterPlayerDataSource: betterPlayerDataSource);
    isPause = true;
    setState(() {});
    _betterPlayerController.play();
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        // ActionChip(
        // padding: EdgeInsets.all(0),
        // visualDensity: VisualDensity.comfortable,
        // labelPadding: EdgeInsets.all(0),
        // onPressed: () {
        //   tapEvent();
        // },
        // label:
        Scaffold(
            resizeToAvoidBottomInset: false,
            // appBar: AppBar(
            //   elevation: 0,backgroundColor: Colors.transparent,
            // ),
            backgroundColor: Colors.black,
            body: Stack(alignment: Alignment.center, children: <Widget>[
              if (_betterPlayerController != null)
                // ActionChip(
                //   padding: EdgeInsets.all(0),
                //   visualDensity: VisualDensity.comfortable,
                //   labelPadding: EdgeInsets.all(0),
                //   onPressed: () {
                //     tapEvent();
                //   },
                //   label:
                GestureDetector(
                  onTap: () {
                    tapEvent();
                  },
                  child: Container(
                    // width: Responsive.width(85, context),
                    // height: Responsive.height(100, context),
                    alignment: Alignment.center,
                    child: VideoPlayer(_betterPlayerController),
                  ),
                ),
              // ),
              Positioned(
                // bottom: 100,
                child: Container(
                    // transform: Matrix4.translationValues(Responsive.width(2, context),
                    //     Responsive.height(42, context), 0),
                    child: Visibility(
                  visible: _onTouch,
                  child: IconButton(
                    icon: isPause ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                    iconSize: 35,
                    color: Colors.white,
                    onPressed: () {
                      isPause = !isPause;
                      setState(() {});
                      if (isPause) {
                        _betterPlayerController.play();
                      } else {
                        _betterPlayerController.pause();
                      }
                      // print('${_betterPlayerController.videoPlayerController.videoEventStreamController.}');
                    },
                  ),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      _navigationService.goBack();
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
              ),
              Container(
                  transform: Matrix4.translationValues(
                      Responsive.width(2, context),
                      Responsive.height(42, context),
                      0),
                  child: Row(
                    children: flagList
                        .map((e) =>
                            Icon(Icons.flag, size: 27, color: Colors.red))
                        .toList(),
                  )),
            ]));
    // );
  }
}
