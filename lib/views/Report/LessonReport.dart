import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:student_app/Constants/app_colors.dart';

import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/navigation_service.dart';
import '../../services/report_services.dart';
import '../../style/global_style.dart';
import '../../widget/CustomAppBar.dart';

class LessonReport extends StatefulWidget {
  @override
  _LessonReportState createState() => _LessonReportState();
}

class _LessonReportState extends State<LessonReport> {
  final NavigationService _navigationService = locator<NavigationService>();
  final ReportServices _reportServices = new ReportServices();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  late ScrollController reportFormScrollController;

  List<Map<String, dynamic>> reportCriteriaAdi = [
    {
      'heading': 'Eyesight & Licence',
      'key': 'performance_0_radio',
      'selected_value': 2
    },
    {
      'heading': 'Cockpit & Controls',
      'key': 'performance_1_radio',
      'selected_value': 2
    },
    {
      'heading': 'Starting precautions',
      'key': 'performance_2_radio',
      'selected_value': 2
    },
    {
      'heading': 'Moving off from flat',
      'key': 'performance_3_radio',
      'selected_value': 2
    },
    {'heading': 'Steering', 'key': 'performance_4_radio', 'selected_value': 2},
    {
      'heading': 'Use of gears',
      'key': 'performance_5_radio',
      'selected_value': 2
    },
    {
      'heading': 'Stopping & basic MSM',
      'key': 'performance_6_radio',
      'selected_value': 2
    },
    {
      'heading': 'Moving off downhill',
      'key': 'performance_7_radio',
      'selected_value': 2
    },
    {
      'heading': 'Moving off uphill',
      'key': 'performance_8_radio',
      'selected_value': 2
    },
    {
      'heading': 'Moving off at angle',
      'key': 'performance_9_radio',
      'selected_value': 2
    },
    {
      'heading': 'Turn in the road',
      'key': 'performance_10_radio',
      'selected_value': 2
    },
    {
      'heading': 'Reversing',
      'key': 'performance_11_radio',
      'selected_value': 2
    },
    {
      'heading': 'Minor to major MSPSL',
      'key': 'performance_12_radio',
      'selected_value': 2
    },
    {
      'heading': 'Parallel Parking',
      'key': 'performance_13_radio',
      'selected_value': 2
    },
    {
      'heading': 'Reverse/Drive into bay',
      'key': 'performance_14_radio',
      'selected_value': 2
    },
    {
      'heading': 'Adequate clearance',
      'key': 'performance_15_radio',
      'selected_value': 2
    },
    {
      'heading': 'Give way & holdback',
      'key': 'performance_16_radio',
      'selected_value': 2
    },
    {
      'heading': 'Progress/hesitancy',
      'key': 'performance_17_radio',
      'selected_value': 2
    },
    {
      'heading': 'Traffic lights',
      'key': 'performance_18_radio',
      'selected_value': 2
    },
    {
      'heading': 'Pedestrian crossings',
      'key': 'performance_19_radio',
      'selected_value': 2
    },
    {
      'heading': 'Anticipation',
      'key': 'performance_20_radio',
      'selected_value': 2
    },
    {
      'heading': 'Emergency stops',
      'key': 'performance_21_radio',
      'selected_value': 2
    },
    {
      'heading': 'Use of mirrors',
      'key': 'performance_22_radio',
      'selected_value': 2
    },
    {
      'heading': 'Use of signals',
      'key': 'performance_23_radio',
      'selected_value': 2
    },
    {
      'heading': 'Roundabouts',
      'key': 'performance_24_radio',
      'selected_value': 2
    },
    {
      'heading': 'Motorway/Overtaking',
      'key': 'performance_25_radio',
      'selected_value': 2
    },
    {
      'heading': 'High speeds/Bad weather',
      'key': 'performance_26_radio',
      'selected_value': 2
    },
    {
      'heading': 'Pull over to the right',
      'key': 'performance_27_radio',
      'selected_value': 2
    },
    {
      'heading': 'Narrow/one way roads',
      'key': 'performance_28_radio',
      'selected_value': 2
    },
    {
      'heading': 'Road signs/markings',
      'key': 'performance_29_radio',
      'selected_value': 2
    },
    {
      'heading': 'Awareness & Planning',
      'key': 'performance_30_radio',
      'selected_value': 2
    },
    {
      'heading': 'Tell me - Show me',
      'key': 'performance_31_radio',
      'selected_value': 2
    },
    {
      'heading': 'Sat Nav / Independent',
      'key': 'performance_32_radio',
      'selected_value': 2
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
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          CustomAppBar(
            preferedHeight: Responsive.height(20, context),
            title: 'Lesson Report',
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
                        //details
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
                                            child: AutoSizeText(
                                                "Lesson Details",
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
                                                                "Lesson ID",
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
                                                                "details['booking_id'].toString()",
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
                                                              "details['location'].toString()",
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
                                                              "details['requested_date'].toString()+"
                                                              "+details['requested_time'].toString()",
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
                                                                "details['name'].toString()",
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
                                                              "details['driver_license_no']==null?'':details['driver_license_no']",
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
                        //report criteria
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
                        //footer buttons
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
                      print("print report...$reportCriteriaAdi");
                      //   print(details["booking_origin"]);
                      //   if (!validate()) {
                      //     Toast.show("Please filled all required(*) field.",
                      //         context,
                      //         duration: Toast.LENGTH_LONG,
                      //         gravity: Toast.BOTTOM);
                      //   }
                      //   else{
                      //     setState(() {
                      //       try {
                      //         print("submit report");
                      //         print("print report...$report");
                      //         Map<String, dynamic> reportData = {};
                      //         reportData["_token"] = "";
                      //         reportData["route_details"] = routeDetailController.text;
                      //         report.forEach((x) {
                      //           //print(x["checkbox_val"].runtimeType);
                      //           if(x.containsKey("key") && x["selected_value"] != null){
                      //             reportData[x['key']] = x['selected_value'];
                      //             if(x.containsKey("checkbox_key")){
                      //               setState(() {
                      //                 if(x["check1"] && x["check2"]){
                      //                   x["checkbox_val"] = ["s","d"];
                      //                 }else if(x["check1"] && !x["check2"]){
                      //                   x["checkbox_val"] = ["s"];
                      //                 }else if(!x["check1"] && x["check2"]){
                      //                   x["checkbox_val"] = ["d"];
                      //                 }
                      //               });
                      //               if(x['checkbox_val'] != null){
                      //                 setState(() {
                      //                   reportData[x['checkbox_key']] = x["checkbox_val"];
                      //                 });
                      //               }
                      //             }
                      //           }
                      //
                      //         });
                      //         reportData["comments"] = commentController.text;
                      //         reportData["test_id"] = details["booking_id"];
                      //         print(jsonEncode(reportData));
                      //         print("report data...$reportData");
                      //
                      //         Map<String, dynamic> testData = {
                      //           'booking_id': details["booking_id"].toString(),
                      //           'report_data': jsonEncode(reportData),
                      //           'booking_type': details["booking_origin"]
                      //         };
                      //         showLoader('Report Submitting...');
                      //         submitReport(testData).then((response) {
                      //           if(response['message'] != null){
                      //             Toast.show(
                      //                 response['message'], context,
                      //                 duration: Toast.LENGTH_LONG,
                      //                 gravity: Toast.BOTTOM);
                      //             if(response['success'] == true)
                      //             {
                      //               _navigationService.goBack();
                      //             }
                      //           }
                      //           closeLoader();
                      //         });
                      //
                      //       } catch (e) {
                      //         print(e);
                      //         Toast.show(
                      //             'Failed request! please try again.', context,
                      //             duration: Toast.LENGTH_LONG,
                      //             gravity: Toast.BOTTOM
                      //         );
                      //       }
                      //     });
                      //   }
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
        ...reportCriteriaAdi.map((report) => Container(
            width: constraints.maxWidth,
            margin: EdgeInsets.only(bottom: 10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                  top: 4.0, bottom: 4.0, left: 3.0, right: 3.0),
                              color: Light,
                              child: AutoSizeText(report['heading'],
                                  style: inputLabelStyleDark(
                                      SizeConfig.labelFontSize)),
                            ),
                            Container(
                                width: constraints.maxWidth,
                                margin: EdgeInsets.only(top: 5.0),
                                color: Colors.grey[200],
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
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
                                                  SizeConfig.blockSizeVertical,
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
                                                  SizeConfig.blockSizeVertical,
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
                                                  SizeConfig.blockSizeVertical,
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
                                                  SizeConfig.blockSizeVertical,
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
                                            width: constraints.maxWidth * 0.1,
                                            alignment: Alignment.centerLeft,
                                            //color:Colors.black12,
                                            padding: EdgeInsets.only(left: 5),
                                            child: AutoSizeText('3',
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
                                                  SizeConfig.blockSizeVertical,
                                              child: Radio(
                                                value: 4,
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
                                            child: AutoSizeText('4',
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
                                //margin: EdgeInsets.only(top: 5.0),
                                color: Colors.grey[200],
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
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
                                                  SizeConfig.blockSizeVertical,
                                              child: Radio(
                                                value: 5,
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
                                            child: AutoSizeText('5',
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
                                                  SizeConfig.blockSizeVertical,
                                              child: Radio(
                                                value: 6,
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
                                            child: AutoSizeText('6',
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
                                            color: Colors.transparent,
                                            alignment: Alignment.topLeft,
                                            //color: Colors.black12,
                                            padding: EdgeInsets.all(0),
                                            child: Transform.scale(
                                                scale: .1 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                child: Text(''))),
                                        Container(
                                            width: constraints.maxWidth * 0.1,
                                            alignment: Alignment.centerLeft,
                                            color: Colors.transparent,
                                            padding: EdgeInsets.only(left: 5),
                                            child: AutoSizeText('6',
                                                style: TextStyle(
                                                    fontSize: 1.8 *
                                                        SizeConfig
                                                            .blockSizeVertical,
                                                    color: Colors.transparent,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                        Container(
                                            width: constraints.maxWidth * 0.1,
                                            height: 4 *
                                                SizeConfig.blockSizeVertical,
                                            color: Colors.transparent,
                                            alignment: Alignment.topLeft,
                                            //color: Colors.black12,
                                            padding: EdgeInsets.all(0),
                                            child: Transform.scale(
                                                scale: .1 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                child: Text(''))),
                                        Container(
                                            width: constraints.maxWidth * 0.1,
                                            alignment: Alignment.centerLeft,
                                            color: Colors.transparent,
                                            padding: EdgeInsets.only(left: 5),
                                            child: AutoSizeText('6',
                                                style: TextStyle(
                                                    fontSize: 1.8 *
                                                        SizeConfig
                                                            .blockSizeVertical,
                                                    color: Colors.transparent,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                        Container(
                                            width: constraints.maxWidth * 0.1,
                                            height: 4 *
                                                SizeConfig.blockSizeVertical,
                                            color: Colors.transparent,
                                            alignment: Alignment.topLeft,
                                            //color: Colors.black12,
                                            padding: EdgeInsets.all(0),
                                            child: Transform.scale(
                                                scale: .1 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                child: Text(''))),
                                        Container(
                                            width: constraints.maxWidth * 0.1,
                                            alignment: Alignment.centerLeft,
                                            color: Colors.transparent,
                                            padding: EdgeInsets.only(left: 5),
                                            child: AutoSizeText('6',
                                                style: TextStyle(
                                                    fontSize: 1.8 *
                                                        SizeConfig
                                                            .blockSizeVertical,
                                                    color: Colors.transparent,
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
                          ],
                        )),
                  ],
                );
              },
            ))),
      ],
    );
  }
}
