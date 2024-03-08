import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Smart_Theory_Test/routing/route_names.dart' as routes;
import 'package:Smart_Theory_Test/views/AIRecommendations/Recommendations.dart';

import '../../Constants/app_colors.dart';
import '../../Constants/global.dart';
import '../../locater.dart';
import '../../my_flutter_app_icons.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/auth.dart';
import '../../services/booking_test.dart';
import '../../services/navigation_service.dart';
import '../../widget/CustomSpinner.dart';
import '../WebView.dart';

class PracticalTab extends StatefulWidget {
  //final FirebaseUser user;
  //const HomeScreen({Key key, this.user}) : super( key: key);
  @override
  _PracticalTabState createState() => _PracticalTabState();
}

class _PracticalTabState extends State<PracticalTab> {
  var _progressValue = 0.0;
  final NavigationService _navigationService = locator<NavigationService>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final BookingService _bookingService = new BookingService();
  List courses = [];
  int userId = 0;
  List cards = [
    {
      'icon': MyFlutterApp.ai_hand,
      'title': 'AI assessment',
      'subTitle':
          'Using our smart AI engine get tailored assessment on how to improve your driving.',
      'type': 'aiRecommendations',
      'buttonText': 'Start'
    },
  ];

  @override
  void initState() {
    super.initState();
    //showLoader("Fetching courses");
    Provider.of<UserProvider>(context, listen: false)
        .getUserData()
        .then((res) => {userId = res['id']});
    _bookingService.getCoursesNameList('').then((courseList) {
      getProgress().then((res) {
        print(res);
        if (res!["success"] == true) {
          if (this.mounted) {
            setState(() {
              courses = courseList;
              _progressValue = res["message"].toDouble();
              print(courses);
            });
          }

          //closeLoader();
        }
      });
    });
    /* Future.delayed(Duration.zero, () {
      this.initializeApi("Loading...");
    }); */
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

  // initializeApi(String loaderMessage) {
  //   checkInternet();
  //   showLoader(loaderMessage);
  //
  //   setState(() {});
  //   closeLoader();
  // }

  void showLoader(String message) {
    CustomSpinner.showLoadingDialog(context, _keyLoader, message);
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
                    Container(
                      // constraints: const BoxConstraints(
                      //     maxHeight: 200, minHeight: 100),
                      margin: EdgeInsets.only(top: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      //margin: EdgeInsets.only(top: 10),
                      width: double.infinity,
                      //color: Colors.black26,
                      child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 8.0,
                          child: Container(
                            // constraints: BoxConstraints(
                            //   maxHeight: 200
                            // ),
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
                                      Text(
                                        'PRACTICAL LEARNING PROGRESS',
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
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Your progress report",
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.blockSizeHorizontal *
                                                    3.5,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600
                                            //fontWeight: FontWeight.bold
                                            ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WebViewContainer(
                                                          '$api/report-details?user_id=' +
                                                              userId.toString(),
                                                          'Progress Report')));
                                        },
                                        child: Text(
                                          "View Report",
                                          style: TextStyle(
                                              fontSize: SizeConfig
                                                      .blockSizeHorizontal *
                                                  3.5,
                                              color: Dark,
                                              fontWeight: FontWeight.w600
                                              //fontWeight: FontWeight.bold
                                              ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                                // Container(
                                //     width: constraints.maxWidth * 1.7,
                                //     height: constraints.maxHeight * 0.34,
                                //     margin: EdgeInsets.fromLTRB(
                                //         0,
                                //         constraints.maxHeight * 0.01,
                                //         0,
                                //         constraints.maxHeight * 0.1),
                                //     child: HomeStatsCardTab(
                                //       heading1:
                                //           'Improve your driving with \nour AI assessment',
                                //       heading2: 'Improve your chances of passing',
                                //       icon: MyFlutterApp.ai_hand,
                                //       data:
                                //           'Using our smart AI engine get tailored assessment on how to improve your driving.',
                                //       btn1: 'Upload',
                                //       onTapbtn1: () {
                                //         _navigationService.navigateTo(
                                //             routes.LessonRecommendationsRoute);
                                //       },
                                //     )),
                              ],
                            ),
                          )),
                    ),
                    Container(
                      //height: Responsive.height(50, context),
                      width: Responsive.width(100, context),
                      //padding: EdgeInsets.all(8.0),
                      //color: Colors.black12,
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            //height: 50,
                            //color: Colors.red,
                            //width: constraints.maxWidth * 0.97,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),

                            child: Text(
                              'COURSES',
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: courses.isEmpty
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Dark,
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: courses.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width:
                                            SizeConfig.blockSizeHorizontal * 80,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          elevation: 3.0,
                                          child: Container(
                                            // width:
                                            height:
                                                Responsive.width(60, context),
                                            // height: 100,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              //mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  courses[index]['course'],
                                                  style: TextStyle(
                                                      fontSize: SizeConfig
                                                              .blockSizeHorizontal *
                                                          4,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                // SizedBox(
                                                //   height: 10,
                                                // ),
                                                Text(
                                                  courses[index][
                                                          'short_description'] ??
                                                      "",
                                                  style: TextStyle(
                                                    fontSize: SizeConfig
                                                            .blockSizeHorizontal *
                                                        3.5,
                                                    //fontWeight: FontWeight.bold
                                                  ),
                                                  //softWrap: true,
                                                  textAlign: TextAlign.center,
                                                  softWrap: true,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    if (courses[index]
                                                            ['static_page'] ==
                                                        'mock-driving-test') {
                                                      _navigationService
                                                          .navigateTo(routes
                                                              .BookTestFormRoute);
                                                    } else {
                                                      //print(courses[index]);
                                                      _navigationService.navigateTo(
                                                          routes
                                                              .BookLessionFormRoute,
                                                          arguments: {
                                                            'courseId':
                                                                courses[index]
                                                                    ["id"],
                                                            'name':
                                                                courses[index]
                                                                    ["course"],
                                                          });
                                                    }
                                                  },
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Dark)),
                                                  child: Text(
                                                    'BOOK',
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
                                                // InkWell(
                                                //   onTap: (){
                                                //     if(courses[index]['static_page'] == 'mock-driving-test'){
                                                //       _navigationService
                                                //           .navigateTo(routes.BookTestFormRoute);
                                                //     }
                                                //     else{
                                                //       //print(courses[index]);
                                                //       _navigationService
                                                //           .navigateTo(routes.BookLessionFormRoute,arguments: {
                                                //         'courseId' : courses[index]["id"],
                                                //         'name' : courses[index]["course"],
                                                //
                                                //       });
                                                //     }
                                                //   },
                                                //   child: Text(
                                                //     "BOOK",
                                                //     style: TextStyle(
                                                //         fontSize: SizeConfig.blockSizeHorizontal*3.5,
                                                //         color: Dark,
                                                //         fontWeight: FontWeight.w600
                                                //       //fontWeight: FontWeight.bold
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                          ),
                          Container(
                            width: double.infinity,
                            //height: 50,
                            //color: Colors.red,
                            //width: constraints.maxWidth * 0.97,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),

                            child: Text(
                              'OUR SERVICES',
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
                            height: Responsive.height(24, context),
                            //height: constraints.maxHeight * 0.8,
                            padding:
                                EdgeInsets.only(left: 10, top: 10, bottom: 10),
                            child: ListView.builder(
                                //padding: EdgeInsets.zero,
                                itemCount: cards.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: SizeConfig.blockSizeHorizontal * 95,
                                    child: Card(
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
                                            Container(
                                              width: double.infinity,
                                              //color: Colors.black12,
                                              child: LayoutBuilder(
                                                builder:
                                                    (context, constraints) {
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    //mainAxisSize: MainAxisSize.,
                                                    children: [
                                                      Container(
                                                        width: constraints
                                                                .maxWidth *
                                                            0.15,
                                                        child: Icon(
                                                          cards[index]["icon"],
                                                          color: Dark,
                                                          size: 30,
                                                        ),
                                                      ),
                                                      Container(
                                                        //color: Colors.black26,
                                                        width: constraints
                                                                .maxWidth *
                                                            0.85,
                                                        child: Text(
                                                          cards[index]["title"],
                                                          // softWrap: true,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontSize: SizeConfig
                                                                      .blockSizeHorizontal *
                                                                  4,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),

                                            // SizedBox(
                                            //   height: 10,
                                            // ),
                                            Text(
                                              cards[index]["subTitle"],
                                              style: TextStyle(
                                                fontSize: SizeConfig
                                                        .blockSizeHorizontal *
                                                    3.5,
                                                //fontWeight: FontWeight.bold
                                              ),
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                if (cards[index]["type"] ==
                                                    'aiRecommendations') {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Recommendations()),
                                                  );
                                                  // Navigator.push(context, MaterialPageRoute(
                                                  //     builder: (context)=>LessonRecommendations()
                                                  // ),);
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
                        ],
                      ),
                    ),

                    // Container(
                    //   height: Responsive.height(30, context),
                    //   width: Responsive.width(100, context),
                    //   //padding: EdgeInsets.all(8.0),
                    //   //color: Colors.black12,
                    //
                    //   child: LayoutBuilder(builder: (context, constraints) {
                    //     return Column(
                    //       children: <Widget>[
                    //         Container(
                    //           //color: Colors.red,
                    //           width: constraints.maxWidth * 0.95,
                    //           margin: EdgeInsets.fromLTRB(
                    //               constraints.maxWidth * 0.04,
                    //               constraints.maxHeight * 0.0,
                    //               constraints.maxWidth * 0.025,
                    //               0.0),
                    //
                    //           child: Text(
                    //             'TOOLS',
                    //             style: TextStyle(
                    //               fontFamily: 'Poppins',
                    //               fontSize: 16,
                    //               color: Dark,
                    //               fontWeight: FontWeight.w700,
                    //             ),
                    //             textAlign: TextAlign.left,
                    //           ),
                    //         ),
                    //         Container(
                    //           width: constraints.maxWidth * 1.4,
                    //           height: constraints.maxHeight * 0.85,
                    //           margin: EdgeInsets.fromLTRB(
                    //               constraints.maxWidth * 0.04,
                    //               constraints.maxHeight * 0.01,
                    //               constraints.maxWidth * 0.07,
                    //               constraints.maxHeight * 0.0),
                    //           child: LayoutBuilder(
                    //               builder: (context, constraints) {
                    //             return Card(
                    //               shape: RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(
                    //                       constraints.maxWidth * 0.01)),
                    //               elevation: 10.0,
                    //               child: Column(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: <Widget>[
                    //                   Container(
                    //                       width: constraints.maxWidth,
                    //                       height: constraints.maxHeight * 0.4,
                    //                       //color: Colors.black26,
                    //                       child: Image.asset(
                    //                         "assets/loginform-bg.jpg",
                    //                         height:
                    //                             SizeConfig.blockSizeVertical *
                    //                                 15,
                    //                         width:
                    //                             SizeConfig.blockSizeHorizontal *
                    //                                 15,
                    //                         // fit: BoxFit.cover,
                    //                       )),
                    //                   Container(
                    //                     width: constraints.maxWidth,
                    //                     // height: constraints.maxHeight * 0.4,
                    //                     // alignment: Alignment.centerLeft,
                    //                     margin: EdgeInsets.fromLTRB(
                    //                         constraints.maxWidth * 0.04,
                    //                         constraints.maxWidth * 0.05,
                    //                         constraints.maxWidth * 0.0,
                    //                         constraints.maxWidth * 0.01),
                    //                     child: Text(
                    //                       'Highway Code',
                    //                       style: TextStyle(
                    //                           fontFamily: 'Poppins',
                    //                           fontSize: 17,
                    //                           color: Color(0xff060606),
                    //                           fontWeight: FontWeight.w700),
                    //                     ),
                    //                   ),
                    //                   Container(
                    //                     width: constraints.maxWidth,
                    //                     // height: constraints.maxHeight * 0.4,
                    //                     // alignment: Alignment.centerLeft,
                    //                     margin: EdgeInsets.fromLTRB(
                    //                         constraints.maxWidth * 0.04,
                    //                         constraints.maxWidth * 0.0,
                    //                         constraints.maxWidth * 0.0,
                    //                         constraints.maxWidth * 0.05),
                    //                     child: Text(
                    //                       'Read and understand the highway code',
                    //                       style: TextStyle(
                    //                         fontFamily: 'Poppins',
                    //                         fontSize: 14,
                    //                         color: Color(0xff060606),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Container(
                    //                       // width: constraints.maxWidth,
                    //                       // height: constraints.maxHeight * 0.4,
                    //                       // alignment: Alignment.centerLeft,
                    //
                    //                       child: Row(children: <Widget>[
                    //                     Container(
                    //                       margin: EdgeInsets.fromLTRB(
                    //                           constraints.maxWidth * 0.04,
                    //                           constraints.maxWidth * 0.0,
                    //                           constraints.maxWidth * 0.0,
                    //                           0.0),
                    //                       child: RichText(
                    //                           text: TextSpan(
                    //                               text: "REVISE NOW",
                    //                               style: TextStyle(
                    //                                   fontFamily: 'Poppins',
                    //                                   fontSize: 14,
                    //                                   color: Dark,
                    //                                   fontWeight:
                    //                                       FontWeight.w700),
                    //                               recognizer:
                    //                                   TapGestureRecognizer()
                    //                                     ..onTap = () {
                    //                                       _navigationService
                    //                                           .navigateTo(routes
                    //                                               .HighwayCodeRoute);
                    //                                     })),
                    //                     ),
                    //                     Container(
                    //                       alignment: Alignment.bottomRight,
                    //                       margin: EdgeInsets.fromLTRB(
                    //                           constraints.maxWidth * 0.55,
                    //                           constraints.maxWidth * 0.0,
                    //                           constraints.maxWidth * 0.0,
                    //                           0.0),
                    //                       child: Icon(
                    //                         MdiIcons.heart,
                    //                         color: const Color(0xff0e9bcf),
                    //                       ),
                    //                     ),
                    //                   ])),
                    //                 ],
                    //               ),
                    //             );
                    //           }),
                    //         ),
                    //       ],
                    //     );
                    //   }),
                    // ),
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
