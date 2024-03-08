import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Smart_Theory_Test/Constants/app_colors.dart';
import 'package:toast/toast.dart';

import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/navigation_service.dart';
import '../../services/report_services.dart';
import '../../style/global_style.dart';
import '../../widget/CustomAppBar.dart';
import '../../widget/CustomSpinner.dart';

class MockTestReport extends StatefulWidget {
  final Map details;
  MockTestReport(this.details);
  @override
  _MockTestReportState createState() => _MockTestReportState(this.details);
}

class _MockTestReportState extends State<MockTestReport> {
  late Map details;
  late ScrollController reportFormScrollController;

  _MockTestReportState(this.details);
  final NavigationService _navigationService = locator<NavigationService>();
  final ReportServices _reportServices = new ReportServices();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<String> xx = [];
  bool chk = false;
  bool chk1 = false;
  TextEditingController routeDetailController = new TextEditingController();
  TextEditingController commentController = new TextEditingController();

  List<Map<String, dynamic>> report = [
    {
      'heading': null,
      'sub_heading': '1a Eyesight',
      'key': 'eyesight',
      'selected_value': null
    },
    {
      'heading': null,
      'sub_heading': '1b H/Code / Safety',
      'key': 'first_option-0-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'first_option-0-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': '2 Controlled Stop',
      'key': 'first_option-1-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'first_option-1-checkbox',
      'checkbox_val': null
    },
    {
      'heading': '3 Reverse / Left Reverse with trailer',
      'sub_heading': '',
      'selected_value': ''
    },
    {
      'heading': null,
      'sub_heading': 'Control',
      'key': 'reverse_left_reverse_with_trailer-0-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'reverse_left_reverse_with_trailer-0-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Observation',
      'key': 'reverse_left_reverse_with_trailer-1-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'reverse_left_reverse_with_trailer-1-checkbox',
      'checkbox_val': null
    },
    {'heading': '4 Reverse/ Right', 'sub_heading': '', 'selected_value': ''},
    {
      'heading': null,
      'sub_heading': 'Control',
      'key': 'reverse_right-0-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'reverse_right-0-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Observation',
      'key': 'reverse_right-1-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'reverse_right-1-checkbox',
      'checkbox_val': null
    },
    {'heading': '5 Reverse Park', 'sub_heading': '', 'selected_value': ''},
    {
      'heading': null,
      'sub_heading': 'Control',
      'key': 'reverse_park-0-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'reverse_park-0-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Observation',
      'key': 'reverse_park-1-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'reverse_park-1-checkbox',
      'checkbox_val': null
    },
    {'heading': '6 Turn in road', 'sub_heading': '', 'selected_value': ''},
    {
      'heading': null,
      'sub_heading': 'Control',
      'key': 'turn_in_road-0-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'turn_in_road-0-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Observation',
      'key': 'turn_in_road-1-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'turn_in_road-1-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': '7 Vehicle checks',
      'key': 'turn_in_road-2-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'turn_in_road-2-checkbox',
      'checkbox_val': null
    },
    {
      'heading': '8 Forward park / Taxi manoeuvre',
      'sub_heading': '',
      'selected_value': ''
    },
    {
      'heading': null,
      'sub_heading': 'Control',
      'key': 'forward_park_taxi_manoeuvre-0-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'forward_park_taxi_manoeuvre-0-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Observation',
      'key': 'forward_park_taxi_manoeuvre-1-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'forward_park_taxi_manoeuvre-1-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': '9 Taxi wheelchair',
      'key': 'forward_park_taxi_manoeuvre-2-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'forward_park_taxi_manoeuvre-2-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': '10 Uncouple / recouple',
      'key': 'forward_park_taxi_manoeuvre-3-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'forward_park_taxi_manoeuvre-3-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': '11 Precautions',
      'key': 'forward_park_taxi_manoeuvre-4-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'forward_park_taxi_manoeuvre-4-checkbox',
      'checkbox_val': null
    },
    {'heading': '12 Control', 'sub_heading': '', 'selected_value': ''},
    {
      'heading': null,
      'sub_heading': 'Accelerator',
      'key': '12_control-0-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '12_control-0-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Clutch',
      'key': '12_control-1-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '12_control-1-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Gears',
      'key': '12_control-2-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '12_control-2-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Footbrake',
      'key': '12_control-3-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '12_control-3-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Parking brake / MC front brake',
      'key': '12_control-4-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '12_control-4-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Steering',
      'key': '12_control-5-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '12_control-5-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Balance M/C',
      'key': '12_control-6-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '12_control-6-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'PCV door exercise',
      'key': '12_control-7-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '12_control-7-checkbox',
      'checkbox_val': null
    },
    {'heading': '13 Move off', 'sub_heading': '', 'selected_value': ''},
    {
      'heading': null,
      'sub_heading': 'Safety',
      'key': '13_move_off-0-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '13_move_off-0-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Control',
      'key': '13_move_off-1-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '13_move_off-1-checkbox',
      'checkbox_val': null
    },
    {
      'heading': '14 Use of mirrors- M/C rear obs',
      'sub_heading': '',
      'selected_value': ''
    },
    {
      'heading': null,
      'sub_heading': 'Signalling',
      'key': 'use_of_mirrors_rear_obs-0-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'use_of_mirrors_rear_obs-0-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Change direction',
      'key': 'use_of_mirrors_rear_obs-1-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'use_of_mirrors_rear_obs-1-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Change speed',
      'key': 'use_of_mirrors_rear_obs-2-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'use_of_mirrors_rear_obs-2-checkbox',
      'checkbox_val': null
    },
    {'heading': '15 Signals', 'sub_heading': '', 'selected_value': ''},
    {
      'heading': null,
      'sub_heading': 'Necessary',
      'key': '15_signals-0-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '15_signals-0-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Correctly',
      'key': '15_signals-1-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '15_signals-1-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Timed',
      'key': '15_signals-2-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '15_signals-2-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': '16 Clearance / obstructions',
      'key': '15_signals-3-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '15_signals-3-checkbox',
      'checkbox_val': null
    },
    {
      'heading': '17 Response to signs / signals',
      'sub_heading': '',
      'selected_value': ''
    },
    {
      'heading': null,
      'sub_heading': 'Traffic signs',
      'key': 'response_to_signs_signals-0-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'response_to_signs_signals-0-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Road markings',
      'key': 'response_to_signs_signals-1-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'response_to_signs_signals-1-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Traffic lights',
      'key': 'response_to_signs_signals-2-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'response_to_signs_signals-2-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Traffic controllers',
      'key': 'response_to_signs_signals-3-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'response_to_signs_signals-3-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Other road users',
      'key': 'response_to_signs_signals-4-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'response_to_signs_signals-4-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': '18 Use of speed',
      'key': 'response_to_signs_signals-5-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'response_to_signs_signals-5-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': '19 Following distance',
      'key': 'response_to_signs_signals-6-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': 'response_to_signs_signals-6-checkbox',
      'checkbox_val': null
    },
    {'heading': '20 Progress', 'sub_heading': '', 'selected_value': ''},
    {
      'heading': null,
      'sub_heading': 'Appropriate',
      'key': '20_progress-0-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '20_progress-0-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Speed',
      'key': '20_progress-1-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '20_progress-1-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Undue hesitation',
      'key': '20_progress-2-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '20_progress-2-checkbox',
      'checkbox_val': null
    },
    {'heading': '21 Junctions', 'sub_heading': '', 'selected_value': ''},
    {
      'heading': null,
      'sub_heading': 'Approach speed',
      'key': '21_junctions-0-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '21_junctions-0-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Observation',
      'key': '21_junctions-1-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '21_junctions-1-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Turning right',
      'key': '21_junctions-2-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '21_junctions-2-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Turning left',
      'key': '21_junctions-3-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '21_junctions-3-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Cutting corners',
      'key': '21_junctions-4-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '21_junctions-4-checkbox',
      'checkbox_val': null
    },
    {'heading': '22 Judgement', 'sub_heading': '', 'selected_value': ''},
    {
      'heading': null,
      'sub_heading': 'Overtaking',
      'key': '22_judgement-0-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '22_judgement-0-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Meeting',
      'key': '22_judgement-1-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '22_judgement-1-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Crossing',
      'key': '22_judgement-2-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '22_judgement-2-checkbox',
      'checkbox_val': null
    },
    {'heading': '23 Positioning', 'sub_heading': '', 'selected_value': ''},
    {
      'heading': null,
      'sub_heading': 'Normal driving',
      'key': '23_positioning-0-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '23_positioning-0-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': 'Lane discipline',
      'key': '23_positioning-1-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '23_positioning-1-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': '24 Pedestrian crossings',
      'key': '23_positioning-2-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '23_positioning-2-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': '25 Position / normal stops',
      'key': '23_positioning-3-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '23_positioning-3-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': '26 Awareness / planning',
      'key': '23_positioning-4-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '23_positioning-4-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': '27 Ancillary controls',
      'key': '23_positioning-5-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '23_positioning-5-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': '28 Spare 1',
      'key': '23_positioning-6-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '23_positioning-6-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': '29 Spare 2',
      'key': '23_positioning-7-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '23_positioning-7-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': '30 Spare 3',
      'key': '23_positioning-8-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '23_positioning-8-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': '31 Spare 4',
      'key': '23_positioning-9-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '23_positioning-9-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': '32 Spare 5',
      'key': '23_positioning-10-radio',
      'selected_value': 0,
      'check1': false,
      'check2': false,
      'checkbox_key': '23_positioning-10-checkbox',
      'checkbox_val': null
    },
    {
      'heading': null,
      'sub_heading': '33 Wheelchair',
      'key': 'wheelchair',
      'selected_value': null
    },
    {
      'heading': null,
      'sub_heading': 'Overall Result',
      'key': 'overall_result',
      'selected_value': null
    },
  ];
  @override
  void initState() {
    reportFormScrollController = ScrollController();
    super.initState();
    // KeyboardVisibilityNotification().addNewListener(
    //   onChange: (bool visible) {
    //     if (!visible) {
    //       FocusScopeNode currentFocus = FocusScope.of(context);
    //       if (!currentFocus.hasPrimaryFocus) {
    //         currentFocus.unfocus();
    //       }
    //     }
    //   },
    // );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print(details);
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          CustomAppBar(
            preferedHeight: Responsive.height(20, context),
            title: 'Mock Test Report',
            textWidth: Responsive.width(35, context),
            iconLeft: Icons.arrow_back,
            onTap1: () {
              _navigationService.goBack();
            },
            iconRight: null,
          ),
          Container(
              // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              margin: EdgeInsets.fromLTRB(
                  20, Responsive.height(12, context), 20, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                // border: BoxBorder(),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      offset: Offset(1, 2),
                      blurRadius: 5.0)
                ],
              ),
              height: Responsive.height(85, context),
              child: LayoutBuilder(builder: (context, constraints) {
                return Container(
                    width: constraints.maxWidth * 1,
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          height: Responsive.height(15, context),
                          //color: Colors.redAccent,
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: LayoutBuilder(builder: (context, constraints) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: constraints.maxWidth * 0.48,
                                  height: constraints.maxHeight * 1,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right:
                                          BorderSide(width: 1.0, color: Dark),
                                    ),
                                  ),
                                  //color: Colors.grey[200],
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Column(
                                        children: [
                                          Container(
                                            width: constraints.maxWidth,
                                            child: AutoSizeText("Test Details",
                                                style: inputLabelStyleDark(
                                                    SizeConfig.labelFontSize),
                                                textAlign: TextAlign.center),
                                          ),
                                          Container(
                                            width: constraints.maxWidth * 0.95,
                                            margin: EdgeInsets.only(top: 5.0),
                                            //color: Colors.black12,
                                            child: LayoutBuilder(
                                              builder: (context, constraints) {
                                                return Column(
                                                  children: [
                                                    Container(
                                                      width:
                                                          constraints.maxWidth,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: constraints
                                                                    .maxWidth *
                                                                0.35,
                                                            //color: Colors.redAccent,
                                                            //alignment: Alignment.topLeft,
                                                            child: AutoSizeText(
                                                                "Test ID",
                                                                style: TextStyle(
                                                                    fontSize: 1.5 *
                                                                        SizeConfig
                                                                            .blockSizeVertical,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left),
                                                          ),
                                                          Container(
                                                            width: constraints
                                                                    .maxWidth *
                                                                0.65,
                                                            //color: Colors.redAccent,
                                                            child: AutoSizeText(
                                                                details['booking_id']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize: 1.5 *
                                                                        SizeConfig
                                                                            .blockSizeVertical,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          constraints.maxWidth,
                                                      margin: EdgeInsets.only(
                                                          top: 5.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: constraints
                                                                    .maxWidth *
                                                                0.35,
                                                            //color: Colors.redAccent,
                                                            //alignment: Alignment.topLeft,
                                                            child: AutoSizeText(
                                                                "Location",
                                                                style: TextStyle(
                                                                    fontSize: 1.5 *
                                                                        SizeConfig
                                                                            .blockSizeVertical,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left),
                                                          ),
                                                          Container(
                                                            width: constraints
                                                                    .maxWidth *
                                                                0.65,
                                                            //color: Colors.redAccent,
                                                            child: AutoSizeText(
                                                              details['location']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 1.5 *
                                                                      SizeConfig
                                                                          .blockSizeVertical,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 3,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          constraints.maxWidth,
                                                      margin: EdgeInsets.only(
                                                          top: 5.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: constraints
                                                                    .maxWidth *
                                                                0.35,
                                                            //color: Colors.redAccent,
                                                            child: AutoSizeText(
                                                                "Date Time",
                                                                style: TextStyle(
                                                                    fontSize: 1.5 *
                                                                        SizeConfig
                                                                            .blockSizeVertical,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left),
                                                          ),
                                                          Container(
                                                            width: constraints
                                                                    .maxWidth *
                                                                0.65,
                                                            //color: Colors.redAccent,
                                                            child: AutoSizeText(
                                                              details['requested_date']
                                                                      .toString() +
                                                                  " " +
                                                                  details['requested_time']
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 1.5 *
                                                                      SizeConfig
                                                                          .blockSizeVertical,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 2,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  width: constraints.maxWidth * 0.48,
                                  height: constraints.maxHeight * 1,
                                  //color: Colors.grey[200],
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Column(
                                        children: [
                                          Container(
                                            width: constraints.maxWidth,
                                            child: AutoSizeText(
                                                "Driver Details",
                                                style: inputLabelStyleDark(
                                                    SizeConfig.labelFontSize),
                                                textAlign: TextAlign.center),
                                          ),
                                          Container(
                                            width: constraints.maxWidth * 0.95,
                                            margin: EdgeInsets.only(top: 5.0),

                                            //color: Colors.black12,
                                            child: LayoutBuilder(
                                              builder: (context, constraints) {
                                                return Column(
                                                  children: [
                                                    Container(
                                                      width:
                                                          constraints.maxWidth,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: constraints
                                                                    .maxWidth *
                                                                0.35,
                                                            //color: Colors.redAccent,
                                                            //alignment: Alignment.topLeft,
                                                            child: AutoSizeText(
                                                                "Name",
                                                                style: TextStyle(
                                                                    fontSize: 1.5 *
                                                                        SizeConfig
                                                                            .blockSizeVertical,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left),
                                                          ),
                                                          Container(
                                                            width: constraints
                                                                    .maxWidth *
                                                                0.65,
                                                            //color: Colors.redAccent,
                                                            child: AutoSizeText(
                                                                details['name']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize: 1.5 *
                                                                        SizeConfig
                                                                            .blockSizeVertical,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Container(
                                                    //   width: constraints.maxWidth,
                                                    //   margin: EdgeInsets.only(
                                                    //       top: 5.0
                                                    //   ),
                                                    //   child: Row(
                                                    //     crossAxisAlignment: CrossAxisAlignment.start,
                                                    //     children: [
                                                    //       Container(
                                                    //         width: constraints.maxWidth*0.35,
                                                    //         //color: Colors.redAccent,
                                                    //         //alignment: Alignment.topLeft,
                                                    //         child: AutoSizeText("Vehicle Preferences",
                                                    //             style: TextStyle(
                                                    //                 fontSize: 1.5*SizeConfig.blockSizeVertical,
                                                    //                 color: Colors.black,
                                                    //                 fontWeight: FontWeight.w500),
                                                    //             textAlign: TextAlign.left),
                                                    //       ),
                                                    //       Container(
                                                    //         width: constraints.maxWidth*0.65,
                                                    //         //color: Colors.redAccent,
                                                    //         child: AutoSizeText(details['location'].toString(),
                                                    //           style: TextStyle(
                                                    //               fontSize: 1.5*SizeConfig.blockSizeVertical,
                                                    //               color: Colors.black,
                                                    //               fontWeight: FontWeight.w400),
                                                    //           textAlign: TextAlign.center,
                                                    //           maxLines: 3,
                                                    //         ),
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                    Container(
                                                      width:
                                                          constraints.maxWidth,
                                                      margin: EdgeInsets.only(
                                                          top: 8.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: constraints
                                                                    .maxWidth *
                                                                0.35,
                                                            //color: Colors.redAccent,
                                                            child: AutoSizeText(
                                                                "Driver License",
                                                                style: TextStyle(
                                                                    fontSize: 1.5 *
                                                                        SizeConfig
                                                                            .blockSizeVertical,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left),
                                                          ),
                                                          Container(
                                                            width: constraints
                                                                    .maxWidth *
                                                                0.65,
                                                            //color: Colors.redAccent,
                                                            child: AutoSizeText(
                                                              details['driver_license_no'] ==
                                                                      null
                                                                  ? ''
                                                                  : details[
                                                                      'driver_license_no'],
                                                              style: TextStyle(
                                                                  fontSize: 1.5 *
                                                                      SizeConfig
                                                                          .blockSizeVertical,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 2,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                )
                              ],
                            );
                          }),
                        ),
                        Container(
                          width: Responsive.width(100, context),
                          height: Responsive.height(62, context),
                          //color: Colors.green,
                          padding: EdgeInsets.fromLTRB(5, 3, 5, 0),
                          child: ListView(
                            controller: reportFormScrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.fromLTRB(10, 2, 10,
                                MediaQuery.of(context).viewInsets.bottom),
                            children: [
                              LayoutBuilder(builder: (context, constraints) {
                                return reportFields(context, constraints);
                              }),
                            ],
                          ),
                        ),
                        Container(
                          width: Responsive.width(100, context),
                          height: Responsive.height(8, context),
                          //color: Colors.cyanAccent,
                          padding: EdgeInsets.all(0),
                          child: LayoutBuilder(builder: (context, constraints) {
                            return footerActionBar(context);
                          }),
                        ),
                      ],
                    ));
              })),
        ],
      ),
    );
  }

  Widget footerActionBar(BuildContext context) {
    return (Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: Responsive.height(8, context),
          alignment: Alignment.centerRight,
          child: ButtonBar(
            alignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(Responsive.width(2, context), 0,
                    Responsive.width(2, context), 0),
                child: ButtonTheme(
                  minWidth: Responsive.width(25, context),
                  height: Responsive.height(5, context),
                  child: ElevatedButton(
                    child: new AutoSizeText(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      print(details["booking_origin"]);
                      if (!validate()) {
                        Toast.show("Please filled all required(*) field.",
                            textStyle: context,
                            duration: Toast.lengthLong,
                            gravity: Toast.bottom);
                      } else {
                        setState(() {
                          try {
                            print("submit report");
                            print("print report...$report");
                            Map<String, dynamic> reportData = {};
                            reportData["_token"] = "";
                            reportData["route_details"] =
                                routeDetailController.text;
                            report.forEach((x) {
                              //print(x["checkbox_val"].runtimeType);
                              if (x.containsKey("key") &&
                                  x["selected_value"] != null) {
                                reportData[x['key']] = x['selected_value'];
                                if (x.containsKey("checkbox_key")) {
                                  setState(() {
                                    if (x["check1"] && x["check2"]) {
                                      x["checkbox_val"] = ["s", "d"];
                                    } else if (x["check1"] && !x["check2"]) {
                                      x["checkbox_val"] = ["s"];
                                    } else if (!x["check1"] && x["check2"]) {
                                      x["checkbox_val"] = ["d"];
                                    }
                                  });
                                  if (x['checkbox_val'] != null) {
                                    setState(() {
                                      reportData[x['checkbox_key']] =
                                          x["checkbox_val"];
                                    });
                                  }
                                }
                              }
                            });
                            reportData["comments"] = commentController.text;
                            reportData["test_id"] = details["booking_id"];
                            print(jsonEncode(reportData));
                            print("report data...$reportData");

                            Map<String, dynamic> testData = {
                              'booking_id': details["booking_id"].toString(),
                              'report_data': jsonEncode(reportData),
                              'booking_type': details["booking_origin"]
                            };
                            showLoader('Report Submitting...');
                            submitReport(testData).then((response) {
                              if (response!['message'] != null) {
                                Toast.show(response['message'],
                                    textStyle: context,
                                    duration: Toast.lengthLong,
                                    gravity: Toast.bottom);
                                if (response['success'] == true) {
                                  _navigationService.goBack();
                                }
                              }
                              closeLoader();
                            });
                          } catch (e) {
                            print(e);
                            Toast.show('Failed request! please try again.',
                                textStyle: context,
                                duration: Toast.lengthLong,
                                gravity: Toast.bottom);
                          }
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }

  Widget reportFields(BuildContext context, BoxConstraints constraints) {
    return Column(
      children: [
        Container(
          width: constraints.maxWidth,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: AutoSizeText("Please fill and submit report",
              style: TextStyle(
                  fontSize: 2.2 * SizeConfig.blockSizeVertical,
                  color: Dark,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.left),
        ),
        Container(
            width: constraints.maxWidth,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: Column(
              children: [
                Container(
                  width: Responsive.width(100, context),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: AutoSizeText("Route Details*",
                      style: inputLabelStyleDark(SizeConfig.labelFontSize),
                      textAlign: TextAlign.left),
                ),
                Container(
                    width: Responsive.width(100, context),
                    height: 4 * SizeConfig.blockSizeVertical,
                    child: TextField(
                        //showCursor: false,
                        controller: routeDetailController,
                        style: inputTextStyle(SizeConfig.inputFontSize),
                        decoration: InputDecoration(
                          focusedBorder: inputFocusedBorderStyle(),
                          enabledBorder: inputBorderStyle(),
                          hintStyle: placeholderStyle(SizeConfig.labelFontSize),
                          contentPadding: EdgeInsets.fromLTRB(5, 0, 3, 16),
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (value) {}))
              ],
            )),
        ...report.map((report) => Container(
            width: constraints.maxWidth,
            margin: EdgeInsets.only(bottom: 10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (report['sub_heading'] == '1a Eyesight')
                      Container(
                          width: constraints.maxWidth,
                          margin: EdgeInsets.only(bottom: 0),
                          //color: Colors.cyanAccent,
                          child: Column(
                            children: [
                              Container(
                                width: constraints.maxWidth,
                                padding: EdgeInsets.only(
                                    top: 4.0,
                                    bottom: 4.0,
                                    left: 3.0,
                                    right: 3.0),
                                color: Light,
                                child: AutoSizeText(report['sub_heading'],
                                    style: TextStyle(
                                        fontSize:
                                            1.8 * SizeConfig.blockSizeVertical,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500)),
                              ),
                              Container(
                                  width: constraints.maxWidth,
                                  margin: EdgeInsets.only(top: 5.0),
                                  color: Colors.grey[200],
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Row(
                                        children: [
                                          Container(
                                              width: constraints.maxWidth * 0.1,
                                              height: 4 *
                                                  SizeConfig.blockSizeVertical,
                                              //color: Colors.black12,
                                              alignment: Alignment.topLeft,
                                              //color: Colors.black12,
                                              padding: EdgeInsets.all(0),
                                              child: Transform.scale(
                                                scale: .1 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                child: Radio(
                                                  value: 1,
                                                  groupValue:
                                                      report['selected_value'],
                                                  activeColor: Dark,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      report['selected_value'] =
                                                          val;
                                                    });
                                                  },
                                                ),
                                              )),
                                          Container(
                                              width:
                                                  constraints.maxWidth * 0.25,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(left: 5),
                                              child: AutoSizeText('Ok',
                                                  style: TextStyle(
                                                      fontSize: 1.8 *
                                                          SizeConfig
                                                              .blockSizeVertical,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                          Container(
                                              width: constraints.maxWidth * 0.1,
                                              height: 4 *
                                                  SizeConfig.blockSizeVertical,
                                              //color: Colors.black12,
                                              alignment: Alignment.topLeft,
                                              //color: Colors.black12,
                                              padding: EdgeInsets.all(0),
                                              child: Transform.scale(
                                                scale: .1 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                child: Radio(
                                                  value: 0,
                                                  groupValue:
                                                      report['selected_value'],
                                                  activeColor: Dark,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      report['selected_value'] =
                                                          val;
                                                    });
                                                  },
                                                ),
                                              )),
                                          Container(
                                              width:
                                                  constraints.maxWidth * 0.25,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(left: 5),
                                              child: AutoSizeText('Not Ok',
                                                  style: TextStyle(
                                                      fontSize: 1.8 *
                                                          SizeConfig
                                                              .blockSizeVertical,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                        ],
                                      );
                                    },
                                  )
                                  // AutoSizeText("hello",
                                  //     style: TextStyle(
                                  //         fontSize: 1.8*SizeConfig.blockSizeVertical,
                                  //         color: Colors.black,
                                  //         fontWeight: FontWeight.w400)
                                  // ),
                                  )
                            ],
                          )),
                    if (report['heading'] != null)
                      Container(
                        width: constraints.maxWidth,
                        margin: EdgeInsets.only(top: 3.0),
                        child: AutoSizeText(report['heading'],
                            style:
                                inputLabelStyleDark(SizeConfig.labelFontSize)),
                      ),
                    if (report['heading'] == null &&
                        report['sub_heading'] != '1a Eyesight' &&
                        report['sub_heading'] != '33 Wheelchair' &&
                        report['sub_heading'] != 'Overall Result')
                      Container(
                          width: constraints.maxWidth,
                          margin: EdgeInsets.only(top: 0.0),
                          //color: Colors.cyanAccent,
                          child: Column(
                            children: [
                              Container(
                                width: constraints.maxWidth,
                                margin: EdgeInsets.only(bottom: 0.0),
                                padding: EdgeInsets.only(
                                    top: 4.0,
                                    bottom: 4.0,
                                    left: 3.0,
                                    right: 3.0),
                                color: Light,
                                child: AutoSizeText(report['sub_heading'],
                                    style: TextStyle(
                                        fontSize:
                                            1.8 * SizeConfig.blockSizeVertical,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500)),
                              ),
                              Container(
                                  width: constraints.maxWidth,
                                  margin: EdgeInsets.only(top: 5.0),
                                  color: Colors.grey[200],
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Row(
                                        children: [
                                          Container(
                                              width: constraints.maxWidth * 0.1,
                                              height: 4 *
                                                  SizeConfig.blockSizeVertical,
                                              //color: Colors.black12,
                                              alignment: Alignment.topLeft,
                                              //color: Colors.black12,
                                              padding: EdgeInsets.all(0),
                                              child: Transform.scale(
                                                scale: .1 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                child: Radio(
                                                  value: 0,
                                                  groupValue:
                                                      report['selected_value'],
                                                  activeColor: Dark,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      report['selected_value'] =
                                                          val;
                                                    });
                                                  },
                                                ),
                                              )),
                                          Container(
                                              width: constraints.maxWidth * 0.1,
                                              alignment: Alignment.centerLeft,
                                              //color:Colors.black12,
                                              padding: EdgeInsets.only(left: 5),
                                              child: AutoSizeText('0',
                                                  style: TextStyle(
                                                      fontSize: 1.8 *
                                                          SizeConfig
                                                              .blockSizeVertical,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                          Container(
                                              width: constraints.maxWidth * 0.1,
                                              height: 4 *
                                                  SizeConfig.blockSizeVertical,
                                              //color: Colors.black12,
                                              alignment: Alignment.topLeft,
                                              //color: Colors.black12,
                                              padding: EdgeInsets.all(0),
                                              child: Transform.scale(
                                                scale: .1 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                child: Radio(
                                                  value: 1,
                                                  groupValue:
                                                      report['selected_value'],
                                                  activeColor: Dark,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      report['selected_value'] =
                                                          val;
                                                    });
                                                  },
                                                ),
                                              )),
                                          Container(
                                              width: constraints.maxWidth * 0.1,
                                              alignment: Alignment.centerLeft,
                                              //color:Colors.black12,
                                              padding: EdgeInsets.only(left: 5),
                                              child: AutoSizeText('1',
                                                  style: TextStyle(
                                                      fontSize: 1.8 *
                                                          SizeConfig
                                                              .blockSizeVertical,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                          Container(
                                              width: constraints.maxWidth * 0.1,
                                              height: 4 *
                                                  SizeConfig.blockSizeVertical,
                                              //color: Colors.black12,
                                              alignment: Alignment.topLeft,
                                              //color: Colors.black12,
                                              padding: EdgeInsets.all(0),
                                              child: Transform.scale(
                                                scale: .1 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                child: Radio(
                                                  value: 2,
                                                  groupValue:
                                                      report['selected_value'],
                                                  activeColor: Dark,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      report['selected_value'] =
                                                          val;
                                                    });
                                                  },
                                                ),
                                              )),
                                          Container(
                                              width: constraints.maxWidth * 0.1,
                                              alignment: Alignment.centerLeft,
                                              //color:Colors.black12,
                                              padding: EdgeInsets.only(left: 5),
                                              child: AutoSizeText('2',
                                                  style: TextStyle(
                                                      fontSize: 1.8 *
                                                          SizeConfig
                                                              .blockSizeVertical,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                          Container(
                                              width: constraints.maxWidth * 0.1,
                                              height: 4 *
                                                  SizeConfig.blockSizeVertical,
                                              //color: Colors.black12,
                                              alignment: Alignment.topLeft,
                                              //color: Colors.black12,
                                              padding: EdgeInsets.all(0),
                                              child: Transform.scale(
                                                scale: .1 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                child: Radio(
                                                  value: 3,
                                                  groupValue:
                                                      report['selected_value'],
                                                  activeColor: Dark,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      report['selected_value'] =
                                                          val;
                                                    });
                                                  },
                                                ),
                                              )),
                                          Container(
                                              width:
                                                  constraints.maxWidth * 0.25,
                                              alignment: Alignment.centerLeft,
                                              //color:Colors.black12,
                                              padding: EdgeInsets.only(left: 5),
                                              child: AutoSizeText('3 or more',
                                                  style: TextStyle(
                                                      fontSize: 1.8 *
                                                          SizeConfig
                                                              .blockSizeVertical,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                        ],
                                      );
                                    },
                                  )
                                  // AutoSizeText("hello",
                                  //     style: TextStyle(
                                  //         fontSize: 1.8*SizeConfig.blockSizeVertical,
                                  //         color: Colors.black,
                                  //         fontWeight: FontWeight.w400)
                                  // ),
                                  ),
                              Container(
                                  width: constraints.maxWidth,
                                  margin: EdgeInsets.only(top: 0.0),
                                  color: Colors.grey[200],
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Row(
                                        children: [
                                          Container(
                                              width: constraints.maxWidth * 0.1,
                                              height: 4 *
                                                  SizeConfig.blockSizeVertical,
                                              //color: Colors.black12,
                                              alignment: Alignment.topLeft,
                                              //color: Colors.black12,
                                              padding: EdgeInsets.all(0),
                                              child: Transform.scale(
                                                scale: .1 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                child: Checkbox(
                                                  checkColor: Colors.white,
                                                  activeColor: Colors.blue,
                                                  value: report['check1'],
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      print(value);
                                                      //xx.add("s");
                                                      report['check1'] = value;
                                                      print(
                                                          "serious...$report");
                                                    });
                                                  },
                                                ),
                                              )),
                                          Container(
                                              width: constraints.maxWidth * 0.3,
                                              alignment: Alignment.centerLeft,
                                              //color:Colors.black12,
                                              padding: EdgeInsets.only(left: 5),
                                              child: AutoSizeText('Serious',
                                                  style: TextStyle(
                                                      fontSize: 1.8 *
                                                          SizeConfig
                                                              .blockSizeVertical,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                          Container(
                                              width: constraints.maxWidth * 0.1,
                                              height: 4 *
                                                  SizeConfig.blockSizeVertical,
                                              //color: Colors.black12,
                                              alignment: Alignment.topLeft,
                                              //color: Colors.black12,
                                              padding: EdgeInsets.all(0),
                                              child: Transform.scale(
                                                scale: .1 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                child: Checkbox(
                                                  checkColor: Colors.white,
                                                  activeColor: Colors.blue,
                                                  value: report['check2'],
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      report['check2'] = value;
                                                      print(
                                                          "dangerous...$report");
                                                    });
                                                  },
                                                ),
                                              )),
                                          Container(
                                              width:
                                                  constraints.maxWidth * 0.45,
                                              alignment: Alignment.centerLeft,
                                              //color:Colors.black12,
                                              padding: EdgeInsets.only(left: 5),
                                              child: AutoSizeText('Dangerous',
                                                  style: TextStyle(
                                                      fontSize: 1.8 *
                                                          SizeConfig
                                                              .blockSizeVertical,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                        ],
                                      );
                                    },
                                  )
                                  // AutoSizeText("hello",
                                  //     style: TextStyle(
                                  //         fontSize: 1.8*SizeConfig.blockSizeVertical,
                                  //         color: Colors.black,
                                  //         fontWeight: FontWeight.w400)
                                  // ),
                                  )
                            ],
                          )),
                    if (report['sub_heading'] == '33 Wheelchair')
                      Container(
                          width: constraints.maxWidth,
                          margin: EdgeInsets.only(bottom: 0),
                          //color: Colors.cyanAccent,
                          child: Column(
                            children: [
                              Container(
                                width: constraints.maxWidth,
                                padding: EdgeInsets.only(
                                    top: 4.0,
                                    bottom: 4.0,
                                    left: 3.0,
                                    right: 3.0),
                                color: Light,
                                child: AutoSizeText(report['sub_heading'],
                                    style: TextStyle(
                                        fontSize:
                                            1.8 * SizeConfig.blockSizeVertical,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500)),
                              ),
                              Container(
                                  width: constraints.maxWidth,
                                  margin: EdgeInsets.only(top: 5.0),
                                  color: Colors.grey[200],
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Row(
                                        children: [
                                          Container(
                                              width: constraints.maxWidth * 0.1,
                                              height: 4 *
                                                  SizeConfig.blockSizeVertical,
                                              //color: Colors.black12,
                                              alignment: Alignment.topLeft,
                                              //color: Colors.black12,
                                              padding: EdgeInsets.all(0),
                                              child: Transform.scale(
                                                scale: .1 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                child: Radio(
                                                  value: "pass",
                                                  groupValue:
                                                      report['selected_value'],
                                                  activeColor: Dark,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      report['selected_value'] =
                                                          val;
                                                    });
                                                  },
                                                ),
                                              )),
                                          Container(
                                              width:
                                                  constraints.maxWidth * 0.25,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(left: 5),
                                              child: AutoSizeText('Pass',
                                                  style: TextStyle(
                                                      fontSize: 1.8 *
                                                          SizeConfig
                                                              .blockSizeVertical,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                          Container(
                                              width: constraints.maxWidth * 0.1,
                                              height: 4 *
                                                  SizeConfig.blockSizeVertical,
                                              //color: Colors.black12,
                                              alignment: Alignment.topLeft,
                                              //color: Colors.black12,
                                              padding: EdgeInsets.all(0),
                                              child: Transform.scale(
                                                scale: .1 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                child: Radio(
                                                  value: "fail",
                                                  groupValue:
                                                      report['selected_value'],
                                                  activeColor: Dark,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      report['selected_value'] =
                                                          val;
                                                    });
                                                  },
                                                ),
                                              )),
                                          Container(
                                              width:
                                                  constraints.maxWidth * 0.25,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(left: 5),
                                              child: AutoSizeText('Fail',
                                                  style: TextStyle(
                                                      fontSize: 1.8 *
                                                          SizeConfig
                                                              .blockSizeVertical,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                        ],
                                      );
                                    },
                                  )
                                  // AutoSizeText("hello",
                                  //     style: TextStyle(
                                  //         fontSize: 1.8*SizeConfig.blockSizeVertical,
                                  //         color: Colors.black,
                                  //         fontWeight: FontWeight.w400)
                                  // ),
                                  )
                            ],
                          )),
                    if (report['sub_heading'] == 'Overall Result')
                      Container(
                          width: constraints.maxWidth,
                          margin: EdgeInsets.only(bottom: 0),
                          //color: Colors.cyanAccent,
                          child: Column(
                            children: [
                              Container(
                                width: constraints.maxWidth,
                                padding: EdgeInsets.only(
                                    top: 4.0,
                                    bottom: 4.0,
                                    left: 3.0,
                                    right: 3.0),
                                color: Light,
                                child: AutoSizeText(report['sub_heading'],
                                    style: TextStyle(
                                        fontSize:
                                            1.8 * SizeConfig.blockSizeVertical,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700)),
                              ),
                              Container(
                                  width: constraints.maxWidth,
                                  margin: EdgeInsets.only(top: 5.0),
                                  color: Colors.grey[200],
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Row(
                                        children: [
                                          Container(
                                              width: constraints.maxWidth * 0.1,
                                              height: 4 *
                                                  SizeConfig.blockSizeVertical,
                                              //color: Colors.black12,
                                              alignment: Alignment.topLeft,
                                              //color: Colors.black12,
                                              padding: EdgeInsets.all(0),
                                              child: Transform.scale(
                                                scale: .1 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                child: Radio(
                                                  value: "pass",
                                                  groupValue:
                                                      report['selected_value'],
                                                  activeColor: Dark,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      report['selected_value'] =
                                                          val;
                                                    });
                                                  },
                                                ),
                                              )),
                                          Container(
                                              width:
                                                  constraints.maxWidth * 0.25,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(left: 5),
                                              child: AutoSizeText('Pass',
                                                  style: TextStyle(
                                                      fontSize: 1.8 *
                                                          SizeConfig
                                                              .blockSizeVertical,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                          Container(
                                              width: constraints.maxWidth * 0.1,
                                              height: 4 *
                                                  SizeConfig.blockSizeVertical,
                                              //color: Colors.black12,
                                              alignment: Alignment.topLeft,
                                              //color: Colors.black12,
                                              padding: EdgeInsets.all(0),
                                              child: Transform.scale(
                                                scale: .1 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                child: Radio(
                                                  value: "fail",
                                                  groupValue:
                                                      report['selected_value'],
                                                  activeColor: Dark,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      report['selected_value'] =
                                                          val;
                                                    });
                                                  },
                                                ),
                                              )),
                                          Container(
                                              width:
                                                  constraints.maxWidth * 0.25,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(left: 5),
                                              child: AutoSizeText('Fail',
                                                  style: TextStyle(
                                                      fontSize: 1.8 *
                                                          SizeConfig
                                                              .blockSizeVertical,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                        ],
                                      );
                                    },
                                  )
                                  // AutoSizeText("hello",
                                  //     style: TextStyle(
                                  //         fontSize: 1.8*SizeConfig.blockSizeVertical,
                                  //         color: Colors.black,
                                  //         fontWeight: FontWeight.w400)
                                  // ),
                                  )
                            ],
                          )),
                  ],
                );
              },
            ))),
        Container(
            width: constraints.maxWidth,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: Column(
              children: [
                Container(
                  width: Responsive.width(100, context),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: AutoSizeText("Comments*",
                      style: inputLabelStyleDark(SizeConfig.labelFontSize),
                      textAlign: TextAlign.left),
                ),
                Container(
                    width: Responsive.width(100, context),
                    height: 4 * SizeConfig.blockSizeVertical,
                    child: TextField(
                        //showCursor: false,
                        controller: commentController,
                        style: inputTextStyle(SizeConfig.inputFontSize),
                        decoration: InputDecoration(
                          focusedBorder: inputFocusedBorderStyle(),
                          enabledBorder: inputBorderStyle(),
                          hintStyle: placeholderStyle(SizeConfig.labelFontSize),
                          contentPadding: EdgeInsets.fromLTRB(5, 0, 3, 16),
                        ),
                        maxLines: 2,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {}))
              ],
            )),
      ],
    );
  }

  bool validate() {
    if (routeDetailController.text == null ||
        routeDetailController.text.trim() == "")
      return false;
    else if (commentController == null && commentController.text.trim() == "")
      return false;
    else
      return true;
  }

  Future<Map?> submitReport(Map<String, dynamic> params) async {
    try {
      Map response = await _reportServices.submitMockTestReport(params);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void showLoader(String message) {
    CustomSpinner.showLoadingDialog(context, _keyLoader, message);
  }

  void closeLoader() {
    try {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    } catch (e) {}
  }
}
