import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/card.dart' as MCard;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_app/routing/route_names.dart' as routes;
import 'package:student_app/views/AIRecommendations/TheoryRecommondation.dart';

import '../../Constants/app_colors.dart';
import '../../Constants/global.dart';
import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/auth.dart';
import '../../services/booking_test.dart';
import '../../services/navigation_service.dart';
import '../../services/payment_services.dart';
import '../../services/practise_theory_test_services.dart';
import '../Driver/PracticeTheoryTest.dart';
import '../Login/welcome.dart';
import '../WebView.dart';

class TheoryTab extends PracticeTheoryTest {
  //final FirebaseUser user;
  //const HomeScreen({Key key, this.user}) : super( key: key);
  @override
  _TheoryTabState createState() => _TheoryTabState();
}

class _TheoryTabState extends State<TheoryTab> {
  var _progressValue = 0.0;
  int seledtedCategoryId = 0;
  List categories = [];
  bool isAllCategoriesSelected = true;
  TextStyle _categoryTextStyle = TextStyle(
      fontSize: 2 * SizeConfig.blockSizeVertical,
      color: Colors.black,
      fontWeight: FontWeight.normal);
  final NavigationService _navigationService = locator<NavigationService>();
  late Future<List>? _recentBooking = null;
  final BookingService _bookingService = BookingService();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final PractiseTheoryTestServices test_api_services =
      new PractiseTheoryTestServices();
  Map? walletDetail = null;
  final PaymentService _paymentService = new PaymentService();
  int? userId;
  String userName = '';
  bool isSubscribed = true;
  List cards = [
    {
      'icon': FontAwesomeIcons.robot,
      'title': 'AI Learn',
      'subTitle': 'Study theory test topics',
      'type': 'aiLearn',
      'buttonText': 'Learn'
    },
    {
      'icon': FontAwesomeIcons.clipboardCheck,
      'title': 'Practice',
      'subTitle':
          'Understand the questions you will likely be asked in DVSA theory test',
      'type': 'theoryTest',
      'buttonText': 'Start'
    },
    {
      'icon': FontAwesomeIcons.car,
      'title': 'Practice Hazard Perception',
      'subTitle':
          'Understand the questions you will likely be asked in a hazard perception test',
      'type': 'hazard',
      'buttonText': 'Start'
    },
    {
      'icon': FontAwesomeIcons.car,
      'title': 'Take DVSA Mock Theory Test',
      'subTitle': 'Takes you to DVSA Website',
      'type': 'dvsaMock',
      'buttonText': 'Start test'
    }
  ];

  List _resourceCards = [
    {
      'title': 'Highway Code',
      'subTitle': 'The Highway Code is a rule book issues by the DVSA.'
          'The DVSA theory test tests learner drivers for understanding of these rules.',
      'type': 'highwayCode',
      'buttonText': 'Read now'
    },
    {
      'title': 'Theory Test Guidance',
      'subTitle': 'Read and get prepare for theory test',
      'type': 'theoryTestGuidance',
      'buttonText': 'Read more'
    },
    {
      'title': 'Book theory test',
      'subTitle': 'You can book theory test direct from here',
      'type': 'bookTheoryTest',
      'buttonText': 'Book now'
    },
  ];

  Future<Map> getUserDetail() async {
    Map response =
        await Provider.of<AuthProvider>(context, listen: false).getUserData();

    return response;
  }

  Future<List> callApiGetRecentBooking() async {
    List bookings = await _bookingService.getRecentBookings();
    return bookings;
  }

  getStatus() async {
    var sharedPref = await SharedPreferences.getInstance();
    var data = sharedPref.getBool('theoryTestPractice');

    if (data == null) {
      theoryTestPractice();
    }
    log('SharedPref Data $data');
  }

  @override
  void initState() {
    super.initState();
    getStatus();
    Future.delayed(Duration.zero, () {
      this.initializeApi("Loading...");
    });
  }

  Future<Map> getAllRecordsFromApi() async {
    Map response = await test_api_services.getAllRecords(2, userId!);
    return response;
  }

  initializeApi(String loaderMessage) async {
    checkInternet();
    loading(value: true);
    var sharedPref = await SharedPreferences.getInstance();
    var data = sharedPref.getBool('theoryTestPractice');

    // if (data == null) {
    //   theoryTestPractice();
    // }
    // log('SharedPref Data $data');
    getUserDetail().then((res) async {
      userId = res['id'];
      await getAllRecordsFromApi().then((records_list) {
        walletDetail = records_list['other_data'];
      });
      log("Subscription status : ${res['dvsa_subscription']}");
      if (res['dvsa_subscription'] == 1) {
        if (mounted) {
          setState(() {
            isSubscribed = true;
          });
        }
      } else {
        // closeLoader();
        if (mounted) {
          setState(() {
            isSubscribed = false;
          });
        }
      }
      fetchUserTheoryProgress(userId!).then((res) {
        setState(() {
          _progressValue = res["progress"].toDouble();
        });
        loading(value: false);
      });
    });
    if (this.mounted) {
      setState(() {
        // CreateTopCard();
        // CreateBottomCard();
      });
    }

    //closeLoader();
  }

  // void showLoader(String message) {
  //   CustomSpinner.showLoadingDialog(context, _keyLoader, message);
  // }

  Future<Map> fetchUserTheoryProgress(int driverId) async {
    final url = Uri.parse('$api/api/fetch/progress/${driverId}');
    //print("URL : $url");
    final response = await http.get(url);
    return jsonDecode(response.body);
  }

  dynamic loading(
      {@required bool? value, String? title, bool closeOverlays = false}) {
    if (value!) {
      EasyLoading.instance
        ..indicatorType = EasyLoadingIndicatorType.ring
        ..backgroundColor = Colors.white
        ..displayDuration = Duration(seconds: 2)
        ..maskColor = Colors.grey.withOpacity(.2)

        /// custom style
        ..loadingStyle = EasyLoadingStyle.custom
        ..indicatorColor = Colors.black
        ..textColor = Colors.black
        ..contentPadding = EdgeInsets.symmetric(
          horizontal: Responsive.width(15, context),
          vertical: Responsive.width(5, context),
        )

        ///
        ..userInteractions = false
        ..animationStyle = EasyLoadingAnimationStyle.offset;
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        status: "Loading..",
        dismissOnTap: true,
      );
    } else {
      EasyLoading.dismiss();
    }
  }
  // void closeLoader() {
  //   try {
  //     Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
  //   } catch (e) {}
  // }

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

  String? _userName;

  Future<String> getUserName() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String userName = storage.getString('userName').toString();
    return userName;
  }

  Future<List> getCategoriesFromApi() async {
    List response = await test_api_services.getCategories();
    return response;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getUserName().then((value) {
      setState(() {
        _userName = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return PopScope(
      onPopInvoked: (val) {
        print('PopInvoke');
        // Navigator.pop(context);
        // Navigator.pop(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                insetAnimationCurve: Curves.easeOutBack,
                                insetPadding: EdgeInsets.all(20),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Container(
                                  height: Responsive.height(55, context),
                                  alignment: Alignment.bottomCenter,
                                  padding: EdgeInsets.fromLTRB(10, 12, 10, 5),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: Responsive.height(35, context),
                                        width: Responsive.width(80, context),
                                        alignment: Alignment.topLeft,
                                        margin:
                                            EdgeInsets.only(bottom: 0, top: 0),
                                        child: Column(children: [
                                          // )),
                                          Text('Your Progress:',
                                              style: _categoryTextStyle),
                                          ListView(
                                              physics:
                                                  AlwaysScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              children: [
                                                ...categories.map((category) {
                                                  // var index = categories
                                                  //     .indexOf(category);
                                                  return Container(
                                                    width: Responsive.width(
                                                        80, context),
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Container(
                                                      width: Responsive.width(
                                                        57,
                                                        context,
                                                      ),
                                                      child: SizedBox(
                                                        width: Responsive.width(
                                                            55, context),
                                                        child: AutoSizeText(
                                                            category['name'],
                                                            style:
                                                                _categoryTextStyle),
                                                      ),
                                                    ),
                                                  );
                                                }).toList()
                                              ])
                                        ]),
                                      )
                                    ],
                                  ),
                                ),
                              ));
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16, 25, 16, 0),
                      width: constraints.maxWidth,
                      //color: Colors.black26,
                      child: MCard.Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 8.0,
                        child: Container(
                          width: constraints.maxWidth,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 18),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Text("$api"),
                                  Text('THEORY LEARNING PROGRESS',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          color: Dark,
                                          fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.left),
                                  Text(
                                    '${(_progressValue * 100).round()}%',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        color: Dark,
                                        fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              LinearProgressIndicator(
                                borderRadius: BorderRadius.circular(5),
                                minHeight: 5,
                                backgroundColor: Dark.withOpacity(0.2),
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.red),
                                value: _progressValue,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: Responsive.width(100, context),
                    height: Responsive.height(18, context),
                    //height: constraints.maxHeight * 0.8,
                    padding: EdgeInsets.fromLTRB(16, 25, 16, 0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: cards.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            width: SizeConfig.blockSizeHorizontal * 70,
                            child: GestureDetector(
                              onTap: () {
                                if (cards[index]["type"] == 'theoryTest') {
                                  context.read<AuthProvider>().changeView =
                                      true;
                                  setState(() {});
                                  print(
                                      "auth_services.changeView ${context.read<AuthProvider>().changeView}");
                                  if (context.read<AuthProvider>().changeView) {
                                    // getCategoriesFromApi().then((response_list) {
                                    //  responseList = response_list;
                                    //  print("------------ responseList $responseList");
                                    //  setState(() {});
                                    // });
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) =>
                                            PracticeTheoryTest());
                                  } else {
                                    _navigationService.navigateTo(
                                        routes.PracticeTheoryTestRoute);
                                  }
                                  /*showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: startButtonWidget(
                                              context, constraints),
                                          // TextButton(
                                          //     child: Text('Start Test'),
                                          //     onPressed: () {
                                          //       _navigationService.navigateTo(
                                          //           routes
                                          //               .PracticeTheoryTestRoute);
                                          //       // CustomSpinner.showLoadingDialog(
                                          //       //     context,
                                          //       //     _keyLoader,
                                          //       //     "Loading...");
                                          //       // getCategoriesFromApi()
                                          //       //     .then((response_list) {
                                          //       //   log("Category : $response_list");
                                          //       //
                                          //       //   // Navigator.of(
                                          //       //   //         _keyLoader
                                          //       //   //             .currentContext!,
                                          //       //   //         rootNavigator: true)
                                          //       //   //     .pop();
                                          //       //   showDialog(
                                          //       //       context: context,
                                          //       //       builder:
                                          //       //           (BuildContext context) {
                                          //       //         return TestSettingDialogBox(
                                          //       //           parentConstraints:
                                          //       //               constraints,
                                          //       //           categories_list:
                                          //       //               response_list,
                                          //       //           onSetValue:
                                          //       //               (_categoryId) {
                                          //       //             log("Category id : $_categoryId");
                                          //       //             gainPoint = 0;
                                          //       //             questionsList = [];
                                          //       //             testQuestionsForResult =
                                          //       //                 [];
                                          //       //             selectedQuestionIndex =
                                          //       //                 0;
                                          //       //             selectedOptionIndex =
                                          //       //                 null;
                                          //       //             category_id =
                                          //       //                 _categoryId;
                                          //       //             CustomSpinner
                                          //       //                 .showLoadingDialog(
                                          //       //                     context,
                                          //       //                     _keyLoader,
                                          //       //                     "Test loading...");
                                          //       //             getQuestionsFromApi()
                                          //       //                 .then(
                                          //       //                     (response_list) {
                                          //       //               Navigator.of(
                                          //       //                       _keyLoader
                                          //       //                           .currentContext!,
                                          //       //                       rootNavigator:
                                          //       //                           true)
                                          //       //                   .pop();
                                          //       //               questionsList =
                                          //       //                   response_list;
                                          //       //               setState(() => {
                                          //       //                     isTestStarted =
                                          //       //                         true
                                          //       //                   });
                                          //       //             });
                                          //       //           },
                                          //       //         );
                                          //       //       });
                                          //       // });
                                          //     }),
                                        );
                                        // return
                                      });*/
                                } else if (cards[index]["type"] == 'hazard') {
                                  _navigationService.navigateTo(
                                      routes.HazardPerceptionOptionsRoute);
                                } else if (cards[index]["type"] == 'dvsaMock') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WebViewContainer(
                                        'https://www.gov.uk/take-practice-theory-test',
                                        'DVSA Mock Theory Test',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TheoryRecommendations(),
                                    ),
                                  ).then((value) {
                                    print('QQQQQQQ $value');
                                    if (value) {
                                      initializeApi("Loading...");
                                    }
                                  });
                                }
                              },
                              child: MCard.Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 3.0,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            cards[index]["icon"],
                                            color: Dark,
                                            size: 22,
                                          ),
                                          SizedBox(width: 15),
                                          Expanded(
                                            child: Text(cards[index]["title"],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: SizeConfig
                                                            .blockSizeHorizontal *
                                                        4,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Text(
                                            cards[index]["subTitle"],
                                            maxLines: 3,
                                            style: TextStyle(
                                                height: 1.2,
                                                fontSize: SizeConfig
                                                        .blockSizeHorizontal *
                                                    3.5,
                                                overflow: TextOverflow.ellipsis
                                                //fontWeight: FontWeight.bold
                                                ),
                                            softWrap: true,
                                            //  textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                      //SizedBox(width: 15),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  Container(
                      height: Responsive.height(35, context),
                      width: Responsive.width(100, context),
                      //padding: EdgeInsets.all(8.0),

                      child: LayoutBuilder(builder: (context, constraints) {
                        return Column(
                          children: <Widget>[
                            Container(
                              //color: Colors.red,
                              width: constraints.maxWidth * 0.95,
                              margin: EdgeInsets.fromLTRB(
                                  constraints.maxWidth * 0.04,
                                  constraints.maxHeight * 0.04,
                                  constraints.maxWidth * 0.025,
                                  0.0),

                              child: Text(
                                'RESOURCES',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Dark,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              width: Responsive.width(100, context),
                              height: Responsive.height(28, context),
                              //height: constraints.maxHeight * 0.8,
                              padding: EdgeInsets.fromLTRB(16, 5, 25, 5),
                              child: ListView.builder(
                                  itemCount: _resourceCards.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 80,
                                      child: MCard.Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        elevation: 3.0,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            //mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                _resourceCards[index]["title"],
                                                style: TextStyle(
                                                  fontSize: SizeConfig
                                                          .blockSizeHorizontal *
                                                      4,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                _resourceCards[index]
                                                    ["subTitle"],
                                                style: TextStyle(
                                                  fontSize: SizeConfig
                                                          .blockSizeHorizontal *
                                                      3.5,
                                                  //fontWeight: FontWeight.bold
                                                ),
                                                softWrap: true,
                                                textAlign: _resourceCards[index]
                                                            ["type"] ==
                                                        'highwayCode'
                                                    ? TextAlign.left
                                                    : TextAlign.center,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (_resourceCards[index]
                                                          ["type"] ==
                                                      'highwayCode') {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                WebViewContainer(
                                                                    'https://www.gov.uk/guidance/the-highway-code',
                                                                    'Highway Code')));
                                                  } else if (_resourceCards[
                                                          index]["type"] ==
                                                      'theoryTestGuidance') {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                WebViewContainer(
                                                                    'https://mockdrivingtest.com/static/practice-theory-test',
                                                                    'Theory Test Guidance')));
                                                  } else {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                WebViewContainer(
                                                                    'https://www.gov.uk/book-theory-test',
                                                                    'Book DVSA Theory Test')));
                                                  }
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Dark)),
                                                child: Text(
                                                  _resourceCards[index]
                                                      ["buttonText"],
                                                  style: TextStyle(
                                                      fontSize: SizeConfig
                                                              .blockSizeHorizontal *
                                                          3.5,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600
                                                      //fontWeight: FontWeight.bold
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        );
                      })),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// PRACTICE THEORY TAB FUNCTION ///
  /// =========================== ///

  resetAll(bool isAllSelect) {
    isAllCategoriesSelected = isAllSelect;
    categories.asMap().forEach((index, category) {
      setState(() {
        categories[index]['selected'] = isAllSelect ? true : false;
      });
    });
  }

  theoryTestPractice() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
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
                      child: Text("Theory Test Practice Module",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: SizeConfig.blockSizeHorizontal * 4.5))),
                  Container(
                    //width: constraints.maxWidth,
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle,
                                size: SizeConfig.blockSizeHorizontal * 4,
                                color: Colors.green),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                  //"2000+ Questions from 14 official question categories set by DVSA.",
                                  "2000+ Questions "),
                            )
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle,
                                size: SizeConfig.blockSizeHorizontal * 4,
                                color: Colors.green),
                            SizedBox(width: 5),
                            Expanded(
                                child: Text(
                              "Free Mock Theory tests to check your test readiness.",
                            ))
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: SizeConfig.blockSizeHorizontal * 4,
                              color: Colors.green,
                            ),
                            // SizedBox(
                            //   width:
                            //       constraints.maxWidth * 0.02,
                            // ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                  'The Only AI powered App In The Market'
                                  //"For each correct answer, earn 1 token! Answer 400 questions correctly and get your DVSA Theory Test free!",
                                  ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 10),
                            child: GestureDetector(
                                onTap: () async {
                                  print("payment");
                                  //
                                  loading(value: true);

                                  Stripe.publishableKey = stripePublic;
                                  Map params = {
                                    'total_cost':
                                        walletDetail!['subscription_cost'],
                                    'user_type': 2,
                                    'parentPageName': "dvsaSubscriptionHome"
                                  };
                                  log("Called before payment");
                                  await _paymentService
                                      .makePayment(
                                          amount: walletDetail![
                                              'subscription_cost'],
                                          currency: 'GBP',
                                          context: context,
                                          desc:
                                              'DVSA Subscription by ${userName} (App)',
                                          metaData: params)
                                      .then((value) => loading(value: false));
                                  log("Called after payment");
                                },
                                child: Container(
                                    // width: constraints.maxWidth * 0.8,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Dark,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
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
                                    )))),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 10),
                          child: GestureDetector(
                            onTap: () {
                              callDialog();
                              Navigator.pop(context);
                            },
                            child: Container(
                              // width: constraints.maxWidth * 0.8,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Dark,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Tabcardbottom {
  final String heading1;
  final String imagepath;

  final String data;
  final String btn1;
  final VoidCallback onTapbtn1;

  Tabcardbottom(
      this.heading1, this.imagepath, this.data, this.btn1, this.onTapbtn1);
}
