import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
 
import 'package:Smart_Theory_Test/provider/VideoProvider.dart';
import 'package:flutter/material.dart';
import 'package:Smart_Theory_Test/routing/route_names.dart' as routes;
import 'package:provider/provider.dart';
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
  int rightClick = 0;
  int maxPoints = 0;

  List<Map<String, int>> clickDurationSlot = [];


  void tapEvent() {
    _onTouch = true;
    setState(() {});
    Future.delayed(const Duration(seconds: 5), () {
      if (this.mounted) {
        setState(() {
          _onTouch = false;
        });
      }
    });
    Duration currentPosition = _betterPlayerController.value.position;
    int milliseconds = currentPosition.inMilliseconds;
    if (!isContinueTaped) {
      if (flagList.length < 5) {
        setState(() {
          flagList.add(milliseconds);
        });
      }
      checkTapDurationDifference();
    }
  }

  void checkTapDurationDifference() {
    int totalSlotJet = flagList.length;
    bool isAnyClickRight = false;
     const List<int> points = [5, 4, 3, 2, 1];

    if (totalSlotJet >= 5) {

     for (int i = 0; i < clickDurationSlot.length; i++) {
      var giveSlot = clickDurationSlot[i];
      flagList.forEach((flag) {
        if (flag >= giveSlot['start']! && flag <= giveSlot['end']!) {
          isAnyClickRight = true;
          maxPoints = points[i] > maxPoints ? points[i] : maxPoints;
        }
      });
    }

    rightClick = maxPoints;
      // clickDurationSlot.forEach((giveSlot) {
      //   giveSlot as dynamic;
      //   flagList.forEach((flag) {
      //     if (flag >= giveSlot['start']! &&
      //         flag <= giveSlot['end']!) {
      //       isAnyClickRight = true;
      //       rightClick += 1;
      //     }
      //   });
      // });

      log(jsonEncode(flagList));
      _localServices.setSelectedFlagsList(flagList);
      _localServices.setVideoDuration(_betterPlayerController.value.duration.inSeconds);
      setState(() {
        _betterPlayerController.pause().then((value) {
          var params = {'pattern_out': true, 'flagList': flagList , 'rightClick' : rightClick ,  'isAnyClickRight' : isAnyClickRight};
          _navigationService.navigateToReplacement(
              routes
                  .HazardPerceptionTestResultRoute,
              arguments: params);
        });
      });
    }
  }

  @override
  void initState() {
    final videoIndexProvider =
        Provider.of<VideoIndexProvider>(context, listen: false);

    videoPaths = _localServices.getVideosList();
    videoIndex = videoIndexProvider.indexOfVideo;

    String videoName = (videoPaths[videoIndex]).substring(
        videoPaths[videoIndex].lastIndexOf('/') + 1,
        videoPaths[videoIndex].lastIndexOf('.'));
    videosTimeSlot[videoName]!.forEach((timeSlot) {
      this.clickDurationSlot.add(timeSlot);
    });

    super.initState();
    initializeVideoPlayer(videoPaths[videoIndex]);
    print('Index incremented to:--- ${videoIndexProvider.indexOfVideo}');
  }

  bool _isVideoComplete = false;

  initializeVideoPlayer(String videoPath) {
    _betterPlayerController = VideoPlayerController.file(File(videoPath))
      ..initialize().then((value) {
        setState(() {}); 
        _betterPlayerController.play();
        _betterPlayerController.addListener(() {
          if (_betterPlayerController.value.position >=
              _betterPlayerController.value.duration) {
            setState(() {
              _isVideoComplete = true;
            });
          }
        });
      }).catchError((e) {
        print('--------------------- $e');
      });

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
  void didChangeDependencies() {
    if (_isVideoComplete) {
      _navigationService.goBack();
    }
    print('============ $_isVideoComplete');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Stack(alignment: Alignment.center, children: <Widget>[
          ValueListenableBuilder(
              valueListenable: _betterPlayerController,
              builder: (context, snapshot, _) {

                if (snapshot.position >= snapshot.duration &&
                    snapshot.isInitialized) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Map params = {'pattern_out': true};
                    _navigationService.navigateToReplacement(
                      routes.HazardPerceptionTestResultRoute,
                      arguments: params,
                    );
                  });
                }
                return GestureDetector(
                  onTap: () {
                    tapEvent();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: VideoPlayer(_betterPlayerController),
                  ),
                );
              }),
          Positioned(
            child: Container(
                child: Visibility(
              visible: _onTouch,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black26,
                ),
                child: IconButton(
                  icon: isPause ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: () {
                    isPause = !isPause;
                    setState(() {});
                    if (isPause) {
                      _betterPlayerController.play();
                    } else {
                      _betterPlayerController.pause();
                    }
                  },
                ),
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
                  color: Colors.red,
                  size: 35,
                ),
              ),
            ),
          ),
          Container(
              transform: Matrix4.translationValues(Responsive.width(2, context),
                  Responsive.height(42, context), 0),
              child: Row(
                children: flagList
                    .map((e) => Icon(Icons.flag, size: 27, color: Colors.red))
                    .toList(),
              )),
        ]));
  }
}
