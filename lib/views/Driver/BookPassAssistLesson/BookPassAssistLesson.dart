// import 'dart:async';
// import 'dart:convert';
//
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:datetime_picker_formfield_new/datetime_picker_formfield_new.dart';
// import 'package:google_place/google_place.dart';
// import 'package:Smart_Theory_Test/Constants/app_colors.dart';
// import 'package:Smart_Theory_Test/routing/route_names.dart' as routes;
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import 'package:toast/toast.dart';
// import '../../../Constants/const_data.dart';
// import '../../../locater.dart';
// import 'dart:io' as Io;
// import 'dart:io';
//
// import '../../../responsive/percentage_mediaquery.dart';
// import '../../../responsive/size_config.dart';
// import '../../../services/auth.dart';
// import '../../../services/booking_test.dart';
// import '../../../services/methods.dart';
// import '../../../services/navigation_service.dart';
// import '../../../style/global_style.dart';
// import '../../../widget/CustomAppBar.dart';
// import '../../../widget/CustomSpinner.dart';
// import '../../../widget/ImageZoomView/image_zoom_view.dart';
// import '../../../widget/MultiSteps/multi_steps_element.dart';
//
// class BookPassAssistLessonForm extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _bookPassAssistLessonForm();
// }
//
// class _bookPassAssistLessonForm extends State<BookPassAssistLessonForm> {
//   final NavigationService _navigationService = locator<NavigationService>();
//   final GlobalKey<MultiStepsElementsSate> _multiStepperWidget =
//       GlobalKey<MultiStepsElementsSate>();
//   final BookingService _bookingService = new BookingService();
//   final GlobalKey<State> _keyLoader = new GlobalKey<State>();
//
//   // init the step to 0th position
//   int current_step = 0;
//   List<String> stepsList = [
//     'Step1:\nLearner Detail',
//     'Step2:\nLessons Booking',
//     'Step3:\nPayment'
//   ];
//   List<Map<String, dynamic>> listOfLessons = [
//     {
//       'name': 'Reverse / Left Reverse with trailer',
//       'key': 'reverse_left',
//       'selected_value': 0,
//       'amount': 0
//     },
//     {
//       'name': 'Reverse/ Right',
//       'key': 'reverse_right',
//       'selected_value': 0,
//       'amount': 0
//     },
//     {
//       'name': 'Reverse Park',
//       'key': 'reverse_park',
//       'selected_value': 0,
//       'amount': 0
//     },
//     {
//       'name': 'Turn in road',
//       'key': 'turn_in_road',
//       'selected_value': 0,
//       'amount': 0
//     },
//     {
//       'name': 'Forward park / Taxi manoeuvre',
//       'key': 'forward_park',
//       'selected_value': 0,
//       'amount': 0
//     },
//     {'name': 'Control', 'key': 'control', 'selected_value': 0, 'amount': 0},
//     {'name': 'Move off', 'key': 'move_off', 'selected_value': 0, 'amount': 0},
//     {
//       'name': 'Use of mirrors- M/C rear obs',
//       'key': 'mirrors',
//       'selected_value': 0,
//       'amount': 0
//     },
//     {'name': 'Signals', 'key': 'signals', 'selected_value': 0, 'amount': 0},
//     {
//       'name': 'Response to signs / signals',
//       'key': 'response_to_signs',
//       'selected_value': 0,
//       'amount': 0
//     },
//     {'name': 'Progress', 'key': 'progress', 'selected_value': 0, 'amount': 0},
//     {'name': 'Junctions', 'key': 'junctions', 'selected_value': 0, 'amount': 0},
//     {'name': 'Judgement', 'key': 'judgement', 'selected_value': 0, 'amount': 0},
//     {
//       'name': 'Positioning',
//       'key': 'positioning',
//       'selected_value': 0,
//       'amount': 0
//     }
//   ];
//
//   late ScrollController list_view_scrollCtrl;
//   late int _userId;
//   late int age;
//   bool? isAdult;
//   String first_name = '', last_name = '', email = '';
//   String vehicle_preference = 'instructor';
//   String carType = 'automatic';
//   late String location = ' ';
//   final TextEditingController test_date_picker = new TextEditingController();
//   final TextEditingController lessonTimeDropContr = new TextEditingController();
//   final TextEditingController birth_date_picker = new TextEditingController();
//   final TextEditingController phone = new TextEditingController(),
//       learner_license_no = new TextEditingController(),
//       license_expiry_date_picker = new TextEditingController();
//   File? licence = null;
//   String licenceBase64 = '';
//   String? licenceHttpPath = null;
//   String? addressSuggestion;
//   final TextEditingController address_line_1 = new TextEditingController(),
//       address_line_2 = new TextEditingController(),
//       town = new TextEditingController(),
//       country = new TextEditingController(),
//       _addressController = new TextEditingController();
//
//   String postcode = "";
//   final TextEditingController discount_code = new TextEditingController(),
//       cost = new TextEditingController(text: '0'),
//       totalCost = new TextEditingController(text: '0');
//   String discountAppliedMessage = '';
//   String diaplayCost = '';
//   int discountApplied =
//       -1; //-1 if not applied, 1 if successfully applied, 0 if not failed
//   bool hearby_agreey_1 = false;
//   bool hearby_agreey_2 = false;
//   bool hearby_agreey_3 = false;
//   late GooglePlace googlePlace;
//   List<AutocompletePrediction> predictions = [];
//   Timer? debounce;
//   calculateAge(DateTime birthDate) {
//     DateTime currentDate = DateTime.now();
//     int age = currentDate.year - birthDate.year;
//     print("today year " + currentDate.toString());
//     print("birth year " + birthDate.toString());
//     print("hello $age");
//     int month1 = currentDate.month;
//     int month2 = birthDate.month;
//     if (month2 > month1) {
//       age--;
//     } else if (month1 == month2) {
//       int day1 = currentDate.day;
//       int day2 = birthDate.day;
//       if (day2 > day1) {
//         age--;
//       }
//     }
//
//     return age;
//   }
//
//   initializeApi(String loaderMessage) {
//     checkInternet();
//     showLoader(loaderMessage);
//     getUserDetail().then((details) {
//       age = calculateAge(DateTime.parse(details['date_of_birth']));
//       _userId = details['id'];
//       closeLoader();
//     }).catchError((onError) => closeLoader());
//   }
//
//   @override
//   void initState() {
//     list_view_scrollCtrl = ScrollController();
//     super.initState();
//     String apiKey = "AIzaSyBa4FdOlhksMcExaWa-z_EHeNppLz6c2ug";
//     googlePlace = GooglePlace(apiKey);
//     Future.delayed(Duration.zero, () {
//       this.initializeApi("Loading...");
//     });
//
//     print(isAdult);
//     // KeyboardVisibilityNotification().addNewListener(
//     //   onChange: (bool visible) {
//     //     if (!visible) {
//     //       FocusScopeNode currentFocus = FocusScope.of(context);
//     //       if (!currentFocus.hasPrimaryFocus) {
//     //         currentFocus.unfocus();
//     //       }
//     //     }
//     //   },
//     // );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   void autocomplete(String value) async {
//     var result = await googlePlace.autocomplete.get(value, region: 'GB');
//     if (result != null && mounted) {
//       setState(() {
//         predictions = result.predictions!;
//       });
//     } else {
//       setState(() {
//         predictions = [];
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print(test_date_picker.text);
//     ToastContext().init(context);
//
//     SizeConfig().init(context);
//     return Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Stack(
//           children: <Widget>[
//             CustomAppBar(
//                 preferedHeight: Responsive.height(24, context),
//                 title: 'Book Pass Assist',
//                 textWidth: Responsive.width(35, context),
//                 iconLeft: Icons.arrow_back,
//                 onTap1: () {
//                   _navigationService.goBack();
//                 },
//                 iconRight: null),
//             Container(
//                 // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                 margin: EdgeInsets.fromLTRB(
//                     20, Responsive.height(14, context), 20, 0),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(Radius.circular(20)),
//                   // border: BoxBorder(),
//                   boxShadow: [
//                     BoxShadow(
//                         color: Color.fromRGBO(0, 0, 0, 1),
//                         offset: Offset(1, 2),
//                         blurRadius: 5.0)
//                   ],
//                 ),
//                 height: Responsive.height(84.5, context),
//                 child: LayoutBuilder(builder: (context, constraints) {
//                   return Container(
//                       width: constraints.maxWidth * 1,
//                       child: Column(
//                         children: [
//                           Container(
//                             width: Responsive.width(80, context),
//                             padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
//                             alignment: Alignment.centerLeft,
//                             child: MultiStepsElements(
//                                 key: _multiStepperWidget,
//                                 steps: this.stepsList,
//                                 constraints: constraints,
//                                 parentContext: context),
//                           ),
//                           Container(
//                             width: Responsive.width(100, context),
//                             height: Responsive.height(62, context),
//                             padding: EdgeInsets.fromLTRB(5, 3, 5, 0),
//                             child: ListView(
//                               controller: list_view_scrollCtrl,
//                               physics: const AlwaysScrollableScrollPhysics(),
//                               shrinkWrap: true,
//                               padding: EdgeInsets.fromLTRB(10, 2, 10,
//                                   MediaQuery.of(context).viewInsets.bottom),
//                               children: [
//                                 if (current_step == 0)
//                                   LayoutBuilder(
//                                       builder: (context, constraints) {
//                                     return learnerDetailsStep(context);
//                                   }),
//                                 if (current_step == 1)
//                                   LayoutBuilder(
//                                       builder: (context, constraints) {
//                                     return lessonBookStep(context);
//                                   }),
//                                 if (current_step == 2)
//                                   LayoutBuilder(
//                                       builder: (context, constraints) {
//                                     return paymentStep(context);
//                                   }),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             width: Responsive.width(100, context),
//                             height: Responsive.height(8, context),
//                             padding: EdgeInsets.all(0),
//                             child:
//                                 LayoutBuilder(builder: (context, constraints_) {
//                               return footerActionBar(context);
//                             }),
//                           ),
//                         ],
//                       ));
//                 })),
//           ],
//         ));
//   }
//
//   Widget learnerDetailsStep(BuildContext context) {
//     return (Container(
//         width: Responsive.width(90, context),
//         padding: EdgeInsets.all(0),
//         margin: EdgeInsets.fromLTRB(0.0, 0, 0.0, 0.0),
//         child: Container(
//           width: Responsive.width(100, context),
//           margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
//           child: Card(
//             margin: EdgeInsets.all(0.0),
//             elevation: 0,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Container(
//                   width: Responsive.width(100, context),
//                   margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
//                   child: AutoSizeText(
//                       "Please provide the following details for requesting lesson bookings and someone from our team will call you to discuss your requirements further.",
//                       style: inputLabelStyleDark(SizeConfig.labelFontSize),
//                       textAlign: TextAlign.left),
//                 ),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: Responsive.width(100, context),
//                           margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                           child: AutoSizeText("Requested Lesson Start Date*",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                           width: Responsive.width(100, context),
//                           height: SizeConfig.inputHeight,
//                           child: DateTimeField(
//                               controller: this.test_date_picker,
//                               textAlign: TextAlign.left,
//                               format: DateFormat('dd-MM-yyyy'),
//                               readOnly: true,
//                               style: inputTextStyle(SizeConfig.inputFontSize),
//                               decoration: InputDecoration(
//                                 hintText: "DD-MM-YYY",
//                                 hintStyle:
//                                     placeholderStyle(SizeConfig.labelFontSize),
//                                 suffixIcon: Container(
//                                   child: Icon(Icons.calendar_today,
//                                       size: SizeConfig.labelFontSize,
//                                       color: Colors.black38),
//                                   margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
//                                 ),
//                                 focusedBorder: inputFocusedBorderStyle(),
//                                 enabledBorder: inputBorderStyle(),
//                                 contentPadding:
//                                     EdgeInsets.fromLTRB(5, 10, 0, 0),
//                               ),
//                               onShowPicker: (context, currentValue) {
//                                 return showDatePicker(
//                                     context: context,
//                                     firstDate: DateTime.now()
//                                         .add(const Duration(days: 5)),
//                                     initialDate: currentValue ??
//                                         DateTime.now()
//                                             .add(const Duration(days: 5)),
//                                     lastDate: DateTime(
//                                         DateTime.now().year + 10, 12, 31));
//                               },
//                               onChanged: (DateTime? selected_date) {
//                                 try {
//                                   this.test_date_picker.text =
//                                       (selected_date!.day).toString() +
//                                           "-" +
//                                           (selected_date.month).toString() +
//                                           "-" +
//                                           (selected_date.year).toString();
//                                   print(test_date_picker.text);
//                                 } catch (e) {}
//                               }),
//                         )
//                       ],
//                     )),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: Responsive.width(100, context),
//                           margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                           child: AutoSizeText("Requested Lesson Time*",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             child: TypeAheadField(
//                               debounceDuration: Duration(milliseconds: 0),
//                               animationDuration: Duration(milliseconds: 0),
//                               hideKeyboard: true,
//                               textFieldConfiguration: TextFieldConfiguration(
//                                   textAlign: TextAlign.left,
//                                   controller: this.lessonTimeDropContr,
//                                   style:
//                                       inputTextStyle(SizeConfig.inputFontSize),
//                                   decoration: InputDecoration(
//                                     focusedBorder: inputFocusedBorderStyle(),
//                                     enabledBorder: inputBorderStyle(),
//                                     hintText: '--Select--',
//                                     hintStyle: placeholderStyle(
//                                         SizeConfig.labelFontSize),
//                                     contentPadding:
//                                         EdgeInsets.fromLTRB(5, 10, 3, 10),
//                                   )),
//                               suggestionsBoxDecoration:
//                                   SuggestionsBoxDecoration(
//                                       elevation: 5,
//                                       constraints:
//                                           BoxConstraints(maxHeight: 250)),
//                               suggestionsCallback: (pattern) async {
//                                 return timeSlots;
//                               },
//                               itemBuilder: (context, suggestion) {
//                                 //print(suggestion);
//                                 return ListTile(
//                                   title: AutoSizeText(suggestion.toString()),
//                                 );
//                               },
//                               onSuggestionSelected: (suggestion) {
//                                 print(suggestion);
//                                 try {
//                                   setState(() {
//                                     this.lessonTimeDropContr.text =
//                                         suggestion.toString();
//                                   });
//                                 } catch (e) {
//                                   print(e);
//                                 }
//                               },
//                             ))
//                       ],
//                     )),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: Responsive.width(100, context),
//                           margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                           child: AutoSizeText("Date of Birth*",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                           width: Responsive.width(100, context),
//                           height: SizeConfig.inputHeight,
//                           child: DateTimeField(
//                               controller: this.birth_date_picker,
//                               textAlign: TextAlign.left,
//                               format: DateFormat('dd-MM-yyyy'),
//                               readOnly: true,
//                               style: inputTextStyle(SizeConfig.inputFontSize),
//                               decoration: InputDecoration(
//                                 hintText: "DD-MM-YYY",
//                                 hintStyle:
//                                     placeholderStyle(SizeConfig.labelFontSize),
//                                 suffixIcon: Container(
//                                   child: Icon(Icons.calendar_today,
//                                       size: SizeConfig.labelFontSize,
//                                       color: Colors.black38),
//                                   margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
//                                 ),
//                                 focusedBorder: inputFocusedBorderStyle(),
//                                 enabledBorder: inputBorderStyle(),
//                                 contentPadding:
//                                     EdgeInsets.fromLTRB(5, 10, 0, 0),
//                               ),
//                               onShowPicker: (context, currentValue) {
//                                 return showDatePicker(
//                                     context: context,
//                                     firstDate: DateTime(1930, 1, 1),
//                                     initialDate:
//                                         currentValue ?? DateTime(2000, 6, 16),
//                                     lastDate: DateTime(2030, 12, 12));
//                               },
//                               onChanged: (DateTime? selected_date) {
//                                 try {
//                                   age = calculateAge(selected_date!);
//                                   this.birth_date_picker.text =
//                                       (selected_date.day).toString() +
//                                           "-" +
//                                           (selected_date.month).toString() +
//                                           "-" +
//                                           (selected_date.year).toString();
//                                 } catch (e) {}
//                               }),
//                         ),
//                         // Visibility(
//                         //   visible: isAdult,
//                         //   child: Container(
//                         //     width: Responsive.width(100, context),
//                         //     margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
//                         //     child: AutoSizeText( "You must be above 18 to book test",
//                         //         style: TextStyle(
//                         //             fontSize: SizeConfig.blockSizeVertical,
//                         //             color: Colors.red,
//                         //             fontWeight: FontWeight.w500),
//                         //         textAlign: TextAlign.left),
//                         //   ),
//                         // ),
//                       ],
//                     )),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: Responsive.width(100, context),
//                           margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                           child: AutoSizeText("Phone*",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             child: TextField(
//                                 controller: phone,
//                                 style: inputTextStyle(SizeConfig.inputFontSize),
//                                 decoration: InputDecoration(
//                                   focusedBorder: inputFocusedBorderStyle(),
//                                   enabledBorder: inputBorderStyle(),
//                                   hintStyle: placeholderStyle(
//                                       SizeConfig.labelFontSize),
//                                   contentPadding:
//                                       EdgeInsets.fromLTRB(5, 0, 3, 16),
//                                 ),
//                                 keyboardType: TextInputType.phone,
//                                 onChanged: (value) {}))
//                       ],
//                     )),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: Responsive.width(100, context),
//                           margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                           child: AutoSizeText("Learner's License No*",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             child: TextField(
//                                 controller: learner_license_no,
//                                 style: inputTextStyle(SizeConfig.inputFontSize),
//                                 decoration: InputDecoration(
//                                   focusedBorder: inputFocusedBorderStyle(),
//                                   enabledBorder: inputBorderStyle(),
//                                   hintStyle: placeholderStyle(
//                                       SizeConfig.labelFontSize),
//                                   contentPadding:
//                                       EdgeInsets.fromLTRB(5, 0, 3, 16),
//                                 ),
//                                 keyboardType: TextInputType.text,
//                                 onChanged: (value) {}))
//                       ],
//                     )),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: Responsive.width(100, context),
//                           margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                           child: AutoSizeText("License Expiry*",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                           width: Responsive.width(100, context),
//                           height: SizeConfig.inputHeight,
//                           child: DateTimeField(
//                               controller: this.license_expiry_date_picker,
//                               textAlign: TextAlign.left,
//                               format: DateFormat('dd-MM-yyyy'),
//                               readOnly: true,
//                               style: inputTextStyle(SizeConfig.inputFontSize),
//                               decoration: InputDecoration(
//                                 hintText: "DD-MM-YYY",
//                                 hintStyle:
//                                     placeholderStyle(SizeConfig.labelFontSize),
//                                 suffixIcon: Container(
//                                   child: Icon(Icons.calendar_today,
//                                       size: SizeConfig.labelFontSize,
//                                       color: Colors.black38),
//                                   margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
//                                 ),
//                                 focusedBorder: inputFocusedBorderStyle(),
//                                 enabledBorder: inputBorderStyle(),
//                                 contentPadding:
//                                     EdgeInsets.fromLTRB(5, 10, 0, 0),
//                               ),
//                               onShowPicker: (context, currentValue) {
//                                 return showDatePicker(
//                                     context: context,
//                                     firstDate: DateTime.now(),
//                                     initialDate: currentValue ?? DateTime.now(),
//                                     lastDate: DateTime(
//                                         DateTime.now().year + 30, 12, 31));
//                               },
//                               onChanged: (DateTime? selected_date) {
//                                 try {
//                                   this.license_expiry_date_picker.text =
//                                       (selected_date!.day).toString() +
//                                           "-" +
//                                           (selected_date.month).toString() +
//                                           "-" +
//                                           (selected_date.year).toString();
//                                 } catch (e) {}
//                               }),
//                         )
//                       ],
//                     )),
//                 Container(
//                   width: Responsive.width(100, context),
//                   margin: EdgeInsets.only(bottom: 0),
//                   child: AutoSizeText('License Image Upload',
//                       style: inputLabelStyle(SizeConfig.labelFontSize)),
//                 ),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.symmetric(vertical: 15),
//                     child: Row(
//                       children: [
//                         if (licence != null || licenceHttpPath != null)
//                           Container(
//                               width: 30 * SizeConfig.blockSizeVertical,
//                               height: 30 * SizeConfig.blockSizeVertical,
//                               // alignment: Alignment(0, -Responsive.width(.1, context)),
//                               child: Stack(
//                                 children: [
//                                   Container(
//                                       margin: EdgeInsets.fromLTRB(
//                                           0,
//                                           2 * SizeConfig.blockSizeVertical,
//                                           0,
//                                           0),
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           Navigator.of(context).push(
//                                               PageRouteBuilder(
//                                                   opaque: false,
//                                                   pageBuilder:
//                                                       (BuildContext context, _,
//                                                               __) =>
//                                                           ZoomView(
//                                                               licenceHttpPath ??
//                                                                   licence!.path,
//                                                               licenceHttpPath !=
//                                                                       null
//                                                                   ? 'http'
//                                                                   : 'file')));
//                                         },
//                                         child: licenceHttpPath != null
//                                             ? FadeInImage.assetNetwork(
//                                                 width: 20 *
//                                                     SizeConfig
//                                                         .blockSizeVertical,
//                                                 height: 20 *
//                                                     SizeConfig
//                                                         .blockSizeVertical,
//                                                 fit: BoxFit.cover,
//                                                 placeholder:
//                                                     'assets/spinner.gif',
//                                                 image: licenceHttpPath!,
//                                                 imageErrorBuilder:
//                                                     (context, url, error) =>
//                                                         Container(
//                                                   child: Column(
//                                                     children: [
//                                                       new Icon(Icons.error,
//                                                           color: Colors.grey,
//                                                           size: 5 *
//                                                               SizeConfig
//                                                                   .blockSizeVertical),
//                                                       Text(
//                                                         "Image not found!",
//                                                         style: TextStyle(
//                                                             fontSize: 2 *
//                                                                 SizeConfig
//                                                                     .blockSizeVertical,
//                                                             color: Colors
//                                                                 .redAccent),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ),
//                                               )
//                                             : Image.file(File(licence!.path),
//                                                 width: 20 *
//                                                     SizeConfig
//                                                         .blockSizeVertical,
//                                                 height: 20 *
//                                                     SizeConfig
//                                                         .blockSizeVertical,
//                                                 fit: BoxFit.cover),
//                                       )),
//                                   Positioned(
//                                     top: -Responsive.width(1, context),
//                                     right: Responsive.width(12, context),
//                                     child: IconButton(
//                                       icon: Icon(Icons.remove_circle),
//                                       iconSize: 30,
//                                       color: Colors.red,
//                                       onPressed: () => {
//                                         this.setState(() {
//                                           licence = null;
//                                           licenceHttpPath = null;
//                                           licenceBase64 = "";
//                                         })
//                                       },
//                                     ),
//                                   )
//                                 ],
//                               )),
//                         if (licence == null && licenceHttpPath == null)
//                           Container(
//                             child: IconButton(
//                               icon: Icon(Icons.camera_alt),
//                               iconSize: 5 * SizeConfig.blockSizeVertical,
//                               color: Colors.blue,
//                               tooltip: 'Add Image By Camera',
//                               onPressed: _openCamera,
//                             ),
//                           ),
//                         if (licence == null && licenceHttpPath == null)
//                           Container(
//                             child: IconButton(
//                               icon: Icon(Icons.folder_open),
//                               iconSize: 5 * SizeConfig.blockSizeVertical,
//                               color: Colors.blue,
//                               tooltip: 'Add Image/File By Gallery',
//                               onPressed: _openGallery,
//                             ),
//                           ),
//                       ],
//                     )),
//                 Container(
//                   width: Responsive.width(100, context),
//                   color: Colors.grey[100],
//                   padding: EdgeInsets.all(5),
//                   margin: EdgeInsets.only(bottom: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: Responsive.width(100, context),
//                         child: AutoSizeText('Vehicle Preference*',
//                             style: inputLabelStyle(SizeConfig.labelFontSize)),
//                       ),
//                       Container(
//                         width: Responsive.width(100, context),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                                 width: Responsive.width(30, context),
//                                 child: LayoutBuilder(
//                                     builder: (context, constraints) {
//                                   return Row(
//                                     children: [
//                                       Container(
//                                           width: constraints.maxWidth * 0.3,
//                                           height:
//                                               4 * SizeConfig.blockSizeVertical,
//                                           alignment: Alignment.centerLeft,
//                                           padding: EdgeInsets.all(0),
//                                           child: Transform.scale(
//                                             scale: .15 *
//                                                 SizeConfig.blockSizeVertical,
//                                             child: Radio(
//                                               value: 'own',
//                                               groupValue: vehicle_preference,
//                                               activeColor: Color(0xFFed1c24),
//                                               onChanged: (val) {
//                                                 setState(() {
//                                                   vehicle_preference =
//                                                       val.toString();
//                                                 });
//                                               },
//                                             ),
//                                           )),
//                                       Container(
//                                         width: constraints.maxWidth * 0.7,
//                                         height:
//                                             4 * SizeConfig.blockSizeVertical,
//                                         alignment: Alignment.centerLeft,
//                                         child: LayoutBuilder(
//                                           builder: (context, constraints) {
//                                             return Container(
//                                                 child: AutoSizeText('Own Car',
//                                                     style: inputLabelStyleDark(
//                                                         SizeConfig
//                                                             .labelFontSize)));
//                                           },
//                                         ),
//                                       )
//                                     ],
//                                   );
//                                 })),
//                             Container(
//                                 width: Responsive.width(40, context),
//                                 child: LayoutBuilder(
//                                     builder: (context, constraints) {
//                                   return Row(
//                                     children: [
//                                       Container(
//                                           width: constraints.maxWidth * 0.3,
//                                           height:
//                                               4 * SizeConfig.blockSizeVertical,
//                                           alignment: Alignment.centerLeft,
//                                           child: Transform.scale(
//                                               scale: .15 *
//                                                   SizeConfig.blockSizeVertical,
//                                               child: Radio(
//                                                 value: 'instructor',
//                                                 groupValue: vehicle_preference,
//                                                 activeColor: Color(0xFFed1c24),
//                                                 onChanged: (val) {
//                                                   setState(() {
//                                                     vehicle_preference =
//                                                         val.toString();
//                                                   });
//                                                 },
//                                               ))),
//                                       Container(
//                                         width: constraints.maxWidth * 0.7,
//                                         height:
//                                             4 * SizeConfig.blockSizeVertical,
//                                         alignment: Alignment.centerLeft,
//                                         child: LayoutBuilder(
//                                           builder: (context, constraints) {
//                                             return Container(
//                                               width: constraints.maxWidth * 0.9,
//                                               child: AutoSizeText(
//                                                   'Instructor car',
//                                                   style: inputLabelStyleDark(
//                                                       SizeConfig
//                                                           .labelFontSize)),
//                                             );
//                                           },
//                                         ),
//                                       )
//                                     ],
//                                   );
//                                 })),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: Responsive.width(100, context),
//                   color: Colors.grey[100],
//                   padding: EdgeInsets.all(5),
//                   margin: EdgeInsets.only(bottom: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: Responsive.width(100, context),
//                         child: AutoSizeText('Car Type:',
//                             style: inputLabelStyle(SizeConfig.labelFontSize)),
//                       ),
//                       Container(
//                         width: Responsive.width(100, context),
//                         margin: EdgeInsets.only(top: 3),
//                         child: Row(
//                           children: [
//                             Container(
//                                 width: Responsive.width(30, context),
//                                 child: LayoutBuilder(
//                                     builder: (context, constraints) {
//                                   return Row(
//                                     children: [
//                                       Container(
//                                           width: constraints.maxWidth * 0.3,
//                                           height:
//                                               4 * SizeConfig.blockSizeVertical,
//                                           alignment: Alignment.centerLeft,
//                                           child: Transform.scale(
//                                             scale: .15 *
//                                                 SizeConfig.blockSizeVertical,
//                                             child: Radio(
//                                               value: 'manual',
//                                               groupValue: carType,
//                                               activeColor: Color(0xFFed1c24),
//                                               onChanged: (val) {
//                                                 setState(() {
//                                                   carType = val.toString();
//                                                 });
//                                               },
//                                             ),
//                                           )),
//                                       Container(
//                                         width: constraints.maxWidth * 0.7,
//                                         height:
//                                             4 * SizeConfig.blockSizeVertical,
//                                         alignment: Alignment.centerLeft,
//                                         child: LayoutBuilder(
//                                           builder: (context, constraints) {
//                                             return Container(
//                                                 width:
//                                                     constraints.maxWidth * 0.9,
//                                                 child: AutoSizeText('Manual',
//                                                     style: inputLabelStyleDark(
//                                                         SizeConfig
//                                                             .labelFontSize)));
//                                           },
//                                         ),
//                                       )
//                                     ],
//                                   );
//                                 })),
//                             Container(
//                                 width: Responsive.width(40, context),
//                                 child: LayoutBuilder(
//                                     builder: (context, constraints) {
//                                   return Row(
//                                     children: [
//                                       Container(
//                                           width: constraints.maxWidth * 0.3,
//                                           height:
//                                               4 * SizeConfig.blockSizeVertical,
//                                           alignment: Alignment.centerLeft,
//                                           child: Transform.scale(
//                                             scale: .15 *
//                                                 SizeConfig.blockSizeVertical,
//                                             child: Radio(
//                                               value: 'automatic',
//                                               groupValue: carType,
//                                               activeColor: Color(0xFFed1c24),
//                                               onChanged: (val) {
//                                                 setState(() {
//                                                   carType = val.toString();
//                                                 });
//                                               },
//                                             ),
//                                           )),
//                                       Container(
//                                         width: constraints.maxWidth * 0.7,
//                                         height:
//                                             4 * SizeConfig.blockSizeVertical,
//                                         alignment: Alignment.centerLeft,
//                                         child: LayoutBuilder(
//                                           builder: (context, constraints) {
//                                             return Container(
//                                                 width:
//                                                     constraints.maxWidth * 0.9,
//                                                 child: AutoSizeText('Automatic',
//                                                     style: inputLabelStyleDark(
//                                                         SizeConfig
//                                                             .labelFontSize)));
//                                           },
//                                         ),
//                                       )
//                                     ],
//                                   );
//                                 })),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: Responsive.width(100, context),
//                   margin: EdgeInsets.only(bottom: 2),
//                   child: AutoSizeText('Requested Lesson Location*',
//                       style: inputLabelStyleWithBold(SizeConfig.labelFontSize)),
//                 ),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: Responsive.width(100, context),
//                           margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                           child: AutoSizeText("Postcode Search:",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                           width: Responsive.width(100, context),
//                           child: TypeAheadField(
//                             debounceDuration: const Duration(milliseconds: 0),
//                             animationDuration: const Duration(milliseconds: 0),
//                             //hideKeyboard: true,
//
//                             textFieldConfiguration: TextFieldConfiguration(
//                               cursorColor: TestColor,
//                               onChanged: (value) {
//                                 if (debounce?.isActive ?? false)
//                                   debounce?.cancel();
//                                 debounce =
//                                     Timer(Duration(milliseconds: 1000), () {
//                                   if (value.isNotEmpty) {
//                                     autocomplete(value);
//                                   } else {
//                                     setState(() {
//                                       predictions = [];
//                                     });
//                                   }
//                                 });
//                               },
//                               textAlign: TextAlign.left,
//                               controller: _addressController,
//                               //style: inputTextStyle(SizeConfig.inputFontSize),
//                               decoration: InputDecoration(
//                                 labelStyle: const TextStyle(fontSize: 16.0),
//                                 isDense: true,
//                                 labelText: 'Address',
//                                 floatingLabelStyle: const TextStyle(
//                                     fontSize: 20.0,
//                                     fontWeight: FontWeight.bold,
//                                     color: TestColor),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   borderSide: const BorderSide(
//                                     color: TestColor,
//                                     width: 2.0,
//                                   ),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   borderSide: const BorderSide(
//                                     color: TestColor,
//                                     width: 2.0,
//                                   ),
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   borderSide: const BorderSide(
//                                     color: TestColor,
//                                     width: 2.0,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             suggestionsBoxDecoration:
//                                 const SuggestionsBoxDecoration(
//                                     elevation: 5,
//                                     constraints:
//                                         BoxConstraints(maxHeight: 250)),
//                             suggestionsCallback: (pattern) {
//                               return predictions;
//                             },
//                             itemBuilder: (context, suggestion) {
//                               AutocompletePrediction data =
//                                   suggestion as AutocompletePrediction;
//
//                               return ListTile(
//                                 title: AutoSizeText(data.description!),
//                               );
//                             },
//                             onSuggestionSelected: (suggestion) async {
//                               AutocompletePrediction data =
//                                   suggestion as AutocompletePrediction;
//                               final detailsByPlaceID =
//                                   await googlePlace.details.getJson(
//                                 data.placeId!,
//                               );
//                               final details =
//                                   jsonDecode(detailsByPlaceID.toString());
//                               final fullAddressDetails =
//                                   details["result"]["formatted_address"];
//                               List detailsAddressComponent =
//                                   details["result"]["address_components"];
//                               final townDetails = detailsAddressComponent
//                                   .where(
//                                       (x) => x["types"].contains("postal_town"))
//                                   .toList();
//                               final postalDetails = detailsAddressComponent
//                                   .where(
//                                       (x) => x["types"].contains("postal_code"))
//                                   .toList();
//
//                               print("Address: $fullAddressDetails");
//                               print(
//                                   "Address Components: ${detailsAddressComponent}");
//                               print(
//                                   "Town Details: ${townDetails[0]["long_name"]}");
//                               print("PostCode Details: ${postalDetails}");
//
//                               setState(() {
//                                 town.text = townDetails[0]["long_name"];
//                                 postcode = postalDetails[0]["long_name"];
//                                 _addressController.text = fullAddressDetails;
//                               });
//
//                               //setFocus(context, focusNode: town);
//                             },
//                           ),
//                         )
//                       ],
//                     )),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: Responsive.width(100, context),
//                           margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                           child: AutoSizeText("Address Line One*",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             child: TextField(
//                               controller: address_line_1,
//                               style: inputTextStyle(SizeConfig.inputFontSize),
//                               decoration: InputDecoration(
//                                 focusedBorder: inputFocusedBorderStyle(),
//                                 enabledBorder: inputBorderStyle(),
//                                 hintStyle:
//                                     placeholderStyle(SizeConfig.labelFontSize),
//                                 contentPadding:
//                                     EdgeInsets.fromLTRB(5, 0, 3, 16),
//                               ),
//                             ))
//                       ],
//                     )),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: Responsive.width(100, context),
//                           margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                           child: AutoSizeText("Address Line two",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             child: TextField(
//                               controller: address_line_2,
//                               style: inputTextStyle(SizeConfig.inputFontSize),
//                               decoration: InputDecoration(
//                                 focusedBorder: inputFocusedBorderStyle(),
//                                 enabledBorder: inputBorderStyle(),
//                                 hintStyle:
//                                     placeholderStyle(SizeConfig.labelFontSize),
//                                 contentPadding:
//                                     EdgeInsets.fromLTRB(5, 0, 3, 16),
//                               ),
//                             ))
//                       ],
//                     )),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: Responsive.width(100, context),
//                           margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                           child: AutoSizeText("Town*",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             child: TextField(
//                               controller: town,
//                               style: inputTextStyle(SizeConfig.inputFontSize),
//                               decoration: InputDecoration(
//                                 focusedBorder: inputFocusedBorderStyle(),
//                                 enabledBorder: inputBorderStyle(),
//                                 hintStyle:
//                                     placeholderStyle(SizeConfig.labelFontSize),
//                                 contentPadding:
//                                     EdgeInsets.fromLTRB(5, 0, 3, 16),
//                               ),
//                             ))
//                       ],
//                     )),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: Responsive.width(100, context),
//                           margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                           child: AutoSizeText("Postcode*",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             alignment: Alignment.centerLeft,
//                             padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
//                             decoration: textAreaBorderLikeAsInput(),
//                             child: AutoSizeText(
//                               postcode != null ? postcode : '',
//                               style: inputTextStyle(SizeConfig.inputFontSize),
//                             ))
//                       ],
//                     )),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: Responsive.width(100, context),
//                           margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                           child: AutoSizeText("Country",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             child: TextField(
//                                 controller: country,
//                                 style: inputTextStyle(SizeConfig.inputFontSize),
//                                 decoration: InputDecoration(
//                                   focusedBorder: inputFocusedBorderStyle(),
//                                   enabledBorder: inputBorderStyle(),
//                                   hintStyle: placeholderStyle(
//                                       SizeConfig.labelFontSize),
//                                   contentPadding:
//                                       EdgeInsets.fromLTRB(5, 0, 3, 16),
//                                 ),
//                                 onChanged: (value) {
//                                   this.country.text = value;
//                                 }))
//                       ],
//                     )),
//               ],
//             ),
//           ),
//         )));
//   }
//
//   Widget lessonBookStep(BuildContext context) {
//     return (Container(
//         width: Responsive.width(90, context),
//         padding: EdgeInsets.all(0),
//         margin: EdgeInsets.fromLTRB(0.0, 0, 0.0, 0.0),
//         child: Container(
//           width: Responsive.width(100, context),
//           margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
//           child: Card(
//             margin: EdgeInsets.all(0.0),
//             elevation: 0,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Container(
//                   width: Responsive.width(100, context),
//                   margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
//                   child: AutoSizeText(
//                       "Please book the number of lessons needed",
//                       style: inputLabelStyle(SizeConfig.labelFontSize),
//                       textAlign: TextAlign.left),
//                 ),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.only(bottom: 10),
//                     child: Column(
//                       children: [
//                         ...listOfLessons.map((lesson) => Container(
//                               width: Responsive.width(100, context),
//                               color: Colors.grey[200],
//                               padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
//                               margin: EdgeInsets.only(bottom: 20),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     width: Responsive.width(100, context),
//                                     margin: EdgeInsets.only(bottom: 5),
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           width: Responsive.width(70, context),
//                                           child: AutoSizeText(lesson['name'],
//                                               style: inputLabelStyleDark(
//                                                   SizeConfig.labelFontSize)),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     width: Responsive.width(100, context),
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                             width:
//                                                 Responsive.width(17, context),
//                                             height: 4 *
//                                                 SizeConfig.blockSizeVertical,
//                                             child: LayoutBuilder(builder:
//                                                 (context, constraints) {
//                                               return Row(
//                                                 children: [
//                                                   Container(
//                                                       width:
//                                                           constraints.maxWidth *
//                                                               0.30,
//                                                       alignment:
//                                                           Alignment.centerLeft,
//                                                       child: Transform.scale(
//                                                         scale: .15 *
//                                                             SizeConfig
//                                                                 .blockSizeVertical,
//                                                         child: Radio(
//                                                           value: 0,
//                                                           groupValue: lesson[
//                                                               'selected_value'],
//                                                           activeColor:
//                                                               Color(0xFFed1c24),
//                                                           onChanged: (val) {
//                                                             setState(() {
//                                                               lesson['selected_value'] =
//                                                                   val as int;
//                                                               if (val > 0) {
//                                                                 int amount =
//                                                                     35 * val;
//                                                                 lesson['amount'] =
//                                                                     amount;
//                                                               } else
//                                                                 lesson['amount'] =
//                                                                     0;
//                                                             });
//                                                           },
//                                                         ),
//                                                       )),
//                                                   Container(
//                                                     width:
//                                                         constraints.maxWidth *
//                                                             0.7,
//                                                     alignment:
//                                                         Alignment.centerLeft,
//                                                     padding: EdgeInsets.only(
//                                                         left: 5),
//                                                     child: LayoutBuilder(
//                                                       builder: (context,
//                                                           constraints) {
//                                                         return Container(
//                                                             child: AutoSizeText(
//                                                                 '0',
//                                                                 style: inputLabelStyleDark(
//                                                                     SizeConfig
//                                                                         .labelFontSize)));
//                                                       },
//                                                     ),
//                                                   )
//                                                 ],
//                                               );
//                                             })),
//                                         Container(
//                                             width:
//                                                 Responsive.width(17, context),
//                                             height: 4 *
//                                                 SizeConfig.blockSizeVertical,
//                                             child: LayoutBuilder(builder:
//                                                 (context, constraints) {
//                                               return Row(
//                                                 children: [
//                                                   Container(
//                                                       width:
//                                                           constraints.maxWidth *
//                                                               0.3,
//                                                       alignment:
//                                                           Alignment.centerLeft,
//                                                       child: Transform.scale(
//                                                           scale: .15 *
//                                                               SizeConfig
//                                                                   .blockSizeVertical,
//                                                           child: Radio(
//                                                             value: 1,
//                                                             groupValue: lesson[
//                                                                 'selected_value'],
//                                                             activeColor: Color(
//                                                                 0xFFed1c24),
//                                                             onChanged: (val) {
//                                                               setState(() {
//                                                                 lesson['selected_value'] =
//                                                                     val as int;
//                                                                 if (val > 0) {
//                                                                   int amount =
//                                                                       35 * val;
//                                                                   lesson['amount'] =
//                                                                       amount;
//                                                                 } else
//                                                                   lesson['amount'] =
//                                                                       0;
//                                                               });
//                                                             },
//                                                           ))),
//                                                   Container(
//                                                     width:
//                                                         constraints.maxWidth *
//                                                             0.7,
//                                                     alignment:
//                                                         Alignment.centerLeft,
//                                                     padding: EdgeInsets.only(
//                                                         left: 5),
//                                                     child: LayoutBuilder(
//                                                       builder: (context,
//                                                           constraints) {
//                                                         return Container(
//                                                             child: AutoSizeText(
//                                                                 '1',
//                                                                 style: inputLabelStyleDark(
//                                                                     SizeConfig
//                                                                         .labelFontSize)));
//                                                       },
//                                                     ),
//                                                   )
//                                                 ],
//                                               );
//                                             })),
//                                         Container(
//                                             width:
//                                                 Responsive.width(17, context),
//                                             height: 4 *
//                                                 SizeConfig.blockSizeVertical,
//                                             child: LayoutBuilder(builder:
//                                                 (context, constraints) {
//                                               return Row(
//                                                 children: [
//                                                   Container(
//                                                       width:
//                                                           constraints.maxWidth *
//                                                               0.3,
//                                                       alignment:
//                                                           Alignment.centerLeft,
//                                                       child: Transform.scale(
//                                                           scale: .15 *
//                                                               SizeConfig
//                                                                   .blockSizeVertical,
//                                                           child: Radio(
//                                                             value: 2,
//                                                             groupValue: lesson[
//                                                                 'selected_value'],
//                                                             activeColor: Color(
//                                                                 0xFFed1c24),
//                                                             onChanged: (val) {
//                                                               setState(() {
//                                                                 lesson['selected_value'] =
//                                                                     val as int;
//                                                                 if (val > 0) {
//                                                                   int amount =
//                                                                       35 * val;
//                                                                   lesson['amount'] =
//                                                                       amount;
//                                                                 } else
//                                                                   lesson['amount'] =
//                                                                       0;
//                                                               });
//                                                             },
//                                                           ))),
//                                                   Container(
//                                                     width:
//                                                         constraints.maxWidth *
//                                                             0.7,
//                                                     alignment:
//                                                         Alignment.centerLeft,
//                                                     padding: EdgeInsets.only(
//                                                         left: 5),
//                                                     child: LayoutBuilder(
//                                                       builder: (context,
//                                                           constraints) {
//                                                         return Container(
//                                                             child: AutoSizeText(
//                                                                 '2',
//                                                                 style: inputLabelStyleDark(
//                                                                     SizeConfig
//                                                                         .labelFontSize)));
//                                                       },
//                                                     ),
//                                                   )
//                                                 ],
//                                               );
//                                             })),
//                                         Container(
//                                             width:
//                                                 Responsive.width(17, context),
//                                             height: 4 *
//                                                 SizeConfig.blockSizeVertical,
//                                             child: LayoutBuilder(builder:
//                                                 (context, constraints) {
//                                               return Row(
//                                                 children: [
//                                                   Container(
//                                                       width:
//                                                           constraints.maxWidth *
//                                                               0.3,
//                                                       alignment:
//                                                           Alignment.centerLeft,
//                                                       child: Transform.scale(
//                                                           scale: .15 *
//                                                               SizeConfig
//                                                                   .blockSizeVertical,
//                                                           child: Radio(
//                                                             value: 3,
//                                                             groupValue: lesson[
//                                                                 'selected_value'],
//                                                             activeColor: Color(
//                                                                 0xFFed1c24),
//                                                             onChanged: (val) {
//                                                               setState(() {
//                                                                 lesson['selected_value'] =
//                                                                     val as int;
//                                                                 if (val > 0) {
//                                                                   int amount =
//                                                                       35 * val;
//                                                                   lesson['amount'] =
//                                                                       amount;
//                                                                 } else
//                                                                   lesson['amount'] =
//                                                                       0;
//                                                               });
//                                                             },
//                                                           ))),
//                                                   Container(
//                                                     width:
//                                                         constraints.maxWidth *
//                                                             0.7,
//                                                     alignment:
//                                                         Alignment.centerLeft,
//                                                     padding: EdgeInsets.only(
//                                                         left: 5),
//                                                     child: LayoutBuilder(
//                                                       builder: (context,
//                                                           constraints) {
//                                                         return Container(
//                                                             child: AutoSizeText(
//                                                                 '3',
//                                                                 style: inputLabelStyleDark(
//                                                                     SizeConfig
//                                                                         .labelFontSize)));
//                                                       },
//                                                     ),
//                                                   )
//                                                 ],
//                                               );
//                                             })),
//                                       ],
//                                     ),
//                                   ),
//                                   if (lesson['amount'] > 0)
//                                     Container(
//                                         alignment: Alignment.centerRight,
//                                         width: Responsive.width(80, context),
//                                         child: AutoSizeText(
//                                           "Total = £" +
//                                               lesson['amount'].toString(),
//                                           style: inputLabelStyle(
//                                               SizeConfig.labelFontSize),
//                                         ))
//                                 ],
//                               ),
//                             ))
//                       ],
//                     )),
//                 Container(
//                   width: Responsive.width(100, context),
//                   margin: EdgeInsets.fromLTRB(0, 15, 0, 5),
//                   child: AutoSizeText("I hereby agree that",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 2 * SizeConfig.blockSizeVertical,
//                       )),
//                 ),
//                 Container(
//                     width: Responsive.width(100, context),
//                     child: Column(
//                       children: [
//                         ListTile(
//                             horizontalTitleGap: 0,
//                             contentPadding: EdgeInsets.only(bottom: 5),
//                             leading: Container(
//                                 width: 5 * SizeConfig.blockSizeVertical,
//                                 child: Transform.scale(
//                                     scale: .15 * SizeConfig.blockSizeVertical,
//                                     child: Checkbox(
//                                       checkColor: Colors.white,
//                                       activeColor: Colors.blue,
//                                       value: hearby_agreey_1,
//                                       onChanged: (bool? value) {
//                                         setState(() {
//                                           hearby_agreey_1 = value!;
//                                         });
//                                       },
//                                     ))),
//                             title: AutoSizeText(
//                                 "I am ready to pay 35 pounds for each of the driving lesson.",
//                                 style: TextStyle(
//                                     fontSize: 2 * SizeConfig.blockSizeVertical,
//                                     color: Colors.blue))),
//                         ListTile(
//                             horizontalTitleGap: 0,
//                             contentPadding: EdgeInsets.only(bottom: 5),
//                             leading: Container(
//                                 width: 5 * SizeConfig.blockSizeVertical,
//                                 child: Transform.scale(
//                                   scale: .15 * SizeConfig.blockSizeVertical,
//                                   child: Checkbox(
//                                     checkColor: Colors.white,
//                                     activeColor: Colors.blue,
//                                     value: hearby_agreey_2,
//                                     onChanged: (bool? value) {
//                                       setState(() {
//                                         hearby_agreey_2 = value!;
//                                       });
//                                     },
//                                   ),
//                                 )),
//                             title: AutoSizeText(
//                                 "My lesson booking will be completed only after Mock Driving Test team have called me to discuss and agree the rates.",
//                                 style: TextStyle(
//                                     fontSize: 2 * SizeConfig.blockSizeVertical,
//                                     color: Colors.blue))),
//                         ListTile(
//                             horizontalTitleGap: 0,
//                             contentPadding: EdgeInsets.only(bottom: 5),
//                             leading: Container(
//                                 width: 5 * SizeConfig.blockSizeVertical,
//                                 child: Transform.scale(
//                                   scale: .15 * SizeConfig.blockSizeVertical,
//                                   child: Checkbox(
//                                     checkColor: Colors.white,
//                                     activeColor: Colors.blue,
//                                     value: hearby_agreey_3,
//                                     onChanged: (bool? value) {
//                                       setState(() {
//                                         hearby_agreey_3 = value!;
//                                       });
//                                     },
//                                   ),
//                                 )),
//                             title: AutoSizeText(
//                                 "I agree to the Terms and Conditions set by Mock Driving Test.",
//                                 style: TextStyle(
//                                     fontSize: 2 * SizeConfig.blockSizeVertical,
//                                     color: Colors.blue))),
//                       ],
//                     )),
//               ],
//             ),
//           ),
//         )));
//   }
//
//   Widget paymentStep(BuildContext context) {
//     return (Container(
//         width: Responsive.width(90, context),
//         padding: EdgeInsets.all(0),
//         margin: EdgeInsets.fromLTRB(0.0, 0, 0.0, 0.0),
//         child: Container(
//           width: Responsive.width(100, context),
//           margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
//           child: Card(
//             margin: EdgeInsets.all(0.0),
//             elevation: 0,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Container(
//                   width: Responsive.width(100, context),
//                   margin: EdgeInsets.only(bottom: 5),
//                   child: AutoSizeText(
//                     'Total Cost: £' + diaplayCost,
//                     style: inputLabelStyleDark(SizeConfig.labelFontSize),
//                   ),
//                 ),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
//                     child: Column(
//                       children: [
//                         Container(
//                             width: Responsive.width(100, context),
//                             margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                             child: Row(
//                               children: [
//                                 Container(
//                                     alignment: Alignment.centerLeft,
//                                     width: Responsive.width(30, context),
//                                     child: AutoSizeText("Discount Code",
//                                         style: inputLabelStyle(
//                                             SizeConfig.labelFontSize),
//                                         textAlign: TextAlign.left)),
//                                 if (discountApplied >= 0)
//                                   Container(
//                                     alignment: Alignment.centerRight,
//                                     width: Responsive.width(47, context),
//                                     child: AutoSizeText(discountAppliedMessage,
//                                         style: TextStyle(
//                                             fontSize: 12,
//                                             color: discountApplied == 0
//                                                 ? Colors.redAccent
//                                                 : Colors.green,
//                                             fontWeight: FontWeight.w500),
//                                         textAlign: TextAlign.left),
//                                   )
//                               ],
//                             )),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             child: TextField(
//                                 controller: discount_code,
//                                 style: inputTextStyle(SizeConfig.inputFontSize),
//                                 decoration: InputDecoration(
//                                   focusedBorder: inputFocusedBorderStyle(),
//                                   enabledBorder: inputBorderStyle(),
//                                   hintStyle: placeholderStyle(
//                                       SizeConfig.labelFontSize),
//                                   contentPadding:
//                                       EdgeInsets.fromLTRB(5, 0, 3, 16),
//                                 ),
//                                 keyboardType: TextInputType.text,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     discountAppliedMessage = '';
//                                   });
//                                 })),
//                         Container(
//                             width: Responsive.width(100, context),
//                             alignment: Alignment.centerRight,
//                             child: ButtonTheme(
//                                 minWidth: 100,
//                                 height: 5 * SizeConfig.blockSizeVertical,
//                                 child: ElevatedButton(
//                                   child: new AutoSizeText(
//                                     'Apply',
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize:
//                                             2 * SizeConfig.blockSizeVertical),
//                                   ),
//                                   onPressed: (discount_code.text == null ||
//                                           discount_code.text.trim() == '')
//                                       ? null
//                                       : () {
//                                           Map<String, String> params = {
//                                             'discount_code': discount_code.text,
//                                             'actual_value': this.totalCost.text,
//                                             'type': 'lesson',
//                                             'user_id': _userId.toString()
//                                           };
//                                           showLoader('Discount applying...');
//                                           applyDiscountCodeApi(params)
//                                               .then((response) {
//                                             closeLoader();
//                                             Color backgroundColor_;
//                                             if (response['success'] == true) {
//                                               backgroundColor_ =
//                                                   Colors.lightGreenAccent;
//                                               discountApplied = 1;
//                                               setState(() {
//                                                 diaplayCost = (response['data']
//                                                         ["new_cost"])
//                                                     .toStringAsFixed(2);
//                                               });
//                                             } else {
//                                               backgroundColor_ =
//                                                   Colors.redAccent;
//                                               discountApplied = 0;
//                                             }
//                                             setState(() {
//                                               discountAppliedMessage =
//                                                   response['message'];
//                                             });
//                                           });
//                                         },
//                                 )))
//                       ],
//                     )),
//               ],
//             ),
//           ),
//         )));
//   }
//
//   Widget footerActionBar(BuildContext context) {
//     return (Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           height: Responsive.height(8, context),
//           alignment: Alignment.centerRight,
//           //color: Colors.black26,
//           child: ButtonBar(
//             alignment: MainAxisAlignment.end,
//             mainAxisSize: MainAxisSize.max,
//             children: <Widget>[
//               if (this.current_step > 0)
//                 Container(
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                     child: ButtonTheme(
//                       minWidth: Responsive.width(25, context),
//                       height: Responsive.height(4, context),
//                       child: ElevatedButton(
//                         child: AutoSizeText(
//                           'Previous',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 2 * SizeConfig.blockSizeVertical,
//                           ),
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             if (this.current_step > 0) {
//                               this.current_step = this.current_step - 1;
//                               _multiStepperWidget.currentState!
//                                   .changeStep(this.current_step);
//                             }
//                             try {
//                               list_view_scrollCtrl.jumpTo(0);
//                             } catch (e) {}
//                           });
//                         },
//                       ),
//                     )),
//               if (this.current_step == 0)
//                 Container(
//                   margin: EdgeInsets.fromLTRB(Responsive.width(2, context), 0,
//                       Responsive.width(2, context), 0),
//                   alignment: Alignment.center,
//                   child: ButtonTheme(
//                     minWidth: Responsive.width(20, context),
//                     height: Responsive.height(4, context),
//                     child: ElevatedButton(
//                       child: AutoSizeText(
//                         'Next',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 2 * SizeConfig.blockSizeVertical,
//                         ),
//                       ),
//                       onPressed: () {
//                         if (this.current_step < 2) {
//                           if (this.current_step == 0 && !validateStep_1()) {
//                             if (age < 16) {
//                               Toast.show("You must be above 16 to book lesson",
//                                   //textStyle: context,
//                                   duration: Toast.lengthLong,
//                                   gravity: Toast.bottom);
//                             } else {
//                               Toast.show("Please filled all required(*) field.",
//                                   //textStyle: context,
//                                   duration: Toast.lengthLong,
//                                   gravity: Toast.bottom);
//                             }
//                           } else {
//                             setState(() {
//                               this.current_step = this.current_step + 1;
//                               _multiStepperWidget.currentState!
//                                   .changeStep(this.current_step);
//                               try {
//                                 list_view_scrollCtrl.jumpTo(0);
//                               } catch (e) {}
//                             });
//                           }
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               if (this.current_step == 1)
//                 Container(
//                   margin: EdgeInsets.fromLTRB(
//                       Responsive.width(2, context), 0, 0, 0),
//                   child: ButtonTheme(
//                     minWidth: Responsive.width(25, context),
//                     height: Responsive.height(4, context),
//                     buttonColor: Color(0xFFed1c24),
//                     child: ElevatedButton(
//                       child: new AutoSizeText(
//                         'Request Booking',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           if (this.current_step < 2) {
//                             if (this.current_step == 1 && !validateStep_2()) {
//                               Toast.show("Please filled all required(*) field.",
//                                   // textStyle: context,
//                                   duration: Toast.lengthLong,
//                                   gravity: Toast.bottom);
//                             } else if (hearby_agreey_1 == false ||
//                                 hearby_agreey_2 == false ||
//                                 hearby_agreey_3 == false) {
//                               Toast.show("Please select agreement terms.",
//                                   //  textStyle: context,
//                                   duration: Toast.lengthLong,
//                                   gravity: Toast.bottom);
//                             } else {
//                               double totalCost_ = 0;
//                               listOfLessons.forEach((lesson) {
//                                 totalCost_ += lesson['amount'];
//                               });
//                               this.totalCost.text =
//                                   (double.parse(this.cost.text) + totalCost_)
//                                       .toString();
//                               setState(() {
//                                 diaplayCost = this.totalCost.text;
//                               });
//                               this.current_step = this.current_step + 1;
//                               _multiStepperWidget.currentState!
//                                   .changeStep(this.current_step);
//                               try {
//                                 list_view_scrollCtrl.jumpTo(0);
//                               } catch (e) {}
//                             }
//                           }
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               if (this.current_step == 2)
//                 Container(
//                   margin: EdgeInsets.fromLTRB(Responsive.width(2, context), 0,
//                       Responsive.width(2, context), 0),
//                   child: ButtonTheme(
//                     minWidth: Responsive.width(25, context),
//                     height: Responsive.height(4, context),
//                     child: ElevatedButton(
//                       child: new AutoSizeText(
//                         'Pay',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       onPressed: () {
//                         print(lessonTimeDropContr.text);
//                         Map<String, String> requestForm = {
//                           'id': this._userId.toString(),
//                           'user_type': '2',
//                           'course_name': '3',
//                           'requested_date': this.test_date_picker.text == null
//                               ? ''
//                               : this.test_date_picker.text,
//                           'test_time': this.lessonTimeDropContr.text == null
//                               ? ''
//                               : this.lessonTimeDropContr.text == "Any Time"
//                                   ? 'any_time'
//                                   : this.lessonTimeDropContr.text,
//                           'vehicle_preference': vehicle_preference,
//                           'carType': carType,
//                           'location':
//                               this.location == null ? '' : this.location,
//                           'address_line_1': address_line_1.text == null
//                               ? ''
//                               : address_line_1.text,
//                           'address_line_2': address_line_2.text == null
//                               ? ''
//                               : address_line_2.text,
//                           'town': this.town.text == null ? '' : this.town.text,
//                           'postcode': postcode,
//                           'country': country.text == null ? '' : country.text,
//                           'first_name':
//                               this.first_name == null ? '' : this.first_name,
//                           'last_name':
//                               this.last_name == null ? '' : this.last_name,
//                           'email': this.email == null ? '' : this.email,
//                           'phone':
//                               this.phone.text == null ? '' : this.phone.text,
//                           'birth_date': this.birth_date_picker.text == null
//                               ? ''
//                               : this.birth_date_picker.text,
//                           'lesson_taken_before': '',
//                           'learner_license_no': learner_license_no.text == null
//                               ? ''
//                               : learner_license_no.text,
//                           'user_license_expiry':
//                               license_expiry_date_picker.text == null
//                                   ? ''
//                                   : license_expiry_date_picker.text,
//                           'license_photo': licenceBase64,
//                           'discount_code': discount_code.text == null
//                               ? ''
//                               : discount_code.text,
//                           'payment_type': 'pay_now',
//                           'cost': diaplayCost,
//                           'orignal_cost': this.totalCost.text == null
//                               ? ''
//                               : this.totalCost.text,
//                         };
//                         listOfLessons.asMap().forEach((index, lesson) {
//                           requestForm[lesson['key']] =
//                               lesson['selected_value'].toString();
//                         });
//                         showLoader('Lesson Submitting...');
//                         postPassAssistLessonApiCall(requestForm)
//                             .then((response) {
//                           print("response.......");
//                           print(response);
//                           closeLoader();
//                           Toast.show(response!["message"],
//                               //textStyle: context,
//                               duration: Toast.lengthLong,
//                               gravity: Toast.bottom);
//                           if (response['success'] == true) {
//                             try {
//                               Map params = {
//                                 'id': this._userId.toString(),
//                                 'user_type': '2',
//                                 'lesson_master_id': response['data']
//                                         ['lesson_master_id']
//                                     .toString(),
//                                 'batch_hash':
//                                     response['data']['batch_hash'].toString(),
//                                 'lesson_type': 'pass-assist',
//                                 'total_cost': diaplayCost,
//                                 'parentPageName':
//                                     routes.BookPassAssistLessonsFormRoute
//                               };
//                               _navigationService.navigateToReplacement(
//                                   routes.CardPaymentRoute,
//                                   arguments: params);
//                             } catch (e) {
//                               print(e);
//                               Toast.show('Failed request! please try again.',
//                                   //textStyle: context,
//                                   duration: Toast.lengthLong,
//                                   gravity: Toast.bottom);
//                             }
//                           }
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         )
//       ],
//     ));
//   }
//
//   void _openGallery() async {
//     final pickedFile =
//         await ImagePicker().getImage(source: ImageSource.gallery);
//     final bytes = Io.File(pickedFile!.path).readAsBytesSync();
//     String base64_ = base64Encode(bytes, getImageExtension(pickedFile.path));
//     this.setState(() {
//       licenceBase64 = base64_;
//       licence = File(pickedFile.path);
//     });
//   }
//
//   void _openCamera() async {
//     final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
//     final bytes = Io.File(pickedFile!.path).readAsBytesSync();
//     String base64_ = base64Encode(bytes, getImageExtension(pickedFile.path));
//     this.setState(() {
//       licenceBase64 = base64_;
//       licence = File(pickedFile.path);
//     });
//   }
//
//   bool validateStep_1() {
//     if (this.test_date_picker.text == null ||
//         this.test_date_picker.text.trim() == "")
//       return false;
//     else if (this.lessonTimeDropContr.text == null ||
//         this.lessonTimeDropContr.text.trim() == "")
//       return false;
//     else if (this.address_line_1.text == null ||
//         this.address_line_1.text.trim() == "")
//       return false;
//     else if (birth_date_picker.text == null ||
//         birth_date_picker.text.trim() == "" ||
//         age < 16)
//       return false;
//     else if (this.town.text == null || this.town.text.trim() == "")
//       return false;
//     else if (postcode == null || postcode.trim() == "")
//       return false;
//     else
//       return true;
//   }
//
//   bool validateStep_2() {
//     return true;
//   }
//
//   void showLoader(String message) {
//     CustomSpinner.showLoadingDialog(context, _keyLoader, message);
//   }
//
//   void closeLoader() {
//     try {
//       Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//     } catch (e) {}
//   }
//
//   Future<bool> checkInternet() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile) {
//       return true;
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       return true;
//     }
//     return false;
//   }
//
//   //Call APi Services
//   Future<Map> getUserDetail() async {
//     Map userDetail =
//         await Provider.of<AuthProvider>(context, listen: false).getUserData();
//     print("response...$userDetail");
//     licenceHttpPath = userDetail['img_url'];
//     _userId = userDetail['id'];
//     first_name = userDetail['first_name'];
//     last_name = userDetail['last_name'];
//     email = userDetail['email'];
//     setState(() {
//       if (userDetail['date_of_birth'] != null) {
//         var dateOfBirth = userDetail['date_of_birth'].split('-');
//
//         age = calculateAge(DateTime.parse(userDetail['date_of_birth']));
//
//         birth_date_picker.text =
//             dateOfBirth[2] + '-' + dateOfBirth[1] + '-' + dateOfBirth[0];
//       }
//
//       phone.text = userDetail['phone'];
//       learner_license_no.text = userDetail['driver_license_no'];
//       var dateOfLicenseExpire = userDetail['driver_license_expiry'].split('-');
//       license_expiry_date_picker.text = dateOfLicenseExpire[2] +
//           '-' +
//           dateOfLicenseExpire[1] +
//           '-' +
//           dateOfLicenseExpire[0];
//     });
//     return userDetail;
//   }
//
//   //call api for getAddress
//   Future<void> getAddressInfo(String udprn, BuildContext page_context) async {
//     Map? addressInfo = await _bookingService.getAddress(udprn);
//     Map<String, String> params = {
//       //  "postcode": addressInfo!['postcode'],
//       "car_type": carType,
//       "vehicle_preference": vehicle_preference,
//       "type": "3",
//       "course_id": ""
//     };
//     getDynamicRateApiCall(params).then((dynamicRateResponse) {
//       if (dynamicRateResponse['success'] == true) {
//         setState(() {
//           this.location = udprn;
//           this.address_line_1.text = addressInfo?['line_1'];
//           this.address_line_2.text = addressInfo?['line_2'];
//           this.town.text = addressInfo?['post_town'];
//           //postcode = addressInfo['postcode'];
//           this.country.text = addressInfo?['country'];
//           /* if (dynamicRateResponse['data']['max_adi_rate'] is double ||
//               dynamicRateResponse['data']['max_adi_rate'] is int)
//             this.cost.text =
//                 (dynamicRateResponse['data']['max_adi_rate']).toString();
//           else
//             this.cost.text = dynamicRateResponse['data']['max_adi_rate']; */
//           diaplayCost = this.cost.text;
//           closeLoader();
//         });
//       } else {
//         closeLoader();
//         setState(() {
//           addressSuggestion = "";
//           this.address_line_1.text = "";
//           this.address_line_2.text = "";
//           this.town.text = "";
//           postcode = "";
//           this.country.text = "";
//         });
//         alertToShowAdiNotFound(page_context);
//       }
//     });
//   }
//
//   //call api for check adi and dynamic rate
//   Future<Map> getDynamicRateApiCall(Map params) async {
//     Map dynamicRateResponse = await _bookingService.getDynamicRate(params);
//     return dynamicRateResponse;
//   }
//
//   //call api for save form data
//   Future<Map?> postPassAssistLessonApiCall(Map<String, String> params) async {
//     try {
//       Map response = await _bookingService.postPassAssistLesson(params);
//       return response;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }
//
//   //call api for apply discount-code
//   Future<Map> applyDiscountCodeApi(Map params) async {
//     Map dynamicRateResponse = await _bookingService.applyDiscountCode(params);
//     return dynamicRateResponse;
//   }
// }
