import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Smart_Theory_Test/custom_button.dart';
import 'package:Smart_Theory_Test/datamodels/ai_data_model.dart';
import 'package:Smart_Theory_Test/external.dart';
import 'package:Smart_Theory_Test/services/subsciption_provider.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../Constants/app_colors.dart';
import '../../Constants/global.dart';
import '../../locater.dart';
import '../../responsive/size_config.dart';
import '../../services/ai_recommendationservice.dart';
import '../../services/auth.dart';
import '../../services/navigation_service.dart';
import '../../services/payment_services.dart';
import '../../services/practise_theory_test_services.dart';
import '../../utils/appImages.dart';
import '../../utils/app_colors.dart';
import '../../widget/CustomSpinner.dart';
import '../WebView.dart';

enum DataStatus { Loading, Loaded, Initial }

class TheoryRecommendations extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TheoryRecommendations();
}

class _TheoryRecommendations extends State<TheoryRecommendations> {
  final NavigationService _navigationService = locator<NavigationService>();

  //List<Entry> changingData = List.empty();
  int? _userId;
  final PractiseTheoryTestServices test_api_services =
      new PractiseTheoryTestServices();
  final AIRecommondationAPI _aIRecommondationService = AIRecommondationAPI();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final PaymentService _paymentService = new PaymentService();
  Map? walletDetail = null;
  List<TheoryContentModel> theoryContent = [];
  Map topicData = {};
  bool expandAll = false;
  bool isWatchVideo = false;
  YoutubePlayerController? youtubePlayerController;

  // var controller = YoutubePlayerController(
  //     params: YoutubePlayerParams(
  //         mute: false, showControls: true, showFullscreenButton: false));
  bool _isSelected = false;
  List<bool> readContentTheory = [];

  DataStatus _dataStatus = DataStatus.Initial;

  //
  // DataStatus _w = DataStatus.Initial;

  int selected = 0;

  // bool isExpanded = false;
  int randomIndex = 0;
  String userName = '';

  Map? dataSub;

  @override
  void initState() {
    //changingData = changingData.toList();
    //print(readContentTheory);
    Future.delayed(Duration.zero, () {
      this.initializeApi("Loading...");
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initializeApi(String loaderMessage) {
    checkInternet();

    showLoader(loaderMessage);
    getUserDetail().then((user_id) async {
      // fetch dvsa subscription status from db.
      await getAllRecordsFromApi().then((records_list) {
        walletDetail = records_list['other_data'];
      });
      await getTheoryContent(
              walletDetail!['dvsa_subscription'] <= 0 ? "no" : "yes")
          .then((value) async {
        await fetchUserTheoryProgress(_userId!).then((res) {
          print("Progress fetch : $res");
          setState(() {
            // theoryContent = value["message"];
          });
          if (res["message"].length == 0) {
            for (int i = 0; i < theoryContent.length; i++) {
              readContentTheory.add(false);
            }
            closeLoader();
          } else {
            for (int i = 0; i < theoryContent.length; i++) {
              readContentTheory.add(false);
            }
            for (int j = 0; j < res["message"].length; j++) {
              setState(() {
                readContentTheory[res["message"][j]["topic_id"] - 1] = true;
              });
            }
            closeLoader();
          }
        });
        print("Status : $readContentTheory");
      });
      // await callApiGetRecommendatedTheory().then((data) { //fetch all theory content.
      //   print(dataSub!["hazard awareness theory test"]);
      // });
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

  //Call APi Services
  Future<Map> getUserDetail() async {
    Map response =
        await Provider.of<UserProvider>(context, listen: false).getUserData();
    _userId = response['id'];
    userName = "${response['first_name']} ${response['last_name']}";

    return response;
  }

  //Fetch topics with description
  Future<Map> getTheoryContent(String isFree) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final url = Uri.parse('$api/api/ai_get_theory_content/${isFree}');
    final response = await http.get(url, headers: header);
    print("URL +++++++ $api/api/ai_get_theory_content/${isFree}");
    if (response.statusCode == 200) {
      var parsedData = jsonDecode(response.body);
      if (parsedData['success'] == true) {
        theoryContent.clear();
        List<TheoryContentModel> data = (parsedData["message"] as List)
            .map((e) => TheoryContentModel.fromJson(e))
            .toList();
        theoryContent.addAll(data);
      }
    } else {
      log('ERORRRR ${response.body}');
    }

    return jsonDecode(response.body);
  }

  Future<Map> getTopicAiContent(String topic) async {
    loading(value: true);
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final url = Uri.parse('$api/api/ai_provideAI_data/${topic}');
    print("URL +++++++ TOPIC $url");
    final response = await http.get(url, headers: header);
    print("RESPONSE OF TOPIC ${response.body}");

    if (response.statusCode == 200) {
      loading(value: false);
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      print("RESPONSE OF TOPIC ${response.body}");
      loading(value: false);
      return {};
    }
  }

  Future<Map> updateTopicProgress(String driverId, String topicId) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final url = Uri.parse('$api/api/update/progress');

    Map<String, String> body = {
      'driver_id': driverId,
      'topic_id': topicId,
    };
    final response = await http.post(url, body: body, headers: header);
    print('URL ===== $api/api/update/progress');
    print('RESPONSE ===== ${response.body}');
    return jsonDecode(response.body);
  }

  Future<Map> fetchUserTheoryProgress(int driverId) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final url = Uri.parse('$api/api/fetch/progress/${driverId}');
    //print("URL : $url");
    final response = await http.get(url, headers: header);
    return jsonDecode(response.body);
  }

  Future<void> callApiGetRecommendatedTheory() async {
    // getUserDetail();
    if (_userId != null)
      dataSub = (await _aIRecommondationService.getrecommondedtheory());

    print("Theory Data : ${dataSub!["hazard awareness theory test"]}");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ToastContext().init(context);
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(true);
        return Future.value(true);
      },
      child: Scaffold(
        /* appBar: AppBar(
          //automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'AI Learning',
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.black12),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh_rounded),
              onPressed: () {
                initializeApi("Refreshing...");
              },
            )
          ],
          elevation: 0.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.0, -1.0),
                end: Alignment(0.0, 1.0),
                colors: [Dark, Light],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        ),*/
        backgroundColor: Colors.grey[100],
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.only(
                  //   bottomLeft: Radius.circular(Responsive.height(3.5, context)),
                  //   bottomRight: Radius.circular(Responsive.height(3.5, context)),
                  // ),
                  gradient: LinearGradient(
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    colors: [
                      Color(0xFF79e6c9).withOpacity(0.5),
                      Color(0xFF38b8cd).withOpacity(0.5),
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 55, left: 20, top: 20),
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('tapppppppppppppppp');
                          SystemChrome.setPreferredOrientations(
                              [DeviceOrientation.portraitUp]).then((_) {
                            Navigator.of(context).pop(true);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black12),
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                      SizedBox(width: 15),
                      Text(
                        'AI Learning',
                        style: AppTextStyle.appBarStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 90,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white),
                  //color: Colors.black12,
                  // color: Colors.grey[100],
                  // decoration: BoxDecoration(
                  //   color: Colors.grey[100],
                  //   borderRadius: const BorderRadius.only(
                  //       topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                  // ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.88,
                    // height: Responsive.height(100, context),
                    //padding: EdgeInsets.only(top: 10),
                    //color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 12, right: 10, top: 0, bottom: 12),
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        key: Key('builder ${selected.toString()}'),
                        itemBuilder: (context, index) {
                          print(
                              "data : -----${theoryContent[index].topicName} ------");
                          if (theoryContent.isNotEmpty &&
                              walletDetail != null &&
                              walletDetail!['dvsa_subscription'] <= 0) {
                            return GestureDetector(
                              onTap: () {
                                print(
                                    '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ${theoryContent[index].isFree}');
                                if (theoryContent[index].isFree == "not-free") {
                                  GetPremium(context);
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                //height: constraints.maxHeight * 0.11,
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                decoration: BoxDecoration(
                                  // gradient: LinearGradient(
                                  //     begin: Alignment.topCenter,
                                  //     end: Alignment.bottomCenter,
                                  //     colors: [
                                  // Colors.white,
                                  // AppColors.borderblue.withOpacity(0.1),
                                  // AppColors.borderblue.withOpacity(0.2)
                                  // ]),
                                  color: AppColors.borderblue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color:
                                          AppColors.borderblue.withOpacity(0.5),
                                      width: 1),
                                ),
                                child: Theme(
                                  data: ThemeData(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    enabled: theoryContent[index].isFree ==
                                            "not-free"
                                        ? false
                                        : true,
                                    tilePadding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    key: Key(index.toString()),
                                    initiallyExpanded: index == selected,
                                    maintainState: true,
                                    onExpansionChanged: (val) {
                                      print(
                                          '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ${theoryContent[index].isFree}');
                                      if (theoryContent[index].isFree ==
                                          "not-free") {
                                        GetPremium(context);
                                      } else {
                                        theoryContent[index].isExpand =
                                            !theoryContent[index].isExpand;
                                        setState(() {});
                                        if (val) {
                                          setState(() {
                                            selected = index;
                                            _dataStatus = DataStatus.Initial;
                                            // _w = DataStatus.Initial;
                                            topicData = {};
                                          });
                                        } else {
                                          setState(() {
                                            selected = -1;
                                            _dataStatus = DataStatus.Initial;
                                            // _w = DataStatus.Initial;
                                            topicData = {};
                                          });
                                        }
                                      }
                                    },
                                    trailing: Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppColors.blueGrad7
                                                    .withOpacity(0.3),
                                                AppColors.blueGrad6
                                                    .withOpacity(0.2),
                                                AppColors.blueGrad5
                                                    .withOpacity(0.2),
                                                AppColors.blueGrad4
                                                    .withOpacity(0.2),
                                                AppColors.blueGrad3
                                                    .withOpacity(0.2),
                                                AppColors.blueGrad2
                                                    .withOpacity(0.2),
                                                AppColors.blueGrad1
                                                    .withOpacity(0.2),
                                              ]),
                                          shape: BoxShape.circle
                                          //borderRadius: BorderRadius.circular(10),
                                          ),
                                      child: Icon(
                                          theoryContent[index].isExpand
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          color: AppColors.blueGrad6),
                                    ),
                                    childrenPadding: EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom: 10,
                                        top: 0),
                                    title: Text(
                                        theoryContent[index]
                                                .topicName!
                                                .replaceAll('_', ' ')
                                                .substring(0, 1)
                                                .toUpperCase() +
                                            theoryContent[index]
                                                .topicName!
                                                .replaceAll('_', ' ')
                                                .substring(1),
                                        style: AppTextStyle.textStyle.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15)),
                                    children: [
                                      Text(
                                        theoryContent[index]
                                            .topicDescription
                                            .toString(),
                                        textAlign: TextAlign.left,
                                        style: AppTextStyle.disStyle.copyWith(
                                            fontWeight: FontWeight.w400),
                                      ),
                                      /*Visibility(
                                          visible: _dataStatus == DataStatus.Loaded
                                              ? false
                                              : true,
                                          child: Container(
                                            //color: Colors.red[200],
                                            margin: EdgeInsets.only(top: 10),
                                            width: double.infinity,
                                            child: _dataStatus == DataStatus.Loading
                                                ? Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(16.0),
                                                      child: CircularProgressIndicator(),
                                                    ),
                                                  )
                                                : Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                            text: "Read AI article",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w500,
                                                              color: Dark,
                                                            ),
                                                            recognizer:
                                                                TapGestureRecognizer()
                                                                  ..onTap = () async {
                                                                    print("Clicked!!");
                                                                    setState(() {
                                                                      _dataStatus =
                                                                          DataStatus
                                                                              .Loading;
                                                                    });
                                                                    await getTopicAiContent(
                                                                            theoryContent[
                                                                                    index][
                                                                                "topic_name"])
                                                                        .then((data) {
                                                                      print(
                                                                          "Topic : $data");
                                                                      setState(() {
                                                                        _dataStatus =
                                                                            DataStatus
                                                                                .Loaded;
                                                                        topicData = data;
                                                                      });
                                                                    });
                                                                  }),
                                                      ),
                                                      SizedBox(height: 3),
                                                      RichText(
                                                        text: TextSpan(
                                                            text: "Watch Video",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w500,
                                                              color: Dark,
                                                            ),
                                                            recognizer:
                                                                TapGestureRecognizer()
                                                                  ..onTap = () async {
                                                                    print("Clicked!!");
                                                                    setState(() {
                                                                      _dataStatus =
                                                                          DataStatus
                                                                              .Loading;
                                                                    });
                                                                    await getTopicAiContent(
                                                                            theoryContent[
                                                                                    index][
                                                                                "topic_name"])
                                                                        .then((data) {
                                                                      print(
                                                                          "Topic : $data");
                                                                      setState(() {
                                                                        _dataStatus =
                                                                            DataStatus
                                                                                .Loaded;
                                                                        topicData = data;
                                                                      });
                                                                    });
                                                                  }),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: _dataStatus == DataStatus.Loaded
                                              ? true
                                              : false,
                                          child: Container(
                                            child: topicData.isNotEmpty
                                                ? Column(
                                                    children: [
                                                      ListTile(
                                                        title: Text("Read article",
                                                            style: TextStyle(color: Dark)),
                                                        onTap: () {
                                                          _handleURLButtonPress(
                                                              context,
                                                              topicData["reading_links"]
                                                                  [0]);
                                                        },
                                                      ),
                                                      ListTile(
                                                        title: YoutubePlayer(
                                                          backgroundColor:
                                                              Colors.transparent,
                                                          controller:
                                                              YoutubePlayerController(
                                                            params: YoutubePlayerParams(
                                                                mute: false,
                                                                showControls: true,
                                                                showFullscreenButton:
                                                                    false),
                                                          )..loadVideo(
                                                                  topicData["yt_links"][0]),
                                                          // width: 250,
                                                        ),
                                                        // onTap: () {
                                                        //   _handleURLButtonPress(context,
                                                        //       "https://www.youtube.com/watch?v=sI2Bbs_IvcU");
                                                        // },
                                                      )
                                                    ],
                                                  )
                                                : Text("No data"),
                                          ),
                                        ),*/
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: CustomButton(
                                                  isfontSize: true,
                                                  isfontWeight: true,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  isImage: true,
                                                  title: "Read AI article",
                                                  image: AppImages.readAi,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                                  onTap: () async {
                                                    print("Clicked!!");
                                                    setState(() {
                                                      _dataStatus =
                                                          DataStatus.Loading;
                                                    });
                                                    await getTopicAiContent(
                                                            theoryContent[index]
                                                                .topicName
                                                                .toString())
                                                        .then((data) {
                                                      print("Topic : $data");
                                                      setState(() {
                                                        _dataStatus =
                                                            DataStatus.Loaded;
                                                        topicData = data;
                                                        print(
                                                            'RRRRGJGJKGJKG $topicData');
                                                        _handleURLButtonPress(
                                                            context,
                                                            topicData['data'][
                                                                    "reading_links"]
                                                                [0]);
                                                      });
                                                    });
                                                  })),
                                          // Expanded(
                                          //   child: RichText(
                                          //     text: TextSpan(
                                          //         text: "Read AI article",
                                          //         style: TextStyle(
                                          //           fontSize: 15,
                                          //           fontWeight: FontWeight.w500,
                                          //           color: Dark,
                                          //         ),
                                          //         recognizer:
                                          //             TapGestureRecognizer()
                                          //               ..onTap = () async {
                                          //                 print("Clicked!!");
                                          //                 setState(() {
                                          //                   _dataStatus =
                                          //                       DataStatus
                                          //                           .Loading;
                                          //                 });
                                          //                 await getTopicAiContent(
                                          //                         theoryContent[
                                          //                                 index]
                                          //                             [
                                          //                             "topic_name"])
                                          //                     .then((data) {
                                          //                   print(
                                          //                       "Topic : $data");
                                          //                   setState(() {
                                          //                     _dataStatus =
                                          //                         DataStatus
                                          //                             .Loaded;
                                          //                     topicData = data;
                                          //                   });
                                          //                 });
                                          //               }),
                                          //   ),
                                          // ),
                                          SizedBox(width: 8),
                                          Expanded(
                                              child: CustomButton(
                                                  isImage: true,
                                                  title: "Watch Video",
                                                  fontSize: 12,
                                                  isfontSize: true,
                                                  isfontWeight: true,
                                                  fontWeight: FontWeight.w500,
                                                  image: AppImages.video,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                                  onTap: () async {
                                                    print("Clicked!!");
                                                    setState(() {
                                                      _dataStatus =
                                                          DataStatus.Loading;
                                                      isWatchVideo = true;
                                                    });
                                                    await getTopicAiContent(
                                                            theoryContent[index]
                                                                .topicName
                                                                .toString())
                                                        .then((data) {
                                                      print("Topic : $data");
                                                      setState(() {
                                                        _dataStatus =
                                                            DataStatus.Loaded;
                                                        topicData = data;
                                                        // YoutubePlayerController.convertUrlToId(
                                                        //         topicData['data']
                                                        //                 [
                                                        //                 'yt_links']
                                                        //             [0]);
                                                        // urlLauncher(
                                                        //     "${topicData['data']["yt_links"][0]}");
                                                        // var id = topicData[
                                                        //             'data']
                                                        //         ["yt_links"][0]
                                                        //     .toString()
                                                        //     .split("=")
                                                        //     .last;
                                                        var id = YoutubePlayer
                                                            .convertUrlToId(
                                                                topicData['data']
                                                                        [
                                                                        "yt_links"]
                                                                    [0]);
                                                        print(
                                                            'YOUTUBE VIDEO ID ============= $id');
                                                        youtubePlayerController =
                                                            YoutubePlayerController(
                                                                initialVideoId: id
                                                                    .toString(),
                                                                flags:
                                                                    YoutubePlayerFlags());

                                                        // controller.loadVideo(
                                                        //     topicData['data']
                                                        //             ['yt_links']
                                                        //         [0]);
                                                      });
                                                    });
                                                  })),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Visibility(
                                        visible:
                                            _dataStatus == DataStatus.Loaded
                                                ? true
                                                : false,
                                        child: Container(
                                          child: topicData.isNotEmpty
                                              ? !isWatchVideo
                                                  ? SizedBox()
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10.0),
                                                          child: InkWell(
                                                              onTap: () {
                                                                isWatchVideo =
                                                                    false;
                                                                setState(() {});
                                                                youtubePlayerController
                                                                    ?.dispose();
                                                              },
                                                              child: Icon(
                                                                  Icons.close)),
                                                        ),
                                                        youtubePlayerController ==
                                                                null
                                                            ? SizedBox()
                                                            : ListTile(
                                                                title:
                                                                    YoutubePlayer(
                                                                controller:
                                                                    youtubePlayerController!,
                                                              ))
                                                      ],
                                                    )
                                              : Text("No data"),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Checkbox(
                                              shape: ContinuousRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              value: readContentTheory[index],
                                              onChanged: readContentTheory[
                                                      index]
                                                  ? null
                                                  : (value) async {
                                                      setState(() {
                                                        readContentTheory[
                                                                index] =
                                                            !readContentTheory[
                                                                index];
                                                        print(
                                                            'readContent------------${readContentTheory[index]}');
                                                      });
                                                      print(
                                                          'readContent------------${readContentTheory[index]}');
                                                      // print(_userId.runtimeType);
                                                      // print(theoryContent[index]["id"].runtimeType);
                                                      await updateTopicProgress(
                                                          _userId!.toString(),
                                                          theoryContent[index]
                                                              .id
                                                              .toString()
                                                              .toString());
                                                    },
                                              fillColor: MaterialStateColor
                                                  .resolveWith(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.disabled)) {
                                                    return Color(0xFF3F57A0);
                                                  }
                                                  return AppColors.transparent;
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "I have read the content",
                                            style:
                                                AppTextStyle.disStyle.copyWith(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                      // _buildTilesX(context, changingData[index]),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                        itemCount: theoryContent.length,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildTilesX(BuildContext context, Entry root) {
  //   if (root.title == "yt_links")
  //     return new ListTile(
  //         title: Text("Watch Video"),
  //         subtitle: YoutubePlayer(
  //           controller: YoutubePlayerController(
  //             initialVideoId:
  //                 YoutubePlayer.convertUrlToId(root.links)!, //Add videoID.
  //             flags: YoutubePlayerFlags(
  //               hideControls: false,
  //               controlsVisibleAtStart: true,
  //               autoPlay: false,
  //               mute: false,
  //             ),
  //           ),
  //           // width: 250,
  //           showVideoProgressIndicator: true,
  //           progressIndicatorColor: Colors.green,
  //         ));

  //   if (root.children.isEmpty && root.title != "yt_links")
  //     return new ListTile(
  //       title: new Text(root.title),
  //       onTap: () => _handleURLButtonPress(context, root.links),
  //     );
  //   return Column(
  //     children:
  //         root.children.map((link) => _buildTilesX(context, link)).toList(),
  //   );
  //   // return new ExpansionTile(
  //   //   key: new PageStorageKey<String>(
  //   //       root.title), // root.title == newerRoot.title is true
  //   //   title: new Text(root.title),
  //   //   subtitle: new Text(root.subheading!),
  //   //   children:
  //   //   root.children.map((link) => _buildTilesX(context, link)).toList(),
  //   // );
  // }

  void showLoader(String message) {
    CustomSpinner.showLoadingDialog(context, _keyLoader, message);
  }

  void closeLoader() {
    try {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    } catch (e) {}
  }

  // List<Entry> generateData() {
  //   List<Entry> chdata = List.empty();
  //   chdata = chdata.toList();
  //   List<Entry> redata = List.empty();
  //   redata = redata.toList();
  //   List<Entry> lnkdata = List.empty();
  //   lnkdata = lnkdata.toList();
  //   String adifname = " ";
  //   String adilname = " ";
  //   String requested_date = " ";
  //   String requested_time = " ";
  //   String? lessondetails;
  //   late String lesson_Name;
  //   late List<dynamic> lesson_link = List.empty();
  //   lesson_link = lesson_link.toList();
  //
  //   late Entry entry_title;
  //   late Entry entry_lesson;
  //   late Entry en_lnk;
  //
  //   try {
  //     if (dataSub != null) {
  //       // for (var data in datas as ma) {
  //       if (dataSub != null && dataSub!.length > 0) {
  //         dataSub!.forEach((k, ve) {
  //           //if (dataSub!["recommendation"] != null && k == "recommendation") {
  //           //  for (int index = 0; index < ve.length; index++) {
  //           ve.forEach((ke, va) {
  //             print("data  :" +
  //                 k +
  //                 "  Links:   " +
  //                 ke +
  //                 "  value : " +
  //                 va.toString());
  //             lesson_link = va;
  //             lesson_Name = k;
  //             print(lesson_link.toString());
  //             for (dynamic link in lesson_link) {
  //               if (ke == "yt_links") {
  //                 en_lnk = new Entry(ke, link as String, '');
  //               } else if (ke == "reading_links") {
  //                 en_lnk = new Entry('Read Article', link as String, '');
  //               }
  //               lnkdata.add(en_lnk);
  //             }
  //           });
  //           lessondetails = Gettopicdescription(lesson_Name);
  //           entry_lesson = new Entry(
  //               lesson_Name.substring(0, 1).toUpperCase() +
  //                   lesson_Name.substring(1),
  //               '',
  //               lessondetails,
  //               lnkdata);
  //
  //           chdata.add(entry_lesson);
  //           lnkdata = List.empty();
  //           lnkdata = lnkdata.toList();
  //           //}
  //
  //           // entry_title =
  //           //  new Entry("Topic name : " + lesson_Name, '', '', redata);
  //           //chdata.add(entry_title);
  //           //}
  //           redata = List.empty();
  //           redata = redata.toList();
  //         });
  //       }
  //
  //       return chdata;
  //     } else {
  //       Entry e = new Entry(' No Data', '');
  //       chdata.add(e);
  //     }
  //     return chdata;
  //   } on Exception catch (exception) {
  //     print(exception);
  //     return chdata;
  //   }
  // }

  Widget? GetPremium(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)), //this right here
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: LinearGradient(
                      begin: Alignment(0.0, -1.0),
                      end: Alignment(0.0, 1.0),
                      colors: [Dark, Light],
                      stops: [0.0, 1.0],
                    )),
                // height: Responsive.height(25, context),
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.topLeft,
                              child: Text('Go For Premium !!!!',
                                  style: AppTextStyle.titleStyle)),
                          SizedBox(height: 8),
                          Text(
                            'Get Premium service for getting AI data for this topic',
                            style: AppTextStyle.disStyle.copyWith(
                                fontWeight: FontWeight.w300,
                                color: AppColors.black),
                          ),
                          SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // margin: const EdgeInsets.only(right: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    // Navigator.of(context).pop();
                                    // showLoader("Loading");
                                    // context
                                    //     .read<SubscriptionProvider>()
                                    //     .fetchOffer();
                                    // Stripe.publishableKey = stripePublic;
                                    // payWallBottomSheet();
                                    // closeLoader();
                                    // Map params = {
                                    //   'total_cost':
                                    //       walletDetail!['subscription_cost'],
                                    //   'user_type': 2,
                                    //   'parentPageName': "dvsaSubscription"
                                    // };
                                    // dev.log("Called before payment");
                                    // await _paymentService
                                    //     .makePayment(
                                    //         amount: walletDetail![
                                    //             'subscription_cost'],
                                    //         currency: 'GBP',
                                    //         context: context,
                                    //         desc:
                                    //             'DVSA Subscription by ${userName} (App)',
                                    //         metaData: params)
                                    //     .then((value) => closeLoader());
                                    dev.log("Called after payment");
                                  },
                                  child: Container(
                                      // width: constraints.maxWidth * 0.8,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Dark,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Buy now",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                SizeConfig.blockSizeHorizontal *
                                                    4),
                                      )),
                                ),
                              ),
                              SizedBox(width: 18),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context, false);
                                    //Provider.of<AuthProvider>(context, listen: false).logOut();
                                    // _navigationService.navigateTo('/Authorization');
                                  },
                                  child: Container(
                                      // width: constraints.maxWidth * 0.8,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Dark,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                SizeConfig.blockSizeHorizontal *
                                                    4),
                                      )),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
    return null;
  }

  payWallBottomSheet() {
    showModalBottomSheet(
        isDismissible: false,
        // enableDrag: false,
        shape: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        backgroundColor: Colors.white,
        context: context,
        builder: (_) => PopScope(
              canPop: false,
              child: Consumer<SubscriptionProvider>(builder: (context, val, _) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            padding: EdgeInsets.all(0),
                            visualDensity: VisualDensity.comfortable,
                            iconSize: 20,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.clear)),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            PurchaseSub.purchasePackage(val.package.first);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                                color: AppColors.borderblue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${val.package.first.storeProduct.title}",
                                    style: AppTextStyle.titleStyle.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black54)),
                                Text(
                                  "${val.package.first.storeProduct.priceString}",
                                  style: AppTextStyle.disStyle
                                      .copyWith(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              }),
            ));
  }

  Future<Map> getAllRecordsFromApi() async {
    Map response = await test_api_services.getAllRecords(2, _userId!);
    return response;
  }
}

// String? Gettopicdescription(String topicName) {
//   switch (topicName) {
//     case TheoryTestTopics.safetymargins:
//       return "The safety margins theory test section is about driving in conditions that affect the braking and handling of a vehicle,As a learner driver, it’s imperative that you always keep in mind the safety of yourself, any passengers you may be carrying and other road users.";
//
//     case TheoryTestTopics.hazardawarenesstheorytest:
//       return "Hazards are among the most important things you must be able to identify in order to become a competent driver,In this hazard awareness section, you’ll learn about the different types of hazards you might encounter and how to react to them.";
//
//     case TheoryTestTopics.roadandtrafficsignstheorytest:
//       return "In this section, you’ll find out about what you can learn from: The shapes of road signs,Road markings,The colours of traffic lights and their sequences,Motorway warning lights,The signals used by other drivers and by police officers.";
//
//     case TheoryTestTopics.rulesofroad:
//       return "Learning the rules of the road will help you and other road users stay safe. It is extremely important that you learn about:The speed limits that you must obey,How to safely use junctions and lanes,How to overtake and reverse safely,How to safely use pedestrian and level crossings,Where it is safe and legal to stop and park.";
//
//     case TheoryTestTopics.alertness:
//       return "By ‘alertness’, we mean the state of being wide awake while you focus on your driving – without distractions such as mobile phones and loud music ,Alertness also includes being ready for hazards";
//
//     case TheoryTestTopics.attitude:
//       return "Your frame of mind when you enter the car. You should be calm, ready to concentrate and focused on driving in a safe manner.How you react to hazards on the road,How you react to other drivers";
//
//     case TheoryTestTopics.safetyandyourvehicle:
//       return "Learning about your vehicle and how it operates can help you ensure that you, your vehicle and other road users remain safe. It will also ensure that you save money and help the environment, as a well looked-after car runs more efficiently and economically with less harmful emissions. ";
//
//     case TheoryTestTopics.vulnerableroadusers:
//       return "Road users are a varied group and have different needs. Some are vulnerable and it’s your responsibility to know how to conduct yourself on the road to ensure everyone’s safety.";
//
//     case TheoryTestTopics.othertypesofvehicle:
//       return "Cars are not the only vehicles that occupy the roads. There are other types of vehicles such as motorcyclists, buses and trams which you must be aware of. In this theory test section, you’ll learn about:,The different types of vehicles that occupy the roads,How to drive safely towards or follow different types of vehicles.";
//
//     case TheoryTestTopics.roadconditionsandvehiclehandling:
//       return "In this section, we’ll show you the correct way to deal with incidents by teaching you how to:Respond if your car breaks down,Drive safely in tunnels, including what to do if you have an emergency,Respond to accidents on the road if you’re the first to arrive on the scene,Help casualties at an incident and how to administer basic first aid,Report an incident to the police.";
//
//     case TheoryTestTopics.motorwaydriving:
//       return "The motorway rules theory test section covers all the driving theory that is needed for motorway travel. Driving on the motorway can be a nerve-wracking experience, particularly as it’s something that most people won’t have done until after they’ve passed their test";
//
//     case TheoryTestTopics.essentialdocuments:
//       return "To legally drive in the UK you must meet certain requirements, such as:Having paid vehicle excise duty (road tax) where appropriate,Holding a valid driving licence for the type of vehicle you wish to drive,Having valid insurance cover,Ensuring that the vehicle you’re driving has a valid MOT certificate, where appropriate.";
//
//     case TheoryTestTopics.incidentsaccidentsemergencies:
//       return "Unfortunately incidents, accidents and emergencies are sometimes unavoidable. By knowing how to deal with incidents in the initial phases, you can prevent them from becoming more serious.";
//
//     case TheoryTestTopics.vehicleloading:
//       return "The vehicle loading section of the driving theory test contains questions about how to load your vehicle, towing trailers and caravans, the use of roof racks etc. ";
//   }
//   return null;
// }

// class Entry {
//   Entry(this.title, this.links,
//       [this.subheading, this.children = const <Entry>[]]);
//   final String title;
//   final String links;
//   final String? subheading;
//   final List<Entry> children;
// }

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
// class EntryItem extends StatelessWidget {
//   const EntryItem(this.entry);
//   final Entry entry;
//   Widget _buildTiles(BuildContext context, Entry root) {
//     if (root.title == "yt_links")
//       return new ListTile(
//           title: Text("Watch Video"),
//           subtitle: YoutubePlayer(
//             controller: YoutubePlayerController(
//               initialVideoId:
//                   YoutubePlayer.convertUrlToId(root.links)!, //Add videoID.
//               flags: YoutubePlayerFlags(
//                 hideControls: false,
//                 controlsVisibleAtStart: true,
//                 autoPlay: false,
//                 mute: false,
//               ),
//             ),
//             // width: 250,
//             showVideoProgressIndicator: true,
//             progressIndicatorColor: Colors.green,
//           ));

//     if (root.children.isEmpty && root.title != "yt_links")
//       return new ListTile(
//         title: new Text(root.title),
//         onTap: () => _handleURLButtonPress(context, root.links),
//       );
//     return new ExpansionTile(
//       key: new PageStorageKey<String>(
//           root.title), // root.title == newerRoot.title is true
//       title: new Text(root.title),
//       subtitle: new Text(root.subheading!),
//       children:
//           root.children.map((link) => _buildTiles(context, link)).toList(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _buildTiles(context, entry);
//   }
// }

void _handleURLButtonPress(BuildContext context, String url) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WebViewContainer(url, 'AI Learning')));
}
