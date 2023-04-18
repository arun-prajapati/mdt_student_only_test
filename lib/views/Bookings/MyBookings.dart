
import 'package:flutter/gestures.dart';
import 'package:student_app/Constants/app_colors.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_app/views/Calendar/calendar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Constants/global.dart';
import '../../locater.dart';
import 'dart:async';

import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/auth.dart';
import '../../services/booking_test.dart';
import '../../services/navigation_service.dart';
import '../../style/global_style.dart';
import '../../widget/CustomSwitch/CustomSwitch.dart';
import '../Chat/chatView.dart';
import '../WebView.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyBooking();
}

enum FilterType { Accepted, Rejected, Completed, Assigned }

class _MyBooking extends State<MyBooking> {
  final GlobalKey<State> _keyPopupMenu = new GlobalKey<State>();
  // Location location = Location();
  final NavigationService _navigationService = locator<NavigationService>();
  final BookingService _bookingService = BookingService();
  //final LocationService _locationService = new LocationService();
  int pageNumber = 1;
  String filterType = 'accepted';
  ValueNotifier<FilterType> _selectedItem =
      new ValueNotifier<FilterType>(FilterType.Accepted);
  late Map data;
  late ScrollController controller;
  bool isDataLoading = false;
  bool isMoreLoading = false;
  bool isMorePage = true;
  late bool isPassAssist;
  late bool isTest;
  late bool isReportSubmitted;
  late Color bookingTypeColor;
  late AuthProvider authProvider;
  int? _userId;
  bool isChatAvailable = false;
  bool notDataFound = false;
  List bookingList = [];
  // late UserLocation _currentLoc;
  late bool track;
  String? subCourse;

  //late PermissionStatus granted;
  late StreamSubscription<dynamic>? dataSub;

  late String _url;

  Future<int?> getUserType() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    int? userType = storage.getInt('userType');
    return userType;
  }

  Future<Map> getUserDetail() async {
    Map response =
        await Provider.of<AuthProvider>(context, listen: false).getUserData();
    // _userId = response['id'];
    return response;
  }

  // Future<UserLocation> locationData(
  //     String bookingId, String bookingType) async {
  //   try {
  //     _currentLoc = await _locationService.getUserLocation();
  //     if (track) {
  //       final url = Uri.parse("$api/api/adi/location/add");
  //       Map<String, dynamic> body = {
  //         'bookingId': bookingId,
  //         'bookingType': bookingType,
  //         'latitude': _currentLoc.latitude,
  //         'longitude': _currentLoc.longitude
  //       };
  //       print(body);
  //       final response = await http.post(
  //         url,
  //         body: body,
  //       );
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //
  //   return _currentLoc;
  // }

  bool chatAvailibility(String date) {
    DateTime parsedDate = DateFormat("yyyy-MM-dd hh:mma").parse(date);
    String bdt = DateFormat("yyyy-MM-dd HH:mm").format(parsedDate);
    DateTime parsedBdt = DateTime.parse(bdt);
    String cdt = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
    DateTime parsedCdt = DateTime.parse(cdt);
    var diff = parsedBdt.difference(parsedCdt);
    print("Difference in hours(for messaging)..." + diff.inHours.toString());
    if (diff.inHours <= 24 && diff.inHours > 0) {
      return true;
    }
    if (diff.inHours < 0 && diff.inHours >= -24) {
      return true;
    }
    return false;
  }

  showValidationDialog(BuildContext context, String message) {
    //print("valid");
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Mock Driving Test'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }

  refresh() {}

  @override
  void initState() {
    _bookingService.setType('upcoming');
    getUserDetail().then((userDetails) {
      _userId = userDetails["id"];
    });
    setState(() {
      isDataLoading = true;
    });
    loadBookingWithApi();

    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadBookingWithApi() {
    if (_bookingService.type == 'upcoming') {
      callApiGetUpcomingBooking();
    }
    if (_bookingService.type == 'past') {
      callApiGetPastBooking();
    }
  }

  void _launchURL() async {
    print("hello");
    try {
      await launch(_url);
    } catch (e) {
      print(e);
    }
  }
  //await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  bool bookingDiffDate(String date) {
    DateTime parsedDate = DateFormat("yyyy-MM-dd hh:mma").parse(date);
    String bdt = DateFormat("yyyy-MM-dd HH:mm").format(parsedDate);
    DateTime parsedBdt = DateTime.parse(bdt);
    String cdt = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
    DateTime parsedCdt = DateTime.parse(cdt);
    var diff = parsedBdt.difference(parsedCdt);
    // print(diff.isNegative);
    print("Difference in hours(for report)..." + diff.inHours.toString());
    if (diff.inHours <= 0) {
      return true;
    }
    return false;
  }

  bool diffDate(String date) {
    DateTime parsedDate = DateFormat("yyyy-MM-dd hh:mma").parse(date);
    String bdt = DateFormat("yyyy-MM-dd HH:mm").format(parsedDate);
    DateTime parsedBdt = DateTime.parse(bdt);
    String cdt = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
    DateTime parsedCdt = DateTime.parse(cdt);
    var diff = parsedBdt.difference(parsedCdt);
    print("Difference in hours(for details)..." + diff.inHours.toString());
    if (diff.inHours < 24) {
      return true;
    }
    return false;
  }

  String diffDate1(String date) {
    DateTime parsedDate = DateFormat("yyyy-MM-dd hh:mma").parse(date);
    String bdt = DateFormat("yyyy-MM-dd HH:mm").format(parsedDate);
    DateTime parsedBdt = DateTime.parse(bdt);
    String cdt = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
    DateTime parsedCdt = DateTime.parse(cdt);
    var diff = parsedBdt.difference(parsedCdt);
    if (!diff.isNegative) {
      if (diff.inHours == 0 && diff.inMinutes <= 10) {
        return 'showButton';
      }
      return 'hideButton';
    }
    return 'hideButton';
  }

  Future<void> callApiGetPastBooking() async {
    dataSub = _bookingService
        .getPastBookings(pageNumber, filterType)
        .asStream()
        .listen((Map? bookingRecords) {
      addBookingInList(bookingRecords);
    });
  }

  Future<void> callApiGetUpcomingBooking() async {
    dataSub = _bookingService
        .getFutureBookings(pageNumber, filterType)
        .asStream()
        .listen((Map? bookingRecords) {
      addBookingInList(bookingRecords);
    });
  }

  addBookingInList(Map? bookingRecords) {
    if (bookingRecords != null) {
      setState(() {
        isDataLoading = false;
        isMoreLoading = false;
        if (bookingRecords['last_page'] == bookingRecords['current_page']) {
          isMorePage = false;
        }
        bookingRecords['data'].forEach((booking) {
          bookingList.add(booking);
        });
      });
    } else {
      setState(() {
        isDataLoading = false;
      });
    }
  }

  String getSelectedFilter(FilterType filterValue) {
    switch (filterValue) {
      case FilterType.Accepted:
        return 'accepted';
        break;
      case FilterType.Rejected:
        return 'rejected';
        break;
      case FilterType.Completed:
        return 'report_submitted';
        break;
      case FilterType.Assigned:
        return 'assigned';
        break;
    }
  }

  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent &&
        isMorePage) {
      setState(() {
        pageNumber += 1;
        isMoreLoading = !isMoreLoading;
        startLoader();
      });
    }
  }

  void startLoader() {
    if (_bookingService.type == 'upcoming') {
      callApiGetUpcomingBooking();
    }
    if (_bookingService.type == 'past') {
      callApiGetPastBooking();
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_userId);
    SizeConfig().init(context);
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Container(
        width: Responsive.width(100, context),
        height: Responsive.height(3, context),
        child: Center(
          child: Text(
            'Lesson tracking start',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: Responsive.width(100, context) * 0.04,
            ),
          ),
        ),
      ),
      duration: Duration(seconds: 1, milliseconds: 500),
      backgroundColor: Colors.green,
    );

    return Scaffold(
        //backgroundColor: Light,
        appBar: AppBar(
          //automaticallyImplyLeading: true,
          title: Text(
            'My Bookings',
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
          ),

          elevation: 0.0,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Calender(),
                  ),
                );
              },
              icon: Icon(
                FontAwesomeIcons.calendarDay,
              ),
            )
          ],
          flexibleSpace: Container(
            decoration:  BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.0, -1.0),
                end: Alignment(0.0, 1.0),
                colors: [Dark, Light],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        ),
        body: Container(
          width: Responsive.width(100, context),
          height: Responsive.height(100, context),
          padding: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)),
          ),
          child: Container(
            width: Responsive.width(100, context),
            height: Responsive.height(80, context),
            margin: EdgeInsets.fromLTRB(
                Responsive.width(5, context),
                Responsive.height(1, context),
                Responsive.width(5, context),
                0.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(
                Radius.circular(Responsive.width(8, context)),
              ),
              border: Border.all(
                width: Responsive.width(0.3, context),
                color: Color(0xff707070),
              ),
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: <Widget>[
                  Container(
                    margin:
                    EdgeInsets.only(top: constraints.maxHeight * 0.03),
                    width: constraints.maxWidth * 1,
                    height: constraints.maxHeight * 0.09,
                    //color: Colors.black26,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.fromLTRB(
                                  constraints.maxWidth * 0.02,
                                  0,
                                  constraints.maxWidth * 0.02,
                                  0.0),
                              child: new CustomSwitch(
                                  notifyParent: refresh,
                                  onSwitchTap: (currentTabType) {
                                    bookingList = [];
                                    setState(() {
                                      isDataLoading = true;
                                      pageNumber = 1;
                                      isMoreLoading = false;
                                      isMorePage = true;
                                    });
                                    dataSub!.cancel();
                                    loadBookingWithApi();
                                  }),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: PopupMenuButton<FilterType>(
                                key: _keyPopupMenu,
                                padding:
                                const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Container(
                                  margin: EdgeInsets.only(
                                      right: constraints.maxWidth * 0.030),
                                  width: constraints.maxWidth * 0.3,
                                  height: constraints.maxHeight * 0.65,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      constraints.maxWidth * 0.08,
                                    ),
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Row(
                                        children: <Widget>[
                                          Container(
                                            width: constraints.maxWidth * 0.4,
                                            child: Icon(
                                              Icons.filter_list,
                                              color: Colors.white,
                                              size: 2.5 *
                                                  SizeConfig
                                                      .blockSizeVertical,
                                            ),
                                          ),
                                          Container(
                                            width: constraints.maxWidth * 0.5,
                                            child: Text('Filter',
                                                style: content1Style(2 *
                                                    SizeConfig
                                                        .blockSizeVertical)),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                itemBuilder: (BuildContext context) {
                                  return new List<
                                      PopupMenuEntry<
                                          FilterType>>.generate(
                                      FilterType.values.length, (int index) {
                                    return new PopupMenuItem(
                                      height: 37,
                                      value: FilterType.values[index],
                                      child: Container(
                                        height: 37,
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 0.0, 0.0, 0.0),
                                        margin: EdgeInsets.fromLTRB(
                                            0.0, 0, 0.0, 0.0),
                                        child: new AnimatedBuilder(
                                          child: Container(
                                            // height: 37,
                                              child: Text(FilterType
                                                  .values[index]
                                                  .toString()
                                                  .split('.')
                                                  .last)),
                                          animation: _selectedItem,
                                          builder: (BuildContext context,
                                              Widget? child) {
                                            return RadioListTile<FilterType>(
                                              //contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                value:
                                                FilterType.values[index],
                                                dense: true,
                                                groupValue:
                                                _selectedItem.value,
                                                title: child,
                                                onChanged:
                                                    (selectedFilterValue) {
                                                  _selectedItem.value =
                                                  selectedFilterValue!;
                                                  filterType =
                                                      getSelectedFilter(
                                                          selectedFilterValue);
                                                  Navigator.of(
                                                      _keyPopupMenu
                                                          .currentContext!,
                                                      rootNavigator: true)
                                                      .pop();
                                                  bookingList = [];
                                                  setState(() {
                                                    isDataLoading = true;
                                                    pageNumber = 1;
                                                    bookingList = [];
                                                    isMoreLoading = false;
                                                    isMorePage = true;
                                                  });
                                                  dataSub!.cancel();
                                                  loadBookingWithApi();
                                                });
                                          },
                                        ),
                                      ),
                                    );
                                  });
                                },
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  Container(
                      width: constraints.maxWidth * 0.99,
                      height: constraints.maxHeight * 0.86,
                      child: Column(
                        children: [
                          if ((bookingList == null ||
                              bookingList.length == 0) &&
                              !isDataLoading)
                            Container(
                                margin: EdgeInsets.only(
                                    top: Responsive.height(20, context)),
                                child: Text("No Booking",
                                    style: TextStyle(
                                        fontSize: 2.5 *
                                            SizeConfig.blockSizeVertical))),
                          if (isDataLoading)
                            Container(
                                margin: EdgeInsets.only(
                                    top: Responsive.height(20, context)),
                                child: Center(
                                    child: CircularProgressIndicator())),
                          if (bookingList != null && bookingList.length > 0)
                            Container(
                              width: constraints.maxWidth * 0.99,
                              height: constraints.maxHeight * 0.86,
                              //color: Colors.black12,
                              padding: EdgeInsets.only(
                                bottom: constraints.maxWidth * 0.01,
                              ),
                              child: ListView.builder(
                                  controller: controller,
                                  physics:
                                  const AlwaysScrollableScrollPhysics(),
                                  itemCount: bookingList == null
                                      ? 0
                                      : bookingList.length,
                                  padding:
                                  EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                  itemBuilder: (context, index) {
                                    Map booking = bookingList[index];
                                    if (booking['requested_time'] == null) {
                                      booking['requested_time'] = '12:30pm';
                                    }
                                    if (booking['lesson_type'] ==
                                        'pass-assist') {
                                      this.isPassAssist = true;
                                      if (booking['lesson_sub_course'] ==
                                          'reverse_right') {
                                        this.subCourse = "Reverse Right";
                                      } else if (booking[
                                      'lesson_sub_course'] ==
                                          'reverse_left') {
                                        this.subCourse = "Reverse Left";
                                      } else if (booking[
                                      'lesson_sub_course'] ==
                                          'reverse_park') {
                                        this.subCourse = "Reverse Park";
                                      } else if (booking[
                                      'lesson_sub_course'] ==
                                          'turn_in_road') {
                                        this.subCourse = "Turn in road";
                                      } else if (booking[
                                      'lesson_sub_course'] ==
                                          'forward_park') {
                                        this.subCourse = "Forward park";
                                      } else if (booking[
                                      'lesson_sub_course'] ==
                                          'control') {
                                        this.subCourse = "Control";
                                      } else if (booking[
                                      'lesson_sub_course'] ==
                                          'move_off') {
                                        this.subCourse = "Move off";
                                      } else if (booking[
                                      'lesson_sub_course'] ==
                                          'mirrors') {
                                        this.subCourse = "Use of mirrors";
                                      } else if (booking[
                                      'lesson_sub_course'] ==
                                          'signals') {
                                        this.subCourse = "Signals";
                                      } else if (booking[
                                      'lesson_sub_course'] ==
                                          'response_to_signs') {
                                        this.subCourse =
                                        "Response to signs / signals";
                                      } else if (booking[
                                      'lesson_sub_course'] ==
                                          'progress') {
                                        this.subCourse = "Progress";
                                      } else if (booking[
                                      'lesson_sub_course'] ==
                                          'junctions') {
                                        this.subCourse = "Junctions";
                                      } else if (booking[
                                      'lesson_sub_course'] ==
                                          'judgement') {
                                        this.subCourse = "Judgement";
                                      } else {
                                        this.subCourse = "Positioning";
                                      }
                                    } else {
                                      this.isPassAssist = false;
                                    }

                                    if (booking["booking_type"] == 'Test') {
                                      if (booking["status"] ==
                                          'report-submitted') {
                                        this.isTest = true;
                                        this.isReportSubmitted = true;
                                      } else if (booking["status"] ==
                                          'assigned') {
                                        this.isTest = true;
                                        this.isReportSubmitted = false;
                                      } else {
                                        this.isTest = false;
                                        this.isReportSubmitted = false;
                                      }
                                    } else {
                                      this.isTest = false;
                                    }

                                    // if(_userType == 1 && booking["booking_type"] == 'Test' && booking["status"] == 'report-submitted'){
                                    //   this.isReportSubmitted = true;
                                    //   this.isTest = true;
                                    // }else{
                                    //   this.isTest = false;
                                    //   this.isReportSubmitted = false;
                                    // }

                                    if (booking["booking_type"] == 'Test') {
                                      this.bookingTypeColor = TestColor;
                                    } else {
                                      this.bookingTypeColor = LessonColor;
                                    }
                                    String dateTime =
                                        booking['requested_date'].toString() +
                                            " " +
                                            booking['requested_time']
                                                .toString()
                                                .toUpperCase();
                                    bool dateDiff = diffDate(dateTime);
                                    bool bookingDateDiff =
                                    bookingDiffDate(dateTime);
                                    String dateDiff1 = diffDate1(dateTime);
                                    //print(dateTime);
                                    return Container(
                                        width: constraints.maxWidth * 0.95,
                                        //height: constraints.maxHeight * 0.11,
                                        margin: EdgeInsets.fromLTRB(
                                            constraints.maxWidth * 0.005,
                                            constraints.maxHeight * 0.009,
                                            constraints.maxWidth * 0.005,
                                            0.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                constraints.maxWidth * 0.025),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(
                                                  0, 0, 0, 0.16),
                                              blurRadius:
                                              6.0, // soften the shadow
                                              spreadRadius:
                                              1.0, //extend the shadow
                                              offset: Offset(
                                                3.0, // Move to right 10  horizontally
                                                0.0, // Move to bottom 10 Vertically
                                              ),
                                            )
                                          ],
                                        ),
                                        child: ExpansionTile(
                                            onExpansionChanged: (val) {
                                              setState(() {
                                                isChatAvailable =
                                                    chatAvailibility(
                                                        dateTime);
                                              });

                                              print(
                                                  "Booking info : ${booking}");
                                              print(
                                                  "\n-----------------------------------------------------------\n");
                                              print(
                                                  "Receiver id : ${booking['user_id']}");
                                              print(
                                                  "\n-----------------------------------------------------------\n");
                                              print("Senders id : $_userId");
                                            },
                                            tilePadding: EdgeInsets.only(
                                              top:
                                              constraints.maxWidth * 0.01,
                                              left:
                                              constraints.maxWidth * 0.02,
                                              right:
                                              constraints.maxWidth * 0.02,
                                              bottom:
                                              constraints.maxWidth * 0.01,
                                            ),
                                            leading: Container(
                                              width:
                                              constraints.maxWidth * 0.15,
                                              height: SizeConfig.inputHeight,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: bookingTypeColor,
                                              ),
                                              child: Center(
                                                child: Container(
                                                  width: constraints.maxWidth,
                                                  child: AutoSizeText(
                                                      booking["booking_type"],
                                                      style: content1Style(1.5 *
                                                          SizeConfig
                                                              .blockSizeVertical),
                                                      textAlign:
                                                      TextAlign.center),
                                                ),
                                              ),
                                            ),
                                            title: Column(
                                              children: [
                                                Align(
                                                  alignment:
                                                  Alignment.topLeft,
                                                  child: AutoSizeText(
                                                      booking['type'],
                                                      style: headingStyle(
                                                          SizeConfig
                                                              .headingFontSize),
                                                      textAlign:
                                                      TextAlign.left),
                                                ),
                                                Visibility(
                                                  visible: isPassAssist,
                                                  child: Align(
                                                    alignment:
                                                    Alignment.topLeft,
                                                    child:
                                                    FractionallySizedBox(
                                                      widthFactor: 1,
                                                      child: Container(
                                                        padding:
                                                        const EdgeInsets
                                                            .fromLTRB(
                                                            0, 2, 5, 1),
                                                        child:
                                                        FractionallySizedBox(
                                                          widthFactor: 1,
                                                          child: AutoSizeText(
                                                              subCourse ==
                                                                  null
                                                                  ? ''
                                                                  : subCourse!,
                                                              style: subHeadingStyle(
                                                                  SizeConfig
                                                                      .subHeadingFontSize),
                                                              textAlign:
                                                              TextAlign
                                                                  .left),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                  Alignment.topLeft,
                                                  child: FractionallySizedBox(
                                                    widthFactor: 1,
                                                    child: Container(
                                                      padding:
                                                      const EdgeInsets
                                                          .fromLTRB(
                                                          0, 2, 5, 1),
                                                      child: AutoSizeText(
                                                          booking["requested_date"] +
                                                              " " +
                                                              booking[
                                                              "requested_time"],
                                                          style: subHeadingStyle(
                                                              SizeConfig
                                                                  .subHeading2FontSize),
                                                          textAlign:
                                                          TextAlign.left),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                  Alignment.topLeft,
                                                  child: Row(
                                                    children: [
                                                      booking["postcode"] !=
                                                          null
                                                          ? Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical:
                                                            5),
                                                        child: Text(
                                                          booking[
                                                          "postcode"],
                                                          style: const TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                              color: Colors
                                                                  .white,
                                                              fontSize:
                                                              13),
                                                        ),
                                                        decoration:
                                                        BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              15.0),
                                                          color: Dark,
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                            horizontal:
                                                            8,
                                                            vertical:
                                                            5),
                                                      )
                                                          : const Text(''),
                                                      SizedBox(
                                                        width: SizeConfig
                                                            .blockSizeHorizontal *
                                                            1,
                                                      ),
                                                      booking["name"] !=
                                                          " " &&
                                                          booking["name"] !=
                                                              null
                                                          ? Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical:
                                                            5),
                                                        child: Text(
                                                          booking[
                                                          "name"],
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                              color: Colors
                                                                  .white,
                                                              fontSize:
                                                              13),
                                                        ),
                                                        decoration:
                                                        BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              15.0),
                                                          color: Dark,
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                            horizontal:
                                                            8,
                                                            vertical:
                                                            5),
                                                      )
                                                          : const Text(''),
                                                      SizedBox(
                                                        width: SizeConfig
                                                            .blockSizeHorizontal *
                                                            1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            children: [
                                              Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  width:
                                                  constraints.maxWidth *
                                                      0.9,
                                                  padding: EdgeInsets.only(
                                                      bottom: constraints
                                                          .maxHeight *
                                                          0.01),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: constraints
                                                            .maxWidth,
                                                        //height: constraints.maxHeight*0.25,
                                                        //color: Colors.cyanAccent,
                                                        child: LayoutBuilder(
                                                            builder: (context,
                                                                constraints) {
                                                              return Row(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                                children: [
                                                                  Container(
                                                                    width: constraints
                                                                        .maxWidth *
                                                                        0.35,
                                                                    child: AutoSizeText(
                                                                        "Location",
                                                                        style: headingStyle(
                                                                            SizeConfig
                                                                                .headingFontSize),
                                                                        textAlign:
                                                                        TextAlign
                                                                            .left),
                                                                  ),
                                                                  Container(
                                                                    width: constraints
                                                                        .maxWidth *
                                                                        0.65,
                                                                    //color: Colors.black54,
                                                                    child:
                                                                    AutoSizeText(
                                                                      booking[
                                                                      "full_location"] == null?booking[
                                                                      "location"] : booking[
                                                                      "full_location"],
                                                                      style: contentStyle(1.6 *
                                                                          SizeConfig
                                                                              .blockSizeVertical),
                                                                      maxLines: 2,
                                                                    ),
                                                                  )
                                                                ],
                                                              );
                                                            }),
                                                      ),
                                                      Container(
                                                        width: constraints
                                                            .maxWidth,
                                                        //height: constraints.maxHeight*0.1875,
                                                        //color: Colors.amber,
                                                        margin:
                                                        EdgeInsets.only(
                                                            top: 7.0),
                                                        child: LayoutBuilder(
                                                            builder: (context,
                                                                constraints) {
                                                              return Row(
                                                                children: [
                                                                  Container(
                                                                    width: constraints
                                                                        .maxWidth *
                                                                        0.35,
                                                                    //color: Colors.black26,
                                                                    child:
                                                                    AutoSizeText(
                                                                      'ADI Details',
                                                                      style: headingStyle(
                                                                          SizeConfig
                                                                              .headingFontSize),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: constraints
                                                                        .maxWidth *
                                                                        0.65,
                                                                    //color: Colors.black54,
                                                                    child: dateDiff ==
                                                                        false
                                                                        ? AutoSizeText(
                                                                      'You will be able to see the instructor\'s details 24 hours before the test.',
                                                                      style:
                                                                      contentStyle(1.5 * SizeConfig.blockSizeVertical),
                                                                      maxLines:
                                                                      2,
                                                                    )
                                                                        : Container(
                                                                      //color: Colors.orange,
                                                                        child:
                                                                        LayoutBuilder(
                                                                          builder:
                                                                              (context, constraints) {
                                                                            return Column(
                                                                              children: [
                                                                                Container(
                                                                                    width: constraints.maxWidth * 1,
                                                                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                                    child: LayoutBuilder(
                                                                                      builder: (context, constraints) {
                                                                                        return Row(
                                                                                          children: [
                                                                                            Container(
                                                                                              width: constraints.maxWidth * 0.35,
                                                                                              alignment: Alignment.topLeft,
                                                                                              //color: Colors.cyanAccent,
                                                                                              child: AutoSizeText(
                                                                                                "Name",
                                                                                                style: subHeadingStyle(1.7 * SizeConfig.blockSizeVertical),
                                                                                                maxLines: 2,
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              width: constraints.maxWidth * 0.65,
                                                                                              alignment: Alignment.center,
                                                                                              //color: Colors.black26,
                                                                                              child: FractionallySizedBox(
                                                                                                widthFactor: 1,
                                                                                                child: AutoSizeText(
                                                                                                  (booking["name"] == null || (booking["name"]).trim() == '') ? '---' : booking["name"].toString(),
                                                                                                  style: contentStyle(1.6 * SizeConfig.blockSizeVertical),
                                                                                                ),
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        );
                                                                                      },
                                                                                    )),
                                                                                Container(
                                                                                    width: constraints.maxWidth * 1,
                                                                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                                                    decoration: const BoxDecoration(
                                                                                      border: Border(
                                                                                        top: BorderSide(width: 1.0, color: Colors.black12),
                                                                                      ),
                                                                                    ),
                                                                                    child: LayoutBuilder(
                                                                                      builder: (context, constraints) {
                                                                                        return Row(
                                                                                          children: [
                                                                                            Container(
                                                                                              width: constraints.maxWidth * 0.35,
                                                                                              alignment: Alignment.topLeft,
                                                                                              //color: Colors.cyanAccent,
                                                                                              child: AutoSizeText(
                                                                                                "Contact No",
                                                                                                style: subHeadingStyle(1.7 * SizeConfig.blockSizeVertical),
                                                                                                //maxLines: 2,
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              width: constraints.maxWidth * 0.65,
                                                                                              alignment: Alignment.center,
                                                                                              //color: Colors.black26,
                                                                                              child: FractionallySizedBox(
                                                                                                widthFactor: 1,
                                                                                                child: AutoSizeText((booking["phone"] == null || (booking["phone"]).trim() == '') ? '---' : booking["phone"].toString(), style: contentStyle(1.6 * SizeConfig.blockSizeVertical)),
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        );
                                                                                      },
                                                                                    ))
                                                                              ],
                                                                            );
                                                                          },
                                                                        )),
                                                                  )
                                                                ],
                                                              );
                                                            }),
                                                      ),
                                                      Visibility(
                                                        visible: isTest &&
                                                            bookingDateDiff &&
                                                            booking['booking_origin'] ==
                                                                "Test",
                                                        child: Container(
                                                          width: constraints
                                                              .maxWidth,
                                                          //height: constraints.maxHeight*0.25,
                                                          margin:
                                                          EdgeInsets.only(
                                                              top: 7.0),
                                                          //color: Colors.cyanAccent,
                                                          child: LayoutBuilder(
                                                              builder: (context,
                                                                  constraints) {
                                                                return Row(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    Container(
                                                                      width: constraints
                                                                          .maxWidth *
                                                                          0.35,
                                                                      child: AutoSizeText(
                                                                          "Report",
                                                                          style: headingStyle(SizeConfig
                                                                              .headingFontSize),
                                                                          textAlign:
                                                                          TextAlign.left),
                                                                    ),
                                                                    Container(
                                                                      //width:constraints.maxWidth *0.7,
                                                                      //color: Colors.black54,
                                                                        child: isReportSubmitted
                                                                            ? RichText(
                                                                          text: TextSpan(
                                                                              text: 'View Report',
                                                                              style: TextStyle(fontSize: 1.5 * SizeConfig.blockSizeVertical, fontWeight: FontWeight.bold, color: Dark),
                                                                              recognizer: TapGestureRecognizer()
                                                                                ..onTap = () {
                                                                                  print("tapped");
                                                                                  Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                          builder: (context) => WebViewContainer(
                                                                                              '$api/test/report/view?booking=${booking['booking_id']}&user=$_userId&type=${booking['booking_origin']}',
                                                                                              'Test Report')));
                                                                                }),
                                                                        )
                                                                            : AutoSizeText("Not available", style: TextStyle(fontSize: 1.5 * SizeConfig.blockSizeVertical, fontWeight: FontWeight.bold, color: Colors.black), textAlign: TextAlign.left)
                                                                      //: AutoSizeText("Report Submitted", style: TextStyle(fontSize: 1.5 * SizeConfig.blockSizeVertical, fontWeight: FontWeight.bold, color: Colors.green), textAlign: TextAlign.left),
                                                                    )
                                                                  ],
                                                                );
                                                              }),
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible:
                                                        booking['status'] ==
                                                            "assigned"
                                                            ? true
                                                            : false,
                                                        child: Container(
                                                          width: constraints
                                                              .maxWidth,
                                                          //height: constraints.maxHeight*0.25,
                                                          margin:
                                                          const EdgeInsets
                                                              .only(
                                                              top: 7.0),
                                                          //color: Colors.cyanAccent,
                                                          child:
                                                          LayoutBuilder(
                                                            builder: (context,
                                                                constraints) {
                                                              return ElevatedButton(
                                                                onPressed:
                                                                    () {
                                                                  if (booking[
                                                                  'booking_add_by'] ==
                                                                      "self") {
                                                                    Navigator.of(
                                                                        context)
                                                                        .push(
                                                                      MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            ChatView(
                                                                              studentId:
                                                                              booking['user_id'],
                                                                              userId:
                                                                              _userId!,
                                                                            ),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    if (isChatAvailable) {
                                                                      print(
                                                                          "CHAT");
                                                                      Navigator.of(context)
                                                                          .push(
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              ChatView(
                                                                                studentId: booking['user_id'],
                                                                                userId: _userId!,
                                                                              ),
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      showValidationDialog(
                                                                          context,
                                                                          "Chat is not available!!");
                                                                    }
                                                                  }
                                                                  // if (booking[
                                                                  //         'booking_add_by'] ==
                                                                  //     "self") {
                                                                  //   Navigator.of(
                                                                  //           context)
                                                                  //       .push(
                                                                  //     MaterialPageRoute(
                                                                  //       builder: (context) =>
                                                                  //           ChatView(
                                                                  //         studentId:
                                                                  //             booking['user_id'],
                                                                  //         userId:
                                                                  //             _userId!,
                                                                  //       ),
                                                                  //     ),
                                                                  //   );
                                                                  // } else {
                                                                  //   if (isChatAvailable) {
                                                                  //     print(
                                                                  //         "CHAT");
                                                                  //     Navigator.of(context)
                                                                  //         .push(
                                                                  //       MaterialPageRoute(
                                                                  //         builder: (context) =>
                                                                  //             ChatView(
                                                                  //           studentId: booking['user_id'],
                                                                  //           userId: _userId!,
                                                                  //         ),
                                                                  //       ),
                                                                  //     );
                                                                  //   } else {
                                                                  //     // showValidationDialog(
                                                                  //     //     context,
                                                                  //     //     "Chat is not available!!");
                                                                  //   }
                                                                  // }
                                                                },
                                                                child: Text(
                                                                    "Message instructor"),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  primary:
                                                                  Dark,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      dateDiff1 ==
                                                          'showButton'
                                                          ? Container(
                                                          width: constraints
                                                              .maxWidth *
                                                              0.9,
                                                          //color: Colors.cyanAccent,
                                                          margin: EdgeInsets
                                                              .only(
                                                              top:
                                                              7.0),
                                                          child:
                                                          LayoutBuilder(
                                                            builder: (context,
                                                                constraints) {
                                                              return Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                                children: [
                                                                  Container(
                                                                      width: constraints.maxWidth *
                                                                          0.3,
                                                                      //color: Colors.black26,
                                                                      child:
                                                                      TextButton(
                                                                        onPressed: () {
                                                                          track = true;
                                                                          // Scaffold.of(context).showSnackBar(snackBar);
                                                                          // Timer.periodic(Duration(seconds: delay), (timer) {
                                                                          //   locationData(booking["booking_id"].toString(), booking["booking_type"]);
                                                                          // });
                                                                        },
                                                                        child: Text("Start"),
                                                                      )),
                                                                  Container(
                                                                      width: constraints.maxWidth *
                                                                          0.3,
                                                                      //color: Colors.black26,
                                                                      child:
                                                                      TextButton(
                                                                        onPressed: () {
                                                                          track = false;
                                                                          // Timer.periodic(Duration(seconds: delay), (timer) {
                                                                          //   locationData( booking["booking_id"], booking["booking_type"]);
                                                                          //   //timer.cancel();
                                                                          // });
                                                                        },
                                                                        child: Text("Stop"),
                                                                      ))
                                                                ],
                                                              );
                                                            },
                                                          ))
                                                          : Text('')
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]));
                                  }),
                            ),
                        ],
                      ))
                ],
              );
            }),
          ),
        ),
        // Stack(
        //   children: <Widget>[
        //     // CustomAppBar(
        //     //   preferedHeight: Responsive.height(21, context),
        //     //   title: 'My Bookings',
        //     //   textWidth: Responsive.width(45, context),
        //     //   iconLeft: FontAwesomeIcons.arrowLeft,
        //     //   onTap1: () {
        //     //     _navigationService.goBack();
        //     //   },
        //     //   iconRight: FontAwesomeIcons.calendarAlt,
        //     //   onTapRightbtn: () {
        //     //     Navigator.push(
        //     //       context,
        //     //       MaterialPageRoute(
        //     //         builder: (context) => Calender(),
        //     //       ),
        //     //     );
        //     //   },
        //     // ),
        //     Container(
        //       width: Responsive.width(100, context),
        //       height: Responsive.height(80, context),
        //       margin: EdgeInsets.fromLTRB(
        //           Responsive.width(5, context),
        //           Responsive.height(12, context) +
        //               MediaQuery.of(context).padding.top,
        //           Responsive.width(5, context),
        //           0.0),
        //       decoration: BoxDecoration(
        //         color: Colors.transparent,
        //         borderRadius: BorderRadius.all(
        //           Radius.circular(Responsive.width(8, context)),
        //         ),
        //         border: Border.all(
        //           width: Responsive.width(0.3, context),
        //           color: Color(0xff707070),
        //         ),
        //       ),
        //       child: LayoutBuilder(builder: (context, constraints) {
        //         return Column(
        //           children: <Widget>[
        //             Container(
        //               margin:
        //                   EdgeInsets.only(top: constraints.maxHeight * 0.03),
        //               width: constraints.maxWidth * 1,
        //               height: constraints.maxHeight * 0.09,
        //               //color: Colors.black26,
        //               child: LayoutBuilder(
        //                 builder: (context, constraints) {
        //                   return Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: <Widget>[
        //                       Container(
        //                         alignment: Alignment.topLeft,
        //                         margin: EdgeInsets.fromLTRB(
        //                             constraints.maxWidth * 0.02,
        //                             0,
        //                             constraints.maxWidth * 0.02,
        //                             0.0),
        //                         child: new CustomSwitch(
        //                             notifyParent: refresh,
        //                             onSwitchTap: (currentTabType) {
        //                               bookingList = [];
        //                               setState(() {
        //                                 isDataLoading = true;
        //                                 pageNumber = 1;
        //                                 isMoreLoading = false;
        //                                 isMorePage = true;
        //                               });
        //                               dataSub!.cancel();
        //                               loadBookingWithApi();
        //                             }),
        //                       ),
        //                       Align(
        //                         alignment: Alignment.topRight,
        //                         child: PopupMenuButton<FilterType>(
        //                           key: _keyPopupMenu,
        //                           padding:
        //                               const EdgeInsets.fromLTRB(0, 0, 0, 0),
        //                           child: Container(
        //                             margin: EdgeInsets.only(
        //                                 right: constraints.maxWidth * 0.030),
        //                             width: constraints.maxWidth * 0.3,
        //                             height: constraints.maxHeight * 0.65,
        //                             decoration: BoxDecoration(
        //                               borderRadius: BorderRadius.circular(
        //                                 constraints.maxWidth * 0.08,
        //                               ),
        //                               color: Colors.black.withOpacity(0.4),
        //                             ),
        //                             child: LayoutBuilder(
        //                               builder: (context, constraints) {
        //                                 return Row(
        //                                   children: <Widget>[
        //                                     Container(
        //                                       width: constraints.maxWidth * 0.4,
        //                                       child: Icon(
        //                                         Icons.filter_list,
        //                                         color: Colors.white,
        //                                         size: 2.5 *
        //                                             SizeConfig
        //                                                 .blockSizeVertical,
        //                                       ),
        //                                     ),
        //                                     Container(
        //                                       width: constraints.maxWidth * 0.5,
        //                                       child: Text('Filter',
        //                                           style: content1Style(2 *
        //                                               SizeConfig
        //                                                   .blockSizeVertical)),
        //                                     )
        //                                   ],
        //                                 );
        //                               },
        //                             ),
        //                           ),
        //                           itemBuilder: (BuildContext context) {
        //                             return new List<
        //                                     PopupMenuEntry<
        //                                         FilterType>>.generate(
        //                                 FilterType.values.length, (int index) {
        //                               return new PopupMenuItem(
        //                                 height: 37,
        //                                 value: FilterType.values[index],
        //                                 child: Container(
        //                                   height: 37,
        //                                   padding: EdgeInsets.fromLTRB(
        //                                       0.0, 0.0, 0.0, 0.0),
        //                                   margin: EdgeInsets.fromLTRB(
        //                                       0.0, 0, 0.0, 0.0),
        //                                   child: new AnimatedBuilder(
        //                                     child: Container(
        //                                         // height: 37,
        //                                         child: Text(FilterType
        //                                             .values[index]
        //                                             .toString()
        //                                             .split('.')
        //                                             .last)),
        //                                     animation: _selectedItem,
        //                                     builder: (BuildContext context,
        //                                         Widget? child) {
        //                                       return RadioListTile<FilterType>(
        //                                           //contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        //                                           value:
        //                                               FilterType.values[index],
        //                                           dense: true,
        //                                           groupValue:
        //                                               _selectedItem.value,
        //                                           title: child,
        //                                           onChanged:
        //                                               (selectedFilterValue) {
        //                                             _selectedItem.value =
        //                                                 selectedFilterValue!;
        //                                             filterType =
        //                                                 getSelectedFilter(
        //                                                     selectedFilterValue);
        //                                             Navigator.of(
        //                                                     _keyPopupMenu
        //                                                         .currentContext!,
        //                                                     rootNavigator: true)
        //                                                 .pop();
        //                                             bookingList = [];
        //                                             setState(() {
        //                                               isDataLoading = true;
        //                                               pageNumber = 1;
        //                                               bookingList = [];
        //                                               isMoreLoading = false;
        //                                               isMorePage = true;
        //                                             });
        //                                             dataSub!.cancel();
        //                                             loadBookingWithApi();
        //                                           });
        //                                     },
        //                                   ),
        //                                 ),
        //                               );
        //                             });
        //                           },
        //                         ),
        //                       )
        //                     ],
        //                   );
        //                 },
        //               ),
        //             ),
        //             Container(
        //                 width: constraints.maxWidth * 0.99,
        //                 height: constraints.maxHeight * 0.86,
        //                 child: Column(
        //                   children: [
        //                     if ((bookingList == null ||
        //                             bookingList.length == 0) &&
        //                         !isDataLoading)
        //                       Container(
        //                           margin: EdgeInsets.only(
        //                               top: Responsive.height(20, context)),
        //                           child: Text("No Booking",
        //                               style: TextStyle(
        //                                   fontSize: 2.5 *
        //                                       SizeConfig.blockSizeVertical))),
        //                     if (isDataLoading)
        //                       Container(
        //                           margin: EdgeInsets.only(
        //                               top: Responsive.height(20, context)),
        //                           child: Center(
        //                               child: CircularProgressIndicator())),
        //                     if (bookingList != null && bookingList.length > 0)
        //                       Container(
        //                         width: constraints.maxWidth * 0.99,
        //                         height: constraints.maxHeight * 0.86,
        //                         //color: Colors.black12,
        //                         padding: EdgeInsets.only(
        //                           bottom: constraints.maxWidth * 0.01,
        //                         ),
        //                         child: ListView.builder(
        //                             controller: controller,
        //                             physics:
        //                                 const AlwaysScrollableScrollPhysics(),
        //                             itemCount: bookingList == null
        //                                 ? 0
        //                                 : bookingList.length,
        //                             padding:
        //                                 EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        //                             itemBuilder: (context, index) {
        //                               Map booking = bookingList[index];
        //                               if (booking['requested_time'] == null) {
        //                                 booking['requested_time'] = '12:30pm';
        //                               }
        //                               if (booking['lesson_type'] ==
        //                                   'pass-assist') {
        //                                 this.isPassAssist = true;
        //                                 if (booking['lesson_sub_course'] ==
        //                                     'reverse_right') {
        //                                   this.subCourse = "Reverse Right";
        //                                 } else if (booking[
        //                                         'lesson_sub_course'] ==
        //                                     'reverse_left') {
        //                                   this.subCourse = "Reverse Left";
        //                                 } else if (booking[
        //                                         'lesson_sub_course'] ==
        //                                     'reverse_park') {
        //                                   this.subCourse = "Reverse Park";
        //                                 } else if (booking[
        //                                         'lesson_sub_course'] ==
        //                                     'turn_in_road') {
        //                                   this.subCourse = "Turn in road";
        //                                 } else if (booking[
        //                                         'lesson_sub_course'] ==
        //                                     'forward_park') {
        //                                   this.subCourse = "Forward park";
        //                                 } else if (booking[
        //                                         'lesson_sub_course'] ==
        //                                     'control') {
        //                                   this.subCourse = "Control";
        //                                 } else if (booking[
        //                                         'lesson_sub_course'] ==
        //                                     'move_off') {
        //                                   this.subCourse = "Move off";
        //                                 } else if (booking[
        //                                         'lesson_sub_course'] ==
        //                                     'mirrors') {
        //                                   this.subCourse = "Use of mirrors";
        //                                 } else if (booking[
        //                                         'lesson_sub_course'] ==
        //                                     'signals') {
        //                                   this.subCourse = "Signals";
        //                                 } else if (booking[
        //                                         'lesson_sub_course'] ==
        //                                     'response_to_signs') {
        //                                   this.subCourse =
        //                                       "Response to signs / signals";
        //                                 } else if (booking[
        //                                         'lesson_sub_course'] ==
        //                                     'progress') {
        //                                   this.subCourse = "Progress";
        //                                 } else if (booking[
        //                                         'lesson_sub_course'] ==
        //                                     'junctions') {
        //                                   this.subCourse = "Junctions";
        //                                 } else if (booking[
        //                                         'lesson_sub_course'] ==
        //                                     'judgement') {
        //                                   this.subCourse = "Judgement";
        //                                 } else {
        //                                   this.subCourse = "Positioning";
        //                                 }
        //                               } else {
        //                                 this.isPassAssist = false;
        //                               }
        //
        //                               if (booking["booking_type"] == 'Test') {
        //                                 if (booking["status"] ==
        //                                     'report-submitted') {
        //                                   this.isTest = true;
        //                                   this.isReportSubmitted = true;
        //                                 } else if (booking["status"] ==
        //                                     'assigned') {
        //                                   this.isTest = true;
        //                                   this.isReportSubmitted = false;
        //                                 } else {
        //                                   this.isTest = false;
        //                                   this.isReportSubmitted = false;
        //                                 }
        //                               } else {
        //                                 this.isTest = false;
        //                               }
        //
        //                               // if(_userType == 1 && booking["booking_type"] == 'Test' && booking["status"] == 'report-submitted'){
        //                               //   this.isReportSubmitted = true;
        //                               //   this.isTest = true;
        //                               // }else{
        //                               //   this.isTest = false;
        //                               //   this.isReportSubmitted = false;
        //                               // }
        //
        //                               if (booking["booking_type"] == 'Test') {
        //                                 this.bookingTypeColor = TestColor;
        //                               } else {
        //                                 this.bookingTypeColor = LessonColor;
        //                               }
        //                               String dateTime =
        //                                   booking['requested_date'].toString() +
        //                                       " " +
        //                                       booking['requested_time']
        //                                           .toString()
        //                                           .toUpperCase();
        //                               bool dateDiff = diffDate(dateTime);
        //                               bool bookingDateDiff =
        //                                   bookingDiffDate(dateTime);
        //                               String dateDiff1 = diffDate1(dateTime);
        //                               //print(dateTime);
        //                               return Container(
        //                                   width: constraints.maxWidth * 0.95,
        //                                   //height: constraints.maxHeight * 0.11,
        //                                   margin: EdgeInsets.fromLTRB(
        //                                       constraints.maxWidth * 0.005,
        //                                       constraints.maxHeight * 0.009,
        //                                       constraints.maxWidth * 0.005,
        //                                       0.0),
        //                                   decoration: BoxDecoration(
        //                                     color: Colors.white,
        //                                     borderRadius: BorderRadius.all(
        //                                       Radius.circular(
        //                                           constraints.maxWidth * 0.025),
        //                                     ),
        //                                     boxShadow: [
        //                                       BoxShadow(
        //                                         color: Color.fromRGBO(
        //                                             0, 0, 0, 0.16),
        //                                         blurRadius:
        //                                             6.0, // soften the shadow
        //                                         spreadRadius:
        //                                             1.0, //extend the shadow
        //                                         offset: Offset(
        //                                           3.0, // Move to right 10  horizontally
        //                                           0.0, // Move to bottom 10 Vertically
        //                                         ),
        //                                       )
        //                                     ],
        //                                   ),
        //                                   child: ExpansionTile(
        //                                       onExpansionChanged: (val) {
        //                                         setState(() {
        //                                           isChatAvailable =
        //                                               chatAvailibility(
        //                                                   dateTime);
        //                                         });
        //
        //                                         print(
        //                                             "Booking info : ${booking}");
        //                                         print(
        //                                             "\n-----------------------------------------------------------\n");
        //                                         print(
        //                                             "Receiver id : ${booking['user_id']}");
        //                                         print(
        //                                             "\n-----------------------------------------------------------\n");
        //                                         print("Senders id : $_userId");
        //                                       },
        //                                       tilePadding: EdgeInsets.only(
        //                                         top:
        //                                             constraints.maxWidth * 0.01,
        //                                         left:
        //                                             constraints.maxWidth * 0.02,
        //                                         right:
        //                                             constraints.maxWidth * 0.02,
        //                                         bottom:
        //                                             constraints.maxWidth * 0.01,
        //                                       ),
        //                                       leading: Container(
        //                                         width:
        //                                             constraints.maxWidth * 0.15,
        //                                         height: SizeConfig.inputHeight,
        //                                         decoration: BoxDecoration(
        //                                           shape: BoxShape.circle,
        //                                           color: bookingTypeColor,
        //                                         ),
        //                                         child: Center(
        //                                           child: Container(
        //                                             width: constraints.maxWidth,
        //                                             child: AutoSizeText(
        //                                                 booking["booking_type"],
        //                                                 style: content1Style(1.5 *
        //                                                     SizeConfig
        //                                                         .blockSizeVertical),
        //                                                 textAlign:
        //                                                     TextAlign.center),
        //                                           ),
        //                                         ),
        //                                       ),
        //                                       title: Column(
        //                                         children: [
        //                                           Align(
        //                                             alignment:
        //                                                 Alignment.topLeft,
        //                                             child: AutoSizeText(
        //                                                 booking['type'],
        //                                                 style: headingStyle(
        //                                                     SizeConfig
        //                                                         .headingFontSize),
        //                                                 textAlign:
        //                                                     TextAlign.left),
        //                                           ),
        //                                           Visibility(
        //                                             visible: isPassAssist,
        //                                             child: Align(
        //                                               alignment:
        //                                                   Alignment.topLeft,
        //                                               child:
        //                                                   FractionallySizedBox(
        //                                                 widthFactor: 1,
        //                                                 child: Container(
        //                                                   padding:
        //                                                       const EdgeInsets
        //                                                               .fromLTRB(
        //                                                           0, 2, 5, 1),
        //                                                   child:
        //                                                       FractionallySizedBox(
        //                                                     widthFactor: 1,
        //                                                     child: AutoSizeText(
        //                                                         subCourse ==
        //                                                                 null
        //                                                             ? ''
        //                                                             : subCourse!,
        //                                                         style: subHeadingStyle(
        //                                                             SizeConfig
        //                                                                 .subHeadingFontSize),
        //                                                         textAlign:
        //                                                             TextAlign
        //                                                                 .left),
        //                                                   ),
        //                                                 ),
        //                                               ),
        //                                             ),
        //                                           ),
        //                                           Align(
        //                                             alignment:
        //                                                 Alignment.topLeft,
        //                                             child: FractionallySizedBox(
        //                                               widthFactor: 1,
        //                                               child: Container(
        //                                                 padding:
        //                                                     const EdgeInsets
        //                                                             .fromLTRB(
        //                                                         0, 2, 5, 1),
        //                                                 child: AutoSizeText(
        //                                                     booking["requested_date"] +
        //                                                         " " +
        //                                                         booking[
        //                                                             "requested_time"],
        //                                                     style: subHeadingStyle(
        //                                                         SizeConfig
        //                                                             .subHeading2FontSize),
        //                                                     textAlign:
        //                                                         TextAlign.left),
        //                                               ),
        //                                             ),
        //                                           ),
        //                                           Align(
        //                                             alignment:
        //                                                 Alignment.topLeft,
        //                                             child: Row(
        //                                               children: [
        //                                                 booking["postcode"] !=
        //                                                         null
        //                                                     ? Container(
        //                                                         margin: const EdgeInsets
        //                                                                 .symmetric(
        //                                                             vertical:
        //                                                                 5),
        //                                                         child: Text(
        //                                                           booking[
        //                                                               "postcode"],
        //                                                           style: const TextStyle(
        //                                                               fontWeight:
        //                                                                   FontWeight
        //                                                                       .w500,
        //                                                               color: Colors
        //                                                                   .white,
        //                                                               fontSize:
        //                                                                   13),
        //                                                         ),
        //                                                         decoration:
        //                                                             BoxDecoration(
        //                                                           borderRadius:
        //                                                               BorderRadius
        //                                                                   .circular(
        //                                                                       15.0),
        //                                                           color: Dark,
        //                                                         ),
        //                                                         padding: EdgeInsets
        //                                                             .symmetric(
        //                                                                 horizontal:
        //                                                                     8,
        //                                                                 vertical:
        //                                                                     5),
        //                                                       )
        //                                                     : const Text(''),
        //                                                 SizedBox(
        //                                                   width: SizeConfig
        //                                                           .blockSizeHorizontal *
        //                                                       1,
        //                                                 ),
        //                                                 booking["name"] !=
        //                                                             " " &&
        //                                                         booking["name"] !=
        //                                                             null
        //                                                     ? Container(
        //                                                         margin: const EdgeInsets
        //                                                                 .symmetric(
        //                                                             vertical:
        //                                                                 5),
        //                                                         child: Text(
        //                                                           booking[
        //                                                               "name"],
        //                                                           style: TextStyle(
        //                                                               fontWeight:
        //                                                                   FontWeight
        //                                                                       .w500,
        //                                                               color: Colors
        //                                                                   .white,
        //                                                               fontSize:
        //                                                                   13),
        //                                                         ),
        //                                                         decoration:
        //                                                             BoxDecoration(
        //                                                           borderRadius:
        //                                                               BorderRadius
        //                                                                   .circular(
        //                                                                       15.0),
        //                                                           color: Dark,
        //                                                         ),
        //                                                         padding: EdgeInsets
        //                                                             .symmetric(
        //                                                                 horizontal:
        //                                                                     8,
        //                                                                 vertical:
        //                                                                     5),
        //                                                       )
        //                                                     : const Text(''),
        //                                                 SizedBox(
        //                                                   width: SizeConfig
        //                                                           .blockSizeHorizontal *
        //                                                       1,
        //                                                 ),
        //                                               ],
        //                                             ),
        //                                           ),
        //                                         ],
        //                                       ),
        //                                       children: [
        //                                         Align(
        //                                           alignment: Alignment.center,
        //                                           child: Container(
        //                                             width:
        //                                                 constraints.maxWidth *
        //                                                     0.9,
        //                                             padding: EdgeInsets.only(
        //                                                 bottom: constraints
        //                                                         .maxHeight *
        //                                                     0.01),
        //                                             child: Column(
        //                                               children: [
        //                                                 Container(
        //                                                   width: constraints
        //                                                       .maxWidth,
        //                                                   //height: constraints.maxHeight*0.25,
        //                                                   //color: Colors.cyanAccent,
        //                                                   child: LayoutBuilder(
        //                                                       builder: (context,
        //                                                           constraints) {
        //                                                     return Row(
        //                                                       crossAxisAlignment:
        //                                                           CrossAxisAlignment
        //                                                               .center,
        //                                                       children: [
        //                                                         Container(
        //                                                           width: constraints
        //                                                                   .maxWidth *
        //                                                               0.35,
        //                                                           child: AutoSizeText(
        //                                                               "Location",
        //                                                               style: headingStyle(
        //                                                                   SizeConfig
        //                                                                       .headingFontSize),
        //                                                               textAlign:
        //                                                                   TextAlign
        //                                                                       .left),
        //                                                         ),
        //                                                         Container(
        //                                                           width: constraints
        //                                                                   .maxWidth *
        //                                                               0.65,
        //                                                           //color: Colors.black54,
        //                                                           child:
        //                                                               AutoSizeText(
        //                                                             booking[
        //                                                                 "location"],
        //                                                             style: contentStyle(1.6 *
        //                                                                 SizeConfig
        //                                                                     .blockSizeVertical),
        //                                                             maxLines: 2,
        //                                                           ),
        //                                                         )
        //                                                       ],
        //                                                     );
        //                                                   }),
        //                                                 ),
        //                                                 Container(
        //                                                   width: constraints
        //                                                       .maxWidth,
        //                                                   //height: constraints.maxHeight*0.1875,
        //                                                   //color: Colors.amber,
        //                                                   margin:
        //                                                       EdgeInsets.only(
        //                                                           top: 7.0),
        //                                                   child: LayoutBuilder(
        //                                                       builder: (context,
        //                                                           constraints) {
        //                                                     return Row(
        //                                                       children: [
        //                                                         Container(
        //                                                           width: constraints
        //                                                                   .maxWidth *
        //                                                               0.35,
        //                                                           //color: Colors.black26,
        //                                                           child:
        //                                                               AutoSizeText(
        //                                                             'ADI Details',
        //                                                             style: headingStyle(
        //                                                                 SizeConfig
        //                                                                     .headingFontSize),
        //                                                           ),
        //                                                         ),
        //                                                         Container(
        //                                                           width: constraints
        //                                                                   .maxWidth *
        //                                                               0.65,
        //                                                           //color: Colors.black54,
        //                                                           child: dateDiff ==
        //                                                                   false
        //                                                               ? AutoSizeText(
        //                                                                   'You will be able to see the instructor\'s details 24 hours before the test.',
        //                                                                   style:
        //                                                                       contentStyle(1.5 * SizeConfig.blockSizeVertical),
        //                                                                   maxLines:
        //                                                                       2,
        //                                                                 )
        //                                                               : Container(
        //                                                                   //color: Colors.orange,
        //                                                                   child:
        //                                                                       LayoutBuilder(
        //                                                                   builder:
        //                                                                       (context, constraints) {
        //                                                                     return Column(
        //                                                                       children: [
        //                                                                         Container(
        //                                                                             width: constraints.maxWidth * 1,
        //                                                                             padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        //                                                                             child: LayoutBuilder(
        //                                                                               builder: (context, constraints) {
        //                                                                                 return Row(
        //                                                                                   children: [
        //                                                                                     Container(
        //                                                                                       width: constraints.maxWidth * 0.35,
        //                                                                                       alignment: Alignment.topLeft,
        //                                                                                       //color: Colors.cyanAccent,
        //                                                                                       child: AutoSizeText(
        //                                                                                         "Name",
        //                                                                                         style: subHeadingStyle(1.7 * SizeConfig.blockSizeVertical),
        //                                                                                         maxLines: 2,
        //                                                                                       ),
        //                                                                                     ),
        //                                                                                     Container(
        //                                                                                       width: constraints.maxWidth * 0.65,
        //                                                                                       alignment: Alignment.center,
        //                                                                                       //color: Colors.black26,
        //                                                                                       child: FractionallySizedBox(
        //                                                                                         widthFactor: 1,
        //                                                                                         child: AutoSizeText(
        //                                                                                           (booking["name"] == null || (booking["name"]).trim() == '') ? '---' : booking["name"].toString(),
        //                                                                                           style: contentStyle(1.6 * SizeConfig.blockSizeVertical),
        //                                                                                         ),
        //                                                                                       ),
        //                                                                                     )
        //                                                                                   ],
        //                                                                                 );
        //                                                                               },
        //                                                                             )),
        //                                                                         Container(
        //                                                                             width: constraints.maxWidth * 1,
        //                                                                             padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        //                                                                             decoration: const BoxDecoration(
        //                                                                               border: Border(
        //                                                                                 top: BorderSide(width: 1.0, color: Colors.black12),
        //                                                                               ),
        //                                                                             ),
        //                                                                             child: LayoutBuilder(
        //                                                                               builder: (context, constraints) {
        //                                                                                 return Row(
        //                                                                                   children: [
        //                                                                                     Container(
        //                                                                                       width: constraints.maxWidth * 0.35,
        //                                                                                       alignment: Alignment.topLeft,
        //                                                                                       //color: Colors.cyanAccent,
        //                                                                                       child: AutoSizeText(
        //                                                                                         "Contact No",
        //                                                                                         style: subHeadingStyle(1.7 * SizeConfig.blockSizeVertical),
        //                                                                                         //maxLines: 2,
        //                                                                                       ),
        //                                                                                     ),
        //                                                                                     Container(
        //                                                                                       width: constraints.maxWidth * 0.65,
        //                                                                                       alignment: Alignment.center,
        //                                                                                       //color: Colors.black26,
        //                                                                                       child: FractionallySizedBox(
        //                                                                                         widthFactor: 1,
        //                                                                                         child: AutoSizeText((booking["phone"] == null || (booking["phone"]).trim() == '') ? '---' : booking["phone"].toString(), style: contentStyle(1.6 * SizeConfig.blockSizeVertical)),
        //                                                                                       ),
        //                                                                                     )
        //                                                                                   ],
        //                                                                                 );
        //                                                                               },
        //                                                                             ))
        //                                                                       ],
        //                                                                     );
        //                                                                   },
        //                                                                 )),
        //                                                         )
        //                                                       ],
        //                                                     );
        //                                                   }),
        //                                                 ),
        //                                                 Visibility(
        //                                                   visible: isTest &&
        //                                                       bookingDateDiff &&
        //                                                       booking['booking_origin'] ==
        //                                                           "Test",
        //                                                   child: Container(
        //                                                     width: constraints
        //                                                         .maxWidth,
        //                                                     //height: constraints.maxHeight*0.25,
        //                                                     margin:
        //                                                         EdgeInsets.only(
        //                                                             top: 7.0),
        //                                                     //color: Colors.cyanAccent,
        //                                                     child: LayoutBuilder(
        //                                                         builder: (context,
        //                                                             constraints) {
        //                                                       return Row(
        //                                                         crossAxisAlignment:
        //                                                             CrossAxisAlignment
        //                                                                 .center,
        //                                                         children: [
        //                                                           Container(
        //                                                             width: constraints
        //                                                                     .maxWidth *
        //                                                                 0.35,
        //                                                             child: AutoSizeText(
        //                                                                 "Report",
        //                                                                 style: headingStyle(SizeConfig
        //                                                                     .headingFontSize),
        //                                                                 textAlign:
        //                                                                     TextAlign.left),
        //                                                           ),
        //                                                           Container(
        //                                                               //width:constraints.maxWidth *0.7,
        //                                                               //color: Colors.black54,
        //                                                               child: isReportSubmitted
        //                                                                   ? RichText(
        //                                                                       text: TextSpan(
        //                                                                           text: 'View Report',
        //                                                                           style: TextStyle(fontSize: 1.5 * SizeConfig.blockSizeVertical, fontWeight: FontWeight.bold, color: Dark),
        //                                                                           recognizer: TapGestureRecognizer()
        //                                                                             ..onTap = () {
        //                                                                               print("tapped");
        //                                                                               _url = Uri.parse("$api/test/report/view?booking=" + booking['booking_id'].toString() + "&user=" + _userId.toString() + "&type=" + booking['booking_origin']).toString();
        //                                                                               print(_url);
        //                                                                               _launchURL();
        //                                                                             }),
        //                                                                     )
        //                                                                   : AutoSizeText("Not available", style: TextStyle(fontSize: 1.5 * SizeConfig.blockSizeVertical, fontWeight: FontWeight.bold, color: Colors.black), textAlign: TextAlign.left)
        //                                                               //: AutoSizeText("Report Submitted", style: TextStyle(fontSize: 1.5 * SizeConfig.blockSizeVertical, fontWeight: FontWeight.bold, color: Colors.green), textAlign: TextAlign.left),
        //                                                               )
        //                                                         ],
        //                                                       );
        //                                                     }),
        //                                                   ),
        //                                                 ),
        //                                                 Visibility(
        //                                                   visible:
        //                                                       booking['status'] ==
        //                                                               "assigned"
        //                                                           ? true
        //                                                           : false,
        //                                                   child: Container(
        //                                                     width: constraints
        //                                                         .maxWidth,
        //                                                     //height: constraints.maxHeight*0.25,
        //                                                     margin:
        //                                                         const EdgeInsets
        //                                                                 .only(
        //                                                             top: 7.0),
        //                                                     //color: Colors.cyanAccent,
        //                                                     child:
        //                                                         LayoutBuilder(
        //                                                       builder: (context,
        //                                                           constraints) {
        //                                                         return ElevatedButton(
        //                                                           onPressed:
        //                                                               () {
        //                                                             if (booking[
        //                                                                     'booking_add_by'] ==
        //                                                                 "self") {
        //                                                               Navigator.of(
        //                                                                       context)
        //                                                                   .push(
        //                                                                 MaterialPageRoute(
        //                                                                   builder: (context) =>
        //                                                                       ChatView(
        //                                                                     studentId:
        //                                                                         booking['user_id'],
        //                                                                     userId:
        //                                                                         _userId!,
        //                                                                   ),
        //                                                                 ),
        //                                                               );
        //                                                             } else {
        //                                                               if (isChatAvailable) {
        //                                                                 print(
        //                                                                     "CHAT");
        //                                                                 Navigator.of(context)
        //                                                                     .push(
        //                                                                   MaterialPageRoute(
        //                                                                     builder: (context) =>
        //                                                                         ChatView(
        //                                                                       studentId: booking['user_id'],
        //                                                                       userId: _userId!,
        //                                                                     ),
        //                                                                   ),
        //                                                                 );
        //                                                               } else {
        //                                                                 showValidationDialog(
        //                                                                     context,
        //                                                                     "Chat is not available!!");
        //                                                               }
        //                                                             }
        //                                                             // if (booking[
        //                                                             //         'booking_add_by'] ==
        //                                                             //     "self") {
        //                                                             //   Navigator.of(
        //                                                             //           context)
        //                                                             //       .push(
        //                                                             //     MaterialPageRoute(
        //                                                             //       builder: (context) =>
        //                                                             //           ChatView(
        //                                                             //         studentId:
        //                                                             //             booking['user_id'],
        //                                                             //         userId:
        //                                                             //             _userId!,
        //                                                             //       ),
        //                                                             //     ),
        //                                                             //   );
        //                                                             // } else {
        //                                                             //   if (isChatAvailable) {
        //                                                             //     print(
        //                                                             //         "CHAT");
        //                                                             //     Navigator.of(context)
        //                                                             //         .push(
        //                                                             //       MaterialPageRoute(
        //                                                             //         builder: (context) =>
        //                                                             //             ChatView(
        //                                                             //           studentId: booking['user_id'],
        //                                                             //           userId: _userId!,
        //                                                             //         ),
        //                                                             //       ),
        //                                                             //     );
        //                                                             //   } else {
        //                                                             //     // showValidationDialog(
        //                                                             //     //     context,
        //                                                             //     //     "Chat is not available!!");
        //                                                             //   }
        //                                                             // }
        //                                                           },
        //                                                           child: Text(
        //                                                               "Message instructor ${booking['booking_add_by']}"),
        //                                                           style: ElevatedButton
        //                                                               .styleFrom(
        //                                                             primary:
        //                                                                 Dark,
        //                                                           ),
        //                                                         );
        //                                                       },
        //                                                     ),
        //                                                   ),
        //                                                 ),
        //                                                 dateDiff1 ==
        //                                                         'showButton'
        //                                                     ? Container(
        //                                                         width: constraints
        //                                                                 .maxWidth *
        //                                                             0.9,
        //                                                         //color: Colors.cyanAccent,
        //                                                         margin: EdgeInsets
        //                                                             .only(
        //                                                                 top:
        //                                                                     7.0),
        //                                                         child:
        //                                                             LayoutBuilder(
        //                                                           builder: (context,
        //                                                               constraints) {
        //                                                             return Row(
        //                                                               mainAxisAlignment:
        //                                                                   MainAxisAlignment
        //                                                                       .spaceEvenly,
        //                                                               children: [
        //                                                                 Container(
        //                                                                     width: constraints.maxWidth *
        //                                                                         0.3,
        //                                                                     //color: Colors.black26,
        //                                                                     child:
        //                                                                         FlatButton(
        //                                                                       textColor: Colors.white,
        //                                                                       color: Colors.green,
        //                                                                       onPressed: () {
        //                                                                         track = true;
        //                                                                         Scaffold.of(context).showSnackBar(snackBar);
        //                                                                         Timer.periodic(Duration(seconds: delay), (timer) {
        //                                                                           locationData(booking["booking_id"].toString(), booking["booking_type"]);
        //                                                                         });
        //                                                                       },
        //                                                                       child: Text("Start"),
        //                                                                     )),
        //                                                                 Container(
        //                                                                     width: constraints.maxWidth *
        //                                                                         0.3,
        //                                                                     //color: Colors.black26,
        //                                                                     child:
        //                                                                         FlatButton(
        //                                                                       textColor: Colors.white,
        //                                                                       color: Colors.red,
        //                                                                       onPressed: () {
        //                                                                         track = false;
        //                                                                         // Timer.periodic(Duration(seconds: delay), (timer) {
        //                                                                         //   locationData( booking["booking_id"], booking["booking_type"]);
        //                                                                         //   //timer.cancel();
        //                                                                         // });
        //                                                                       },
        //                                                                       child: Text("Stop"),
        //                                                                     ))
        //                                                               ],
        //                                                             );
        //                                                           },
        //                                                         ))
        //                                                     : Text('')
        //                                               ],
        //                                             ),
        //                                           ),
        //                                         ),
        //                                       ]));
        //                             }),
        //                       ),
        //                   ],
        //                 ))
        //           ],
        //         );
        //       }),
        //     ),
        //   ],
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Visibility(
          child: const FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: null,
              child: Center(child: CircularProgressIndicator())),
          visible: isMoreLoading,
        ));
  }
}
