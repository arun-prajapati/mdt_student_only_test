import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../Constants/app_colors.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/ai_recommendationservice.dart';
import '../../services/auth.dart';
import '../../widget/CustomSpinner.dart';
import '../WebView.dart';

class TestRecommendation extends StatefulWidget {
  const TestRecommendation({Key? key}) : super(key: key);

  @override
  State<TestRecommendation> createState() => _TestRecommendationState();
}

class _TestRecommendationState extends State<TestRecommendation> {
  int? _userId;
  int selected = -1;
  int selected_2 = -1;
  List<Map<String, dynamic>> list = [];
  List testRecommendationData = [];
  final AIRecommondationAPI _aIRecommendationService = AIRecommondationAPI();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      this.initializeApi("Loading...");
    });
    super.initState();
  }

  void showLoader(String message) {
    CustomSpinner.showLoadingDialog(context, _keyLoader, message);
  }

  void closeLoader() {
    try {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    } catch (e) {}
  }

  Future<Map> getUserDetail() async {
    Map response =
        await Provider.of<UserProvider>(context, listen: false).getUserData();
    return response;
  }

  // List<Widget> buildUI(Map<String,dynamic> data){
  //   List<Widget> list = [];
  //
  //   return list;
  // }

  initializeApi(String loaderMessage) {
    checkInternet();
    showLoader(loaderMessage);

    getUserDetail().then((res) async {
      _userId = res['id'];
      _aIRecommendationService.getrecommondedtest(_userId!).then((testData) {
        setState(() {
          testRecommendationData = testData;
        });
        print("Test Recommendation Data : ${testRecommendationData}");
        closeLoader();
      });
    });
  }

  Future<bool> checkInternet() async {
    print("internet check..1.");
    var connectivityResult = await (Connectivity().checkConnectivity());
    print("internet check.2..");
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainer(url, 'AI Recommendation')));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: double.infinity,
      height: Responsive.height(100, context),
      color: Colors.grey[200],
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: testRecommendationData.isEmpty
          ? Center(
              child: Text("No data"),
            )
          : ListView.builder(
              itemCount: testRecommendationData.length,
              itemBuilder: (context, index) {
                List topicName = [];
                Map data = testRecommendationData[index]['recommendation'];
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  //height: constraints.maxHeight * 0.11,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                        blurRadius: 6.0, // soften the shadow
                        spreadRadius: 1.0, //extend the shadow
                        offset: Offset(
                          3.0, // Move to right 10  horizontally
                          0.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  child: ExpansionTile(
                      key: Key(index.toString()),
                      initiallyExpanded: index == selected,
                      maintainState: true,
                      onExpansionChanged: (val) {
                        if (val) {
                          print("yes");

                          print(
                              testRecommendationData[index]['recommendation']);

                          if (testRecommendationData[index]['recommendation'] !=
                              null) {
                            data.forEach((k, v) {
                              topicName.add(k);
                              //print(k);
                            });

                            for (int i = 0; i < data.length; i++) {
                              list.add({
                                'topicName': topicName[i]
                                        .toString()
                                        .substring(0, 1)
                                        .toUpperCase() +
                                    topicName[i].toString().substring(1),
                                'yt_link':
                                    data[topicName[i]]["yt_links"].isEmpty
                                        ? []
                                        : data[topicName[i]]["yt_links"][0],
                                'reading_link':
                                    data[topicName[i]]["reading_links"].isEmpty
                                        ? []
                                        : data[topicName[i]]["reading_links"]
                                            [0],
                              });
                            }
                          }

                          print("Topic Name(List) : $topicName");
                          print("Topic data : $list");
                          setState(() {
                            selected = index;
                          });
                        } else {
                          print("no");
                          list = [];
                          setState(() {
                            selected = -1;
                          });
                        }
                      },
                      childrenPadding: EdgeInsets.only(
                          left: 16, right: 16, bottom: 10, top: 0),
                      title: Text(
                        testRecommendationData[index]['booking_data']
                                ['requested_date'] +
                            ' ' +
                            testRecommendationData[index]['booking_data']
                                ['requested_time'],
                        style: TextStyle(
                            fontSize: 1.8 * SizeConfig.blockSizeVertical,
                            fontWeight: FontWeight.w500,
                            color: Dark),
                      ),
                      children: testRecommendationData[index]
                                  ['recommendation'] ==
                              null
                          ? [
                              Center(
                                child: Text("No recommendations"),
                              )
                            ]
                          : list.map((element) {
                              return ExpansionTile(
                                title: Text(element['topicName']),
                                tilePadding:
                                    EdgeInsets.only(left: 0, right: 16),
                                childrenPadding: EdgeInsets.only(bottom: 10),
                                children: [
                                  element['reading_link'].length == 0
                                      ? Container()
                                      : Container(
                                          alignment: Alignment.topLeft,
                                          child: RichText(
                                            text: TextSpan(
                                                text: "Read AI article",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Dark,
                                                ),
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () =>
                                                      _handleURLButtonPress(
                                                          context,
                                                          element[
                                                              'reading_link'])),
                                          ),
                                        ),
                                  element['yt_link'].length == 0
                                      ? Container()
                                      : Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: YoutubePlayer(
                                            controller: YoutubePlayerController(
                                              params: YoutubePlayerParams(
                                                  mute: false,
                                                  showControls: true,
                                                  showFullscreenButton: false),
                                            )..loadVideo(element["yt_link"][0]),
                                            // width: 250,
                                          ),
                                        )
                                ],
                              );
                            }).toList()),
                );
              },
            ),
    );
  }
}
