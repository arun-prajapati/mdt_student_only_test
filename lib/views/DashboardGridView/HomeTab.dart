import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:student_app/routing/route_names.dart' as routes;
import 'package:flutter/src/material/card.dart' as MCard;
import '../../Constants/app_colors.dart';
import '../../Constants/global.dart';
import '../../locater.dart';
import '../../responsive/size_config.dart';
import '../../services/auth.dart';
import '../../services/booking_test.dart';
import '../../services/navigation_service.dart';
import '../../services/payment_services.dart';
import '../../services/practise_theory_test_services.dart';
import '../../style/global_style.dart';
import '../../widget/CustomSpinner.dart';

typedef void SendData(String action);

class HomeTab extends StatefulWidget {
  //final FirebaseUser user;
  //const HomeScreen({Key key, this.user}) : super( key: key);
  final SendData onDataChanged;

  const HomeTab({super.key, required this.onDataChanged});
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  var _theoryprogressValue = 0.0;
  var _practicalprogressValue = 0.0;

  final NavigationService _navigationService = locator<NavigationService>();
  late Future<List>? _recentBooking = null;
  final BookingService _bookingService = BookingService();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final PaymentService _paymentService = new PaymentService();
  final PractiseTheoryTestServices test_api_services =
      new PractiseTheoryTestServices();
  Map? walletDetail = null;
  List data = [];
  bool isLoading = true;
  int? userId;
  bool isSubscribed = true;
  String userName = '';

  Future<List> callApiGetRecentBooking() async {
    List bookings = await _bookingService.getRecentBookings();
    return bookings;
  }

  Future<Map?> getProgress() async {
    final url = Uri.parse("$api/api/lesson/progress");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final response = await http.get(url, headers: header);
    print(json.decode(response.body));
    Map data = json.decode(response.body);
    return data;
  }

  Future<Map> fetchUserTheoryProgress(int driverId) async {
    final url = Uri.parse('$api/api/fetch/progress/${driverId}');
    //print("URL : $url");
    final response = await http.get(url);
    return jsonDecode(response.body);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.initializeApi("Fetching Data");
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
        if (mounted) {
          setState(() {
            _theoryprogressValue = res["progress"].toDouble();
          });
        }
      });
      getProgress().then((res) {
        print(res);
        if (res!["success"] == true) {
          if (this.mounted) {
            setState(() {
              _practicalprogressValue = res["message"].toDouble();
            });
          }

          closeLoader();
        }
      });
    });
    callApiGetRecentBooking().then((value) {
      if (this.mounted) {
        setState(() {
          data = value;
          isLoading = false;
        });
      }
    });
  }

  void showLoader(String message) {
    CustomSpinner.showLoadingDialog(context, _keyLoader, message);
  }

  Future<Map> getUserDetail() async {
    Map response =
        await Provider.of<AuthProvider>(context, listen: false).getUserData();
    userName = "${response['first_name']} ${response['last_name']}";
    return response;
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
      //resizeToAvoidBottomInset: false,
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        //color: Colors.black12,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: constraints.maxHeight * 0.85,
                  //color: Colors.red,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              //height: constraints.maxHeight,
                              width: double.infinity,
                              padding: EdgeInsets.fromLTRB(16, 10, 25, 10),
                              //color: Colors.black12,
                              child: LayoutBuilder(
                                builder: (BuildContext context,
                                    BoxConstraints constraints) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Visibility(
                                        visible: !isSubscribed,
                                        child: Container(
                                          width: constraints.maxWidth,
                                          margin: EdgeInsets.only(bottom: 10),
                                          //height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
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
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            elevation: 0.0,
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 10),
                                              //color: Dark,
                                              child: LayoutBuilder(
                                                builder:
                                                    (context, constraints) {
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        width: constraints
                                                            .maxWidth,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        //color: Colors.redAccent,
                                                        child: Text(
                                                          "Theory Test Practice Module",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: SizeConfig
                                                                      .blockSizeHorizontal *
                                                                  4.5),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: constraints
                                                            .maxWidth,
                                                        margin: EdgeInsets.only(
                                                            top: 10),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              width: constraints
                                                                  .maxWidth,
                                                              //color: Colors.black38,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          8),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    //width: constraints.maxWidth*0.1,
                                                                    //color: Colors.yellowAccent,
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Icon(
                                                                      Icons
                                                                          .check_circle,
                                                                      size:
                                                                          SizeConfig.blockSizeHorizontal *
                                                                              4,
                                                                      color: Colors
                                                                          .green,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: constraints
                                                                            .maxWidth *
                                                                        0.02,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      width: constraints
                                                                              .maxWidth *
                                                                          0.9,
                                                                      //color: Colors.cyanAccent,
                                                                      child:
                                                                          Text(
                                                                        "2000+ Questions from 14 official question categories set by DVSA.",
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              width: constraints
                                                                  .maxWidth,
                                                              //color: Colors.black38,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          8),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    //width: constraints.maxWidth*0.1,
                                                                    //color: Colors.yellowAccent,
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Icon(
                                                                      Icons
                                                                          .check_circle,
                                                                      size:
                                                                          SizeConfig.blockSizeHorizontal *
                                                                              4,
                                                                      color: Colors
                                                                          .green,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: constraints
                                                                            .maxWidth *
                                                                        0.02,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      width: constraints
                                                                              .maxWidth *
                                                                          0.9,
                                                                      //color: Colors.cyanAccent,
                                                                      child:
                                                                          Text(
                                                                        "Free Mock Theory tests to check your test readiness.",
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              width: constraints
                                                                  .maxWidth,
                                                              //color: Colors.black38,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          8),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    //width: constraints.maxWidth*0.1,
                                                                    //color: Colors.yellowAccent,
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Icon(
                                                                      Icons
                                                                          .check_circle,
                                                                      size:
                                                                          SizeConfig.blockSizeHorizontal *
                                                                              4,
                                                                      color: Colors
                                                                          .green,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: constraints
                                                                            .maxWidth *
                                                                        0.02,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      width: constraints
                                                                              .maxWidth *
                                                                          0.9,
                                                                      //color: Colors.cyanAccent,
                                                                      child:
                                                                          Text(
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
                                                        alignment:
                                                            Alignment.center,
                                                        margin: EdgeInsets.only(
                                                            top: 10),
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            print("payment");
                                                            showLoader(
                                                                "Processing payment");

                                                            Stripe.publishableKey =
                                                                stripePublic;
                                                            Map params = {
                                                              'total_cost':
                                                                  walletDetail![
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
                                                                    currency:
                                                                        'GBP',
                                                                    context:
                                                                        context,
                                                                    desc:
                                                                        'DVSA Subscription by ${userName} (App)',
                                                                    metaData:
                                                                        params)
                                                                .then((value) =>
                                                                    closeLoader());
                                                            log("Called after payment");
                                                          },
                                                          child: Container(
                                                            width: constraints
                                                                    .maxWidth *
                                                                0.8,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        12),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Dark,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    5),
                                                              ),
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "Buy now",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      SizeConfig
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
                                      Container(
                                        //color: Colors.red,
                                        width: constraints.maxWidth,
                                        margin: EdgeInsets.only(top: 10),
                                        child: Text(
                                          'YOUR PROGRESS',
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
                                        width: constraints.maxWidth,
                                        margin: EdgeInsets.only(top: 5),
                                        //color: Colors.black26,
                                        child: MCard.Card(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          elevation: 5.0,
                                          child: Container(
                                            // constraints: BoxConstraints(
                                            //   maxHeight: 200
                                            // ),
                                            width: constraints.maxWidth,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 18),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // Text("$api"),
                                                      Text(
                                                        'THEORY LEARNING PROGRESS',
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      Text(
                                                        '${(_theoryprogressValue * 100).round()}%',
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child:
                                                      LinearProgressIndicator(
                                                    minHeight: 5,
                                                    backgroundColor: Colors.grey
                                                        .withOpacity(0.5),
                                                    valueColor:
                                                        new AlwaysStoppedAnimation<
                                                            Color>(Dark),
                                                    value: _theoryprogressValue,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // Text("$api"),
                                                      Text(
                                                        'PRACTICAL LEARNING PROGRESS',
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      Text(
                                                        '${(_practicalprogressValue * 100).round()}%',
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child:
                                                      LinearProgressIndicator(
                                                    minHeight: 5,
                                                    backgroundColor: Colors.grey
                                                        .withOpacity(0.5),
                                                    valueColor:
                                                        new AlwaysStoppedAnimation<
                                                            Color>(Dark),
                                                    value:
                                                        _practicalprogressValue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        //color: Colors.red,
                                        width: constraints.maxWidth,
                                        margin: EdgeInsets.only(top: 20),
                                        child: Text(
                                          'QUICK LINKS',
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
                                        width: constraints.maxWidth,
                                        //color: Colors.black26,
                                        margin: EdgeInsets.only(top: 5),
                                        child: MCard.Card(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          elevation: 5.0,
                                          child: Container(
                                            width: constraints.maxWidth,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 12),
                                            child: LayoutBuilder(
                                              builder: (context, constraints) {
                                                return Row(
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: () {
                                                        widget.onDataChanged(
                                                            "course");
                                                      },
                                                      child: Container(
                                                        width: constraints
                                                                .maxWidth *
                                                            0.2,
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        //color:Colors.redAccent,
                                                        child: Column(
                                                          children: [
                                                            Icon(
                                                              FontAwesomeIcons
                                                                  .book,
                                                            ),
                                                            SizedBox(
                                                              height: 8,
                                                            ),
                                                            Text(
                                                              "Book Course",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    //SizedBox(width: constraints.maxWidth*0.05,),
                                                    InkWell(
                                                      onTap: () async {
                                                        _navigationService
                                                            .navigateTo(routes
                                                                .PracticeTheoryTestRoute);
                                                      },
                                                      child: Container(
                                                        width: constraints
                                                                .maxWidth *
                                                            0.3,
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        //color:Colors.redAccent,
                                                        child: Column(
                                                          children: [
                                                            Icon(FontAwesomeIcons
                                                                .clipboardCheck),
                                                            SizedBox(
                                                              height: 8,
                                                            ),
                                                            Text(
                                                              "Theory Test Premium",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            )
                                                          ],
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
                                      Container(
                                        //color: Colors.red,
                                        width: constraints.maxWidth,
                                        margin: EdgeInsets.only(top: 20),
                                        child: Text(
                                          'RECENT BOOKINGS',
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
                                        constraints: const BoxConstraints(
                                          maxHeight: 400,
                                          minHeight: 100,
                                        ),
                                        margin: EdgeInsets.only(top: 5),
                                        width: double.infinity,
                                        //color: Colors.red,
                                        child: MCard.Card(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          elevation: 5.0,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 18,
                                            ),
                                            child: isLoading
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Dark,
                                                    ),
                                                  )
                                                : data.isEmpty
                                                    ? Center(
                                                        child: Text("No Data"),
                                                      )
                                                    : ListView.builder(
                                                        itemCount: data.length,
                                                        //padding: EdgeInsets.symmetric(vertical: 5),
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          // Map _booking = bookingList[index];
                                                          // DateTime requested_date =
                                                          // DateTime.parse(_booking["requested_date"]);
                                                          // String requested_date_formate =
                                                          //     requested_date.day.toString() +
                                                          //         '-' +
                                                          //         requested_date.month.toString() +
                                                          //         '-' +
                                                          //         requested_date.year.toString();
                                                          return MCard.Card(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            margin:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        5),
                                                            elevation: 3,
                                                            child: ListTile(
                                                              //minLeadingWidth: 50,
                                                              leading:
                                                                  CircleAvatar(
                                                                radius: 30,
                                                                backgroundColor:
                                                                    Dark,
                                                                child: Text(
                                                                  "${data[index]["booking_type"]}",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                              title: Column(
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: AutoSizeText(
                                                                        data[index]
                                                                            [
                                                                            "type"],
                                                                        style: headingStyle(SizeConfig
                                                                            .headingFontSize),
                                                                        textAlign:
                                                                            TextAlign.left),
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child:
                                                                        FractionallySizedBox(
                                                                      widthFactor:
                                                                          1,
                                                                      child:
                                                                          Container(
                                                                        //color: Colors.black26,
                                                                        padding: const EdgeInsets.fromLTRB(
                                                                            0,
                                                                            2,
                                                                            5,
                                                                            1),
                                                                        child: AutoSizeText(
                                                                            data[index]["requested_date"] +
                                                                                " " +
                                                                                data[index]["requested_time"],
                                                                            style: subHeadingStyle(SizeConfig.subHeading2FontSize),
                                                                            textAlign: TextAlign.left),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Row(
                                                                      children: [
                                                                        data[index]["postcode"] !=
                                                                                null
                                                                            ? InkWell(
                                                                                onTap: () async {
                                                                                  // print(bookingList[index]);
                                                                                  // _map.openMap(
                                                                                  //     "${bookingList[index]["location"]},${bookingList[index]["postcode"]}");
                                                                                },
                                                                                child: Container(
                                                                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                                                                  child: Text(
                                                                                    data[index]["postcode"],
                                                                                    style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 13),
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(15.0),
                                                                                    color: Dark,
                                                                                  ),
                                                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                                ),
                                                                              )
                                                                            : Text(
                                                                                '',
                                                                              ),
                                                                        SizedBox(
                                                                          width:
                                                                              SizeConfig.blockSizeHorizontal * 1,
                                                                        ),
                                                                        data[index]["name"].length >
                                                                                2
                                                                            ? Container(
                                                                                margin: const EdgeInsets.symmetric(vertical: 5),
                                                                                child: Text(
                                                                                  data[index]["name"],
                                                                                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 13),
                                                                                ),
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(15.0),
                                                                                  color: Dark,
                                                                                ),
                                                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                              )
                                                                            : Container(
                                                                                margin: const EdgeInsets.symmetric(vertical: 5),
                                                                                child: Text(
                                                                                  "Not assigned yet",
                                                                                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 13),
                                                                                ),
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(15.0),
                                                                                  color: Dark,
                                                                                ),
                                                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                              ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          5),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: constraints.maxHeight * 0.15,
                  //color: Colors.amberAccent,
                  padding: EdgeInsets.symmetric(
                      //horizontal: 10,
                      vertical: constraints.maxHeight * 0.04),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return MaterialButton(
                        onPressed: () {
                          _navigationService.navigateTo(routes.MyBookingRoute);
                        },
                        child: Container(
                          height: constraints.maxHeight,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Dark,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: Text(
                            'MANAGE BOOKINGS',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 2.0 * SizeConfig.blockSizeVertical,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(255, 255, 255, 1.0),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
