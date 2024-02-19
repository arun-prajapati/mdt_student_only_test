import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/card.dart' as MCard;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:student_app/external.dart';
import 'package:student_app/routing/route_names.dart' as routes;
import 'package:student_app/utils/appImages.dart';
import 'package:student_app/utils/app_colors.dart';
import 'package:student_app/views/AIRecommendations/TheoryRecommondation.dart';
import 'package:student_app/views/custom_widget/linerperchantage_widget.dart';

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

class TheoryTab extends StatefulWidget {
  //final FirebaseUser user;
  //const HomeScreen({Key key, this.user}) : super( key: key);
  @override
  _TheoryTabState createState() => _TheoryTabState();
}

class _TheoryTabState extends State<TheoryTab> {
  double _progressValue = 0.0;
  int seledtedCategoryId = 0;
  List categories = [];
  bool isAllCategoriesSelected = true;
  TextStyle _categoryTextStyle =
      AppTextStyle.titleStyle.copyWith(fontWeight: FontWeight.w600);
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
      'icon': AppImages.aiImage,
      'title': 'AI Learn',
      'subTitle': 'Study theory test topics',
      'type': 'aiLearn',
      'buttonText': 'Learn'
    },
    {
      'icon': AppImages.practice,
      'title': 'Practice',
      'subTitle':
          'Understand the questions you will likely be asked in DVSA theory test',
      'type': 'theoryTest',
      'buttonText': 'Start'
    },
    {
      'icon': AppImages.hazards,
      'title': 'Practice Hazard Perception',
      'subTitle':
          'Understand the questions you will likely be asked in a hazard perception test',
      'type': 'hazard',
      'buttonText': 'Start'
    },
    {
      'icon': AppImages.dvsaTest,
      'title': 'DVSA Mock Theory Test',
      'subTitle': 'Takes you to DVSA Website',
      'type': 'dvsaMock',
      'buttonText': 'Start test'
    }
  ];
  late List categories_list;
  List _resourceCards = [
    {
      'title': 'Highway Code',
      'subTitle': 'The Highway Code is a rule book issues by the DVSA.'
          'The DVSA theory test tests learner drivers for understanding of these rules.',
      'type': 'highwayCode',
      'buttonText': 'Read now',
      'image': AppImages.highway2,
    },
    {
      'title': 'Theory Test Guidance',
      'subTitle': 'Read and get prepare for theory test',
      'type': 'theoryTestGuidance',
      'buttonText': 'Read more',
      'image': AppImages.illustraion2,
    },
    {
      'title': 'Book theory test',
      'subTitle': 'You can book theory test direct from here',
      'type': 'bookTheoryTest',
      'buttonText': 'Book now',
      'image': AppImages.bookTest2,
    },
  ];

  Future<Map> getUserDetail() async {
    Map response =
        await Provider.of<UserProvider>(context, listen: false).getUserData();

    return response;
  }

  Future<List> callApiGetRecentBooking() async {
    List bookings = await _bookingService.getRecentBookings();
    return bookings;
  }

  getStatus() async {
    print('Call Popup Box---');
    var sharedPref = await SharedPreferences.getInstance();
    var data = sharedPref.getBool('theoryTestPractice');

    if (data == null) {
      if (context.read<UserProvider>().googleNavigate) {
        Navigator.of(context).pop();
      }
      theoryTestPractice();
    }
    log('SharedPref Data $data');
  }

  @override
  void initState() {
    super.initState();
    getStatus();
    getCategoriesFromApi();

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
    // var sharedPref = await SharedPreferences.getInstance();
    // var data = sharedPref.getBool('theoryTestPractice');

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
          print({'%value: ${_progressValue * 100}'});
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
  Future<List> getCategoriesFromApi() async {
    loading(value: true);
    categories = await test_api_services.getCategories();

    // http.Response.
    print('RESPONSE DATA :: $categories');
    loading(value: false);
    return categories;
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
    print("fetchUserTheoryProgress URL $api/api/fetch/progress/${driverId}");
    log("RESPONSE fetchUserTheoryProgress ++++++++++++++++ ${response.body}");
    return jsonDecode(response.body);
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

  // Future<List> getCategoriesFromApi() async {
  //   List response = await test_api_services.getCategories();
  //   return response;
  // }

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
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            // color: Colors.green,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ListView(
              padding: EdgeInsets.all(0),
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          isDismissible: false,
                          isScrollControlled: true,
                          constraints: BoxConstraints.expand(
                              height:
                                  MediaQuery.of(context).size.height * 0.80),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (context) {
                            return Container(
                              height: Responsive.height(55, context),
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('', style: _categoryTextStyle),
                                          Text('${_userName}\'s Progress:',
                                              style: _categoryTextStyle),
                                          InkWell(
                                              onTap: () =>
                                                  Navigator.pop(context),
                                              child: Icon(Icons.close,
                                                  color: AppColors.black)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(
                                              categories.length, (index) {
                                            // print("CATEGORY LIST :: ${categories_list}");
                                            print("CATEGORY :: ${categories}");
                                            return Column(
                                              children: [
                                                LinearPercentIndicatorWidget(
                                                  perTitle: categories[index]
                                                          ["theory_progress"]
                                                      .toDouble(),
                                                  // perTitle: "${((() * 100).toStringAsFixed(0))}%",
                                                  textTitle: categories[index]
                                                      ["name"],
                                                )
                                              ],
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                  ]),
                            );
                          });
/*
                          showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                insetAnimationCurve: Curves.easeOutBack,
                                insetPadding: EdgeInsets.all(20),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child:
                              ));*/
                    },
                    child: CircularPercentIndicator(
                      backgroundColor: Color(0xfff0f4ec),
                      // progressColor: Colors.red,
                      radius: 78,
                      lineWidth: 12,
                      circularStrokeCap: CircularStrokeCap.round,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xff78E6C9),
                            Color(0xff0E9BD0),
                          ]),
                      percent: _progressValue,
                      //progressColor: AppColors.primary,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Image.asset(
                              AppImages.Robot,
                              height: 60,
                              width: 60,
                            ),
                          ),
                          SizedBox(height: 5),
                          GradientText(
                            '${(((_progressValue) * 100).toStringAsFixed(0))}%',
                            colors: [
                              AppColors.blueGrad7,
                              AppColors.blueGrad6,
                              AppColors.blueGrad5,
                              AppColors.blueGrad4,
                              AppColors.blueGrad3,
                              //AppColors.blueGrad2,
                              AppColors.blueGrad1,
                            ],
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              decorationThickness: 2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Column(
                    //   children: [
                    //     Container(
                    //       padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
                    //       width: constraints.maxWidth,
                    //       //color: Colors.black26,
                    //       child: MCard.Card(
                    //         color: Colors.white,
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(10.0),
                    //         ),
                    //         elevation: 8.0,
                    //         child: Container(
                    //           width: constraints.maxWidth,
                    //           padding: EdgeInsets.symmetric(
                    //               horizontal: 10, vertical: 18),
                    //           child: Column(
                    //             children: <Widget>[
                    //               Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 children: [
                    //                   // Text("$api"),
                    //                   Text('THEORY LEARNING PROGRESS',
                    //                       style: TextStyle(
                    //                           fontFamily: 'Poppins',
                    //                           fontSize: 14,
                    //                           color: Dark,
                    //                           fontWeight: FontWeight.w700),
                    //                       textAlign: TextAlign.left),
                    //                   Text(
                    //                     '${(_progressValue * 100).round()}%',
                    //                     style: TextStyle(
                    //                         fontFamily: 'Poppins',
                    //                         fontSize: 14,
                    //                         color: Dark,
                    //                         fontWeight: FontWeight.w700),
                    //                     textAlign: TextAlign.left,
                    //                   ),
                    //                 ],
                    //               ),
                    //               SizedBox(height: 8),
                    //               LinearProgressIndicator(
                    //                 borderRadius: BorderRadius.circular(5),
                    //                 minHeight: 5,
                    //                 backgroundColor: Dark.withOpacity(0.2),
                    //                 valueColor:
                    //                     new AlwaysStoppedAnimation<Color>(
                    //                         Colors.red),
                    //                 value: _progressValue,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  //margin: EdgeInsets.zero,
                  //width: 155,
                  child: Text(
                    'Theory Learning \n Progress',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle
                        .copyWith(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
                SizedBox(height: 15),
                Divider(color: AppColors.black.withOpacity(0.05), thickness: 1),
                Container(
                  // width: Responsive.width(100, context),
                  // height: Responsive.height(44, context),
                  //height: constraints.maxHeight * 0.8,
                  // height: 420,
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.8),
                      // childAspectRatio: 2 / 3,
                    ),
                    //shrinkWrap: true,
                    itemCount: cards.length,
                    // scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onDoubleTap: () {},
                        onTap: () {
                          if (cards[index]["type"] == 'theoryTest') {
                            context.read<UserProvider>().changeView = true;
                            setState(() {});
                            print(
                                "auth_services.changeView ${context.read<UserProvider>().changeView}");
                            if (context.read<UserProvider>().changeView) {
                              // getCategoriesFromApi().then((response_list) {
                              //  responseList = response_list;
                              //  print("------------ responseList $responseList");
                              //  setState(() {});
                              // });
                              showDialog(
                                  useSafeArea: false,
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => PracticeTheoryTest());
                              // _navigationService
                              //     .navigateTo(routes.PracticeTheoryTestRoute);
                            } else {
                              _navigationService
                                  .navigateTo(routes.PracticeTheoryTestRoute);
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
                                builder: (context) => TheoryRecommendations(),
                              ),
                            ).then((value) {
                              print('QQQQQQQ $value');
                              if (value) {
                                initializeApi("Loading...");
                              }
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 12, bottom: 10, right: 12, left: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: AppColors.borderblue.withOpacity(0.5),
                                width: 1),
                          ),
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(10)),
                          // elevation: 3.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 0,
                                child: Center(
                                  child: Image.asset(cards[index]["icon"],
                                      height: 50),
                                ),
                              ),
                              SizedBox(height: 10),
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: Text("${cards[index]["title"]}"),
                              //     ),
                              //   ],
                              // ),
                              Expanded(
                                flex: 0,
                                child: RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    text: '${cards[index]["title"]}',
                                    style: AppTextStyle.boldStyle,
                                    children: [
                                      TextSpan(
                                        text: '→',
                                        style: TextStyle(
                                          fontSize: 25,
                                          height: 1,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 5),
                              Expanded(
                                //flex: 0,
                                child: Text(
                                  cards[index]["subTitle"],
                                  maxLines: 4,
                                  style: AppTextStyle.disStyle.copyWith(
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5,
                                      height: 1.2,
                                      fontSize: 11,
                                      overflow: TextOverflow.clip),
                                  softWrap: true,
                                  //  textAlign: TextAlign.justify,
                                ),
                              ),
                              //SizedBox(width: 15),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
                Divider(
                  color: AppColors.black.withOpacity(0.1),
                  thickness: 1,
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.only(left: 18),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: GradientText(
                      'Resources',
                      colors: [
                        AppColors.blueGrad7,
                        AppColors.blueGrad6,
                        AppColors.blueGrad5,
                        AppColors.blueGrad4,
                        AppColors.blueGrad3,
                        //AppColors.blueGrad2,
                        AppColors.blueGrad1
                      ],
                      style: AppTextStyle.textStyle
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height * 0.62,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 5),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.85),
                    ),
                    itemCount: _resourceCards.length,
                    //shrinkWrap: true,
                    itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                          color: AppColors.bgColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 15, bottom: 1, left: 15, right: 15),
                        child: GestureDetector(
                          onTap: () {
                            if (_resourceCards[index]["type"] ==
                                'highwayCode') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WebViewContainer(
                                          'https://www.gov.uk/guidance/the-highway-code',
                                          'Highway Code')));
                            } else if (_resourceCards[index]["type"] ==
                                'theoryTestGuidance') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WebViewContainer(
                                          'https://mockdrivingtest.com/static/practice-theory-test',
                                          'Theory Test Guidance')));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WebViewContainer(
                                          'https://www.gov.uk/book-theory-test',
                                          'Book DVSA Theory Test')));
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 2),
                                          child: Text(
                                              _resourceCards[index]["title"],
                                              style: AppTextStyle.textStyle
                                                  .copyWith(
                                                      height: 1.2,
                                                      fontWeight:
                                                          FontWeight.w500)
                                              //overflow: TextOverflow.ellipsis,
                                              ),
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      Expanded(
                                        flex: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (_resourceCards[index]["type"] ==
                                                'highwayCode') {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          WebViewContainer(
                                                              'https://www.gov.uk/guidance/the-highway-code',
                                                              'Highway Code')));
                                            } else if (_resourceCards[index]
                                                    ["type"] ==
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
                                          child: Image.asset(
                                            AppImages.rightArrow,
                                            height: 19,
                                            width: 20,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: EdgeInsets.only(right: 3),
                                    child: Text(
                                      _resourceCards[index]["subTitle"],
                                      maxLines: 3,
                                      style: AppTextStyle.disStyle.copyWith(
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.5,
                                          height: 1.2,
                                          fontSize: 11,
                                          overflow: TextOverflow.ellipsis),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                              Image.asset(
                                _resourceCards[index]['image'],
                                height: 75,
                                width: 150,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                // Container(
                //     height: Responsive.height(35, context),
                //     width: Responsive.width(100, context),
                //     //padding: EdgeInsets.all(8.0),
                //     child: LayoutBuilder(builder: (context, constraints) {
                //       return Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: <Widget>[
                //           Container(
                //             width: Responsive.width(100, context),
                //             height: Responsive.height(28, context),
                //             //height: constraints.maxHeight * 0.8,
                //             padding: EdgeInsets.fromLTRB(16, 5, 25, 5),
                //             child: ListView.builder(
                //                 itemCount: _resourceCards.length,
                //                 scrollDirection: Axis.horizontal,
                //                 itemBuilder: (context, index) {
                //                   return Container(
                //                     width:
                //                         SizeConfig.blockSizeHorizontal * 80,
                //                     child: MCard.Card(
                //                       shape: RoundedRectangleBorder(
                //                           borderRadius:
                //                               BorderRadius.circular(10)),
                //                       elevation: 3.0,
                //                       child: Container(
                //                         padding: EdgeInsets.symmetric(
                //                             vertical: 15, horizontal: 10),
                //                         child: Column(
                //                           crossAxisAlignment:
                //                               CrossAxisAlignment.center,
                //                           //mainAxisSize: MainAxisSize.max,
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.spaceEvenly,
                //                           children: [
                //                             Text(
                //                               _resourceCards[index]["title"],
                //                               style: TextStyle(
                //                                 fontSize: SizeConfig
                //                                         .blockSizeHorizontal *
                //                                     4,
                //                                 fontWeight: FontWeight.bold,
                //                               ),
                //                               overflow: TextOverflow.ellipsis,
                //                             ),
                //                             Text(
                //                               _resourceCards[index]
                //                                   ["subTitle"],
                //                               style: TextStyle(
                //                                 fontSize: SizeConfig
                //                                         .blockSizeHorizontal *
                //                                     3.5,
                //                                 //fontWeight: FontWeight.bold
                //                               ),
                //                               softWrap: true,
                //                               textAlign: _resourceCards[index]
                //                                           ["type"] ==
                //                                       'highwayCode'
                //                                   ? TextAlign.left
                //                                   : TextAlign.center,
                //                             ),
                //                             ElevatedButton(
                //                               onPressed: () {
                //                                 if (_resourceCards[index]
                //                                         ["type"] ==
                //                                     'highwayCode') {
                //                                   Navigator.push(
                //                                       context,
                //                                       MaterialPageRoute(
                //                                           builder: (context) =>
                //                                               WebViewContainer(
                //                                                   'https://www.gov.uk/guidance/the-highway-code',
                //                                                   'Highway Code')));
                //                                 } else if (_resourceCards[
                //                                         index]["type"] ==
                //                                     'theoryTestGuidance') {
                //                                   Navigator.push(
                //                                       context,
                //                                       MaterialPageRoute(
                //                                           builder: (context) =>
                //                                               WebViewContainer(
                //                                                   'https://mockdrivingtest.com/static/practice-theory-test',
                //                                                   'Theory Test Guidance')));
                //                                 } else {
                //                                   Navigator.push(
                //                                       context,
                //                                       MaterialPageRoute(
                //                                           builder: (context) =>
                //                                               WebViewContainer(
                //                                                   'https://www.gov.uk/book-theory-test',
                //                                                   'Book DVSA Theory Test')));
                //                                 }
                //                               },
                //                               style: ButtonStyle(
                //                                   backgroundColor:
                //                                       MaterialStateProperty
                //                                           .all(Dark)),
                //                               child: Text(
                //                                 _resourceCards[index]
                //                                     ["buttonText"],
                //                                 style: TextStyle(
                //                                     fontSize: SizeConfig
                //                                             .blockSizeHorizontal *
                //                                         3.5,
                //                                     color: Colors.white,
                //                                     fontWeight:
                //                                         FontWeight.w600
                //                                     //fontWeight: FontWeight.bold
                //                                     ),
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                   );
                //                 }),
                //           ),
                //         ],
                //       );
                //     })),
              ],
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
      builder: (context) => PopScope(
        canPop: false,
        child: Dialog(
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
                                fontSize:
                                    SizeConfig.blockSizeHorizontal * 4.5))),
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
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
