import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_app/Constants/app_colors.dart';
import 'package:student_app/routing/route_names.dart' as routes;
import 'package:student_app/views/DashboardGridView/Dashboard.dart';
import 'package:student_app/widget/navigation_drawer/navigation_drawer.dart'
    as NB;
import 'package:shared_preferences/shared_preferences.dart';

import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/auth.dart';
import '../../services/booking_test.dart';
import '../../services/navigation_service.dart';

class HomeScreen extends StatefulWidget {
  //final FirebaseUser user;
  //const HomeScreen({Key key, this.user}) : super( key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NavigationService _navigationService = locator<NavigationService>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final AuthProvider _authProvider = new AuthProvider();
  final BookingService _bookingService = BookingService();
  String? _userName;
  late Future<List> _recentBooking;
  late Future<String> _userEMail;

  Future<int?> getUserType() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    int? userType = 2; // storage.getInt('userType');
    return userType;
  }

  Future<String> getUserName() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String userName = storage.getString('userName').toString();
    return userName;
  }

  Future<String> getEMail() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String userEMail = storage.getString('eMail').toString();
    return userEMail;
  }

  Future<List> callApiGetRecentBooking() async {
    List bookings = await _bookingService.getRecentBookings();
    return bookings;
  }

  @override
  void initState() {
    super.initState();
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

    return Scaffold(
      drawer: NB.NavigationDrawer(),
      key: _scaffoldKey,
      //backgroundColor: Light,
      appBar: AppBar(
        //automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Welcome $_userName',
          style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 6,
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       //Navigator.pushNamed(context, routes.NotificationsRoute);
        //     },
        //     icon: const Icon(FontAwesomeIcons.solidBell),
        //   ),
        // ],
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
      ),
      body: SafeArea(
        child: Container(
          width: Responsive.width(100, context),
          height: Responsive.height(100, context),
          //color: Colors.amberAccent,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight,
                width: double.infinity,
                //color: Colors.amber,
                child: Dashboard(),
              );
            },
          ),
        ),
      ),
    );
  }

  Container _buildBottomSheet(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
          height: Responsive.height(25, context),
          width: Responsive.width(100, context),
          //padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 1.0),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Responsive.height(0, context)),
                topRight: Radius.circular(Responsive.height(0, context))),
            gradient: LinearGradient(
              begin: Alignment(0.0, -1.0),
              end: Alignment(0.0, 1.0),
              colors: [Dark, Light],
              stops: [0.0, 1.0],
            ),
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: <Widget>[
                Container(
                    //color: Colors.red,
                    width: constraints.maxWidth * 0.95,
                    margin: EdgeInsets.fromLTRB(
                        constraints.maxWidth * 0.025,
                        constraints.maxHeight * 0.05,
                        constraints.maxWidth * 0.025,
                        0.0),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            //color: Colors.black26,
                            width: constraints.maxWidth * 0.4,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                'My Bookings',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 30,
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Container(
                              //color: Colors.black26,
                              width: constraints.maxWidth * 0.12,
                              child: GestureDetector(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    'View all',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 40,
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                onTap: () {
                                  _navigationService
                                      .navigateTo(routes.MyBookingRoute);
                                },
                              )),
                        ],
                      );
                    })),
                Expanded(
                    child: FutureBuilder<dynamic>(
                        future: _recentBooking,
                        builder: (context, snapshot) {
                          List<dynamic> bookingList = snapshot.data ?? [];
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                                alignment: Alignment.center,
                                child:
                                    Center(child: CircularProgressIndicator()));
                          }
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              bookingList.length == 0) {
                            return Container(
                                margin: EdgeInsets.only(top: 50),
                                child: Text("No Booking",
                                    style: TextStyle(
                                        fontSize:
                                            2 * SizeConfig.blockSizeVertical,
                                        color: Colors.black38)));
                          }
                          if (snapshot.hasError) {
                            return Container(
                                margin: EdgeInsets.only(
                                    top: Responsive.height(20, context)),
                                child: Text("Network problem!",
                                    style: TextStyle(
                                        fontSize: 2.5 *
                                            SizeConfig.blockSizeVertical)));
                          }
                          return ListView.builder(
                              itemCount: bookingList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                Map _booking = bookingList[index];
                                DateTime requested_date =
                                    DateTime.parse(_booking["requested_date"]);
                                String requested_date_formate =
                                    requested_date.day.toString() +
                                        '-' +
                                        requested_date.month.toString() +
                                        '-' +
                                        requested_date.year.toString();
                                return Stack(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.fromLTRB(
                                            constraints.maxWidth * 0.05,
                                            constraints.maxHeight * 0.15,
                                            constraints.maxWidth * 0.02,
                                            0),
                                        height: constraints.maxHeight * 0.55,
                                        width: constraints.maxWidth * 0.55,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                constraints.maxHeight * 0.1)),
                                        child: LayoutBuilder(
                                            builder: (context, constraints) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                  height: constraints.maxHeight,
                                                  width: constraints.maxWidth *
                                                      0.3,
                                                  child: LayoutBuilder(builder:
                                                      (context, constraints) {
                                                    return Container(
                                                      //width: constraints.maxWidth*0.1,
                                                      //height: constraints.maxHeight*0.1,
                                                      margin: EdgeInsets.all(
                                                          constraints
                                                                  .maxHeight *
                                                              0.07),
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          shape:
                                                              BoxShape.circle),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              5, 4, 5, 0),
                                                      child: Center(
                                                        child: Container(
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.5,
                                                          //color: Colors.amber,
                                                          child: FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Text(
                                                              _booking[
                                                                  'booking_type'],
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'poppins',
                                                                fontSize: 50,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              //textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  })),
                                              Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  width: constraints.maxWidth *
                                                      0.7,
                                                  child: LayoutBuilder(builder:
                                                      (context, constraints) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                          //color: Colors.black26,
                                                          margin: EdgeInsets.fromLTRB(
                                                              constraints
                                                                      .maxWidth *
                                                                  0.025,
                                                              0,
                                                              constraints
                                                                      .maxWidth *
                                                                  0.025,
                                                              0),
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.9,
                                                          child: FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Text(
                                                              _booking['type'],
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 50.0,
                                                                color: const Color(
                                                                    0xff040404),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                height:
                                                                    0.7647058823529411,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: constraints
                                                                  .maxHeight *
                                                              0.1,
                                                        ),
                                                        Container(
                                                          //color: Colors.black26,
                                                          margin: EdgeInsets.fromLTRB(
                                                              constraints
                                                                      .maxWidth *
                                                                  0.025,
                                                              0,
                                                              constraints
                                                                      .maxWidth *
                                                                  0.025,
                                                              0),
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.7,
                                                          child: FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Text(
                                                              requested_date_formate +
                                                                  ' ' +
                                                                  (_booking['requested_time'] ==
                                                                          null
                                                                      ? 'Any Time'
                                                                      : _booking[
                                                                          'requested_time']),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 13,
                                                                color: const Color(
                                                                    0xff040404),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height:
                                                                    0.7647058823529411,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // SizedBox(
                                                        //     height: constraints
                                                        //             .maxHeight *
                                                        //         0.1),
                                                        // Container(
                                                        //   //color: Colors.black26,
                                                        //   margin: EdgeInsets.fromLTRB(
                                                        //       constraints
                                                        //               .maxWidth *
                                                        //           0.025,
                                                        //       0,
                                                        //       constraints
                                                        //               .maxWidth *
                                                        //           0.025,
                                                        //       0),
                                                        //   width: constraints
                                                        //           .maxWidth *
                                                        //       0.4,
                                                        //   child: FittedBox(
                                                        //     fit: BoxFit.contain,
                                                        //     child: Text(
                                                        //       'Pending',
                                                        //       style: TextStyle(
                                                        //         fontFamily:
                                                        //             'Poppins',
                                                        //         fontSize: 13,
                                                        //         color: const Color(
                                                        //             0xff040404),
                                                        //         fontWeight:
                                                        //             FontWeight
                                                        //                 .w700,
                                                        //         height:
                                                        //             0.7647058823529411,
                                                        //       ),
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                      ],
                                                    );
                                                  })),
                                            ],
                                          );
                                        })),
                                  ],
                                );
                              });
                        }))
              ],
            );
          })),
    );
  }
}
//class GridListExample extends StatelessWidget {
//  const GridListExample({Key key}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return GridView.count(
//      // Create a grid with 2 columns. If you change the scrollDirection to
//      // horizontal, this would produce 2 rows.
//      crossAxisCount: 2,
//      scrollDirection: Axis.vertical,
//      // Generate 100 Widgets that display their index in the List
//      children: List.generate(100, (index) {
//        return Center(
//          child: Container(
//            decoration: BoxDecoration(
//              border: Border.all(color: Colors.grey, width: 3.0),
//            ),
//            padding: const EdgeInsets.all(0.0),
//            child: Text(
//              'Item $index',
//              style: Theme.of(context).textTheme.headline5,
//            ),
//          ),
//        );
//      }),
//    );
//  }
//}
