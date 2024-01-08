import 'dart:convert';
import 'dart:developer';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:google_api_headers/google_api_headers.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:student_app/Constants/app_colors.dart';
import 'package:flutter/src/material/card.dart' as MCard;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import '../../../Constants/const_data.dart';
import '../../../Constants/global.dart';
import '../../../locater.dart';
import 'dart:io' as Io;
import 'dart:io';
import 'dart:async';

import '../../../responsive/percentage_mediaquery.dart';
import '../../../responsive/size_config.dart';
import '../../../services/auth.dart';
import '../../../services/booking_test.dart';
import '../../../services/methods.dart';
import '../../../services/navigation_service.dart';
import '../../../services/payment_services.dart';
import '../../../style/global_style.dart';
import '../../../widget/CustomAppBar.dart';
import '../../../widget/CustomSpinner.dart';
import '../../../widget/ImageZoomView/image_zoom_view.dart';
import '../../../widget/MultiSteps/multi_steps_element.dart';

class BookLessionForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _bookLessionForm();
}

class _bookLessionForm extends State<BookLessionForm> {
  final GlobalKey<MultiStepsElementsSate> _multiStepperWidget =
      GlobalKey<MultiStepsElementsSate>();
  final NavigationService _navigationService = locator<NavigationService>();
  final BookingService _bookingService = new BookingService();
  final PaymentService _paymentService = new PaymentService();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  // init the step to 0th position
  int current_step = 0;
  late int age;

  List<String> stepsList = [
    'Step1:\nLesson Search',
    'Step2:\nLearner Detail',
    'Step3:\nPayment'
  ];

  final SuggestionsBoxController _suggestionsBoxController =
      new SuggestionsBoxController();
  late int _userId;
  late ScrollController list_view_scrollCtrl;
  String course_id = '';
  final TextEditingController course_nameDropContr =
      new TextEditingController();
  final TextEditingController lesson_date_picker = new TextEditingController();
  final TextEditingController lessonTimeDropContr = new TextEditingController();
  String vehicle_preference = 'instructor';
  String carType = 'automatic';
  late String location = ' ';
  String? addressSuggestion;
  final TextEditingController address_line_1 = new TextEditingController(),
      address_line_2 = new TextEditingController(),
      town = new TextEditingController(),
      country = new TextEditingController(),
      _addressController = new TextEditingController();
  String postcode = "";
  final TextEditingController first_name = new TextEditingController(),
      last_name = new TextEditingController(),
      email = new TextEditingController(),
      phone = new TextEditingController();
  final TextEditingController birth_date_picker = new TextEditingController();
  final TextEditingController lesson_taken_beforeDropCtrl =
      new TextEditingController();
  final TextEditingController learner_license_no = new TextEditingController();
  final TextEditingController license_expiry_date_picker =
      new TextEditingController();
  File? licence = null;
  String licenceBase64 = '';
  String? licenceHttpPath = null;
  final TextEditingController discount_code = new TextEditingController();
  final TextEditingController cost = new TextEditingController();
  String displayCost = '';
  String discountAppliedMessage = '';
  int discountApplied =
      -1; //-1 if not applied, 1 if successfully applied, 0 if not failed
  double discounted_cost = 0;
  bool hearby_agreey_1 = false;
  bool hearby_agreey_2 = false;
  bool hearby_agreey_3 = false;
  Timer? debounce;
  String _address = "Search Postcode";
  Mode _mode = Mode.overlay;

  Future<void> _handlePressButton() async {
    void onError(PlacesAutocompleteResponse response) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.errorMessage ?? 'Unknown error'),
        ),
      );
    }

    // show input autocomplete with selected mode
    // then get the Prediction selected
    final p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      types: ["postal_code"],
      components: [Component(Component.country, 'uk')],
    );

    await displayPrediction(p, ScaffoldMessenger.of(context));
  }

  Future<void> displayPrediction(
      Prediction? p, ScaffoldMessengerState messengerState) async {
    if (p == null) {
      print('NULLL ///////////////  ');
      return;
    }

    // get detail (lat/lng)
    final _places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    final detail = await _places.getDetailsByPlaceId(p.placeId!);
    log("-------------------------------------------------");
    log("Desc : ${p.description!}");
    log("Place id : ${p.placeId!}");
    log("Place details : ${detail.result.toJson()}");
    String postalCode = detail.result.addressComponents
        .where((element) => element.types.contains("postal_code"))
        .first
        .longName;
    String townName = detail.result.addressComponents
        .where((element) => element.types.contains("postal_town"))
        .first
        .longName;
    Iterable street = detail.result.addressComponents
        .where((element) => element.types.contains("route"));
    setState(() {
      town.text = townName;
      postcode = postalCode;
      _address = detail.result.formattedAddress!;
    });
    if (street.length > 0) {
      String streetAdd = street.first.longName;
      log("Street Code : ${streetAdd}");
      setState(() {
        address_line_2.text = streetAdd;
      });
    } else {
      setState(() {
        address_line_2.text = "";
      });
    }
    Map<String, String> params = {
      "postcode": postalCode,
      "car_type": carType,
      "vehicle_preference": vehicle_preference,
      "type": "lesson",
      "course_id": this.course_id
    };
    getDynamicRateApiCall(params).then((dynamicRateResponse) {
      if (dynamicRateResponse['success'] == true) {
        setState(() {
          if (dynamicRateResponse['data']['max_adi_rate'] is double ||
              dynamicRateResponse['data']['max_adi_rate'] is int)
            this.cost.text =
                (dynamicRateResponse['data']['max_adi_rate']).toString();
          else
            this.cost.text = dynamicRateResponse['data']['max_adi_rate'];
          displayCost = this.cost.text;
          closeLoader();
        });
      } else {
        closeLoader();
        setState(() {
          addressSuggestion = "";
          this.address_line_1.text = "";
          this.address_line_2.text = "";
          this.town.text = "";
          postcode = "";
          this.country.text = "";
        });
        alertToShowAdiNotFound(context);
      }
    });
    log("Display Cost : $displayCost");
    log("Postal Code : ${postalCode}");
    log("Town name : ${townName}");
    detail.result.addressComponents
        .forEach((e) => log("Address Components : ${e.toJson()}"));
    //log("Address Components : ${detail.result.addressComponents[1].toJson()}");
    log("-------------------------------------------------");
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    print("today year " + currentDate.toString());
    print("birth year " + birthDate.toString());
    print("hello $age");
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }

    return age;
  }

  initializeApi(String loaderMessage) {
    checkInternet();
    showLoader(loaderMessage);
    getUserDetail().then((userDetail) {
      setState(() {
        first_name.text = userDetail['first_name'];
        last_name.text =
            userDetail['last_name'] != null ? userDetail['last_name'] : '';
        email.text = userDetail['email'] != null ? userDetail['email'] : '';
        phone.text = userDetail['phone'] != null ? userDetail['phone'] : '';
        if (userDetail['date_of_birth'] != null) {
          var dateOfBirth = userDetail['date_of_birth'].split('-');

          age = calculateAge(DateTime.parse(userDetail['date_of_birth']));

          birth_date_picker.text =
              dateOfBirth[2] + '-' + dateOfBirth[1] + '-' + dateOfBirth[0];
        }
        learner_license_no.text = userDetail['driver_license_no'];
        var dateOfLicenseExpire =
            userDetail['driver_license_expiry'].split('-');
        license_expiry_date_picker.text = dateOfLicenseExpire[2] +
            '-' +
            dateOfLicenseExpire[1] +
            '-' +
            dateOfLicenseExpire[0];
      });
      closeLoader();
    }).catchError((onError) => closeLoader());
  }

  @override
  void initState() {
    list_view_scrollCtrl = ScrollController();
    super.initState();
    Future.delayed(Duration.zero, () {
      this.initializeApi("Loading...");
    });
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

  // void autocomplete(String value) async {
  //   var result = await googlePlace.autocomplete.get(value, region: 'GB');
  //   if (result != null && mounted) {
  //     setState(() {
  //       predictions = result.predictions!;
  //     });
  //   } else {
  //     setState(() {
  //       predictions = [];
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;

    print("args : ${args["courseId"]}");
    course_id = args["courseId"].toString();
    course_nameDropContr.text = args["name"];
    SizeConfig().init(context);
    ToastContext().init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          CustomAppBar(
              preferedHeight: Responsive.height(24, context),
              title: 'Book Driving Course',
              textWidth: Responsive.width(35, context),
              iconLeft: Icons.arrow_back,
              onTap1: () {
                _navigationService.goBack();
              },
              iconRight: null),
          Container(
              // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              margin: EdgeInsets.fromLTRB(
                  20, Responsive.height(14, context), 20, 0),
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
                          width: Responsive.width(80, context),
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          alignment: Alignment.centerLeft,
                          child: MultiStepsElements(
                              key: _multiStepperWidget,
                              steps: this.stepsList,
                              constraints: constraints,
                              parentContext: context),
                        ),
                        Container(
                          width: Responsive.width(100, context),
                          height: Responsive.height(62, context),
                          padding: EdgeInsets.fromLTRB(5, 3, 5, 0),
                          child: ListView(
                            controller: list_view_scrollCtrl,
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.fromLTRB(10, 2, 10,
                                MediaQuery.of(context).viewInsets.bottom),
                            children: [
                              if (current_step == 0)
                                LayoutBuilder(builder: (context, constraints) {
                                  return lessionSearchStep(context);
                                }),
                              if (current_step == 1)
                                LayoutBuilder(builder: (context, constraints) {
                                  return learnerDetailsStep(
                                      context, constraints);
                                }),
                              if (current_step == 2)
                                LayoutBuilder(builder: (context, constraints) {
                                  return paymentStep(context);
                                }),
                            ],
                          ),
                        ),
                        Container(
                          width: Responsive.width(100, context),
                          height: Responsive.height(8, context),
                          padding: EdgeInsets.all(0),
                          child:
                              LayoutBuilder(builder: (context, constraints_) {
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

  Widget lessionSearchStep(BuildContext context) {
    return (Container(
        width: Responsive.width(90, context),
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.fromLTRB(0.0, 0, 0.0, 0.0),
        child: Container(
          width: Responsive.width(100, context),
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: MCard.Card(
            margin: EdgeInsets.all(0.0),
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    width: Responsive.width(100, context),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: AutoSizeText("Course*",
                              style: inputLabelStyle(SizeConfig.labelFontSize),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                          width: Responsive.width(100, context),
                          //height: SizeConfig.inputHeight,
                          child: Text(
                            course_nameDropContr.text,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )),
                Container(
                    width: Responsive.width(100, context),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: AutoSizeText("Requested Lesson Start Date*",
                              style: inputLabelStyle(SizeConfig.labelFontSize),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                          width: Responsive.width(100, context),
                          height: SizeConfig.inputHeight,
                          child: DateTimeField(
                              controller: this.lesson_date_picker,
                              textAlign: TextAlign.left,
                              format: DateFormat('dd-MM-yyyy'),
                              readOnly: true,
                              style: inputTextStyle(SizeConfig.inputFontSize),
                              decoration: InputDecoration(
                                hintText: "DD-MM-YYY",
                                hintStyle:
                                    placeholderStyle(SizeConfig.labelFontSize),
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
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  Dark, // button text color
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                    firstDate: DateTime.now()
                                        .add(const Duration(days: 5)),
                                    initialDate: currentValue ??
                                        DateTime.now()
                                            .add(const Duration(days: 5)),
                                    lastDate: DateTime(
                                        DateTime.now().year + 10, 12, 31));
                              },
                              onChanged: (DateTime? selected_date) {
                                try {
                                  this.lesson_date_picker.text =
                                      (selected_date!.day).toString() +
                                          "-" +
                                          (selected_date.month).toString() +
                                          "-" +
                                          (selected_date.year).toString();
                                } catch (e) {}
                              }),
                        )
                      ],
                    )),
                Container(
                    width: Responsive.width(100, context),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: AutoSizeText("Requested Lesson Time*",
                              style: inputLabelStyle(SizeConfig.labelFontSize),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                            width: Responsive.width(100, context),
                            height: 40,
                            child: TypeAheadField(
                              debounceDuration: Duration(milliseconds: 0),
                              animationDuration: Duration(milliseconds: 0),
                              hideKeyboard: true,
                              textFieldConfiguration: TextFieldConfiguration(
                                  textAlign: TextAlign.left,
                                  controller: this.lessonTimeDropContr,
                                  style:
                                      inputTextStyle(SizeConfig.inputFontSize),
                                  decoration: InputDecoration(
                                    focusedBorder: inputFocusedBorderStyle(),
                                    enabledBorder: inputBorderStyle(),
                                    hintText: '--Select--',
                                    hintStyle: placeholderStyle(
                                        SizeConfig.labelFontSize),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(5, 10, 3, 10),
                                  )),
                              suggestionsBoxDecoration:
                                  SuggestionsBoxDecoration(
                                      elevation: 5,
                                      constraints:
                                          BoxConstraints(maxHeight: 250)),
                              suggestionsCallback: (pattern) async {
                                return timeSlots;
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: AutoSizeText(suggestion.toString()),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                try {
                                  setState(() {
                                    this.lessonTimeDropContr.text =
                                        suggestion.toString();
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              },
                            ))
                      ],
                    )),
                Container(
                  width: Responsive.width(100, context),
                  margin: EdgeInsets.only(bottom: 2),
                  child: AutoSizeText('Booking Details',
                      style: inputLabelStyleWithBold(SizeConfig.labelFontSize)),
                ),
                Container(
                  width: Responsive.width(100, context),
                  color: Colors.grey[100],
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Responsive.width(100, context),
                        child: AutoSizeText('Vehicle Preference*',
                            style: inputLabelStyle(SizeConfig.labelFontSize)),
                      ),
                      Container(
                        width: Responsive.width(100, context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: Responsive.width(30, context),
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  return Row(
                                    children: [
                                      Container(
                                          width: constraints.maxWidth * 0.3,
                                          height:
                                              4 * SizeConfig.blockSizeVertical,
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.all(0),
                                          child: Transform.scale(
                                            scale: .15 *
                                                SizeConfig.blockSizeVertical,
                                            child: Radio(
                                              value: 'own',
                                              groupValue: vehicle_preference,
                                              activeColor: Dark,
                                              onChanged: (val) {
                                                setState(() {
                                                  vehicle_preference =
                                                      val.toString();
                                                });
                                              },
                                            ),
                                          )),
                                      Container(
                                        width: constraints.maxWidth * 0.7,
                                        height:
                                            4 * SizeConfig.blockSizeVertical,
                                        alignment: Alignment.centerLeft,
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                                child: AutoSizeText('Own Car',
                                                    style: inputLabelStyleDark(
                                                        SizeConfig
                                                            .labelFontSize)));
                                          },
                                        ),
                                      )
                                    ],
                                  );
                                })),
                            Container(
                                width: Responsive.width(40, context),
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  return Row(
                                    children: [
                                      Container(
                                          width: constraints.maxWidth * 0.3,
                                          height:
                                              4 * SizeConfig.blockSizeVertical,
                                          alignment: Alignment.centerLeft,
                                          child: Transform.scale(
                                              scale: .15 *
                                                  SizeConfig.blockSizeVertical,
                                              child: Radio(
                                                value: 'instructor',
                                                groupValue: vehicle_preference,
                                                activeColor: Dark,
                                                onChanged: (val) {
                                                  setState(() {
                                                    vehicle_preference =
                                                        val.toString();
                                                  });
                                                },
                                              ))),
                                      Container(
                                        width: constraints.maxWidth * 0.7,
                                        height:
                                            4 * SizeConfig.blockSizeVertical,
                                        alignment: Alignment.centerLeft,
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width: constraints.maxWidth * 0.9,
                                              child: AutoSizeText(
                                                  'Instructor car',
                                                  style: inputLabelStyleDark(
                                                      SizeConfig
                                                          .labelFontSize)),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  );
                                })),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: Responsive.width(100, context),
                  color: Colors.grey[100],
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Responsive.width(100, context),
                        child: AutoSizeText('Car Type:',
                            style: inputLabelStyle(SizeConfig.labelFontSize)),
                      ),
                      Container(
                        width: Responsive.width(100, context),
                        margin: EdgeInsets.only(top: 3),
                        child: Row(
                          children: [
                            Container(
                                width: Responsive.width(30, context),
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  return Row(
                                    children: [
                                      Container(
                                          width: constraints.maxWidth * 0.3,
                                          height:
                                              4 * SizeConfig.blockSizeVertical,
                                          alignment: Alignment.centerLeft,
                                          child: Transform.scale(
                                            scale: .15 *
                                                SizeConfig.blockSizeVertical,
                                            child: Radio(
                                              value: 'manual',
                                              groupValue: carType,
                                              activeColor: Dark,
                                              onChanged: (val) {
                                                setState(() {
                                                  carType = val.toString();
                                                });
                                              },
                                            ),
                                          )),
                                      Container(
                                        width: constraints.maxWidth * 0.7,
                                        height:
                                            4 * SizeConfig.blockSizeVertical,
                                        alignment: Alignment.centerLeft,
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                                width:
                                                    constraints.maxWidth * 0.9,
                                                child: AutoSizeText('Manual',
                                                    style: inputLabelStyleDark(
                                                        SizeConfig
                                                            .labelFontSize)));
                                          },
                                        ),
                                      )
                                    ],
                                  );
                                })),
                            Container(
                                width: Responsive.width(40, context),
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  return Row(
                                    children: [
                                      Container(
                                          width: constraints.maxWidth * 0.3,
                                          height:
                                              4 * SizeConfig.blockSizeVertical,
                                          alignment: Alignment.centerLeft,
                                          child: Transform.scale(
                                            scale: .15 *
                                                SizeConfig.blockSizeVertical,
                                            child: Radio(
                                              value: 'automatic',
                                              groupValue: carType,
                                              activeColor: Dark,
                                              onChanged: (val) {
                                                setState(() {
                                                  carType = val.toString();
                                                });
                                              },
                                            ),
                                          )),
                                      Container(
                                        width: constraints.maxWidth * 0.7,
                                        height:
                                            4 * SizeConfig.blockSizeVertical,
                                        alignment: Alignment.centerLeft,
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                                width:
                                                    constraints.maxWidth * 0.9,
                                                child: AutoSizeText('Automatic',
                                                    style: inputLabelStyleDark(
                                                        SizeConfig
                                                            .labelFontSize)));
                                          },
                                        ),
                                      )
                                    ],
                                  );
                                })),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: Responsive.width(100, context),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: AutoSizeText("Postcode Search:",
                              style: inputLabelStyle(SizeConfig.labelFontSize),
                              textAlign: TextAlign.left),
                        ),
                        GestureDetector(
                          onTap: _handlePressButton,
                          child: Container(
                            width: Responsive.width(100, context),
                            height: SizeConfig.inputHeight,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                            decoration: textAreaBorderLikeAsInput(),
                            child: AutoSizeText(
                              _address != null ? _address : '',
                              style: TextStyle(
                                  fontSize: SizeConfig.inputFontSize,
                                  color: Colors.blueGrey),
                            ),
                          ),
                        )
                      ],
                    )),
                Container(
                    width: Responsive.width(100, context),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: AutoSizeText("Address Line One*",
                              style: inputLabelStyle(SizeConfig.labelFontSize),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                            width: Responsive.width(100, context),
                            height: SizeConfig.inputHeight,
                            child: TextField(
                              controller: address_line_1,
                              style: inputTextStyle(SizeConfig.inputFontSize),
                              decoration: InputDecoration(
                                focusedBorder: inputFocusedBorderStyle(),
                                enabledBorder: inputBorderStyle(),
                                hintStyle:
                                    placeholderStyle(SizeConfig.labelFontSize),
                                contentPadding:
                                    EdgeInsets.fromLTRB(5, 0, 3, 16),
                              ),
                            ))
                      ],
                    )),
                Container(
                    width: Responsive.width(100, context),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: AutoSizeText("Address Line two",
                              style: inputLabelStyle(SizeConfig.labelFontSize),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                            width: Responsive.width(100, context),
                            height: SizeConfig.inputHeight,
                            child: TextField(
                              controller: address_line_2,
                              style: inputTextStyle(SizeConfig.inputFontSize),
                              decoration: InputDecoration(
                                focusedBorder: inputFocusedBorderStyle(),
                                enabledBorder: inputBorderStyle(),
                                hintStyle:
                                    placeholderStyle(SizeConfig.labelFontSize),
                                contentPadding:
                                    EdgeInsets.fromLTRB(5, 0, 3, 16),
                              ),
                            ))
                      ],
                    )),
                Container(
                    width: Responsive.width(100, context),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: AutoSizeText("Town*",
                              style: inputLabelStyle(SizeConfig.labelFontSize),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                            width: Responsive.width(100, context),
                            height: SizeConfig.inputHeight,
                            child: TextField(
                              controller: town,
                              style: inputTextStyle(SizeConfig.inputFontSize),
                              decoration: InputDecoration(
                                focusedBorder: inputFocusedBorderStyle(),
                                enabledBorder: inputBorderStyle(),
                                hintStyle:
                                    placeholderStyle(SizeConfig.labelFontSize),
                                contentPadding:
                                    EdgeInsets.fromLTRB(5, 0, 3, 16),
                              ),
                            ))
                      ],
                    )),
                Container(
                    width: Responsive.width(100, context),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: AutoSizeText("Postcode*",
                              style: inputLabelStyle(SizeConfig.labelFontSize),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                            width: Responsive.width(100, context),
                            height: SizeConfig.inputHeight,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                            decoration: textAreaBorderLikeAsInput(),
                            child: AutoSizeText(
                                postcode != null ? postcode : '',
                                style:
                                    inputTextStyle(SizeConfig.inputFontSize)))
                      ],
                    )),
                Container(
                    width: Responsive.width(100, context),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: AutoSizeText("Country",
                              style: inputLabelStyle(SizeConfig.labelFontSize),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                            width: Responsive.width(100, context),
                            height: SizeConfig.inputHeight,
                            child: TextField(
                              controller: country,
                              style: inputTextStyle(SizeConfig.inputFontSize),
                              decoration: InputDecoration(
                                focusedBorder: inputFocusedBorderStyle(),
                                enabledBorder: inputBorderStyle(),
                                hintStyle:
                                    placeholderStyle(SizeConfig.labelFontSize),
                                contentPadding:
                                    EdgeInsets.fromLTRB(5, 0, 3, 16),
                              ),
                            ))
                      ],
                    )),
              ],
            ),
          ),
        )));
  }

  Widget learnerDetailsStep(BuildContext context, BoxConstraints constraints) {
    return (Container(
        width: Responsive.width(90, context),
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.fromLTRB(0.0, 0, 0.0, 0.0),
        child: Container(
          width: Responsive.width(100, context),
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: MCard.Card(
            margin: EdgeInsets.all(0.0),
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    width: Responsive.width(100, context),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: AutoSizeText("First Name*",
                              style: inputLabelStyle(SizeConfig.labelFontSize),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                            width: Responsive.width(100, context),
                            height: SizeConfig.inputHeight,
                            child: TextField(
                                controller: first_name,
                                style: inputTextStyle(SizeConfig.inputFontSize),
                                decoration: InputDecoration(
                                  focusedBorder: inputFocusedBorderStyle(),
                                  enabledBorder: inputBorderStyle(),
                                  hintStyle: placeholderStyle(
                                      SizeConfig.labelFontSize),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(5, 0, 3, 16),
                                ),
                                keyboardType: TextInputType.text,
                                onChanged: (value) {}))
                      ],
                    )),
                Container(
                    width: Responsive.width(100, context),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: AutoSizeText("Last Name*",
                              style: inputLabelStyle(SizeConfig.labelFontSize),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                            width: Responsive.width(100, context),
                            height: SizeConfig.inputHeight,
                            child: TextField(
                                controller: last_name,
                                style: inputTextStyle(SizeConfig.inputFontSize),
                                decoration: InputDecoration(
                                  focusedBorder: inputFocusedBorderStyle(),
                                  enabledBorder: inputBorderStyle(),
                                  hintStyle: placeholderStyle(
                                      SizeConfig.labelFontSize),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(5, 0, 3, 16),
                                ),
                                keyboardType: TextInputType.text,
                                onChanged: (value) {}))
                      ],
                    )),
                Container(
                    width: Responsive.width(100, context),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: AutoSizeText("Email*",
                              style: inputLabelStyle(SizeConfig.labelFontSize),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                            width: Responsive.width(100, context),
                            height: SizeConfig.inputHeight,
                            child: TextField(
                                controller: email,
                                style: inputTextStyle(SizeConfig.inputFontSize),
                                decoration: InputDecoration(
                                  focusedBorder: inputFocusedBorderStyle(),
                                  enabledBorder: inputBorderStyle(),
                                  hintStyle: placeholderStyle(
                                      SizeConfig.labelFontSize),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(5, 0, 3, 16),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {}))
                      ],
                    )),
                Container(
                    width: Responsive.width(100, context),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: AutoSizeText("Phone*",
                              style: inputLabelStyle(SizeConfig.labelFontSize),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                            width: Responsive.width(100, context),
                            height: SizeConfig.inputHeight,
                            child: TextField(
                                controller: phone,
                                style: inputTextStyle(SizeConfig.inputFontSize),
                                decoration: InputDecoration(
                                  focusedBorder: inputFocusedBorderStyle(),
                                  enabledBorder: inputBorderStyle(),
                                  hintStyle: placeholderStyle(
                                      SizeConfig.labelFontSize),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(5, 0, 3, 16),
                                ),
                                keyboardType: TextInputType.phone,
                                onChanged: (value) {}))
                      ],
                    )),
                Container(
                    width: Responsive.width(100, context),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: AutoSizeText("Date of Birth*",
                              style: inputLabelStyle(SizeConfig.labelFontSize),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                          width: Responsive.width(100, context),
                          height: SizeConfig.inputHeight,
                          child: DateTimeField(
                              controller: this.birth_date_picker,
                              textAlign: TextAlign.left,
                              format: DateFormat('dd-MM-yyyy'),
                              readOnly: true,
                              style: inputTextStyle(SizeConfig.inputFontSize),
                              decoration: InputDecoration(
                                hintText: "DD-MM-YYY",
                                hintStyle:
                                    placeholderStyle(SizeConfig.labelFontSize),
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
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  Dark, // button text color
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                    firstDate: DateTime(1930, 1, 1),
                                    initialDate:
                                        currentValue ?? DateTime(2000, 6, 16),
                                    lastDate: DateTime(2030, 12, 30));
                              },
                              onChanged: (DateTime? selected_date) {
                                try {
                                  age = calculateAge(selected_date!);
                                  this.birth_date_picker.text =
                                      (selected_date.day).toString() +
                                          "-" +
                                          (selected_date.month).toString() +
                                          "-" +
                                          (selected_date.year).toString();
                                } catch (e) {}
                              }),
                        )
                      ],
                    )),
                Container(
                    width: Responsive.width(100, context),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: AutoSizeText(
                              "Number of driving lessons taken so far*",
                              style: inputLabelStyle(SizeConfig.labelFontSize),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                            width: Responsive.width(100, context),
                            height: SizeConfig.inputHeight,
                            child: TypeAheadField(
                              debounceDuration: Duration(milliseconds: 0),
                              animationDuration: Duration(milliseconds: 0),
                              hideKeyboard: true,
                              textFieldConfiguration: TextFieldConfiguration(
                                  textAlign: TextAlign.left,
                                  controller: this.lesson_taken_beforeDropCtrl,
                                  style:
                                      inputTextStyle(SizeConfig.inputFontSize),
                                  decoration: InputDecoration(
                                    focusedBorder: inputFocusedBorderStyle(),
                                    enabledBorder: inputBorderStyle(),
                                    hintText: '--Select--',
                                    hintStyle: placeholderStyle(
                                        SizeConfig.labelFontSize),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(5, 10, 3, 10),
                                  )),
                              suggestionsBoxDecoration:
                                  SuggestionsBoxDecoration(
                                      elevation: 5,
                                      constraints:
                                          BoxConstraints(maxHeight: 250)),
                              suggestionsCallback: (pattern) async {
                                return driving_lesson_no_list;
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: AutoSizeText(suggestion.toString()),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                try {
                                  setState(() {
                                    this.lesson_taken_beforeDropCtrl.text =
                                        suggestion.toString();
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              },
                            ))
                      ],
                    )),
                Container(
                    width: Responsive.width(100, context),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: AutoSizeText("Provisional License No*",
                              style: inputLabelStyle(SizeConfig.labelFontSize),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                            width: Responsive.width(100, context),
                            height: SizeConfig.inputHeight,
                            child: TextField(
                                controller: learner_license_no,
                                style: inputTextStyle(SizeConfig.inputFontSize),
                                decoration: InputDecoration(
                                  focusedBorder: inputFocusedBorderStyle(),
                                  enabledBorder: inputBorderStyle(),
                                  hintStyle: placeholderStyle(
                                      SizeConfig.labelFontSize),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(5, 0, 3, 16),
                                ),
                                onChanged: (value) {}))
                      ],
                    )),
                Container(
                    width: Responsive.width(100, context),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: AutoSizeText("License Expiry*",
                              style: inputLabelStyle(SizeConfig.labelFontSize),
                              textAlign: TextAlign.left),
                        ),
                        Container(
                          width: Responsive.width(100, context),
                          height: SizeConfig.inputHeight,
                          child: DateTimeField(
                              controller: this.license_expiry_date_picker,
                              textAlign: TextAlign.left,
                              format: DateFormat('dd-MM-yyyy'),
                              readOnly: true,
                              style: inputTextStyle(SizeConfig.inputFontSize),
                              decoration: InputDecoration(
                                hintText: "DD-MM-YYY",
                                hintStyle:
                                    placeholderStyle(SizeConfig.labelFontSize),
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
                                          textButtonTheme: TextButtonThemeData(
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
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(
                                        DateTime.now().year + 30, 12, 31));
                              },
                              onChanged: (DateTime? selected_date) {
                                try {
                                  this.license_expiry_date_picker.text =
                                      (selected_date!.day).toString() +
                                          "-" +
                                          (selected_date.month).toString() +
                                          "-" +
                                          (selected_date.year).toString();
                                } catch (e) {}
                              }),
                        )
                      ],
                    )),
                Container(
                  width: Responsive.width(100, context),
                  margin: EdgeInsets.only(bottom: 0),
                  child: AutoSizeText('License Image Upload',
                      style: inputLabelStyle(SizeConfig.labelFontSize)),
                ),
                Container(
                    width: Responsive.width(100, context),
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        if (licence != null || licenceHttpPath != null)
                          Container(
                              width: 30 * SizeConfig.blockSizeVertical,
                              height: 30 * SizeConfig.blockSizeVertical,
                              // alignment: Alignment(0, -Responsive.width(.1, context)),
                              child: Stack(
                                children: [
                                  Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0,
                                          2 * SizeConfig.blockSizeVertical,
                                          0,
                                          0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              PageRouteBuilder(
                                                  opaque: false,
                                                  pageBuilder: (BuildContext
                                                              context,
                                                          _,
                                                          __) =>
                                                      ZoomView(
                                                          licenceHttpPath !=
                                                                  null
                                                              ? licenceHttpPath!
                                                              : licence!.path,
                                                          licenceHttpPath !=
                                                                  null
                                                              ? 'http'
                                                              : 'file')));
                                        },
                                        child: licenceHttpPath != null
                                            ? FadeInImage.assetNetwork(
                                                width: 20 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                height: 20 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                fit: BoxFit.cover,
                                                placeholder:
                                                    'assets/spinner.gif',
                                                image: licenceHttpPath!,
                                                imageErrorBuilder:
                                                    (context, url, error) =>
                                                        Container(
                                                  child: Column(
                                                    children: [
                                                      new Icon(Icons.error,
                                                          color: Colors.grey,
                                                          size: 5 *
                                                              SizeConfig
                                                                  .blockSizeVertical),
                                                      Text(
                                                        "Image not found!",
                                                        style: TextStyle(
                                                            fontSize: 2 *
                                                                SizeConfig
                                                                    .blockSizeVertical,
                                                            color: Colors
                                                                .redAccent),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Image.file(File(licence!.path),
                                                width: 20 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                height: 20 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                fit: BoxFit.cover),
                                      )),
                                  Positioned(
                                    top: -Responsive.width(1, context),
                                    right: Responsive.width(12, context),
                                    child: IconButton(
                                      icon: Icon(Icons.remove_circle),
                                      iconSize: 30,
                                      color: Colors.red,
                                      onPressed: () => {
                                        this.setState(() {
                                          licence = null;
                                          licenceHttpPath = null;
                                          licenceBase64 = "";
                                        })
                                      },
                                    ),
                                  )
                                ],
                              )),
                        if (licence == null && licenceHttpPath == null)
                          Container(
                            child: IconButton(
                              icon: Icon(Icons.camera_alt),
                              iconSize: 5 * SizeConfig.blockSizeVertical,
                              color: Colors.blue,
                              tooltip: 'Add Image By Camera',
                              onPressed: _openCamera,
                            ),
                          ),
                        if (licence == null && licenceHttpPath == null)
                          Container(
                            child: IconButton(
                              icon: Icon(Icons.folder_open),
                              iconSize: 5 * SizeConfig.blockSizeVertical,
                              color: Colors.blue,
                              tooltip: 'Add Image/File By Gallery',
                              onPressed: _openGallery,
                            ),
                          ),
                      ],
                    )),
              ],
            ),
          ),
        )));
  }

  Widget paymentStep(BuildContext context) {
    return (Container(
        width: Responsive.width(90, context),
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.fromLTRB(0.0, 0, 0.0, 0.0),
        child: Container(
          width: Responsive.width(100, context),
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: MCard.Card(
            margin: EdgeInsets.all(0.0),
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: Responsive.width(100, context),
                  margin: EdgeInsets.only(bottom: 5),
                  child: AutoSizeText('Total Cost: £' + displayCost,
                      style: inputLabelStyleDark(SizeConfig.labelFontSize)),
                ),
                Container(
                    width: Responsive.width(100, context),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(
                      children: [
                        Container(
                            width: Responsive.width(100, context),
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                            child: Row(
                              children: [
                                Container(
                                    alignment: Alignment.centerLeft,
                                    width: Responsive.width(30, context),
                                    child: AutoSizeText("Discount Code",
                                        style: inputLabelStyle(
                                            SizeConfig.labelFontSize),
                                        textAlign: TextAlign.left)),
                                if (discountApplied >= 0)
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: Responsive.width(47, context),
                                    child: AutoSizeText(discountAppliedMessage,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: discountApplied == 0
                                                ? Colors.redAccent
                                                : Colors.green,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.left),
                                  )
                              ],
                            )),
                        Container(
                            width: Responsive.width(100, context),
                            height: SizeConfig.inputHeight,
                            child: TextField(
                                controller: discount_code,
                                style: inputTextStyle(SizeConfig.inputFontSize),
                                decoration: InputDecoration(
                                  focusedBorder: inputFocusedBorderStyle(),
                                  enabledBorder: inputBorderStyle(),
                                  hintStyle: placeholderStyle(
                                      SizeConfig.labelFontSize),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(5, 0, 3, 16),
                                ),
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  setState(() {
                                    discountAppliedMessage = '';
                                  });
                                })),
                        Container(
                            width: Responsive.width(100, context),
                            alignment: Alignment.centerRight,
                            child: ButtonTheme(
                                minWidth: 100,
                                height: 5 * SizeConfig.blockSizeVertical,
                                child: ElevatedButton(
                                  child: AutoSizeText(
                                    'Apply',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            2 * SizeConfig.blockSizeVertical),
                                  ),
                                  onPressed: (discount_code.text.trim() == '')
                                      ? null
                                      : () {
                                          Map<String, String> params = {
                                            'discount_code': discount_code.text,
                                            'actual_value': cost.text,
                                            'type': 'lesson',
                                            'user_id': _userId.toString()
                                          };
                                          showLoader("Discount applying...");
                                          applyDiscountCodeApi(params)
                                              .then((response) {
                                            closeLoader();
                                            Color backgroundColor_;
                                            if (response['success'] == true) {
                                              backgroundColor_ =
                                                  Colors.lightGreenAccent;
                                              discountApplied = 1;
                                              setState(() {
                                                print(response['data']
                                                        ["new_cost"]
                                                    .runtimeType);
                                                if (response['data']["new_cost"]
                                                        .runtimeType ==
                                                    int) {
                                                  discounted_cost =
                                                      double.parse(
                                                          response['data']
                                                                  ["new_cost"]
                                                              .toString());
                                                } else {
                                                  discounted_cost =
                                                      response['data']
                                                          ["new_cost"];
                                                }

                                                print(discounted_cost
                                                    .runtimeType);
                                                displayCost = (discounted_cost)
                                                    .toStringAsFixed(2);
                                              });
                                            } else {
                                              backgroundColor_ =
                                                  Colors.redAccent;
                                              discountApplied = 0;
                                            }
                                            setState(() {
                                              discountAppliedMessage =
                                                  response['message'];
                                            });
                                          });
                                        },
                                )))
                      ],
                    )),
                Container(
                  width: Responsive.width(100, context),
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 5),
                  child: AutoSizeText("I'm aware that",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 2 * SizeConfig.blockSizeVertical)),
                ),
                Container(
                    width: Responsive.width(100, context),
                    child: Column(
                      children: [
                        ListTile(
                            leading: Container(
                                child: Icon(Icons.circle,
                                    size: 1.3 * SizeConfig.blockSizeVertical,
                                    color: Colors.black),
                                padding: EdgeInsets.only(right: 10)),
                            title: AutoSizeText(
                                "My personal data will be stored securely on Mock Driving Test servers (Mock Driving test uses end to end encryption to secure data in transit and at rest)",
                                style: TextStyle(
                                    fontSize: 2 * SizeConfig.blockSizeVertical,
                                    color: Colors.black)),
                            horizontalTitleGap: 0,
                            minLeadingWidth: 15,
                            minVerticalPadding: 5),
                        ListTile(
                            leading: Container(
                                child: Icon(Icons.circle,
                                    size: 1.3 * SizeConfig.blockSizeVertical,
                                    color: Colors.black),
                                padding: EdgeInsets.only(right: 10)),
                            title: AutoSizeText(
                                "My test results will be used for preparing stastics to evaluate success of the site but no one will be able to identify me through the stats",
                                style: TextStyle(
                                    fontSize: 2 * SizeConfig.blockSizeVertical,
                                    color: Colors.black)),
                            horizontalTitleGap: 0,
                            minLeadingWidth: 15,
                            minVerticalPadding: 5),
                        ListTile(
                            leading: Container(
                                child: Icon(Icons.circle,
                                    size: 1.3 * SizeConfig.blockSizeVertical,
                                    color: Colors.black),
                                padding: EdgeInsets.only(right: 10)),
                            title: AutoSizeText(
                                "Mock Driving Test are happy to provide me all the data they hold about me within 7 days of me requesting them for it I accept the privacy policy",
                                style: TextStyle(
                                    fontSize: 2 * SizeConfig.blockSizeVertical,
                                    color: Colors.black)),
                            horizontalTitleGap: 0,
                            minLeadingWidth: 15,
                            minVerticalPadding: 5),
                        ListTile(
                            leading: Container(
                                child: Icon(Icons.circle,
                                    size: 1.3 * SizeConfig.blockSizeVertical,
                                    color: Colors.black),
                                padding: EdgeInsets.only(right: 10)),
                            title: AutoSizeText(
                                "The Requested Date and Time may change in regards to the availabilty of an ADI.",
                                style: TextStyle(
                                    fontSize: 2 * SizeConfig.blockSizeVertical,
                                    color: Colors.black)),
                            horizontalTitleGap: 0,
                            minLeadingWidth: 15,
                            minVerticalPadding: 5),
                      ],
                    )),
                Container(
                  width: Responsive.width(100, context),
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 5),
                  child: AutoSizeText("I hereby agree that",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 2 * SizeConfig.blockSizeVertical,
                      )),
                ),
                Container(
                    width: Responsive.width(100, context),
                    child: Column(
                      children: [
                        ListTile(
                            horizontalTitleGap: 0,
                            contentPadding: EdgeInsets.only(bottom: 5),
                            leading: Container(
                                width: 5 * SizeConfig.blockSizeVertical,
                                child: Transform.scale(
                                    scale: .15 * SizeConfig.blockSizeVertical,
                                    child: Checkbox(
                                      checkColor: Colors.white,
                                      activeColor: Colors.blue,
                                      value: hearby_agreey_1,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          hearby_agreey_1 = value!;
                                        });
                                      },
                                    ))),
                            title: AutoSizeText(
                                "I will hold a valid provisional UK driving license or full license from a foreign country when I take a lesson/ mock-test.",
                                style: TextStyle(
                                    fontSize: 2 * SizeConfig.blockSizeVertical,
                                    color: Colors.blue))),
                        ListTile(
                            horizontalTitleGap: 0,
                            contentPadding: EdgeInsets.only(bottom: 5),
                            leading: Container(
                                width: 5 * SizeConfig.blockSizeVertical,
                                child: Transform.scale(
                                  scale: .15 * SizeConfig.blockSizeVertical,
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: Colors.blue,
                                    value: hearby_agreey_2,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        hearby_agreey_2 = value!;
                                      });
                                    },
                                  ),
                                )),
                            title: AutoSizeText(
                                "I am aware that I will lose the booking fee if I cancel a lesson/ mock-test within 48 hours of the scheduled time.",
                                style: TextStyle(
                                    fontSize: 2 * SizeConfig.blockSizeVertical,
                                    color: Colors.blue))),
                        ListTile(
                            horizontalTitleGap: 0,
                            contentPadding: EdgeInsets.only(bottom: 5),
                            leading: Container(
                                width: 5 * SizeConfig.blockSizeVertical,
                                child: Transform.scale(
                                  scale: .15 * SizeConfig.blockSizeVertical,
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: Colors.blue,
                                    value: hearby_agreey_3,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        hearby_agreey_3 = value!;
                                      });
                                    },
                                  ),
                                )),
                            title: AutoSizeText(
                                "I agree to the Terms and Conditions set by Mock Driving Test.",
                                style: TextStyle(
                                    fontSize: 2 * SizeConfig.blockSizeVertical,
                                    color: Colors.blue))),
                      ],
                    )),
              ],
            ),
          ),
        )));
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
            // this will take space as minimum as posible(to center)
            children: <Widget>[
              if (this.current_step > 0)
                Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: ButtonTheme(
                      minWidth: Responsive.width(25, context),
                      height: Responsive.height(4, context),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Dark)),
                        child: AutoSizeText(
                          'Previous',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 2 * SizeConfig.blockSizeVertical,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            if (this.current_step > 0) {
                              this.current_step = this.current_step - 1;
                              _multiStepperWidget.currentState!
                                  .changeStep(this.current_step);
                              try {
                                list_view_scrollCtrl.jumpTo(0);
                              } catch (e) {}
                            }
                          });
                        },
                      ),
                    )),
              if (this.current_step < 2)
                Container(
                  margin: EdgeInsets.fromLTRB(Responsive.width(2, context), 0,
                      Responsive.width(2, context), 0),
                  alignment: Alignment.center,
                  child: ButtonTheme(
                    minWidth: Responsive.width(20, context),
                    height: Responsive.height(4, context),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Dark)),
                      child: AutoSizeText(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 2 * SizeConfig.blockSizeVertical,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (this.current_step < 2) {
                            if ((this.current_step == 0 && !validateStep_1()) ||
                                (this.current_step == 1 && !validateStep_2())) {
                              if (age < 16) {
                                Toast.show(
                                    "You must be above 16 to book lesson",
                                    // textStyle: context,
                                    duration: Toast.lengthLong,
                                    gravity: Toast.bottom);
                              } else {
                                Toast.show(
                                    "Please filled all required(*) field.",
                                    // textStyle: context,
                                    duration: Toast.lengthLong,
                                    gravity: Toast.bottom);
                              }
                            } else {
                              setState(() {
                                this.current_step = this.current_step + 1;
                                _multiStepperWidget.currentState!
                                    .changeStep(this.current_step);
                                try {
                                  list_view_scrollCtrl.jumpTo(0);
                                } catch (e) {}
                              });
                            }
                          }
                        });
                      },
                    ),
                  ),
                ),
              if (this.current_step == 2)
                Container(
                  margin: EdgeInsets.fromLTRB(
                      Responsive.width(2, context), 0, 0, 0),
                  child: ButtonTheme(
                    minWidth: Responsive.width(25, context),
                    height: Responsive.height(4, context),
                    buttonColor: Color(0xFFed1c24),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Dark)),
                      child: AutoSizeText(
                        'Pay Now',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 2 * SizeConfig.blockSizeVertical),
                      ),
                      onPressed: () {
                        bookLessonPayHandler("pay_now");
                      },
                    ),
                  ),
                ),
              // if (this.current_step == 2)
              //   Container(
              //     margin: EdgeInsets.fromLTRB(Responsive.width(2, context), 0,
              //         Responsive.width(2, context), 0),
              //     child: ButtonTheme(
              //       minWidth: Responsive.width(25, context),
              //       height: Responsive.height(6, context),
              //       child: RaisedButton(
              //         color: Color(0xFFed1c24),
              //         elevation: 0,
              //         child: AutoSizeText(
              //           'Pay Later',
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 2 * SizeConfig.blockSizeVertical),
              //         ),
              //         onPressed: () {
              //           bookLessonPayHandler(
              //             "pay_later",
              //           );
              //         },
              //       ),
              //     ),
              //   ),
            ],
          ),
        )
      ],
    ));
  }

  bookLessonPayHandler(String payType) {
    if (hearby_agreey_1 == false ||
        hearby_agreey_2 == false ||
        hearby_agreey_3 == false) {
      Toast.show("Please select agreement terms.",
          // textStyle: context,
          duration: Toast.lengthLong,
          gravity: Toast.bottom);
    } else {
      Map<String, String> requestForm = {
        'id': _userId.toString(),
        'user_type': "2",
        'course_name': course_id,
        'requested_date': lesson_date_picker.text,
        'test_time': lessonTimeDropContr.text == "Any Time"
            ? 'any_time'
            : lessonTimeDropContr.text,
        'location': this._addressController.text.isEmpty &&
                this.address_line_1.text.isEmpty
            ? ''
            : '${this.address_line_1.text},${this._addressController.text}',
        'vehicle_preference': vehicle_preference,
        'carType': carType,
        'address_line_1':
            address_line_1.text.isEmpty ? '' : address_line_1.text,
        'address_line_2':
            address_line_2.text.isEmpty ? '' : address_line_2.text,
        'town': town.text.isEmpty ? '' : town.text,
        'postcode': postcode.isEmpty ? '' : postcode,
        'country': country.text.isEmpty ? '' : country.text,
        'phone': phone.text.isEmpty ? '' : phone.text,
        'birth_date':
            birth_date_picker.text.isEmpty ? '' : birth_date_picker.text,
        // 'first_name': first_name.text == null ? '' : first_name.text,
        // 'last_name': last_name.text == null ? '' : last_name.text,
        //'email': email.text == null ? '' : email.text,
        'lesson_taken_before': lesson_taken_beforeDropCtrl.text.isEmpty
            ? ''
            : lesson_taken_beforeDropCtrl.text,
        'learner_license_no':
            learner_license_no.text.isEmpty ? '' : learner_license_no.text,
        'user_license_expiry': license_expiry_date_picker.text.isEmpty
            ? ''
            : license_expiry_date_picker.text,
        'license_photo': licenceBase64,
        'cost': discounted_cost.toString(),
        'orignal_cost': cost.text.isEmpty ? '' : cost.text,
        'discount_code': discount_code.text.isEmpty ? '' : discount_code.text,
        //'discounted_cost':discounted_cost.toString()
      };
      showLoader("Course Submitting...");
      postBookLessonApiCall(requestForm).then((response) {
        closeLoader();
        Toast.show(response!["message"],
            //  textStyle: context,
            duration: Toast.lengthLong,
            gravity: Toast.bottom);
        if (response['success'] == true && payType == "pay_now") {
          try {
            Map params = {
              'id': _userId.toString(),
              'user_type': "2",
              'lesson_master_id':
                  response['data']['lesson_master_id'].toString(),
              'batch_hash': response['data']['batch_hash'].toString(),
              'lesson_type': 'book_lesson',
              'total_cost': displayCost,
              'parentPageName': "Lesson"
            };
            Stripe.publishableKey = stripePublic;
            showLoader("Processing...");
            _paymentService
                .makePayment(
                    amount: displayCost,
                    currency: 'GBP',
                    desc:
                        'Lesson-${this.first_name.text} ${this.last_name.text}-${this.lesson_date_picker.text}-${this.postcode}',
                    context: context,
                    metaData: params)
                .then((value) => closeLoader());
          } catch (e) {
            print(e);
            Toast.show('Failed request! please try again.',
                // textStyle: context,
                duration: Toast.lengthLong,
                gravity: Toast.bottom);
          }
        } else {
          // _navigationService.navigateToReplacement(routes.MyBookingRoute);
        }
      }).catchError((onError) => closeLoader());
    }
  }

  bool validateStep_1() {
    if (this.course_nameDropContr.text.trim() == "")
      return false;
    else if (this.lesson_date_picker.text.trim() == "")
      return false;
    else if (this.lessonTimeDropContr.text.trim() == "")
      return false;
    else if (this.address_line_1.text.trim() == "")
      return false;
    else if (this.town.text.trim() == "")
      return false;
    else if (postcode.trim() == "")
      return false;
    else
      return true;
  }

  bool validateStep_2() {
    if (first_name.text.trim() == "")
      return false;
    else if (last_name.text.trim() == "")
      return false;
    else if (email.text.trim() == "")
      return false;
    else if (phone.text.trim() == "")
      return false;
    else if (birth_date_picker.text.trim() == "" || age < 16)
      return false;
    else if (lesson_taken_beforeDropCtrl.text.trim() == "")
      return false;
    else if (learner_license_no.text.trim() == "")
      return false;
    else if (license_expiry_date_picker.text.trim() == "")
      return false;
    else
      return true;
  }

  void _openGallery() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    final bytes = Io.File(pickedFile!.path).readAsBytesSync();
    String base64_ = base64Encode(bytes, getImageExtension(pickedFile.path));
    //print("File path Gallery...$base64_");
    this.setState(() {
      licenceBase64 = base64_;
      licence = File(pickedFile.path);
    });
  }

  void _openCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    final bytes = Io.File(pickedFile!.path).readAsBytesSync();
    String base64_ = base64Encode(bytes, getImageExtension(pickedFile.path));
    //print("File path Camers...$base64_");
    this.setState(() {
      licenceBase64 = base64_;
      licence = File(pickedFile.path);
    });
  }

  void showLoader(String message) {
    CustomSpinner.showLoadingDialog(context, _keyLoader, message);
  }

  void closeLoader() {
    try {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    } catch (e) {}
  }

  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  //Call APi Services
  Future<Map> getUserDetail() async {
    Map response =
        await Provider.of<AuthProvider>(context, listen: false).getUserData();
    licenceHttpPath = response['img_url'];
    _userId = response['id'];
    return response;
  }

  //call api for getAddress
  Future<void> getAddressInfo(BuildContext page_context) async {
    Map<String, String> params = {
      // "postcode": addressInfo!['postcode'],
      "car_type": this.carType,
      "vehicle_preference": this.vehicle_preference,
      "type": "lesson",
      "course_id": this.course_id
    };
    if (course_id == '') {
      setState(() {
        addressSuggestion = '';
      });
      closeLoader();
      Toast.show("Please select course type!",
          // textStyle: context,
          duration: Toast.lengthLong,
          gravity: Toast.bottom);
    } else {
      getDynamicRateApiCall(params).then((dynamicRateResponse) {
        if (dynamicRateResponse['success'] == true) {
          setState(() {
            if (dynamicRateResponse['data']['max_adi_rate'] is double ||
                dynamicRateResponse['data']['max_adi_rate'] is int)
              this.cost.text =
                  (dynamicRateResponse['data']['max_adi_rate']).toString();
            else
              this.cost.text = dynamicRateResponse['data']['max_adi_rate'];
            displayCost = this.cost.text;
            closeLoader();
          });
        } else {
          closeLoader();
          setState(() {
            addressSuggestion = "";
            this.address_line_1.text = "";
            this.address_line_2.text = "";
            this.town.text = "";
            postcode = "";
            this.country.text = "";
          });
          alertToShowAdiNotFound(page_context);
        }
      });
    }
  }

  //call api for check adi and dynamic rate
  Future<Map> getDynamicRateApiCall(Map params) async {
    Map dynamicRateResponse = await _bookingService.getDynamicRate(params);
    return dynamicRateResponse;
  }

  //call api for apply discount-code
  Future<Map> applyDiscountCodeApi(Map params) async {
    Map dynamicRateResponse = await _bookingService.applyDiscountCode(params);
    return dynamicRateResponse;
  }

  //call api for save form data
  Future<Map?> postBookLessonApiCall(Map<String, String> params) async {
    try {
      Map response = await _bookingService.postBookLesson(params);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
