import 'dart:developer';


import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:student_app/Constants/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../../Constants/const_data.dart';
import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../responsive/sizes.dart';
import '../../services/calendar_service.dart';
import '../../services/navigation_service.dart';
import '../../style/global_style.dart';
import '../../widget/CustomSpinner.dart';

//import '../responsive/percentage_mediaquery.dart';
//import '../responsive/size_config.dart';

class Calender extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Calender();
}

class _Calender extends State<Calender> with TickerProviderStateMixin {
  final NavigationService _navigationService = locator<NavigationService>();
  final CalendarService _calendarService = new CalendarService();
  AnimationController? _animationController;
  TextEditingController requestedTimeDropController =
      new TextEditingController();
  final GlobalKey<State> _keyLoader1 = new GlobalKey<State>();

  //final String api = 'https://mockdrivingtest.com';
  String _startDate = ''; //start date for get count of events on each date
  String _endDate = ''; //end date for get count of events on each date
  DateTime _initialSelectedDay = DateTime.now();
  Map? data;
  List events = [];
  Map<DateTime, List> allEvents = {};
  bool? isTest;
  bool? isDisabled;
  Future<Map>? event;
  DateTime? _selectedDay;
  List? _selectedEvents;
  bool isEventsLoading = false;
  bool isMoreLoading = false;
  bool isMorePage = true;
  bool confirmationCheck = true;
  int pageNumber = 1;
  int? _userType;
  double? h;

  TextEditingController requestedDateController = TextEditingController();
  ScrollController? controller;
  String selectedDate_ = DateTime.now().year.toString() +
      '-' +
      DateTime.now().month.toString() +
      '-' +
      DateTime.now().day.toString();
  int visibleMonth = DateTime.now().month;

//   Future<Map<DateTime, List>?> eventList() async {
//     final url = Uri.parse("$api/api/adi/booking/all");
//     SharedPreferences storage = await SharedPreferences.getInstance();
//     String? token = storage.getString('token');
//
//     Map<String, String> header = {
//       'token': token as String,
//     };
//     final response = await http.get(url, headers: header);
//     data = jsonDecode(response.body);
//     events = data?["message"];
// print(events);
//     final groups = groupBy(events, (e) {
//
//       //return DateTime.parse(e['requested_date']);
//       //return e["requested_date"];
//     });
//
//     return null;
//   }

  Future<Map<DateTime,List>> callApiBookingCountDateWise() async {
    List bookingRecords =
        await _calendarService.getCalenderBookingCount(_startDate, _endDate);
    Map<DateTime, List<dynamic>> groups = new Map();
    bookingRecords.forEach((element) {
      groups[DateTime.parse(element['date'])] = [
        {'count': element['count']}
      ];
    });
    log("Count wise events : $groups");
    return groups;
  }

  Future<List> callApiToGetDayEvents() async {
    print("selectedDate_........" + selectedDate_);
    Map? record =
        await _calendarService.getDayEvents(selectedDate_, pageNumber);
    List<Map<dynamic, dynamic>> events = [];
    if (record != null) {
      if (record['last_page'] > pageNumber)
        isMorePage = true;
      else
        isMorePage = false;
      record['data'].forEach((event) {
        events.add(event);
      });
    }
    print("Event count " + events.length.toString());
    return events;
  }

  Future<int?> getUserType() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    int? userType = storage.getInt('userType');
    return userType;
  }

  bool isADI() {
    if (_userType == 1) {
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
    // print(diff.isNegative);
    print("Difference in hours(for editing)..." + diff.inHours.toString());
    if (!diff.isNegative) {
      if (diff.inHours > 24) {
        return false;
      }
      return true;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    final thisYear = DateTime.now();
    _startDate = thisYear.year.toString() + '-01-01';
    _endDate = thisYear.year.toString() + '-12-31';
    event = callApiBookingCountDateWise();
    getUserType().then((userType) {
      _userType = userType;
    });
    callApiToGetDayEvents().then((eventsList) {
      setState(() {
        _selectedEvents = eventsList;
      });
    });
    callApiBookingCountDateWise().then((value){
      setState(() {
        allEvents = value;
      });
    });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    controller = ScrollController()..addListener(_scrollListener);
    _animationController?.forward();

    //diffDate("2021-07-22 11:30PM");
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  List _onDaySelected(DateTime day) {
    //log("${DateTime.parse(day)}");
    log("on Day event : ${DateTime.parse(day.toString().replaceAll('Z',''))}");
    log("---------------------------------------------${allEvents[DateTime.parse(day.toString().replaceAll('Z',''))]}");
    return allEvents[DateTime.parse(day.toString().replaceAll('Z',''))] ?? [];
  }

  void showLoader(String message) {
    CustomSpinner.showLoadingDialog(context, _keyLoader1, message);
  }

  void closeLoader() {
    try {
      Navigator.of(_keyLoader1.currentContext!, rootNavigator: true).pop();
    } catch (e) {}
  }

  Future<Map?> updateCalender(String id, String type) async {
    try {
      Map formData = {
        'booking_id': id,
        'booking_type': type,
        'requested_date': requestedDateController.text,
        'requested_time': requestedTimeDropController.text,
      };
      Map? response = await _calendarService.saveCalenderDate(formData);
      print("updateCalender...$response");
      return response;
    } catch (e) {
      print(e);
    }
  }

  void _scrollListener() {
    if (controller?.position.pixels == controller?.position.maxScrollExtent &&
        isMorePage) {
      setState(() {
        pageNumber += 1;
        isMoreLoading = !isMoreLoading;
        startLoader();
      });
    }
  }

  void startLoader() {
    //call method for get data from api
    callApiToGetDayEvents().then((eventsList) {
      setState(() {
        isMoreLoading = !isMoreLoading;
        eventsList.forEach((eventItem) {
          _selectedEvents?.add(eventItem);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    h = Responsive.height(90, context);
    return Scaffold(
      body: Container(
          height: Responsive.height(100, context),
          width: Responsive.width(100, context),
          color: Colors.black26,
          child: LayoutBuilder(builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    //gradient
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(14, 155, 207, 0.75),
                              Color.fromRGBO(120, 230, 200, 0.75),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomRight,
                            stops: [0.65, 1]),
                      ),
                    ),
                    Container(
                      transform: Matrix4.translationValues(
                          (Responsive.width(1, context)),
                          (Responsive.height(4, context)),
                          0),
                      width: Responsive.width(15, context),
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(
                          left: Responsive.width(5, context),
                          top: Responsive.width(2, context)),
                      child: GestureDetector(
                        onTap: () {
                          _navigationService.goBack();
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    //text
                    Container(
                      alignment: Alignment.topCenter,
                      width: constraints.maxWidth * 1,
                      margin: EdgeInsets.fromLTRB(
                          0, constraints.maxHeight * 0.05, 0.0, 0.0),
                      child: AutoSizeText(
                        'My Calendar',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 4 * SizeConfig.blockSizeVertical,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                      width: constraints.maxWidth,
                      height: h,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, .8),
                        borderRadius: BorderRadius.only(
                            topRight:
                                Radius.circular(constraints.maxWidth * 0.12),
                            topLeft:
                                Radius.circular(constraints.maxWidth * 0.12)),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              _buildHorizontalDatesCalender(),
                              const SizedBox(height: 8.0),
                              Expanded(child: _buildEventList(context)),
                              _loader()
                            ],
                          );
                        },
                      )),
                ),
              ],
            );
          })),
    );
  }

  Widget _buildHorizontalDatesCalender() {
    return FutureBuilder(
      future: event,
      builder: (context, snapshot) {
        Map<DateTime, List<dynamic>> eList =
            snapshot.data as Map<DateTime, List<dynamic>>? ?? {};
        log("Event Lists----- : ${eList}");
        _selectedDay = DateTime.now();
        //log("$_selectedDay");
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
              margin: EdgeInsets.only(top: Responsive.height(5, context)),
              child: Center(child: CircularProgressIndicator()));
        }
        return Container(
          constraints: BoxConstraints(
            maxHeight: 500
          ),
          //color: Colors.black12,
          child: TableCalendar(
            eventLoader: _onDaySelected,
            shouldFillViewport: true,
            firstDay: DateTime.utc(DateTime.now().year - 1),
            lastDay: DateTime.utc(DateTime.now().year + 1),
            focusedDay: _initialSelectedDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            onPageChanged: (current) {
              log("On Page changed $current");
              int startDateYearInVar = int.parse(_startDate.split('-')[0]);
              int endDateYearInVar = int.parse(_endDate.split('-')[0]);
              int yearInParam = current.year;
              if (current.month == 1 && startDateYearInVar == yearInParam) {
                _startDate = (startDateYearInVar - 1).toString() + '-01-01';
                setState(() {
                  _selectedEvents = [];
                  _initialSelectedDay = DateTime(startDateYearInVar, 01, 01);
                  visibleMonth = 01;
                  event = callApiBookingCountDateWise();
                  isEventsLoading = true;
                  selectedDate_ = (startDateYearInVar).toString() + '-01-01';
                  pageNumber = 1;
                  callApiToGetDayEvents().then((eventsList) {
                    setState(() {
                      isEventsLoading = false;
                      _selectedEvents = eventsList;
                    });
                  });
                  callApiBookingCountDateWise().then((value){
                    setState(() {
                      allEvents = value;
                    });
                  });
                });
              }
              if (current.month == 12 && endDateYearInVar == yearInParam) {
                _endDate = (endDateYearInVar + 1).toString() + '-12-31';
                setState(() {
                  _selectedEvents = [];
                  _initialSelectedDay = DateTime(endDateYearInVar, 12, 01);
                  visibleMonth = 12;
                  event = callApiBookingCountDateWise();
                  isEventsLoading = true;
                  selectedDate_ = (endDateYearInVar).toString() + '-12-01';
                  pageNumber = 1;
                  callApiToGetDayEvents().then((eventsList) {
                    setState(() {
                      isEventsLoading = false;
                      _selectedEvents = eventsList;
                    });
                  });
                  callApiBookingCountDateWise().then((value){
                    setState(() {
                      allEvents = value;
                    });
                  });
                });
              }
            },
            onDaySelected: (selectedDay, focusedDay) {
              log("Selected : $selectedDay");
              log("Focused : $focusedDay");
              setState(() {
                _initialSelectedDay = selectedDay;
                selectedDate_ = selectedDay.toString();
                isEventsLoading = true;
              });
              callApiToGetDayEvents().then((dayEvent) {
                log("Day event : $dayEvent");
                setState(() {
                  _selectedEvents = dayEvent;
                  isEventsLoading = false;
                });
              });
            },
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            calendarFormat: CalendarFormat.month,
            currentDay: _initialSelectedDay,
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            rowHeight: 6 * SizeConfig.blockSizeVertical,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(
                color: Dark,
                shape: BoxShape.circle
              ),
              selectedDecoration: BoxDecoration(
                  color: Dark.withOpacity(0.5),
                  shape: BoxShape.circle
              )
            ),
            headerStyle: HeaderStyle(
              formatButtonTextStyle: TextStyle().copyWith(
                  color: Colors.white, fontSize: SizeConfig.labelFontSize),
              formatButtonDecoration: BoxDecoration(
                color: Dark,
                borderRadius: BorderRadius.circular(16.0),
              ),
              formatButtonShowsNext: false,
              leftChevronIcon: Icon(
                Icons.arrow_back_ios,
                size: 4 * SizeConfig.blockSizeVertical,
              ),
              rightChevronIcon: Icon(
                Icons.arrow_forward_ios,
                size: 4 * SizeConfig.blockSizeVertical,
              ),
              titleTextStyle:
                  TextStyle(fontSize: 2.5 * SizeConfig.blockSizeVertical),
              titleCentered: true,
            ),
            calendarBuilders: CalendarBuilders(
              singleMarkerBuilder: (context, day, events){
                log("Events : ${events as Map}");
                if (events['count'] > 0) {
                  return Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(2.0)),
                    height: 15.0,
                    //margin: EdgeInsets.only(bottom: 100,top: 0),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                    //margin: EdgeInsets.only(top: 10),
                    child: AutoSizeText(events['count'].toString(),
                        style: TextStyle(
                            color: Colors.white, fontSize: FontSize.s8)),
                  );
                } else{
                  return Text("");
                }
              },

            ),
          ),
        );
      },
    );
  }

  Widget _buildEventList(BuildContext context) {
    Widget y;
    if (_selectedEvents == null && !isEventsLoading) {
      y = Center(
        child: Text('No Bookings'),
      );
    } else if (_selectedEvents!.isEmpty && !isEventsLoading) {
      y = Center(
        child: Text('No Bookings'),
      );
    } else if (isEventsLoading) {
      y = Container(
          margin: EdgeInsets.only(top: Responsive.height(5, context)),
          child: Center(child: CircularProgressIndicator()));
    } else {
      y = Container(
        width: Responsive.width(100, context),
        //color: Colors.black12,
        alignment: Alignment.centerLeft,
        child: Container(
          width: Responsive.width(90, context),
          margin: EdgeInsets.only(
            left: Responsive.width(5, context),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ListView.builder(
                  padding: const EdgeInsets.all(0.0),
                  controller: controller,
                  itemCount: _selectedEvents?.length,
                  itemBuilder: (context, i) {
                    Map<dynamic, dynamic> event = new Map();
                    event = _selectedEvents![i];
                    if (event["booking_type"] == 'Test') {
                      isTest = true;
                    } else {
                      isTest = false;
                    }
                    if (event['requested_time'] == null ||
                        event['requested_time'] == '') {
                      event['requested_time'] = '12:00pm';
                    }
                    String bookingDateTime =
                        event['requested_date'].toString() +
                            " " +
                            event['requested_time'].toString().toUpperCase();
                    isDisabled = diffDate(bookingDateTime);
                    //requestedTimeDropController = TextEditingController(text: event["requested_time"]);
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.8),
                        borderRadius: BorderRadius.circular(12.0),
                        //color: Colors.black12,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                        trailing: !isTest!
                            ? Container(
                                width: constraints.maxWidth * 0.3,
                                //height: 25,
                                //color: Colors.black12,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Container(
                                      width: constraints.maxWidth * 0.6,
                                      //height: 30.0,
                                      alignment: Alignment.center,
                                      //color: Colors.cyanAccent,
                                      child: isADI()
                                          ? SizedBox(
                                              width:
                                                  Responsive.width(20, context),
                                              height: 4 *
                                                  SizeConfig.blockSizeVertical,
                                              child: ElevatedButton(
                                                child: AutoSizeText(
                                                  "Edit",
                                                  style: TextStyle(
                                                      color: isDisabled!
                                                          ? Colors.black
                                                          : Colors.white,
                                                      fontSize: 1.8 *
                                                          SizeConfig
                                                              .blockSizeVertical,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                onPressed: () {
                                                  if (!isDisabled!) {
                                                    if (event['requested_date'] !=
                                                            null ||
                                                        event['requested_date'] !=
                                                            '') {
                                                      var requestedDate = event[
                                                              'requested_date']
                                                          .split('-');
                                                      requestedDateController =
                                                          TextEditingController(
                                                              text: requestedDate[2] +
                                                                  '-' +
                                                                  requestedDate[
                                                                      1] +
                                                                  '-' +
                                                                  requestedDate[
                                                                      0]);
                                                    }
                                                    requestedTimeDropController =
                                                        TextEditingController(
                                                            text: event[
                                                                "requested_time"]);
                                                    Rescheduler(context, event);
                                                  } else {
                                                    Toast.show(
                                                        "You can't reschedule this lesson",
                                                        textStyle: context,
                                                        duration:
                                                            Toast.lengthLong,
                                                        gravity: Toast.bottom);
                                                  }
                                                },
                                              ),
                                            )
                                          : Text(''),
                                    );
                                  },
                                ))
                            : Text(''),
                        dense: true,
                        title: Container(
                          width: constraints.maxWidth * 0.8,
                          //color: Colors.black12,
                          padding: EdgeInsets.only(left: 10),
                          child: AutoSizeText(event["type"].toString(),
                              style: TextStyle(
                                  fontSize: 1.9 * SizeConfig.blockSizeVertical,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.left),
                        ),
                        subtitle: Container(
                          width: constraints.maxWidth * 0.8,
                          padding: EdgeInsets.only(left: 10),
                          //color: Colors.black26,
                          child: AutoSizeText(
                              event["requested_date"].toString() +
                                  " " +
                                  event["requested_time"].toString(),
                              style: headingStyle(
                                  1.5 * SizeConfig.blockSizeVertical),
                              textAlign: TextAlign.left),
                        ),
                        onTap: () {
                          print(event['booking_type']);
                          print(event['booking_origin']);
                          print("booking datetime....$bookingDateTime");
                          print("Disabled button...." + isDisabled.toString());
                        },
                      ),
                    );
                  });
            },
          ),
        ),
      );
    }

    return y;
  }

  Widget _loader() {
    return isMoreLoading
        ? Align(
            child: Container(
              width: 70.0,
              height: 70.0,
              child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Center(child: CircularProgressIndicator())),
            ),
            alignment: FractionalOffset.bottomCenter,
          )
        : const SizedBox(
            width: 0.0,
            height: 0.0,
          );
  }

  Future Rescheduler(BuildContext context, event) {
    print(requestedTimeDropController.text);
    print(event);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              width: Responsive.width(90, context),
              height: Responsive.height(43, context),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 25, 15, 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: Responsive.width(100, context),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: AutoSizeText(
                                'Edit',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Dark,
                                    fontSize:
                                        2.5 * SizeConfig.blockSizeVertical),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: AutoSizeText(
                                'Please confirm the new time with the student before rescheduling.',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize:
                                        1.8 * SizeConfig.blockSizeVertical),
                              ),
                            ),
                            Container(
                              width: Responsive.width(100, context),
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                              child: Text("Requested Date",
                                  style: inputLabelStyleDark(
                                      SizeConfig.labelFontSize),
                                  textAlign: TextAlign.left),
                            ),
                            Container(
                              width: Responsive.width(100, context),
                              height: 5 * SizeConfig.blockSizeVertical,
                              child: DateTimeField(
                                controller: requestedDateController,
                                textAlign: TextAlign.left,
                                format: DateFormat('dd-MM-yyyy'),
                                readOnly: true,
                                style: inputTextStyle(SizeConfig.inputFontSize),
                                onFieldSubmitted: (DateTime? date) {
                                  setState(() {
                                    requestedDateController.text =
                                        date.toString();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "DD-MM-YYYY",
                                  hintStyle: placeholderStyle(
                                      SizeConfig.labelFontSize),
                                  suffixIcon: Container(
                                    child: Icon(Icons.calendar_today,
                                        size: SizeConfig.labelFontSize,
                                        color: Colors.black38),
                                    margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  ),
                                  focusedBorder: inputFocusedBorderStyle(),
                                  enabledBorder: inputBorderStyle(),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(5, 10, 0, 0),
                                ),
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                      context: context,
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: Dark, // <-- SEE HERE
                                              onPrimary:
                                                  Colors.white, // <-- SEE HERE
                                              onSurface:
                                                  Colors.black, // <-- SEE HERE
                                            ),
                                            textButtonTheme:
                                                TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    Dark, // button text color
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                      firstDate: DateTime.now(),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(
                                          DateTime.now().year + 30, 12, 31));
                                },
                              ),
                            ),
                            Container(
                              width: Responsive.width(100, context),
                              margin: EdgeInsets.fromLTRB(0, 15, 0, 5),
                              child: Text("Requested Time",
                                  style: inputLabelStyleDark(
                                      SizeConfig.labelFontSize),
                                  textAlign: TextAlign.left),
                            ),
                            Container(
                                width: Responsive.width(100, context),
                                height: 40,
                                child: TypeAheadField(
                                  debounceDuration: Duration(milliseconds: 0),
                                  animationDuration: Duration(milliseconds: 0),
                                  hideKeyboard: true,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                          textAlign: TextAlign.left,
                                          controller:
                                              requestedTimeDropController,
                                          style: inputTextStyle(
                                              SizeConfig.inputFontSize),
                                          decoration: InputDecoration(
                                            focusedBorder:
                                                inputFocusedBorderStyle(),
                                            enabledBorder: inputBorderStyle(),
                                            hintText: '--Select--',
                                            hintStyle: placeholderStyle(
                                                SizeConfig.labelFontSize),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                5, 10, 3, 10),
                                          )),
                                  suggestionsBoxDecoration:
                                      const SuggestionsBoxDecoration(
                                          elevation: 5,
                                          constraints: BoxConstraints(
                                              maxHeight: 150, maxWidth: 200)),
                                  suggestionsCallback: (pattern) async {
                                    return timeSlots;
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      title: AutoSizeText(suggestion as String),
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    try {
                                      setState(() {
                                        requestedTimeDropController.text =
                                            suggestion as String;
                                      });
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                )),
                            Container(
                                width: Responsive.width(100, context),
                                margin: EdgeInsets.fromLTRB(0, 15, 0, 5),
                                //color:Colors.cyanAccent,
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: constraints.maxWidth * 0.1,
                                          height: 2.5 *
                                              SizeConfig.blockSizeVertical,
                                          //color: Colors.black12,
                                          alignment: Alignment.topLeft,
                                          padding: EdgeInsets.all(0),
                                          child: Transform.scale(
                                            scale: .1 *
                                                SizeConfig.blockSizeVertical,
                                            child: Checkbox(
                                              value: confirmationCheck,
                                              onChanged: (val) {
                                                print(confirmationCheck);
                                                setState(() {
                                                  confirmationCheck = val!;
                                                });
                                              },
                                              activeColor: Dark,
                                            ),
                                          )),
                                      Container(
                                        width: constraints.maxWidth * 0.85,
                                        height:
                                            4 * SizeConfig.blockSizeVertical,
                                        alignment: Alignment.centerLeft,
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                                child: AutoSizeText(
                                              'I confirm that I have agreed the new time with the student before making change.',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontSize: 1.8 *
                                                      SizeConfig
                                                          .blockSizeVertical),
                                            ));
                                          },
                                        ),
                                      )
                                    ],
                                  );
                                })),
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            //margin: const EdgeInsets.only(right: 10),
                            child: SizedBox(
                              width: Responsive.width(25, context),
                              height: 4 * SizeConfig.blockSizeVertical,
                              child: ElevatedButton(
                                child: AutoSizeText(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          1.8 * SizeConfig.blockSizeVertical,
                                      fontWeight: FontWeight.w500),
                                ),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                            ),
                          ),
                          Container(
                            child: SizedBox(
                              width: Responsive.width(30, context),
                              height: 4 * SizeConfig.blockSizeVertical,
                              child: ElevatedButton(
                                child: AutoSizeText(
                                  "Re-schedule",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          1.8 * SizeConfig.blockSizeVertical,
                                      fontWeight: FontWeight.w500),
                                ),
                                onPressed: () {
                                  print(requestedTimeDropController.text);
                                  print(requestedDateController.text);
                                  print(event["booking_id"]);
                                  print(event["booking_origin"]);
                                  showLoader("Re-scheduling...");
                                  updateCalender(event["booking_id"].toString(),
                                          event["booking_origin"])
                                      .then((response) {
                                    print(response);
                                    if (response?['message'] != null) {
                                      Toast.show(response?['message'],
                                          textStyle: context,
                                          duration: Toast.lengthLong,
                                          gravity: Toast.bottom);
                                      if (response?['success'] == true) {
                                        _navigationService.goBack();
                                      }
                                    }
                                    closeLoader();
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
