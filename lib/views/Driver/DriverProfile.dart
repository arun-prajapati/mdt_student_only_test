import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' as Io;
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_app/Constants/app_colors.dart';
import 'package:student_app/utils/app_colors.dart';
import 'package:toast/toast.dart';

import '../../Constants/global.dart';
import '../../custom_button.dart';
import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/auth.dart';
import '../../services/booking_test.dart';
import '../../services/driver_profile_services.dart';
import '../../services/methods.dart';
import '../../services/navigation_service.dart';
import '../../style/global_style.dart';
import '../../widget/CustomAppBar.dart';
import '../../widget/CustomSpinner.dart';
import '../../widget/ImageZoomView/image_zoom_view.dart';

class DriverProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _driverProfile();
}

class _driverProfile extends State<DriverProfile> {
  final NavigationService _navigationService = locator<NavigationService>();
  final DriverProfileServices api_services = new DriverProfileServices();
  final BookingService _bookingService = new BookingService();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final UserProvider auth_services = new UserProvider();
  Mode _mode = Mode.overlay;
  String? addressSuggestion;
  TextEditingController? first_name,
      last_name,
      phone_number,
      address_line_1,
      address_line_2,
      town,
      license_no,
      license_exp_date,
      _addressController;
  String postcode = "";
  String _address = "Search Postcode";
  late int _userId;
  String carType = 'automatic';
  String vehiclePreference = 'instructor';
  File? license;
  String licenceBase64 = '';
  bool licenceBool = false;
  String? licenceHttpPath;

  // late GooglePlace googlePlace;
  // List<AutocompletePrediction> predictions = [];
  Timer? debounce;

  //Call APi Services
  Future<int> getUserDetail() async {
    Map response =
        await Provider.of<UserProvider>(context, listen: false).getUserData();
    _userId = response['id'];
    print('USER ID *************************  $_userId');
    print('USER ID *************************  ${response['user_type']}');
    return _userId;
  }

  //call api for getQuestions
  Future<Map> getProfileDetail() async {
    Map response = await api_services.getProfileDetail(2, _userId);
    return response;
  }

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
      town?.text = townName;
      postcode = postalCode;
      _address = detail.result.formattedAddress!;
    });
    if (street.length > 0) {
      String streetAdd = street.first.longName;
      log("Street Code : ${streetAdd}");
      setState(() {
        address_line_2?.text = streetAdd;
      });
    } else {
      setState(() {
        address_line_2?.text = "";
      });
    }

    log("Postal Code : ${postalCode}");
    log("Town name : ${townName}");
    log("Address Components : ${detail.result.addressComponents[1].toJson()}");
    log("-------------------------------------------------");
  }

  @override
  void initState() {
    super.initState();
    // googlePlace = GooglePlace(apiKey);
    Future.delayed(Duration.zero, () {
      this.initializeApi("Loading...");
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  initializeApi(String loaderMessage) {
    checkInternet();
    showLoader(loaderMessage);
    getUserDetail().then((user_id) {
      getProfileDetail().then((records) async {
        Map userProfileDetail = records;
        log("RECORDSSSS **************            $records");
        setState(() {});
        // setState(() {
        first_name = TextEditingController(
            text: checkForNull(userProfileDetail['first_name']));
        last_name = TextEditingController(
            text: checkForNull(userProfileDetail['last_name'] ?? ""));
        phone_number = TextEditingController(
            text: checkForNull(userProfileDetail['phone'] == null
                ? ''
                : userProfileDetail['phone'].contains("+44")
                    ? userProfileDetail['phone'].replaceAll("+44", "")
                    : userProfileDetail['phone'] ?? ""));
        //phone_number = TextEditingController(text: userProfileDetail['phone'] ?? '');
        print('USer Phone Number---------${userProfileDetail['phone']}');
        vehiclePreference =
            checkForNull(userProfileDetail['vehicle_preference'] ?? "");
        _address = userProfileDetail['address'] ?? "";
        address_line_1 = TextEditingController(
            text: checkForNull(userProfileDetail['address_line_1'] ?? ""));
        address_line_2 = TextEditingController(
            text: checkForNull(userProfileDetail['address_line_2'] ?? ""));
        town = TextEditingController(
            text: checkForNull(userProfileDetail['town'] ?? ""));
        postcode = checkForNull(userProfileDetail['postcode'] ?? "");
        license_no = TextEditingController(
            text: checkForNull(userProfileDetail['driver_license_no'] ?? ""));
        if (userProfileDetail['driver_license_expiry'] != null &&
            userProfileDetail['driver_license_expiry'] != "") {
          var dateOfLicenseExpire =
              userProfileDetail['driver_license_expiry'].split('-') ?? "";
          license_exp_date = TextEditingController(
              text: dateOfLicenseExpire[2] +
                  '-' +
                  dateOfLicenseExpire[1] +
                  '-' +
                  dateOfLicenseExpire[0]);
        }
        if (userProfileDetail['img_url']
            .toString()
            .split('.')
            .last
            .isNotEmpty) {
          licenceHttpPath = userProfileDetail['img_url'];
        } else {
          setState(() {
            licenceHttpPath = null;
          });
        }
        if (userProfileDetail['img_url'].toString().isNotEmpty) {
          // licenceBase64 = "${api}${userProfileDetail['img_url']}";
          // var pref = await SharedPreferences.getInstance();
          // var image = pref.getString("image");
          // licenceBase64 = image.toString();
          // final bytes = ;
          // String base64_ = base64Encode(bytes, getImageExtension(pickedFile.path));
          setState(() {});
          print('::::::::: $licenceBase64');
        }
      });

      closeLoader();
    });
    // });
  }

  String checkForNull(String text) {
    return text.isEmpty ? "" : text;
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
    SizeConfig().init(context);
    ToastContext().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          CustomAppBar(
            preferedHeight: Responsive.height(24, context),
            title: 'Profile',
            textWidth: Responsive.width(35, context),
            iconLeft: Icons.arrow_back,
            onTap1: () {
              _navigationService.goBack();
            },
            iconRight: null,
          ),
          Container(
            margin:
                EdgeInsets.fromLTRB(0, Responsive.height(14, context), 0, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              // border: BoxBorder(),
              // boxShadow: [
              //   BoxShadow(
              //       color: Color.fromRGBO(0, 0, 0, 1),
              //       offset: Offset(1, 2),
              //       blurRadius: 5.0)
              // ],
            ),
            // height: Responsive.height(84, context),
            padding: EdgeInsets.fromLTRB(3, 25, 3, 0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: constraints.maxWidth * 1,
                          height: constraints.maxHeight * .87,
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.fromLTRB(10, 2, 10, 0),
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("First Name",
                                      style: inputLabelStyle(
                                          SizeConfig.labelFontSize),
                                      textAlign: TextAlign.left),
                                  SizedBox(height: 8),
                                  TextField(
                                    controller: first_name,
                                    style: inputTextStyle(
                                        SizeConfig.inputFontSize),
                                    decoration: InputDecoration(
                                      focusedBorder: inputFocusedBorderStyle(),
                                      enabledBorder: inputBorderStyle(),
                                      hintStyle: placeholderStyle(
                                          SizeConfig.labelFontSize),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(5, 0, 3, 16),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text("Last Name",
                                      style: inputLabelStyle(
                                          SizeConfig.labelFontSize),
                                      textAlign: TextAlign.left),
                                  SizedBox(height: 8),
                                  TextField(
                                    controller: last_name,
                                    style: inputTextStyle(
                                        SizeConfig.inputFontSize),
                                    decoration: InputDecoration(
                                      focusedBorder: inputFocusedBorderStyle(),
                                      enabledBorder: inputBorderStyle(),
                                      hintStyle: placeholderStyle(
                                          SizeConfig.labelFontSize),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(5, 0, 3, 16),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text("Phone Number",
                                      style: inputLabelStyle(
                                          SizeConfig.labelFontSize),
                                      textAlign: TextAlign.left),
                                  SizedBox(height: 8),
                                  TextField(
                                    controller: phone_number,
                                    style: inputTextStyle(
                                        SizeConfig.inputFontSize),
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      focusedBorder: inputFocusedBorderStyle(),
                                      enabledBorder: inputBorderStyle(),
                                      hintStyle: placeholderStyle(
                                          SizeConfig.labelFontSize),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(5, 0, 3, 16),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text('Vehicle Preference',
                                      style: AppTextStyle.textStyle.copyWith(
                                          color: AppColors.grey,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    //crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 0,
                                        child: LayoutBuilder(
                                            builder: (context, constraints) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Transform.scale(
                                                scale: .15 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                child: Radio(
                                                  value: 'own',
                                                  groupValue: vehiclePreference,
                                                  activeColor: Dark,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      vehiclePreference =
                                                          val.toString();
                                                    });
                                                  },
                                                ),
                                              ),
                                              LayoutBuilder(
                                                builder:
                                                    (context, constraints) {
                                                  return Container(
                                                      child: AutoSizeText(
                                                          'Own Car',
                                                          style: inputLabelStyleDark(
                                                              SizeConfig
                                                                  .labelFontSize)));
                                                },
                                              )
                                            ],
                                          );
                                        }),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        flex: 0,
                                        child: LayoutBuilder(
                                            builder: (context, constraints) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Transform.scale(
                                                  scale: .15 *
                                                      SizeConfig
                                                          .blockSizeVertical,
                                                  child: Radio(
                                                    value: 'instructor',
                                                    groupValue:
                                                        vehiclePreference,
                                                    activeColor: Dark,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        vehiclePreference =
                                                            val.toString();
                                                      });
                                                    },
                                                  )),
                                              LayoutBuilder(
                                                builder:
                                                    (context, constraints) {
                                                  return AutoSizeText(
                                                      'Instructor car',
                                                      style: inputLabelStyleDark(
                                                          SizeConfig
                                                              .labelFontSize));
                                                },
                                              )
                                            ],
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text('Address:',
                                      style: AppTextStyle.textStyle.copyWith(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 8),
                                  Text(
                                    "Address Search",
                                    style: AppTextStyle.textStyle.copyWith(
                                        color: AppColors.grey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 8),
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
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Address Line One",
                                    style: AppTextStyle.textStyle.copyWith(
                                        color: AppColors.grey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 8),
                                  TextField(
                                    controller: address_line_1,
                                    style: inputTextStyle(
                                        SizeConfig.inputFontSize),
                                    decoration: InputDecoration(
                                      focusedBorder: inputFocusedBorderStyle(),
                                      enabledBorder: inputBorderStyle(),
                                      hintStyle: placeholderStyle(
                                          SizeConfig.labelFontSize),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(5, 0, 3, 16),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Address Line two",
                                    style: AppTextStyle.textStyle.copyWith(
                                        color: AppColors.grey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 8),
                                  TextField(
                                    controller: address_line_2,
                                    style: inputTextStyle(
                                        SizeConfig.inputFontSize),
                                    decoration: InputDecoration(
                                      focusedBorder: inputFocusedBorderStyle(),
                                      enabledBorder: inputBorderStyle(),
                                      hintStyle: placeholderStyle(
                                          SizeConfig.labelFontSize),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(5, 0, 3, 16),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text("Town",
                                      style: AppTextStyle.textStyle.copyWith(
                                          color: AppColors.grey,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 8),
                                  TextField(
                                    controller: town,
                                    style: inputTextStyle(
                                        SizeConfig.inputFontSize),
                                    decoration: InputDecoration(
                                      focusedBorder: inputFocusedBorderStyle(),
                                      enabledBorder: inputBorderStyle(),
                                      hintStyle: placeholderStyle(
                                          SizeConfig.labelFontSize),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(5, 0, 3, 16),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text("Postcode",
                                      style: AppTextStyle.textStyle.copyWith(
                                          color: AppColors.grey,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 8),
                                  Text(postcode != null ? postcode : '',
                                      style: inputTextStyle(
                                          SizeConfig.inputFontSize)),
                                  SizedBox(height: 8),
                                  Text('Learner License Details',
                                      style: AppTextStyle.textStyle.copyWith(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 8),
                                  Text("Provisional License No",
                                      style: AppTextStyle.textStyle.copyWith(
                                          color: AppColors.grey,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 8),
                                  TextField(
                                    controller: license_no,
                                    style: inputTextStyle(
                                        SizeConfig.inputFontSize),
                                    decoration: InputDecoration(
                                      focusedBorder: inputFocusedBorderStyle(),
                                      enabledBorder: inputBorderStyle(),
                                      hintStyle: placeholderStyle(
                                          SizeConfig.labelFontSize),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(5, 0, 3, 16),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text("License Expiry",
                                      style: AppTextStyle.textStyle.copyWith(
                                          color: AppColors.grey,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 8),
                                  DateTimeField(
                                    controller: license_exp_date,
                                    textAlign: TextAlign.left,
                                    onSaved: (val) {
                                      print('333 $val');
                                    },
                                    format: DateFormat('dd-MM-yyyy'),
                                    keyboardType: TextInputType.datetime,
                                    onChanged: (_) {},
                                    style: inputTextStyle(
                                        SizeConfig.inputFontSize),
                                    decoration: InputDecoration(
                                      hintText: "DD-MM-YYY",
                                      hintStyle: placeholderStyle(
                                          SizeConfig.labelFontSize),
                                      suffixIcon: Container(
                                        child: Icon(Icons.calendar_today,
                                            size: SizeConfig.labelFontSize,
                                            color: Colors.black38),
                                        margin:
                                            EdgeInsets.fromLTRB(15, 0, 0, 0),
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
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    colorScheme:
                                                        ColorScheme.light(
                                                      primary: Dark,
                                                      // <-- SEE HERE
                                                      onPrimary: Colors.white,
                                                      // <-- SEE HERE
                                                      onSurface: Colors
                                                          .black, // <-- SEE HERE
                                                    ),
                                                    textButtonTheme:
                                                        TextButtonThemeData(
                                                      style:
                                                          TextButton.styleFrom(
                                                        foregroundColor:
                                                            Dark, // button text color
                                                      ),
                                                    ),
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                              firstDate: DateTime.now(),
                                              initialDate: DateTime.now(),
                                              lastDate: DateTime(
                                                  DateTime.now().year + 35,
                                                  12,
                                                  31))
                                          .then((DateTime? date) async {
                                        // if (date != null) {
                                        //   final time = await showTimePicker(
                                        //     context: context,
                                        //     initialTime: TimeOfDay.fromDateTime(
                                        //         currentValue ?? DateTime.now()),
                                        //   );
                                        //   return DateTimeField.combine(
                                        //       date, time);
                                        // } else {
                                        license_exp_date =
                                            TextEditingController(
                                                text: formatDate(date!));
                                        setState(() {});
                                        return currentValue;
                                        // }
                                      });
                                    },
                                  ),
                                  SizedBox(height: 8),
                                  Text('License Image',
                                      style: AppTextStyle.textStyle.copyWith(
                                          color: AppColors.grey,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      if (license != null ||
                                          licenceHttpPath != null)
                                        Container(
                                          width:
                                              30 * SizeConfig.blockSizeVertical,
                                          height:
                                              30 * SizeConfig.blockSizeVertical,
                                          color: Colors.transparent,
                                          // alignment: Alignment(0, -Responsive.width(.1, context)),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                child: Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0,
                                                        0 *
                                                            SizeConfig
                                                                .blockSizeVertical,
                                                        0,
                                                        0),
                                                    // padding:
                                                    //     EdgeInsets.all(0),
                                                    decoration: BoxDecoration(
                                                      // border: Border.all(
                                                      //     color: AppColors
                                                      //         .grey
                                                      //         .withOpacity(
                                                      //             .50)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: .0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          print(
                                                              'Imageee--------$imageBaseUrl');
                                                          Navigator.of(context).push(PageRouteBuilder(
                                                              opaque: false,
                                                              pageBuilder: (BuildContext
                                                                          context,
                                                                      _,
                                                                      __) =>
                                                                  ZoomView(
                                                                      "${imageBaseUrl}$licenceHttpPath" ??
                                                                          license!
                                                                              .path,
                                                                      licenceHttpPath !=
                                                                              null
                                                                          ? 'http'
                                                                          : 'file')));
                                                        },
                                                        child: licenceHttpPath !=
                                                                null
                                                            ? ClipRRect(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                                child: SizedBox(
                                                                  width: 20 *
                                                                      SizeConfig
                                                                          .blockSizeVertical,
                                                                  height: 20 *
                                                                      SizeConfig
                                                                          .blockSizeVertical,
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl:
                                                                        "${imageBaseUrl}$licenceHttpPath",
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    placeholder:
                                                                        (context,
                                                                            url) {
                                                                      return Center(
                                                                        child: CircularProgressIndicator(
                                                                            strokeWidth:
                                                                                1.4,
                                                                            color:
                                                                                AppColors.secondary),
                                                                      );
                                                                    },
                                                                    errorWidget: (c,
                                                                            e,
                                                                            v) =>
                                                                        Icon(Icons
                                                                            .error_outline),
                                                                    // width: 20 * SizeConfig.blockSizeVertical,
                                                                    // height: 20 * SizeConfig.blockSizeVertical,
                                                                    // fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                              )
                                                            : Image.file(
                                                                File(license!
                                                                    .path),
                                                                width: 20 *
                                                                    SizeConfig
                                                                        .blockSizeVertical,
                                                                height: 20 *
                                                                    SizeConfig
                                                                        .blockSizeVertical,
                                                                fit: BoxFit
                                                                    .cover),
                                                      ),
                                                    )),
                                              ),
                                              Positioned(
                                                top: -12,
                                                right: Responsive.width(
                                                    17, context),
                                                child: IconButton(
                                                  icon:
                                                      Icon(Icons.remove_circle),
                                                  iconSize: 30,
                                                  color: Colors.red,
                                                  onPressed: () => {
                                                    this.setState(() {
                                                      // print('licence------$license');
                                                      // print('licencepath-=-------$licenceHttpPath');
                                                      // print('licence base------------$licenceBase64');
                                                      license = null;
                                                      licenceHttpPath = null;
                                                      licenceBase64 = "";
                                                      licenceBool = true;
                                                    })
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      if (license == null &&
                                          licenceHttpPath == null)
                                        Container(
                                          child: IconButton(
                                            icon: Icon(Icons.camera_alt),
                                            iconSize: 5 *
                                                SizeConfig.blockSizeVertical,
                                            color: Colors.blue,
                                            tooltip: 'Add Image By Camera',
                                            onPressed: _openCamera,
                                          ),
                                        ),
                                      if (license == null &&
                                          licenceHttpPath == null)
                                        Container(
                                          child: IconButton(
                                            icon: Icon(Icons.folder_open),
                                            iconSize: 5 *
                                                SizeConfig.blockSizeVertical,
                                            color: Colors.blue,
                                            tooltip:
                                                'Add Image/File By Gallery',
                                            onPressed: _openGallery,
                                          ),
                                        ),
                                    ],
                                  ),
                                  Text(
                                      'Note: License image should show license number, expiry date, address and your picture clearly.',
                                      style: AppTextStyle.textStyle.copyWith(
                                          color: AppColors.grey,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          child: CustomButton(
                            title: 'Update',
                            onTap: () => updateUserDetail(),
                          ),

                          // Container(
                          //   //height: constraints.maxHeight * 0.08,
                          //   width: constraints.maxWidth * 0.65,
                          //   margin:
                          //       EdgeInsets.only(top: constraints.maxHeight * 0.05),
                          //   child: Material(
                          //     borderRadius: BorderRadius.circular(10),
                          //     color: Dark,
                          //     elevation: 5.0,
                          //     child: MaterialButton(
                          //       onPressed: () => updateUserDetail(),
                          //       child: LayoutBuilder(
                          //         builder: (context, constraints) {
                          //           return Container(
                          //             //width: constraints.maxWidth * 0.35,
                          //             child: Text(
                          //               'Update',
                          //               style: TextStyle(
                          //                 fontFamily: 'Poppins',
                          //                 fontSize: 24,
                          //                 fontWeight: FontWeight.w700,
                          //                 color: Color.fromRGBO(255, 255, 255, 1.0),
                          //               ),
                          //             ),
                          //           );
                          //         },
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openGallery() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    final bytes = Io.File(pickedFile!.path).readAsBytesSync();
    String base64_ = base64Encode(bytes, getImageExtension(pickedFile.path));
    // var pref = await SharedPreferences.getInstance();
    // pref.setString("image", base64_);
    this.setState(() {
      licenceBase64 = base64_;
      license = File(pickedFile.path);
    });
  }

  void _openCamera() async {
    print('|||||||||||');
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    final bytes = Io.File(pickedFile!.path).readAsBytesSync();
    String base64_ = base64Encode(bytes, getImageExtension(pickedFile.path));
    log('WWWWWWWWWW ${base64_}');
    this.setState(() {
      licenceBase64 = base64_;
      license = File(pickedFile.path);
    });
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

  //call api for getAddress
  Future<void> getAddressInfo(String udprn, BuildContext page_context) async {
    Map? addressInfo = await _bookingService.getAddress(udprn);
    Map<String, String> params = {
      "postcode": addressInfo!['postcode'],
      "car_type": carType,
      "vehicle_preference": vehiclePreference,
      "type": "2",
      "course_id": ""
    };
    getDynamicRateApiCall(params).then((dynamicRateResponse) {
      if (dynamicRateResponse['success'] == true) {
        setState(() {
          this.address_line_1!.text = addressInfo['line_1'];
          this.address_line_2!.text = addressInfo['line_2'];
          this.town!.text = addressInfo['post_town'];
          //postcode = addressInfo['postcode'];
        });
        closeLoader();
      } else {
        closeLoader();
        setState(() {
          addressSuggestion = "";
          this.address_line_1!.text = "";
          this.address_line_2!.text = "";
          this.town!.text = "";
          postcode = "";
        });
        alertToShowAdiNotFound(page_context);
      }
    }).catchError((error) => closeLoader());
  }

  //call api for check adi and dynamic rate
  Future<Map> getDynamicRateApiCall(Map params) async {
    Map dynamicRateResponse = await _bookingService.getDynamicRate(params);
    return dynamicRateResponse;
  }

  //call api for save form data
  Future<void> updateUserDetail() async {
    showLoader("Updating...");
    try {
      Map<String, String> formData = {
        'id': _userId.toString(),
        'user_type': "2",
        'first_name': first_name != null ? first_name!.text : '',
        'last_name': last_name != null ? last_name!.text : '',
        'phone': phone_number != null ? phone_number!.text : '',
        'vehicle_preference': vehiclePreference,
        'address': _address != null ? _address : '',
        'address_line_1': address_line_1 != null ? address_line_1!.text : '',
        'address_line_2': address_line_2 != null ? address_line_2!.text : '',
        'town': town != null ? town!.text : '',
        'postcode': postcode != null ? postcode : '',
        'user_license': license_no != null ? license_no!.text : '',
        'user_license_expiry':
            license_exp_date != null ? license_exp_date!.text : '',
        'license_photo': licenceBase64,
        if (licenceBool) ...{"license_photo_remove": "yes"},
      };
      print('Licence Expiry Date---------- ${jsonEncode(formData)}');
      Map response = await api_services.updateProfileDetail(formData);
      log('WWWWWWWWWW ${licenceBase64}');

      if (response['message'] != null) {
        Toast.show(response['message'],
            duration: Toast.lengthLong, gravity: Toast.bottom);
        if (response['success'] == true) {
          SharedPreferences storage = await SharedPreferences.getInstance();
          await storage.setString('userName',
              formData['first_name']! + ' ' + formData['last_name']!);
          _navigationService.goBack();
        }
      }
      closeLoader();
    } catch (e) {
      print("profile save exception....");
      print(e);
      closeLoader();
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

String formatDate(DateTime date) {
  return DateFormat("dd-MM-yyyy").format(date);
}
