import 'dart:convert';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:student_app/views/AIRecommendations/TheoryRecommondation.dart';
import 'package:flutter/src/material/card.dart' as MCard;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:student_app/routing/route_names.dart' as routes;

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
import '../../widget/CustomSpinner.dart';
import '../WebView.dart';

class TheoryTab extends StatefulWidget {
  //final FirebaseUser user;
  //const HomeScreen({Key key, this.user}) : super( key: key);
  @override
  _TheoryTabState createState() => _TheoryTabState();
}

class _TheoryTabState extends State<TheoryTab> {
  var _progressValue = 0.0;
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
      'subTitle': 'To learn theory test topics.',
      'type': 'aiLearn',
      'buttonText': 'Learn'
    },
    {
      'icon': FontAwesomeIcons.clipboardCheck,
      'title': 'Practice Theory Test questions',
      'subTitle':
          'Understand the questions you will likely be\nasked in DVSA theory test',
      'type': 'theoryTest',
      'buttonText': 'Start'
    },
    {
      'icon': FontAwesomeIcons.car,
      'title': 'Practice Hazard Perception',
      'subTitle':
          'Understand the questions you will likely be asked \nin a hazard perception test',
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
      'subTitle':
          'The Highway Code is a rule book issues by the DVSA. The DVSA theory test tests learner drivers for understanding of these rules.',
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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.initializeApi("Loading...");
    });
  }

  Future<Map> getAllRecordsFromApi() async {
    Map response = await test_api_services.getAllRecords(2, userId!);
    return response;
  }

  initializeApi(String loaderMessage) {
    checkInternet();
    showLoader(loaderMessage);
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
        closeLoader();
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

  void showLoader(String message) {
    CustomSpinner.showLoadingDialog(context, _keyLoader, message);
  }

  Future<Map> fetchUserTheoryProgress(int driverId) async {
    final url = Uri.parse('$api/api/fetch/progress/${driverId}');
    //print("URL : $url");
    final response = await http.get(url);
    return jsonDecode(response.body);
  }

  void closeLoader() {
    try {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    } catch (e) {}
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              //color: Colors.amber,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 25, 25, 0),
                      child: Visibility(
                        visible: !isSubscribed,
                        child: Container(
                          width: constraints.maxWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                              begin: Alignment(0.0, -1.0),
                              end: Alignment(0.0, 1.0),
                              colors: [Dark, Light],
                              stops: [0.0, 1.0],
                            ),
                          ),
                          child: MCard.Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 0.0,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              //color: Dark,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Column(
                                    children: [
                                      Container(
                                        width: constraints.maxWidth,
                                        alignment: Alignment.centerLeft,
                                        //color: Colors.redAccent,
                                        child: Text(
                                          "Theory Test Practice Module",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: SizeConfig
                                                      .blockSizeHorizontal *
                                                  4.5),
                                        ),
                                      ),
                                      Container(
                                        width: constraints.maxWidth,
                                        margin: EdgeInsets.only(top: 10),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: constraints.maxWidth,
                                              //color: Colors.black38,
                                              margin:
                                                  EdgeInsets.only(bottom: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    //width: constraints.maxWidth*0.1,
                                                    //color: Colors.yellowAccent,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Icon(
                                                      Icons.check_circle,
                                                      size: SizeConfig
                                                              .blockSizeHorizontal *
                                                          4,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.02,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      width:
                                                          constraints.maxWidth *
                                                              0.9,
                                                      //color: Colors.cyanAccent,
                                                      child: Text(
                                                        "2000+ Questions from 14 official question categories set by DVSA.",
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: constraints.maxWidth,
                                              //color: Colors.black38,
                                              margin:
                                                  EdgeInsets.only(bottom: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    //width: constraints.maxWidth*0.1,
                                                    //color: Colors.yellowAccent,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Icon(
                                                      Icons.check_circle,
                                                      size: SizeConfig
                                                              .blockSizeHorizontal *
                                                          4,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.02,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      width:
                                                          constraints.maxWidth *
                                                              0.9,
                                                      //color: Colors.cyanAccent,
                                                      child: Text(
                                                        "Free Mock Theory tests to check your test readiness.",
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: constraints.maxWidth,
                                              //color: Colors.black38,
                                              margin:
                                                  EdgeInsets.only(bottom: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    //width: constraints.maxWidth*0.1,
                                                    //color: Colors.yellowAccent,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Icon(
                                                      Icons.check_circle,
                                                      size: SizeConfig
                                                              .blockSizeHorizontal *
                                                          4,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.02,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      width:
                                                          constraints.maxWidth *
                                                              0.9,
                                                      //color: Colors.cyanAccent,
                                                      child: Text(
                                                        "For each correct answer, earn 1 token! Answer 400 questions correctly and get your DVSA Theory Test free!",
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(top: 10),
                                        child: GestureDetector(
                                          onTap: () async {
                                            print("payment");
                                            showLoader("Processing payment");

                                            Stripe.publishableKey =
                                                stripePublic;
                                            Map params = {
                                              'total_cost': walletDetail![
                                                  'subscription_cost'],
                                              'user_type': 2,
                                              'parentPageName':
                                                  "dvsaSubscriptionHome"
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
                                                .then((value) => closeLoader());
                                            log("Called after payment");
                                          },
                                          child: Container(
                                            width: constraints.maxWidth * 0.8,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12),
                                            decoration: BoxDecoration(
                                              color: Dark,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Buy now",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: SizeConfig
                                                          .blockSizeHorizontal *
                                                      4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 25, 25, 0),
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
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Text("$api"),
                                      Text(
                                        'THEORY LEARNING PROGRESS',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          color: Dark,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        '${(_progressValue * 100).round()}%',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          color: Dark,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: LinearProgressIndicator(
                                    minHeight: 5,
                                    backgroundColor: Light,
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(Dark),
                                    value: _progressValue,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                    Container(
                      width: Responsive.width(100, context),
                      height: Responsive.height(24, context),
                      //height: constraints.maxHeight * 0.8,
                      padding: EdgeInsets.fromLTRB(16, 25, 25, 0),
                      child: ListView.builder(
                          itemCount: cards.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              width: SizeConfig.blockSizeHorizontal * 70,
                              child: MCard.Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            cards[index]["icon"],
                                            color: Dark,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            cards[index]["title"],
                                            style: TextStyle(
                                              fontSize: SizeConfig
                                                      .blockSizeHorizontal *
                                                  4,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        cards[index]["subTitle"],
                                        style: TextStyle(
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal *
                                                  3.5,
                                          //fontWeight: FontWeight.bold
                                        ),
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (cards[index]["type"] ==
                                              'theoryTest') {
                                            _navigationService.navigateTo(
                                                routes.PracticeTheoryTestRoute);
                                          } else if (cards[index]["type"] ==
                                              'hazard') {
                                            _navigationService.navigateTo(routes
                                                .HazardPerceptionOptionsRoute);
                                          } else if (cards[index]["type"] ==
                                              'dvsaMock') {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    WebViewContainer(
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
                                              if (value) {
                                                initializeApi("Loading...");
                                              }
                                            });
                                          }
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Dark)),
                                        child: Text(
                                          cards[index]["buttonText"],
                                          style: TextStyle(
                                              fontSize: SizeConfig
                                                      .blockSizeHorizontal *
                                                  3.5,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600
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
                                                  _resourceCards[index]
                                                      ["title"],
                                                  style: TextStyle(
                                                    fontSize: SizeConfig
                                                            .blockSizeHorizontal *
                                                        4,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                  textAlign:
                                                      _resourceCards[index]
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
              ),
            );
          },
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
