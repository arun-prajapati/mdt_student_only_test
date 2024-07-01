import 'dart:io';

import 'package:Smart_Theory_Test/Constants/app_colors.dart';
import 'package:Smart_Theory_Test/services/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/card.dart' as MCard;

// import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Smart_Theory_Test/routing/route_names.dart' as routes;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../locater.dart';
import '../../../responsive/percentage_mediaquery.dart';
import '../../../services/local_services.dart';
import '../../../services/navigation_service.dart';
import '../../../utils/app_colors.dart';
import '../../../widget/CustomAppBar.dart';
import '../../../widget/CustomSpinner.dart';

class HazardPerceptionOptions extends StatefulWidget {
  HazardPerceptionOptions({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HazardPerceptionOptions();
}

class _HazardPerceptionOptions extends State<HazardPerceptionOptions>
    with TickerProviderStateMixin {
  final NavigationService _navigationService = locator<NavigationService>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  // late GifController controller;
  LocalServices _localServices = LocalServices();
  List<String> videosName = [
    'clip1mdt.mp4',
    'clip2mdt.mp4',
    'clip3mdt.mp4',
    'clip4mdt.mp4',
    'clip5mdt.mp4',
    'clip6mdt.mp4',
    'clip7mdt.mp4',
    'clip8mdt.mp4',
    'clip9mdt.mp4',
    'clip10mdt.mp4',
    'tutorial_2.mp4',
    'tutorial_3.mp4'
  ];
  List<String> RevVideosName = [
    'clip1mdtrev.mp4',
    'clip2mdtrev.mp4',
    'clip3mdtrev.mp4',
    'clip4mdtrev.mp4',
    'clip5mdtrev.mp4',
    'clip6mdtrev.mp4',
    'clip7mdtrev.mp4',
    'clip8mdtrev.mp4',
    'clip9mdtrev.mp4',
    'clip10mdtrev.mp4'
  ];

  void transferVideoToAppDocPath() async {
    try {
      List file = [];
      String directory = (await getApplicationDocumentsDirectory()).path;
      file = Directory("$directory").listSync();
      List<String> tutorialVideoPaths = [];
      List<String> paths = [];
      List<String> rev_paths = [];
      if (mounted)
        CustomSpinner.showLoadingDialog(context, _keyLoader, "Loading...");
      if (_localServices.getVideosList().length == 0) {
        await Future.forEach(videosName, (String assetFileName) async {
          ByteData bData;
          bData = await rootBundle.load('assets/hazardVideos/' + assetFileName);
          String filePath = "$directory/" + assetFileName;
          File savePath = await writeToFile(bData, filePath);
          if ((filePath).indexOf("mdt.mp4") >= 0) paths.add(filePath);
          if ((filePath).indexOf("tutorial_") >= 0)
            tutorialVideoPaths.add(filePath);
        }).then((value) async {
          _localServices.setVideosList(paths);
          _localServices.setTutorialVideosList(tutorialVideoPaths);
          if (_localServices.getRevVideosList().length == 0) {
            await Future.forEach(RevVideosName, (String assetFileName) async {
              ByteData bData;
              bData =
                  await rootBundle.load('assets/hazardVideos/' + assetFileName);
              String filePath = "$directory/" + assetFileName;
              File savePath = await writeToFile(bData, filePath);
              rev_paths.add(filePath);
            }).then((value) {
              _localServices.setRevVideosList(rev_paths);
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
            }).catchError((onError) {
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
            });
          } else {
            file.forEach((element) {
              if ((element.path).indexOf("mdtrev.mp4") >= 0)
                rev_paths.add(element.path);
            });
            _localServices.setRevVideosList(rev_paths);
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          }
        }).catchError((onError) {
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        });
      } else {
        file.forEach((element) {
          if ((element.path).indexOf("tutorial_") >= 0)
            tutorialVideoPaths.add(element.path);
          if ((element.path).indexOf("mdt.mp4") >= 0) paths.add(element.path);
          if ((element.path).indexOf("mdtrev.mp4") >= 0)
            rev_paths.add(element.path);
        });
        _localServices.setTutorialVideosList(tutorialVideoPaths);
        _localServices.setVideosList(paths);
        _localServices.setRevVideosList(rev_paths);
        print("tutorialVideoPaths....>");
        print(tutorialVideoPaths);
        print("paths...>");
        print(paths);
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }

  Future<File> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  getData() async {
    var sharedPref = await SharedPreferences.getInstance();
    var data = sharedPref.getBool('showHazardDialog');
    if (data == null) {
      showMessageDialog();
    }
    await context.read<UserProvider>().getUserData(context);
  }

  @override
  void initState() {
    super.initState();
    // controller = new GifController(vsync: this);
    Future.delayed(Duration(milliseconds: 500), () {
      if (_localServices.getVideosList().length == 0) {
        transferVideoToAppDocPath();
      }
      getData();
      // animationStart();
    });
  }

  // void animationStart() {
  //   controller.value = 0;
  //   controller.animateTo(15,
  //       duration: Duration(milliseconds: 100), curve: Curves.linear);
  //   controller.repeat(
  //       min: 0, max: 15, reverse: false, period: Duration(milliseconds: 3000));
  // }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFe1e1e1),
        body: Stack(children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomAppBar(
                preferedHeight: Responsive.height(12, context),
                title: 'Practice Hazard Perception',
                textWidth: Responsive.width(45, context),
                iconLeft: Icons.arrow_back,
                onTap1: () {
                  _navigationService.goBack();
                },
                iconRight: null),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.12,
            child: Container(
              height: Responsive.height(82, context),
              width: Responsive.width(100, context),
              // margin:
              //     EdgeInsets.fromLTRB(0, Responsive.height(18, context), 0, 0),
              // padding: EdgeInsets.only(bottom: Responsive.height(5, context)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Color(0xFFe1e1e1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Spacer(),
                  // Container(
                  //   transform: Matrix4.translationValues(
                  //       0, -Responsive.height(05, context), 0),
                  //   child: Gif(
                  //     width: Responsive.width(40, context),
                  //     height: Responsive.height(30, context),
                  //     // controller: controller,
                  //     image: AssetImage("assets/road-in-fulleye.gif"),
                  //   ),
                  // ),
                  Container(
                    width: Responsive.width(50, context),
                    height: Responsive.height(30, context),
                    // controller: gifControl,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/road-in-fulleye.gif")),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.landscapeLeft]);
                      _navigationService
                          .navigateTo(routes.HazardPerceptionTutorialRoute);
                    },
                    style: buttonStyle(),
                    child: Text(
                      'WATCH TUTORIAL',
                      style: textStyle(),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.landscapeLeft]).then((_) {
                        _navigationService.navigateTo(
                            routes.HazardPerceptionConfirmationRoute);
                      });
                    },
                    style: buttonStyle(),
                    child: Text('START TEST', style: textStyle()),
                  ),
                  // SizedBox(height: 10),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     _navigationService
                  //         .navigateTo(routes.HazardPerceptionVideosListRoute);
                  //   },
                  //   style: buttonStyle(),
                  //   child: Text(
                  //     'HAZARD PERCEPTION VIDEOS',
                  //     style: textStyle(),
                  //   ),
                  // )
                ],
              ),
            ),
          )
        ]));
  }

  showMessageDialog({bool isTheoryTestGuidance = false}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => PopScope(
        canPop: false,
        child: Dialog(
          insetPadding: EdgeInsets.all(20),
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                  begin: Alignment(0.0, -1.0),
                  end: Alignment(0.0, 1.0),
                  colors: [Dark, Light],
                  stops: [0.0, 1.0],
                )),
            child: MCard.Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 0.0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "Good luck with your Hazard Perception Test!",
                            style: AppTextStyle.titleStyle)),
                    Container(
                      //width: constraints.maxWidth,
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Text(
                              "Just so you know, at the end of every video, you will get an opportunity to see the correct answer.",
                              textAlign: TextAlign.justify,
                              style: AppTextStyle.disStyle.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: AppColors.black)),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                                // style: ButtonStyle(
                                //     visualDensity: VisualDensity.comfortable,
                                //     padding: MaterialStateProperty.all(
                                //         EdgeInsets.all(0)),
                                //     overlayColor:
                                //         MaterialStateProperty.all(Colors.blue)),
                                onTap: () async {
                                  Navigator.pop(context);
                                  var sharedPref =
                                      await SharedPreferences.getInstance();
                                  sharedPref.setBool('showHazardDialog', true);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  color: Colors.transparent,
                                  child: Text(
                                    "OK",
                                    style: AppTextStyle.titleStyle
                                        .copyWith(fontSize: 16),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ButtonStyle buttonStyle() {
    return ButtonStyle(
      padding: WidgetStateProperty.resolveWith<EdgeInsetsGeometry>((states) {
        return EdgeInsets.symmetric(vertical: 20, horizontal: 20);
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        return Colors.white;
      }),
      textStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        return TextStyle(fontSize: 14, color: Colors.black);
      }),
      minimumSize: WidgetStateProperty.resolveWith<Size>((states) {
        return Size(Responsive.width(80, context), 40);
      }),
    );
  }

  TextStyle textStyle() {
    return AppTextStyle.textStyle.copyWith(fontWeight: FontWeight.w500);
  }
}
