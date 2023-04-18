// import 'dart:convert';
// //import 'package:circular_check_box/circular_check_box.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:mdt/responsive/size_config.dart';
// import 'package:mdt/services/booking_test.dart';
// import 'package:mdt/services/methods.dart';
// import 'package:mdt/style/global_style.dart';
// import 'package:mdt/widgets/ImageZoomView/image_zoom_view.dart';
// import 'package:mdt/widgets/address-search-bar.dart';
// import 'package:toast/toast.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'dart:io' as Io;
// import 'dart:io';
//
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:student_app/Constants/app_colors.dart';
// import 'package:mdt/constants/global.dart';
// import 'package:mdt/responsive/percentage_mediaquery.dart';
// import 'package:mdt/responsive/size_config.dart';
// import 'package:mdt/services/navigation_service.dart';
// import 'package:mdt/services/validator.dart';
// import 'package:mdt/widgets/CustomSpinner.dart';
// import 'package:mdt/widgets/MultiSteps/multi_steps_element.dart';
// import 'package:mdt/widgets/navigatin_bar/CustomAppBar.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../locater.dart';
//
// class AdiProfile extends StatefulWidget {
//   @override
//   _AdiProfileState createState() => _AdiProfileState();
// }
//
// class _AdiProfileState extends State<AdiProfile> {
//   final NavigationService _navigationService = locator<NavigationService>();
//   final BookingService _bookingService = new BookingService();
//   final GlobalKey<State> _keyLoader1 = new GlobalKey<State>();
//   final GlobalKey<MultiStepsElementsSate> _multiStepperWidget1 =
//       GlobalKey<MultiStepsElementsSate>();
//   late ScrollController list_view_scrollCtrl;
//   final _key1 = GlobalKey<ScaffoldState>();
//   int current_step = 0;
//   List<String> stepsList = [
//     'Personal and Address Details',
//     'License\nDetail',
//     'Other\nDetails',
//     'Car\nDetails',
//     'Comment and Confirmations'
//   ];
//   List<Map> suggestion = [
//     {'name': "", 'details': "--Insurance Provider--"},
//     {'name': "Adrian Flux", 'details': "Adrian Flux 0800 369 8590"},
//     {
//       'name': "Arthur J Gallagher",
//       'details': "Arthur J Gallagher 0845 7697 323"
//     },
//     {'name': "Barry Grainger", 'details': "Barry Grainger 01892 501 501"},
//     {'name': "C&A Mackie", 'details': "C&A Mackie 0141 423 8555"},
//     {'name': "DCL", 'details': "DCL 0208 773 5261"},
//     {'name': "DIA", 'details': "DIA 0800 988 9255"},
//     {
//       'name': "Insurance 4 Instructors",
//       'details': "Insurance 4 Instructors 01603 301 770"
//     },
//     {
//       'name': "Instructor Cover Plus",
//       'details': "Instructor Cover Plus 02920 629 413"
//     },
//     {'name': "Lloyd Latchford", 'details': "Lloyd Latchford 01844 275 555"},
//     {'name': "Master Cover", 'details': "Master Cover 0208 236 3600"},
//     {'name': "Master Cover 2", 'details': "Master Cover 01208 833050"},
//     {'name': "Park Insurance", 'details': "Park Insurance 01454 411 187"},
//     {'name': "Policy Wave", 'details': "Policy Wave 0333 332 7750"},
//     {'name': "Waveney", 'details': "Waveney 01603 753 888"},
//     {'name': "other", 'details': "Other"},
//   ];
//   late String addressSuggestion;
//   File? licenseFront;
//   String licenceFrontBase64 = '';
//   String? licenceFrontHttpPath;
//   File? licenseBack;
//   String licenceBackBase64 = '';
//   String? licenceBackHttpPath;
//
//   late Map data;
//   late Map adiData;
//   late Future adi;
//   //String name;
//   late String fName;
//   late String lName;
//   late String phone;
//   late String add1;
//   late String add2;
//   late String town;
//   late String postcode;
//   late String adiLicense;
//   late String expDate;
//   late String lang;
//   late String postcodeCovered;
//   late String studentTrain;
//   late String distance;
//   late String manual;
//   late String mMake;
//   late String mModel;
//   late String mColor;
//   late String mReg;
//   late String mOwnRate;
//   late String mCustomerRate;
//   late String automatic;
//   late String aMake;
//   late String aModel;
//   late String aColor;
//   late String aReg;
//   late String aOwnRate;
//   late String aCustomerRate;
//   late String comment;
//   late String referredBy;
//   late String experience;
//
//   late String message;
//   //int current_step = 0;
//   late int _radValue1;
//   late int _radValue2;
//   late int _radValue3;
//   late int _radValue4;
//   late String base64Image;
//   late File tmpFile;
//   late String base64Image1;
//   late File tmpFile1;
//   late bool carManual;
//   late bool carAuto;
//   bool checkboxValue1 = false;
//   bool checkboxValue2 = false;
//   bool checkboxValue3 = false;
//   bool checkboxValue4 = false;
//
//   String manualInsuranceProvider = '';
//   String autoInsuranceProvider = '';
//   // //Step1 Controllers
//   TextEditingController fNameController = new TextEditingController();
//   TextEditingController lNameController = new TextEditingController();
//   TextEditingController phoneController = new TextEditingController();
//   TextEditingController address1Controller = new TextEditingController();
//   TextEditingController address2Controller = new TextEditingController();
//   TextEditingController townController = new TextEditingController();
//   TextEditingController postcodeController = new TextEditingController();
//   //
//   // //Step2 Controllers
//   TextEditingController licenseController = new TextEditingController();
//   TextEditingController expiryDateController = new TextEditingController();
//   //
//   // //Step3 Controllers
//   TextEditingController languageController = new TextEditingController();
//   TextEditingController referredController = new TextEditingController();
//   TextEditingController postcodeCoverController = new TextEditingController();
//   TextEditingController distanceController = new TextEditingController();
//   TextEditingController studentTrainedController = new TextEditingController();
//   TextEditingController yearExpController = new TextEditingController();
//   //
//   // //Step4 Controllers
//   TextEditingController manualMakeController = new TextEditingController();
//   TextEditingController manualModelController = new TextEditingController();
//   TextEditingController manualColorController = new TextEditingController();
//   TextEditingController manualRegController = new TextEditingController();
//   TextEditingController manualOwnCarRateController =
//       new TextEditingController();
//   TextEditingController manualCustomerCarRateController =
//       new TextEditingController();
//   TextEditingController manualInsuranceRenewalController =
//       new TextEditingController();
//   TextEditingController manualInsuranceProviderDropController =
//       new TextEditingController();
//
//   //
//   TextEditingController autoMakeController = new TextEditingController();
//   TextEditingController autoModelController = new TextEditingController();
//   TextEditingController autoColorController = new TextEditingController();
//   TextEditingController autoRegController = new TextEditingController();
//   TextEditingController autoOwnCarRateController = new TextEditingController();
//   TextEditingController autoCustomerCarRateController =
//       new TextEditingController();
//   TextEditingController autoInsuranceRenewalController =
//       new TextEditingController();
//   TextEditingController autoInsuranceProviderDropController =
//       new TextEditingController();
//   //
//   // //Step5 Controllers
//   TextEditingController commentController = new TextEditingController();
//
//   //final String phpEndPoint = 'http://192.168.43.171/phpAPI/image.php';
//
//   void _openGallery() async {
//     final pickedFile =
//         await ImagePicker().getImage(source: ImageSource.gallery);
//     final bytes = Io.File(pickedFile!.path).readAsBytesSync();
//     String base64Front =
//         base64Encode(bytes, getImageExtension(pickedFile.path));
//     //print(base64_);
//     this.setState(() {
//       licenceFrontBase64 = base64Front;
//       licenseFront = File(pickedFile!.path);
//     });
//   }
//
//   void _openCamera() async {
//     final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
//     final bytes = Io.File(pickedFile!.path).readAsBytesSync();
//     String base64Front =
//         base64Encode(bytes, getImageExtension(pickedFile.path));
//     this.setState(() {
//       licenceFrontBase64 = base64Front;
//       licenseFront = File(pickedFile.path);
//     });
//   }
//
//   Future<String?> networkImageToBase64(Uri imageUrl) async {
//     http.Response response = await http.get(imageUrl);
//     final bytes = response?.bodyBytes;
//     //print(base64Encode(bytes,"jpg"));
//     return (bytes != null ? base64Encode(bytes, "jpg") : null);
//   }
//
//   void _openGallery1() async {
//     final pickedFile =
//         await ImagePicker().getImage(source: ImageSource.gallery);
//     final bytes = Io.File(pickedFile!.path).readAsBytesSync();
//     String base64Back = base64Encode(bytes, getImageExtension(pickedFile.path));
//     //print(base64_);
//     this.setState(() {
//       licenceBackBase64 = base64Back;
//       licenseBack = File(pickedFile.path);
//     });
//   }
//
//   void _openCamera1() async {
//     final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
//     final bytes = Io.File(pickedFile!.path).readAsBytesSync();
//     String base64Back = base64Encode(bytes, getImageExtension(pickedFile.path));
//     this.setState(() {
//       licenceBackBase64 = base64Back;
//       licenseBack = File(pickedFile.path);
//     });
//   }
//
//   Future<Map> getAdiData() async {
//     final url = Uri.parse("$api/api/adi-data");
//     SharedPreferences storage = await SharedPreferences.getInstance();
//     String? token = storage.getString('token');
//
//     Map<String, String> header = {
//       'token': token!,
//     };
//
//     final response = await http.get(url, headers: header);
//
//     data = jsonDecode(response.body);
//
//     adiData = data["data"];
//
//     return adiData;
//   }
//
//   Future<void> saveUserData() async {
//     try {
//       if (checkboxValue1 == false ||
//           checkboxValue2 == false ||
//           checkboxValue3 == false ||
//           checkboxValue4 == false) {
//         Toast.show("Please select agreement terms.",
//             textStyle: context,
//             duration: Toast.lengthLong,
//             gravity: Toast.bottom);
//       } else {
//         showLoader("Saving...");
//         Map formData = {
//           'firstName': fNameController.text != null ? fNameController.text : '',
//           'lastName': lNameController.text != null ? lNameController.text : '',
//           'phoneNumber':
//               phoneController.text != null ? phoneController.text : '',
//           'address': addressSuggestion,
//           'address1':
//               address1Controller.text != null ? address1Controller.text : '',
//           'address2':
//               address2Controller.text != null ? address2Controller.text : '',
//           'town': townController.text != null ? townController.text : '',
//           'postcode':
//               postcodeController.text != null ? postcodeController.text : '',
//           'adiLicenseNumber':
//               licenseController.text != null ? licenseController.text : '',
//           'expDate': expiryDateController.text != null
//               ? expiryDateController.text
//               : '',
//           'frontImg': licenceFrontBase64,
//           'backImg': licenceBackBase64,
//           'langSpoken':
//               languageController.text != null ? languageController.text : '',
//           'postcodeCovered': postcodeCoverController.text != null
//               ? postcodeCoverController.text
//               : '',
//           'studentTrained': studentTrainedController.text != null
//               ? studentTrainedController.text
//               : '',
//           'distanceTravel':
//               distanceController.text != null ? distanceController.text : '',
//           'referral':
//               referredController.text != null ? referredController.text : '',
//           'exp': yearExpController.text != null ? yearExpController.text : '',
//           'manual': carManual ? "1" : "0",
//           'manualMake': manualMakeController.text != null
//               ? manualMakeController.text
//               : '',
//           'manualModel': manualModelController.text != null
//               ? manualModelController.text
//               : '',
//           'manualColor': manualColorController.text != null
//               ? manualColorController.text
//               : '',
//           'manualRegNumber':
//               manualRegController.text != null ? manualRegController.text : '',
//           'manualOwnCarRate': manualOwnCarRateController.text != null
//               ? manualOwnCarRateController.text
//               : '',
//           'manualCustomerCarRate': manualCustomerCarRateController.text != null
//               ? manualCustomerCarRateController.text
//               : '',
//           'manualInsuranceProvider': manualInsuranceProvider,
//           'manualRenewalDate': manualInsuranceRenewalController.text != null
//               ? manualInsuranceRenewalController.text
//               : '',
//           'automatic': carAuto ? "1" : "0",
//           'autoMake':
//               autoMakeController.text != null ? autoMakeController.text : '',
//           'autoModel':
//               autoModelController.text != null ? autoModelController.text : '',
//           'autoColor':
//               autoColorController.text != null ? autoColorController.text : '',
//           'autoRegNumber':
//               autoRegController.text != null ? autoRegController.text : '',
//           'autoOwnCarRate': autoOwnCarRateController.text != null
//               ? autoOwnCarRateController.text
//               : '',
//           'autoCustomerCarRate': autoCustomerCarRateController.text != null
//               ? autoCustomerCarRateController.text
//               : '',
//           'autoInsuranceProvider': autoInsuranceProvider,
//           'autoRenewalDate': autoInsuranceRenewalController.text != null
//               ? autoInsuranceRenewalController.text
//               : '',
//           'radio1': _radValue1.toString(),
//           'radio2': _radValue2.toString(),
//           'radio3': _radValue3.toString(),
//           'radio4': _radValue4.toString(),
//           'comment':
//               commentController.text != null ? commentController.text : '',
//         };
//         Map response = await submitAdiProfile(formData);
//         if (response['message'] != null) {
//           Toast.show(response['message'],
//               textStyle: context,
//               duration: Toast.lengthLong,
//               gravity: Toast.bottom);
//           if (response['success'] == true) {
//             _navigationService.goBack();
//           }
//         }
//         closeLoader();
//       }
//     } catch (e) {
//       closeLoader();
//     }
//   }
//
//   Future<Map> submitAdiProfile(Map formData) async {
//     final url = Uri.parse("$api/api/adi-data/update");
//     SharedPreferences storage = await SharedPreferences.getInstance();
//     String? token = storage.getString('token');
//
//     Map<String, String> header = {
//       'token': token!,
//     };
//     print(manualInsuranceProvider);
//     print(autoInsuranceProvider);
//
//     final response = await http.post(url, headers: header, body: formData);
//     //print("in");
//     data = jsonDecode(response.body);
//     return data;
//     //return message;
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       this.initializeApi("Loading...");
//     });
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
//   Future<bool> checkInternet() async {
//     print("internet check..1.");
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     print("internet check.2..");
//     print(connectivityResult);
//     if (connectivityResult == ConnectivityResult.mobile) {
//       return true;
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       return true;
//     }
//     return false;
//   }
//
//   void showLoader(String message) {
//     CustomSpinner.showLoadingDialog(context, _keyLoader1, message);
//   }
//
//   void closeLoader() {
//     try {
//       Navigator.of(_keyLoader1.currentContext!, rootNavigator: true).pop();
//     } catch (e) {}
//   }
//
//   String checkForNull(String text) {
//     return text == null ? "" : text;
//   }
//
//   Future<void> getAddressInfo(String udprn, BuildContext page_context) async {
//     Map? addressInfo = await _bookingService.getAddress(udprn);
//     print(addressInfo);
//     this.address1Controller.text = addressInfo!['line_1'];
//     this.address2Controller.text = addressInfo['line_2'];
//     this.townController.text = addressInfo['post_town'];
//     this.postcodeController.text = addressInfo['postcode'];
//
//     closeLoader();
//   }
//
//   initializeApi(String loaderMessage) {
//     checkInternet();
//     showLoader(loaderMessage);
//
//     getAdiData().then((records) {
//       Map userProfileDetail = records;
//       print("profile data: $userProfileDetail");
//       print(userProfileDetail["img_url_front"]);
//       print(userProfileDetail["img_url_back"]);
//       setState(() {
//         fNameController = TextEditingController(
//             text: checkForNull(userProfileDetail['first_name']));
//         lNameController = TextEditingController(
//             text: checkForNull(userProfileDetail['last_name']));
//         phoneController = TextEditingController(
//             text: checkForNull(userProfileDetail['phone']));
//         // vehiclePreference = checkForNull(userProfileDetail['vehicle_preference']);
//         addressSuggestion = checkForNull(userProfileDetail['address']);
//         address1Controller = TextEditingController(
//             text: checkForNull(userProfileDetail['address_line_1']));
//         address2Controller = TextEditingController(
//             text: checkForNull(userProfileDetail['address_line_2']));
//         townController = TextEditingController(
//             text: checkForNull(userProfileDetail['town']));
//         postcodeController = TextEditingController(
//             text: checkForNull(userProfileDetail['postcode']));
//
//         licenseController = TextEditingController(
//             text: checkForNull(userProfileDetail['adi_number']));
//
//         languageController = TextEditingController(
//             text: checkForNull(userProfileDetail['language_spoken']));
//         referredController = TextEditingController(
//             text: checkForNull(userProfileDetail['referred_by']));
//         postcodeCoverController = TextEditingController(
//             text: checkForNull(userProfileDetail['postecode_covered']));
//         distanceController = TextEditingController(
//             text:
//                 checkForNull(userProfileDetail['distance_travel'].toString()));
//         studentTrainedController = TextEditingController(
//             text: checkForNull(userProfileDetail['success_story'].toString()));
//         yearExpController = TextEditingController(
//             text: checkForNull(userProfileDetail['year_of_exp'].toString()));
//         //print(userProfileDetail['expire_date']);
//         // license_no = TextEditingController(text: checkForNull(userProfileDetail['driver_license_no']));
//         if (userProfileDetail['expire_date'] != null) {
//           print("in");
//           var dateOfLicenseExpire = userProfileDetail['expire_date'].split('-');
//           var date = dateOfLicenseExpire[2].split(' ');
//           print(date);
//           expiryDateController = TextEditingController(
//               text: date[0] +
//                   '-' +
//                   dateOfLicenseExpire[1] +
//                   '-' +
//                   dateOfLicenseExpire[0]);
//         } else {
//           expiryDateController = TextEditingController(text: "");
//         }
//
//         licenceFrontHttpPath = userProfileDetail['img_url_front'];
//         licenceBackHttpPath = userProfileDetail['img_url_back'];
//
//         if (userProfileDetail['car_manual'] == 1) {
//           //print("manual");
//           carManual = true;
//         } else {
//           carManual = false;
//         }
//         manualMakeController = TextEditingController(
//             text: checkForNull(userProfileDetail['manual_make'].toString()));
//         manualModelController = TextEditingController(
//             text: checkForNull(userProfileDetail['manual_model'].toString()));
//         manualColorController = TextEditingController(
//             text: checkForNull(userProfileDetail['manual_color'].toString()));
//         manualRegController = TextEditingController(
//             text: checkForNull(
//                 userProfileDetail['manual_reg_number'].toString()));
//         manualOwnCarRateController = TextEditingController(
//             text: checkForNull(
//                 userProfileDetail['hourly_rate_adi_car_manual'].toString()));
//         manualCustomerCarRateController = TextEditingController(
//             text: checkForNull(
//                 userProfileDetail['hourly_rate_driver_car_manual'].toString()));
//         if (userProfileDetail['manual_insurance_renewal_date'] != null) {
//           var dateOfLicenseExpire =
//               userProfileDetail['manual_insurance_renewal_date'].split('-');
//           var date = dateOfLicenseExpire[2].split(' ');
//           print(date);
//           manualInsuranceRenewalController = TextEditingController(
//               text: date[0] +
//                   '-' +
//                   dateOfLicenseExpire[1] +
//                   '-' +
//                   dateOfLicenseExpire[0]);
//         } else {
//           manualInsuranceRenewalController = TextEditingController(text: "");
//         }
//
//         if (userProfileDetail['manual_insurance_provider'] == 'Adrian Flux') {
//           manualInsuranceProvider = "Adrian Flux";
//           manualInsuranceProviderDropController =
//               TextEditingController(text: "Adrian Flux 0800 369 8590");
//         } else if (userProfileDetail['manual_insurance_provider'] ==
//             'Arthur J Gallagher') {
//           manualInsuranceProvider = "Arthur J Gallagher";
//           manualInsuranceProviderDropController =
//               TextEditingController(text: "Arthur J Gallagher 0845 7697 323");
//         } else if (userProfileDetail['manual_insurance_provider'] ==
//             'Barry Grainger') {
//           manualInsuranceProvider = "Barry Grainger";
//           manualInsuranceProviderDropController =
//               TextEditingController(text: "Barry Grainger 01892 501 501");
//         } else if (userProfileDetail['manual_insurance_provider'] ==
//             'C&A Mackie') {
//           manualInsuranceProvider = "C&A Mackie";
//           manualInsuranceProviderDropController =
//               TextEditingController(text: "C&A Mackie 0141 423 8555");
//         } else if (userProfileDetail['manual_insurance_provider'] == 'DCL') {
//           manualInsuranceProvider = "DCL";
//           manualInsuranceProviderDropController =
//               TextEditingController(text: "DCL 0208 773 5261");
//         } else if (userProfileDetail['manual_insurance_provider'] == 'DIA') {
//           manualInsuranceProvider = "DIA";
//           manualInsuranceProviderDropController =
//               TextEditingController(text: "DIA 0800 988 9255");
//         } else if (userProfileDetail['manual_insurance_provider'] ==
//             'Insurance 4 Instructors') {
//           manualInsuranceProvider = "Insurance 4 Instructors";
//           manualInsuranceProviderDropController = TextEditingController(
//               text: "Insurance 4 Instructors 01603 301 770");
//         } else if (userProfileDetail['manual_insurance_provider'] ==
//             'Instructor Cover Plus') {
//           manualInsuranceProvider = "Instructor Cover Plus";
//           manualInsuranceProviderDropController = TextEditingController(
//               text: "Instructor Cover Plus 02920 629 413");
//         } else if (userProfileDetail['manual_insurance_provider'] ==
//             'Lloyd Latchford') {
//           manualInsuranceProvider = "Lloyd Latchford";
//           manualInsuranceProviderDropController =
//               TextEditingController(text: "Lloyd Latchford 01844 275 555");
//         } else if (userProfileDetail['manual_insurance_provider'] ==
//             'Master Cover') {
//           manualInsuranceProvider = "Master Cover";
//           manualInsuranceProviderDropController =
//               TextEditingController(text: "Master Cover 0208 236 3600");
//         } else if (userProfileDetail['manual_insurance_provider'] ==
//             'Master Cover 2') {
//           manualInsuranceProvider = "Master Cover 2";
//           manualInsuranceProviderDropController =
//               TextEditingController(text: "Master Cover 01208 833050");
//         } else if (userProfileDetail['manual_insurance_provider'] ==
//             'Park Insurance') {
//           manualInsuranceProvider = "Park Insurance";
//           manualInsuranceProviderDropController =
//               TextEditingController(text: "Park Insurance 01454 411 187");
//         } else if (userProfileDetail['manual_insurance_provider'] ==
//             'Policy Wave') {
//           manualInsuranceProvider = "Policy Wave";
//           manualInsuranceProviderDropController =
//               TextEditingController(text: "Policy Wave 0333 332 7750");
//         } else if (userProfileDetail['manual_insurance_provider'] ==
//             'Waveney') {
//           manualInsuranceProvider = "Waveney";
//           manualInsuranceProviderDropController =
//               TextEditingController(text: "Waveney 01603 753 888");
//         } else if (userProfileDetail['manual_insurance_provider'] == 'other') {
//           manualInsuranceProvider = "other";
//           manualInsuranceProviderDropController =
//               TextEditingController(text: "Other");
//         }
//
//         if (userProfileDetail['car_auto'] == 1) {
//           //print("auto");
//           carAuto = true;
//         } else {
//           carAuto = false;
//         }
//         autoMakeController = TextEditingController(
//             text: checkForNull(userProfileDetail['auto_make'].toString()));
//         autoModelController = TextEditingController(
//             text: checkForNull(userProfileDetail['auto_model'].toString()));
//         autoColorController = TextEditingController(
//             text: checkForNull(userProfileDetail['auto_color'].toString()));
//         autoRegController = TextEditingController(
//             text:
//                 checkForNull(userProfileDetail['auto_reg_number'].toString()));
//         autoOwnCarRateController = TextEditingController(
//             text: checkForNull(
//                 userProfileDetail['hourly_rate_adi_car_auto'].toString()));
//         autoCustomerCarRateController = TextEditingController(
//             text: checkForNull(
//                 userProfileDetail['hourly_rate_driver_car_auto'].toString()));
//         if (userProfileDetail['auto_insurance_renewal_date'] != null) {
//           var dateOfLicenseExpire =
//               userProfileDetail['auto_insurance_renewal_date'].split('-');
//           var date = dateOfLicenseExpire[2].split(' ');
//           print(date);
//           autoInsuranceRenewalController = TextEditingController(
//               text: date[0] +
//                   '-' +
//                   dateOfLicenseExpire[1] +
//                   '-' +
//                   dateOfLicenseExpire[0]);
//         } else {
//           autoInsuranceRenewalController = TextEditingController(text: "");
//         }
//         // print("Everything OK");
//         if (userProfileDetail['auto_insurance_provider'] == 'Adrian Flux') {
//           autoInsuranceProvider = "Adrian Flux";
//           autoInsuranceProviderDropController =
//               TextEditingController(text: "Adrian Flux 0800 369 8590");
//         } else if (userProfileDetail['auto_insurance_provider'] ==
//             'Arthur J Gallagher') {
//           autoInsuranceProvider = "Arthur J Gallagher";
//           autoInsuranceProviderDropController =
//               TextEditingController(text: "Arthur J Gallagher 0845 7697 323");
//         } else if (userProfileDetail['auto_insurance_provider'] ==
//             'Barry Grainger') {
//           autoInsuranceProvider = "Barry Grainger";
//           autoInsuranceProviderDropController =
//               TextEditingController(text: "Barry Grainger 01892 501 501");
//         } else if (userProfileDetail['auto_insurance_provider'] ==
//             'C&A Mackie') {
//           autoInsuranceProvider = "C&A Mackie";
//           autoInsuranceProviderDropController =
//               TextEditingController(text: "C&A Mackie 0141 423 8555");
//         } else if (userProfileDetail['auto_insurance_provider'] == 'DCL') {
//           autoInsuranceProvider = "DCL";
//           autoInsuranceProviderDropController =
//               TextEditingController(text: "DCL 0208 773 5261");
//         } else if (userProfileDetail['auto_insurance_provider'] == 'DIA') {
//           autoInsuranceProvider = "DIA";
//           autoInsuranceProviderDropController =
//               TextEditingController(text: "DIA 0800 988 9255");
//         } else if (userProfileDetail['auto_insurance_provider'] ==
//             'Insurance 4 Instructors') {
//           autoInsuranceProvider = "Insurance 4 Instructors";
//           autoInsuranceProviderDropController = TextEditingController(
//               text: "Insurance 4 Instructors 01603 301 770");
//         } else if (userProfileDetail['auto_insurance_provider'] ==
//             'Instructor Cover Plus') {
//           autoInsuranceProvider = "Instructor Cover Plus";
//           autoInsuranceProviderDropController = TextEditingController(
//               text: "Instructor Cover Plus 02920 629 413");
//         } else if (userProfileDetail['auto_insurance_provider'] ==
//             'Lloyd Latchford') {
//           autoInsuranceProvider = "Lloyd Latchford";
//           autoInsuranceProviderDropController =
//               TextEditingController(text: "Lloyd Latchford 01844 275 555");
//         } else if (userProfileDetail['auto_insurance_provider'] ==
//             'Master Cover') {
//           autoInsuranceProvider = "Master Cover";
//           autoInsuranceProviderDropController =
//               TextEditingController(text: "Master Cover 0208 236 3600");
//         } else if (userProfileDetail['auto_insurance_provider'] ==
//             'Master Cover 2') {
//           autoInsuranceProvider = "Master Cover 2";
//           autoInsuranceProviderDropController =
//               TextEditingController(text: "Master Cover 01208 833050");
//         } else if (userProfileDetail['auto_insurance_provider'] ==
//             'Park Insurance') {
//           autoInsuranceProvider = "Park Insurance";
//           autoInsuranceProviderDropController =
//               TextEditingController(text: "Park Insurance 01454 411 187");
//         } else if (userProfileDetail['auto_insurance_provider'] ==
//             'Policy Wave') {
//           autoInsuranceProvider = "Policy Wave";
//           autoInsuranceProviderDropController =
//               TextEditingController(text: "Policy Wave 0333 332 7750");
//         } else if (userProfileDetail['auto_insurance_provider'] == 'Waveney') {
//           autoInsuranceProvider = "Waveney";
//           autoInsuranceProviderDropController =
//               TextEditingController(text: "Waveney 01603 753 888");
//         } else if (userProfileDetail['auto_insurance_provider'] == 'other') {
//           autoInsuranceProvider = "other";
//           autoInsuranceProviderDropController =
//               TextEditingController(text: "Other");
//         }
//
//         if (userProfileDetail['theory_tuition_per_hour'] == 1) {
//           _radValue1 = 1;
//         } else {
//           _radValue1 = 0;
//         }
//
//         if (userProfileDetail["test_the_driver_car"] == 1) {
//           _radValue2 = 1;
//         } else {
//           _radValue2 = 0;
//         }
//
//         if (userProfileDetail["provide_assist_class"] == 1) {
//           _radValue3 = 1;
//         } else {
//           _radValue3 = 0;
//         }
//
//         if (userProfileDetail["leads_for_lessons"] == 1) {
//           _radValue4 = 1;
//         } else {
//           _radValue4 = 0;
//         }
//
//         commentController = TextEditingController(
//             text: checkForNull(userProfileDetail['comments']));
//       });
//
//       closeLoader();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return Scaffold(
//       key: _key1,
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: [
//           CustomAppBar(
//             preferedHeight: Responsive.height(24, context),
//             title: 'My Profile',
//             textWidth: Responsive.width(35, context),
//             iconLeft: FontAwesomeIcons.arrowLeft,
//             onTap1: () {
//               _navigationService.goBack();
//             },
//             iconRight: null,
//           ),
//           Container(
//               margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
//               child: LayoutBuilder(builder: (context, constraints) {
//                 return Container(
//                     width: constraints.maxWidth * 1,
//                     child: Column(
//                       children: [
//                         Container(
//                           width: Responsive.width(100, context),
//                           height: Responsive.height(17, context),
//                           margin: EdgeInsets.only(
//                               top: Responsive.height(10, context)),
//                           padding: EdgeInsets.symmetric(
//                               horizontal: Responsive.width(2, context)),
//                           alignment: Alignment.centerLeft,
//                           child: MultiStepsElements(
//                               key: _multiStepperWidget1,
//                               steps: this.stepsList,
//                               constraints: constraints,
//                               parentContext: context),
//                         ),
//                         Container(
//                           width: Responsive.width(100, context),
//                           height: Responsive.height(65, context),
//                           padding: EdgeInsets.only(top: 15, bottom: 5),
//                           child: ListView(
//                             controller: list_view_scrollCtrl,
//                             physics: const AlwaysScrollableScrollPhysics(),
//                             shrinkWrap: true,
//                             padding: EdgeInsets.fromLTRB(10, 2, 10,
//                                 MediaQuery.of(context).viewInsets.bottom),
//                             children: [
//                               if (current_step == 0)
//                                 LayoutBuilder(builder: (context, constraints) {
//                                   return personalDetailsStep(context);
//                                 }),
//                               if (current_step == 1)
//                                 LayoutBuilder(builder: (context, constraints) {
//                                   return licenceDetailsStep(
//                                       context, constraints);
//                                 }),
//                               if (current_step == 2)
//                                 LayoutBuilder(builder: (context, constraints) {
//                                   return otherDetailsStep(context, constraints);
//                                 }),
//                               if (current_step == 3)
//                                 LayoutBuilder(builder: (context, constraints) {
//                                   return carDetailsStep(context, constraints);
//                                 }),
//                               if (current_step == 4)
//                                 LayoutBuilder(builder: (context, constraints) {
//                                   return confirmationStep(context, constraints);
//                                 }),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           width: Responsive.width(100, context),
//                           height: Responsive.height(8, context),
//                           child:
//                               LayoutBuilder(builder: (context, constraints_) {
//                             return footerActionBar(context);
//                           }),
//                         ),
//                       ],
//                     ));
//               })),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     // fNameController.dispose();
//     // lNameController.dispose();
//     // phoneController.dispose();
//     // address1Controller.dispose();
//     // address2Controller.dispose();
//     // townController.dispose();
//     // postcodeController.dispose();
//     //
//     // licenseController.dispose();
//     // expiryDateController.dispose();
//     //
//     // languageController.dispose();
//     // referredController.dispose();
//     // postcodeCoverController.dispose();
//     // distanceController.dispose();
//     // studentTrainedController.dispose();
//     // yearExpController.dispose();
//     //
//     // manualMakeController.dispose();
//     // manualModelController.dispose();
//     // manualColorController.dispose();
//     // manualRegController.dispose();
//     // manualOwnCarRateController.dispose();
//     // manualCustomerCarRateController.dispose();
//     // autoMakeController.dispose();
//     // autoModelController.dispose();
//     // autoColorController.dispose();
//     // autoRegController.dispose();
//     // autoOwnCarRateController.dispose();
//     // autoCustomerCarRateController.dispose();
//     //
//     // commentController.dispose();
//
//     super.dispose();
//   }
//
//   bool validateStep_0() {
//     if (fNameController.text == null || fNameController.text.trim() == "")
//       return false;
//     else if (lNameController.text == null || lNameController.text.trim() == "")
//       return false;
//     else if (phoneController.text == null || phoneController.text.trim() == "")
//       return false;
//     else if (addressSuggestion == null || addressSuggestion.trim() == "")
//       return false;
//     else if (address1Controller.text == null ||
//         address1Controller.text.trim() == "")
//       return false;
//     else if (townController.text == null || townController.text.trim() == "")
//       return false;
//     else if (postcodeController.text == null ||
//         postcodeController.text.trim() == "")
//       return false;
//     else
//       return true;
//   }
//
//   bool validateStep_1() {
//     if (licenseController.text == null || licenseController.text.trim() == "")
//       return false;
//     else if (licenceFrontHttpPath == null && licenseFront == null)
//       return false;
//     else if (licenceBackHttpPath == null && licenseBack == null)
//       return false;
//     else
//       return true;
//   }
//
//   bool validateManualCarDetails() {
//     if (carManual) {
//       if (manualMakeController.text == null ||
//           manualMakeController.text.trim() == "") {
//         return false;
//       } else if (manualModelController.text == null ||
//           manualModelController.text.trim() == "") {
//         return false;
//       } else if (manualColorController.text == null ||
//           manualColorController.text.trim() == "") {
//         return false;
//       } else if (manualRegController.text == null ||
//           manualRegController.text.trim() == "") {
//         return false;
//       } else if (manualOwnCarRateController.text == null ||
//           manualOwnCarRateController.text.trim() == "") {
//         return false;
//       } else if (manualCustomerCarRateController.text == null ||
//           manualCustomerCarRateController.text.trim() == "") {
//         return false;
//       } else if (manualInsuranceRenewalController.text == null ||
//           manualInsuranceRenewalController.text.trim() == "") {
//         return false;
//       }
//     }
//     return true;
//   }
//
//   bool validateAutoCarDetails() {
//     if (carAuto) {
//       if (autoMakeController.text == null ||
//           autoMakeController.text.trim() == "") {
//         return false;
//       } else if (autoModelController.text == null ||
//           autoModelController.text.trim() == "") {
//         return false;
//       } else if (autoColorController.text == null ||
//           autoColorController.text.trim() == "") {
//         return false;
//       } else if (autoRegController.text == null ||
//           autoRegController.text.trim() == "") {
//         return false;
//       } else if (autoOwnCarRateController.text == null ||
//           autoOwnCarRateController.text.trim() == "") {
//         return false;
//       } else if (autoCustomerCarRateController.text == null ||
//           autoCustomerCarRateController.text.trim() == "") {
//         return false;
//       } else if (autoInsuranceRenewalController.text == null ||
//           autoInsuranceRenewalController.text.trim() == "") {
//         return false;
//       }
//     }
//     return true;
//   }
//
//   Widget personalDetailsStep(BuildContext context) {
//     return Container(
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
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: Responsive.width(100, context),
//                           margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                           child: AutoSizeText("First Name*",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             child: TextField(
//                                 //showCursor: false,
//                                 controller: fNameController,
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
//                           child: AutoSizeText("Last Name*",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             child: TextField(
//                                 controller: lNameController,
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
//                           child: AutoSizeText("Phone Number*",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             child: TextField(
//                                 controller: phoneController,
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
//                           child: AutoSizeText("Address Search*",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             child: GestureDetector(
//                                 onTap: () {
//                                   showDialog<void>(
//                                       context: context,
//                                       barrierDismissible: true,
//                                       barrierColor: Colors.black45,
//                                       builder: (BuildContext context_) {
//                                         return new AddressSearchPopup(
//                                           selectedAddress: addressSuggestion,
//                                           onTapToSuggestion: (suggestion) {
//                                             setState(() {
//                                               addressSuggestion =
//                                                   suggestion['suggestion'];
//                                             });
//                                             showLoader('Address Loading..');
//                                             try {
//                                               getAddressInfo(
//                                                   (suggestion['udprn'])
//                                                       .toString(),
//                                                   context);
//                                             } catch (e) {
//                                               closeLoader();
//                                             }
//                                           },
//                                         );
//                                       });
//                                 },
//                                 child: Container(
//                                     width: Responsive.width(100, context),
//                                     height: SizeConfig.inputHeight,
//                                     alignment: Alignment.centerLeft,
//                                     padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
//                                     decoration: textAreaBorderLikeAsInput(),
//                                     child: AutoSizeText(
//                                         addressSuggestion != null
//                                             ? addressSuggestion
//                                             : '',
//                                         style: inputTextStyle(
//                                             SizeConfig.inputFontSize)))))
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
//                               controller: address1Controller,
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
//                               controller: address2Controller,
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
//                           width: Responsive.width(100, context),
//                           height: SizeConfig.inputHeight,
//                           child: TextField(
//                             controller: townController,
//                             style: inputTextStyle(SizeConfig.inputFontSize),
//                             decoration: InputDecoration(
//                               focusedBorder: inputFocusedBorderStyle(),
//                               enabledBorder: inputBorderStyle(),
//                               hintStyle:
//                                   placeholderStyle(SizeConfig.labelFontSize),
//                               contentPadding: EdgeInsets.fromLTRB(5, 0, 3, 16),
//                             ),
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
//                           child: AutoSizeText("Postcode*",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                           width: Responsive.width(100, context),
//                           height: SizeConfig.inputHeight,
//                           child: TextField(
//                             controller: postcodeController,
//                             style: inputTextStyle(SizeConfig.inputFontSize),
//                             decoration: InputDecoration(
//                               focusedBorder: inputFocusedBorderStyle(),
//                               enabledBorder: inputBorderStyle(),
//                               hintStyle:
//                                   placeholderStyle(SizeConfig.labelFontSize),
//                               contentPadding: EdgeInsets.fromLTRB(5, 0, 3, 16),
//                             ),
//                           ),
//                         )
//                       ],
//                     )),
//               ],
//             ),
//           ),
//         ));
//   }
//
//   Widget licenceDetailsStep(BuildContext context, BoxConstraints constraints) {
//     return Container(
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
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: Responsive.width(100, context),
//                           margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                           child: AutoSizeText("ADI No.*",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             child: TextField(
//                                 controller: licenseController,
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
//                           child: Text("Expiry Date",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                           width: Responsive.width(100, context),
//                           height: SizeConfig.inputHeight,
//                           child: DateTimeField(
//                             controller: expiryDateController,
//                             textAlign: TextAlign.left,
//                             format: DateFormat('dd-MM-yyyy'),
//                             readOnly: true,
//                             style: inputTextStyle(SizeConfig.inputFontSize),
//                             decoration: InputDecoration(
//                               hintText: "DD-MM-YYYY",
//                               hintStyle:
//                                   placeholderStyle(SizeConfig.labelFontSize),
//                               suffixIcon: Container(
//                                 child: Icon(Icons.calendar_today,
//                                     size: SizeConfig.labelFontSize,
//                                     color: Colors.black38),
//                                 margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
//                               ),
//                               focusedBorder: inputFocusedBorderStyle(),
//                               enabledBorder: inputBorderStyle(),
//                               contentPadding: EdgeInsets.fromLTRB(5, 10, 0, 0),
//                             ),
//                             onShowPicker: (context, currentValue) {
//                               return showDatePicker(
//                                   context: context,
//                                   firstDate: DateTime(1990, 1, 1),
//                                   initialDate:
//                                       currentValue ?? DateTime(2000, 6, 16),
//                                   lastDate: DateTime(2030, 12, 30));
//                             },
//                           ),
//                         )
//                       ],
//                     )),
//                 Container(
//                   width: Responsive.width(100, context),
//                   margin: EdgeInsets.only(bottom: 0),
//                   child: Text('ADI Card Image Front*',
//                       style: inputLabelStyle(SizeConfig.labelFontSize)),
//                 ),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.symmetric(vertical: 10),
//                     child: Row(
//                       children: [
//                         if (licenseFront != null ||
//                             licenceFrontHttpPath != null)
//                           Container(
//                               width: 15 * SizeConfig.blockSizeVertical,
//                               height: 14 * SizeConfig.blockSizeVertical,
//                               alignment: Alignment(
//                                   0, -.2 * SizeConfig.blockSizeVertical),
//                               child: Stack(
//                                 children: [
//                                   Container(
//                                       margin: EdgeInsets.fromLTRB(0, 15, 20, 0),
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           Navigator.of(context).push(
//                                               PageRouteBuilder(
//                                                   opaque: false,
//                                                   pageBuilder: (BuildContext
//                                                               context,
//                                                           _,
//                                                           __) =>
//                                                       ZoomView(
//                                                           licenceFrontHttpPath ??
//                                                               licenseFront!
//                                                                   .path,
//                                                           licenceFrontHttpPath !=
//                                                                   null
//                                                               ? 'http'
//                                                               : 'file')));
//                                         },
//                                         child: licenceFrontHttpPath != null
//                                             ? Image.network(
//                                                 licenceFrontHttpPath!,
//                                                 width: 100,
//                                                 height: 100,
//                                                 fit: BoxFit.cover)
//                                             : Image.file(
//                                                 File(licenseFront!.path),
//                                                 width: 100,
//                                                 height: 100,
//                                                 fit: BoxFit.cover),
//                                       )),
//                                   Positioned(
//                                     top: -10,
//                                     right: 0,
//                                     child: IconButton(
//                                       icon: Icon(Icons.remove_circle),
//                                       iconSize: 30,
//                                       color: Colors.red,
//                                       onPressed: () {
//                                         print("pressed");
//                                         this.setState(() {
//                                           licenseFront = null;
//                                           licenceFrontHttpPath = null;
//                                           licenceFrontBase64 = "";
//                                         });
//                                       },
//                                     ),
//                                   )
//                                 ],
//                               )),
//                         if (licenseFront == null &&
//                             licenceFrontHttpPath == null)
//                           Container(
//                             child: IconButton(
//                               icon: Icon(Icons.camera_alt),
//                               iconSize: 5 * SizeConfig.blockSizeVertical,
//                               color: Colors.blue,
//                               tooltip: 'Add Image By Camera',
//                               onPressed: _openCamera,
//                             ),
//                           ),
//                         if (licenseFront == null &&
//                             licenceFrontHttpPath == null)
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
//                   margin: EdgeInsets.only(bottom: 0),
//                   child: Text('ADI Card Image Back*',
//                       style: inputLabelStyle(SizeConfig.labelFontSize)),
//                 ),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.symmetric(vertical: 10),
//                     //color: Colors.black12,
//                     child: Row(
//                       children: [
//                         if (licenseBack != null || licenceBackHttpPath != null)
//                           Container(
//                               width: 15 * SizeConfig.blockSizeVertical,
//                               height: 14 * SizeConfig.blockSizeVertical,
//                               alignment: Alignment(
//                                   0, -.2 * SizeConfig.blockSizeVertical),
//                               child: Stack(
//                                 children: [
//                                   Container(
//                                       margin: EdgeInsets.fromLTRB(0, 15, 20, 0),
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           Navigator.of(context).push(
//                                               PageRouteBuilder(
//                                                   opaque: false,
//                                                   pageBuilder: (BuildContext
//                                                               context,
//                                                           _,
//                                                           __) =>
//                                                       ZoomView(
//                                                           licenceBackHttpPath ??
//                                                               licenseBack!.path,
//                                                           licenceBackHttpPath !=
//                                                                   null
//                                                               ? 'http'
//                                                               : 'file')));
//                                         },
//                                         child: licenceBackHttpPath != null
//                                             ? Image.network(
//                                                 licenceBackHttpPath!,
//                                                 width: 100,
//                                                 height: 100,
//                                                 fit: BoxFit.cover)
//                                             : Image.file(
//                                                 File(licenseBack!.path),
//                                                 width: 100,
//                                                 height: 100,
//                                                 fit: BoxFit.cover),
//                                       )),
//                                   Positioned(
//                                     top: -10,
//                                     right: 0,
//                                     child: IconButton(
//                                       icon: Icon(Icons.remove_circle),
//                                       iconSize: 30,
//                                       color: Colors.red,
//                                       onPressed: () {
//                                         print("pressed");
//                                         this.setState(() {
//                                           licenseBack = null;
//                                           licenceBackHttpPath = null;
//                                           licenceBackBase64 = "";
//                                         });
//                                       },
//                                     ),
//                                   )
//                                 ],
//                               )),
//                         if (licenseBack == null && licenceBackHttpPath == null)
//                           Container(
//                             child: IconButton(
//                               icon: Icon(Icons.camera_alt),
//                               iconSize: 5 * SizeConfig.blockSizeVertical,
//                               color: Colors.blue,
//                               tooltip: 'Add Image By Camera',
//                               onPressed: _openCamera1,
//                             ),
//                           ),
//                         if (licenseBack == null && licenceBackHttpPath == null)
//                           Container(
//                             child: IconButton(
//                               icon: Icon(Icons.folder_open),
//                               iconSize: 5 * SizeConfig.blockSizeVertical,
//                               color: Colors.blue,
//                               tooltip: 'Add Image/File By Gallery',
//                               onPressed: _openGallery1,
//                             ),
//                           ),
//                       ],
//                     )),
//               ],
//             ),
//           ),
//         ));
//   }
//
//   Widget otherDetailsStep(BuildContext context, BoxConstraints constraints) {
//     return Container(
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
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: Responsive.width(100, context),
//                           margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                           child: AutoSizeText("Languages Spoken",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             child: TextField(
//                                 controller: languageController,
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
//                           child: AutoSizeText("Referred By",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             child: TextField(
//                                 controller: referredController,
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
//                           child: AutoSizeText("Postcodes Covered",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             child: TextField(
//                                 controller: postcodeCoverController,
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
//                           child: AutoSizeText(
//                               "Distance you can travel to take lesson",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             child: TextField(
//                                 controller: distanceController,
//                                 style: inputTextStyle(SizeConfig.inputFontSize),
//                                 decoration: InputDecoration(
//                                   focusedBorder: inputFocusedBorderStyle(),
//                                   enabledBorder: inputBorderStyle(),
//                                   hintStyle: placeholderStyle(
//                                       SizeConfig.labelFontSize),
//                                   contentPadding:
//                                       EdgeInsets.fromLTRB(5, 0, 3, 16),
//                                 ),
//                                 keyboardType: TextInputType.number,
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
//                           child: AutoSizeText(
//                               "Number of Students successfully trained",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             child: TextField(
//                               controller: studentTrainedController,
//                               style: inputTextStyle(SizeConfig.inputFontSize),
//                               decoration: InputDecoration(
//                                 focusedBorder: inputFocusedBorderStyle(),
//                                 enabledBorder: inputBorderStyle(),
//                                 hintStyle:
//                                     placeholderStyle(SizeConfig.labelFontSize),
//                                 contentPadding:
//                                     EdgeInsets.fromLTRB(5, 0, 3, 16),
//                               ),
//                               keyboardType: TextInputType.number,
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
//                           child: AutoSizeText("Years of experience",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                           width: Responsive.width(100, context),
//                           height: SizeConfig.inputHeight,
//                           child: TextField(
//                             controller: yearExpController,
//                             style: inputTextStyle(SizeConfig.inputFontSize),
//                             decoration: InputDecoration(
//                               focusedBorder: inputFocusedBorderStyle(),
//                               enabledBorder: inputBorderStyle(),
//                               hintStyle:
//                                   placeholderStyle(SizeConfig.labelFontSize),
//                               contentPadding: EdgeInsets.fromLTRB(5, 0, 3, 16),
//                             ),
//                             keyboardType: TextInputType.number,
//                           ),
//                         )
//                       ],
//                     )),
//               ],
//             ),
//           ),
//         ));
//   }
//
//   Widget carDetailsStep(BuildContext context, BoxConstraints constraints) {
//     return Container(
//         width: Responsive.width(90, context),
//         //color: Colors.black12,
//         //alignment: Alignment.center,
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
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: Responsive.width(100, context),
//                   margin: EdgeInsets.only(bottom: 10, top: 0),
//                   child: AutoSizeText(
//                       "Please provide details of the car that you use for providing instruction:",
//                       style: inputLabelStyle(SizeConfig.labelFontSize),
//                       textAlign: TextAlign.left),
//                 ),
//                 Container(
//                     width: Responsive.width(90, context),
//                     margin: EdgeInsets.only(bottom: 10, top: 0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(constraints.maxWidth * 0.025),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Color.fromRGBO(0, 0, 0, 0.16),
//                           blurRadius: 6.0, // soften the shadow
//                           spreadRadius: 1.0, //extend the shadow
//                           offset: Offset(
//                             3.0, // Move to right 10  horizontally
//                             0.0, // Move to bottom 10 Vertically
//                           ),
//                         )
//                       ],
//                     ),
//                     child: ExpansionTile(
//                       maintainState: true,
//                       tilePadding: EdgeInsets.only(
//                           left: constraints.maxWidth * 0.02,
//                           right: constraints.maxWidth * 0.03,
//                           top: 0.0,
//                           bottom: 0.0),
//                       leading: Checkbox(
//                         value: this.carManual,
//                         onChanged: (bool? value) {
//                           print("$value 1");
//                           setState(() {
//                             this.carManual = value!;
//                             print("$carManual 2");
//                           });
//                         },
//                       ),
//                       title: AutoSizeText("Manual Car",
//                           style: inputLabelStyle(SizeConfig.labelFontSize),
//                           textAlign: TextAlign.left),
//                       children: [
//                         Container(
//                             width: Responsive.width(80, context),
//                             margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   width: Responsive.width(100, context),
//                                   margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                                   child: AutoSizeText("Car Make*",
//                                       style: inputLabelStyle(
//                                           SizeConfig.labelFontSize),
//                                       textAlign: TextAlign.left),
//                                 ),
//                                 Container(
//                                     width: Responsive.width(100, context),
//                                     height: SizeConfig.inputHeight,
//                                     child: TextField(
//                                         controller: manualMakeController,
//                                         style: inputTextStyle(
//                                             SizeConfig.inputFontSize),
//                                         decoration: InputDecoration(
//                                           focusedBorder:
//                                               inputFocusedBorderStyle(),
//                                           enabledBorder: inputBorderStyle(),
//                                           hintStyle: placeholderStyle(
//                                               SizeConfig.labelFontSize),
//                                           contentPadding:
//                                               EdgeInsets.fromLTRB(5, 0, 3, 16),
//                                         ),
//                                         keyboardType: TextInputType.text,
//                                         onChanged: (value) {}))
//                               ],
//                             )),
//                         Container(
//                             width: Responsive.width(80, context),
//                             margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   width: Responsive.width(100, context),
//                                   margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                                   child: AutoSizeText("Car Model*",
//                                       style: inputLabelStyle(
//                                           SizeConfig.labelFontSize),
//                                       textAlign: TextAlign.left),
//                                 ),
//                                 Container(
//                                     width: Responsive.width(100, context),
//                                     height: SizeConfig.inputHeight,
//                                     child: TextField(
//                                         controller: manualModelController,
//                                         style: inputTextStyle(
//                                             SizeConfig.inputFontSize),
//                                         decoration: InputDecoration(
//                                           focusedBorder:
//                                               inputFocusedBorderStyle(),
//                                           enabledBorder: inputBorderStyle(),
//                                           hintStyle: placeholderStyle(
//                                               SizeConfig.labelFontSize),
//                                           contentPadding:
//                                               EdgeInsets.fromLTRB(5, 0, 3, 16),
//                                         ),
//                                         keyboardType: TextInputType.text,
//                                         onChanged: (value) {}))
//                               ],
//                             )),
//                         Container(
//                             width: Responsive.width(80, context),
//                             margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   width: Responsive.width(100, context),
//                                   margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                                   child: AutoSizeText("Car Color*",
//                                       style: inputLabelStyle(
//                                           SizeConfig.labelFontSize),
//                                       textAlign: TextAlign.left),
//                                 ),
//                                 Container(
//                                     width: Responsive.width(100, context),
//                                     height: SizeConfig.inputHeight,
//                                     child: TextField(
//                                         controller: manualColorController,
//                                         style: inputTextStyle(
//                                             SizeConfig.inputFontSize),
//                                         decoration: InputDecoration(
//                                           focusedBorder:
//                                               inputFocusedBorderStyle(),
//                                           enabledBorder: inputBorderStyle(),
//                                           hintStyle: placeholderStyle(
//                                               SizeConfig.labelFontSize),
//                                           contentPadding:
//                                               EdgeInsets.fromLTRB(5, 0, 3, 16),
//                                         ),
//                                         keyboardType: TextInputType.text,
//                                         onChanged: (value) {}))
//                               ],
//                             )),
//                         Container(
//                             width: Responsive.width(80, context),
//                             margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   width: Responsive.width(100, context),
//                                   margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                                   child: AutoSizeText(
//                                       "Car Registration Number*",
//                                       style: inputLabelStyle(
//                                           SizeConfig.labelFontSize),
//                                       textAlign: TextAlign.left),
//                                 ),
//                                 Container(
//                                     width: Responsive.width(100, context),
//                                     height: SizeConfig.inputHeight,
//                                     child: TextField(
//                                         controller: manualRegController,
//                                         style: inputTextStyle(
//                                             SizeConfig.inputFontSize),
//                                         decoration: InputDecoration(
//                                           focusedBorder:
//                                               inputFocusedBorderStyle(),
//                                           enabledBorder: inputBorderStyle(),
//                                           hintStyle: placeholderStyle(
//                                               SizeConfig.labelFontSize),
//                                           contentPadding:
//                                               EdgeInsets.fromLTRB(5, 0, 3, 16),
//                                         ),
//                                         keyboardType: TextInputType.text,
//                                         onChanged: (value) {}))
//                               ],
//                             )),
//                         Container(
//                             width: Responsive.width(80, context),
//                             margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   width: Responsive.width(100, context),
//                                   margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                                   child: AutoSizeText("Hourly Rate Own Car*",
//                                       style: inputLabelStyle(
//                                           SizeConfig.labelFontSize),
//                                       textAlign: TextAlign.left),
//                                 ),
//                                 Container(
//                                     width: Responsive.width(100, context),
//                                     height: SizeConfig.inputHeight,
//                                     child: TextField(
//                                         controller: manualOwnCarRateController,
//                                         style: inputTextStyle(
//                                             SizeConfig.inputFontSize),
//                                         decoration: InputDecoration(
//                                           focusedBorder:
//                                               inputFocusedBorderStyle(),
//                                           enabledBorder: inputBorderStyle(),
//                                           hintStyle: placeholderStyle(
//                                               SizeConfig.labelFontSize),
//                                           contentPadding:
//                                               EdgeInsets.fromLTRB(5, 0, 3, 16),
//                                         ),
//                                         keyboardType: TextInputType.number,
//                                         onChanged: (value) {}))
//                               ],
//                             )),
//                         Container(
//                             width: Responsive.width(80, context),
//                             margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   width: Responsive.width(100, context),
//                                   margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                                   child: AutoSizeText(
//                                       "Hourly Rate Customer Car*",
//                                       style: inputLabelStyle(
//                                           SizeConfig.labelFontSize),
//                                       textAlign: TextAlign.left),
//                                 ),
//                                 Container(
//                                     width: Responsive.width(100, context),
//                                     height: SizeConfig.inputHeight,
//                                     child: TextField(
//                                         controller:
//                                             manualCustomerCarRateController,
//                                         style: inputTextStyle(
//                                             SizeConfig.inputFontSize),
//                                         decoration: InputDecoration(
//                                           focusedBorder:
//                                               inputFocusedBorderStyle(),
//                                           enabledBorder: inputBorderStyle(),
//                                           hintStyle: placeholderStyle(
//                                               SizeConfig.labelFontSize),
//                                           contentPadding:
//                                               EdgeInsets.fromLTRB(5, 0, 3, 16),
//                                         ),
//                                         keyboardType: TextInputType.number,
//                                         onChanged: (value) {}))
//                               ],
//                             )),
//                         Container(
//                             width: Responsive.width(80, context),
//                             margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   width: Responsive.width(100, context),
//                                   margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                                   child: AutoSizeText("Insurance Provider",
//                                       style: inputLabelStyle(
//                                           SizeConfig.labelFontSize),
//                                       textAlign: TextAlign.left),
//                                 ),
//                                 Container(
//                                     width: Responsive.width(100, context),
//                                     height: SizeConfig.inputHeight,
//                                     child: TypeAheadField(
//                                       debounceDuration:
//                                           Duration(milliseconds: 0),
//                                       animationDuration:
//                                           Duration(milliseconds: 0),
//                                       hideKeyboard: true,
//                                       textFieldConfiguration:
//                                           TextFieldConfiguration(
//                                         textAlign: TextAlign.left,
//                                         controller:
//                                             manualInsuranceProviderDropController,
//                                         style: inputTextStyle(
//                                             SizeConfig.inputFontSize),
//                                         decoration: InputDecoration(
//                                           focusedBorder:
//                                               inputFocusedBorderStyle(),
//                                           enabledBorder: inputBorderStyle(),
//                                           hintText: '--Insurance Provider--',
//                                           hintStyle: placeholderStyle(
//                                               SizeConfig.labelFontSize),
//                                           contentPadding:
//                                               EdgeInsets.fromLTRB(5, 10, 3, 10),
//                                         ),
//                                       ),
//                                       suggestionsBoxDecoration:
//                                           SuggestionsBoxDecoration(
//                                               elevation: 5,
//                                               constraints: BoxConstraints(
//                                                   maxHeight: 250)),
//                                       suggestionsCallback: (pattern) async {
//                                         return suggestion;
//                                       },
//                                       itemBuilder: (context, suggestion) {
//                                         //print(suggestion);
//                                         suggestion as dynamic;
//                                         return ListTile(
//                                           title: AutoSizeText(
//                                               suggestion['details']),
//                                         );
//                                       },
//                                       onSuggestionSelected: (suggestion) {
//                                         suggestion as dynamic;
//
//                                         print(manualInsuranceProvider);
//                                         print(suggestion);
//                                         try {
//                                           setState(() {
//                                             manualInsuranceProvider =
//                                                 suggestion['name'];
//                                             manualInsuranceProviderDropController
//                                                 .text = suggestion['details'];
//                                           });
//                                         } catch (e) {
//                                           print(e);
//                                         }
//                                       },
//                                     ))
//                               ],
//                             )),
//                         Container(
//                             width: Responsive.width(80, context),
//                             margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   width: Responsive.width(100, context),
//                                   margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                                   child: AutoSizeText("Insurance Renewal date",
//                                       style: inputLabelStyle(
//                                           SizeConfig.labelFontSize),
//                                       textAlign: TextAlign.left),
//                                 ),
//                                 Container(
//                                   width: Responsive.width(100, context),
//                                   height: SizeConfig.inputHeight,
//                                   child: DateTimeField(
//                                     controller:
//                                         manualInsuranceRenewalController,
//                                     textAlign: TextAlign.left,
//                                     format: DateFormat('dd-MM-yyyy'),
//                                     readOnly: true,
//                                     style: inputTextStyle(
//                                         SizeConfig.inputFontSize),
//                                     decoration: InputDecoration(
//                                       hintText: "DD-MM-YYYY",
//                                       hintStyle: placeholderStyle(
//                                           SizeConfig.labelFontSize),
//                                       suffixIcon: Container(
//                                         child: Icon(Icons.calendar_today,
//                                             size: SizeConfig.labelFontSize,
//                                             color: Colors.black38),
//                                         margin:
//                                             EdgeInsets.fromLTRB(15, 0, 0, 0),
//                                       ),
//                                       focusedBorder: inputFocusedBorderStyle(),
//                                       enabledBorder: inputBorderStyle(),
//                                       contentPadding:
//                                           EdgeInsets.fromLTRB(5, 10, 0, 0),
//                                     ),
//                                     onShowPicker: (context, currentValue) {
//                                       return showDatePicker(
//                                           context: context,
//                                           firstDate: DateTime(1990, 1, 1),
//                                           initialDate: currentValue ??
//                                               DateTime(2000, 6, 16),
//                                           lastDate: DateTime(2030, 12, 30));
//                                     },
//                                   ),
//                                 )
//                               ],
//                             )),
//                       ],
//                       initiallyExpanded: carManual ? true : false,
//                     )),
//                 Container(
//                     width: Responsive.width(90, context),
//                     margin: EdgeInsets.only(bottom: 15, top: 0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(constraints.maxWidth * 0.025),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Color.fromRGBO(0, 0, 0, 0.16),
//                           blurRadius: 6.0, // soften the shadow
//                           spreadRadius: 1.0, //extend the shadow
//                           offset: Offset(
//                             3.0, // Move to right 10  horizontally
//                             0.0, // Move to bottom 10 Vertically
//                           ),
//                         )
//                       ],
//                     ),
//                     child: ExpansionTile(
//                       maintainState: true,
//                       tilePadding: EdgeInsets.only(
//                           left: constraints.maxWidth * 0.02,
//                           right: constraints.maxWidth * 0.03,
//                           top: 0.0,
//                           bottom: 0.0),
//                       leading: Checkbox(
//                         value: this.carAuto,
//                         onChanged: (bool? value) {
//                           print("$value 1");
//                           setState(() {
//                             this.carAuto = value!;
//                             print("$carAuto 2");
//                           });
//                         },
//                       ),
//                       title: AutoSizeText("Automatic Car",
//                           style: inputLabelStyle(SizeConfig.labelFontSize),
//                           textAlign: TextAlign.left),
//                       children: [
//                         Container(
//                             width: Responsive.width(80, context),
//                             margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   width: Responsive.width(100, context),
//                                   margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                                   child: AutoSizeText("Car Make*",
//                                       style: inputLabelStyle(
//                                           SizeConfig.labelFontSize),
//                                       textAlign: TextAlign.left),
//                                 ),
//                                 Container(
//                                     width: Responsive.width(100, context),
//                                     height: SizeConfig.inputHeight,
//                                     child: TextField(
//                                         controller: autoMakeController,
//                                         style: inputTextStyle(
//                                             SizeConfig.inputFontSize),
//                                         decoration: InputDecoration(
//                                           focusedBorder:
//                                               inputFocusedBorderStyle(),
//                                           enabledBorder: inputBorderStyle(),
//                                           hintStyle: placeholderStyle(
//                                               SizeConfig.labelFontSize),
//                                           contentPadding:
//                                               EdgeInsets.fromLTRB(5, 0, 3, 16),
//                                         ),
//                                         keyboardType: TextInputType.text,
//                                         onChanged: (value) {}))
//                               ],
//                             )),
//                         Container(
//                             width: Responsive.width(80, context),
//                             margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   width: Responsive.width(100, context),
//                                   margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                                   child: AutoSizeText("Car Model*",
//                                       style: inputLabelStyle(
//                                           SizeConfig.labelFontSize),
//                                       textAlign: TextAlign.left),
//                                 ),
//                                 Container(
//                                     width: Responsive.width(100, context),
//                                     height: SizeConfig.inputHeight,
//                                     child: TextField(
//                                         controller: autoModelController,
//                                         style: inputTextStyle(
//                                             SizeConfig.inputFontSize),
//                                         decoration: InputDecoration(
//                                           focusedBorder:
//                                               inputFocusedBorderStyle(),
//                                           enabledBorder: inputBorderStyle(),
//                                           hintStyle: placeholderStyle(
//                                               SizeConfig.labelFontSize),
//                                           contentPadding:
//                                               EdgeInsets.fromLTRB(5, 0, 3, 16),
//                                         ),
//                                         keyboardType: TextInputType.text,
//                                         onChanged: (value) {}))
//                               ],
//                             )),
//                         Container(
//                             width: Responsive.width(80, context),
//                             margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   width: Responsive.width(100, context),
//                                   margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                                   child: AutoSizeText("Car Color*",
//                                       style: inputLabelStyle(
//                                           SizeConfig.labelFontSize),
//                                       textAlign: TextAlign.left),
//                                 ),
//                                 Container(
//                                     width: Responsive.width(100, context),
//                                     height: SizeConfig.inputHeight,
//                                     child: TextField(
//                                         controller: autoColorController,
//                                         style: inputTextStyle(
//                                             SizeConfig.inputFontSize),
//                                         decoration: InputDecoration(
//                                           focusedBorder:
//                                               inputFocusedBorderStyle(),
//                                           enabledBorder: inputBorderStyle(),
//                                           hintStyle: placeholderStyle(
//                                               SizeConfig.labelFontSize),
//                                           contentPadding:
//                                               EdgeInsets.fromLTRB(5, 0, 3, 16),
//                                         ),
//                                         keyboardType: TextInputType.text,
//                                         onChanged: (value) {}))
//                               ],
//                             )),
//                         Container(
//                             width: Responsive.width(80, context),
//                             margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   width: Responsive.width(100, context),
//                                   margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                                   child: AutoSizeText(
//                                       "Car Registration Number*",
//                                       style: inputLabelStyle(
//                                           SizeConfig.labelFontSize),
//                                       textAlign: TextAlign.left),
//                                 ),
//                                 Container(
//                                     width: Responsive.width(100, context),
//                                     height: SizeConfig.inputHeight,
//                                     child: TextField(
//                                         controller: autoRegController,
//                                         style: inputTextStyle(
//                                             SizeConfig.inputFontSize),
//                                         decoration: InputDecoration(
//                                           focusedBorder:
//                                               inputFocusedBorderStyle(),
//                                           enabledBorder: inputBorderStyle(),
//                                           hintStyle: placeholderStyle(
//                                               SizeConfig.labelFontSize),
//                                           contentPadding:
//                                               EdgeInsets.fromLTRB(5, 0, 3, 16),
//                                         ),
//                                         keyboardType: TextInputType.text,
//                                         onChanged: (value) {}))
//                               ],
//                             )),
//                         Container(
//                             width: Responsive.width(80, context),
//                             margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   width: Responsive.width(100, context),
//                                   margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                                   child: AutoSizeText("Hourly Rate Own Car*",
//                                       style: inputLabelStyle(
//                                           SizeConfig.labelFontSize),
//                                       textAlign: TextAlign.left),
//                                 ),
//                                 Container(
//                                     width: Responsive.width(100, context),
//                                     height: SizeConfig.inputHeight,
//                                     child: TextField(
//                                         controller: autoOwnCarRateController,
//                                         style: inputTextStyle(
//                                             SizeConfig.inputFontSize),
//                                         decoration: InputDecoration(
//                                           focusedBorder:
//                                               inputFocusedBorderStyle(),
//                                           enabledBorder: inputBorderStyle(),
//                                           hintStyle: placeholderStyle(
//                                               SizeConfig.labelFontSize),
//                                           contentPadding:
//                                               EdgeInsets.fromLTRB(5, 0, 3, 16),
//                                         ),
//                                         keyboardType: TextInputType.number,
//                                         onChanged: (value) {}))
//                               ],
//                             )),
//                         Container(
//                             width: Responsive.width(80, context),
//                             margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   width: Responsive.width(100, context),
//                                   margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                                   child: AutoSizeText(
//                                       "Hourly Rate Customer Car*",
//                                       style: inputLabelStyle(
//                                           SizeConfig.labelFontSize),
//                                       textAlign: TextAlign.left),
//                                 ),
//                                 Container(
//                                     width: Responsive.width(100, context),
//                                     height: SizeConfig.inputHeight,
//                                     child: TextField(
//                                         controller:
//                                             autoCustomerCarRateController,
//                                         style: inputTextStyle(
//                                             SizeConfig.inputFontSize),
//                                         decoration: InputDecoration(
//                                           focusedBorder:
//                                               inputFocusedBorderStyle(),
//                                           enabledBorder: inputBorderStyle(),
//                                           hintStyle: placeholderStyle(
//                                               SizeConfig.labelFontSize),
//                                           contentPadding:
//                                               EdgeInsets.fromLTRB(5, 0, 3, 16),
//                                         ),
//                                         keyboardType: TextInputType.number,
//                                         onChanged: (value) {}))
//                               ],
//                             )),
//                         Container(
//                             width: Responsive.width(80, context),
//                             margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   width: Responsive.width(100, context),
//                                   margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                                   child: AutoSizeText("Insurance Provider",
//                                       style: inputLabelStyle(
//                                           SizeConfig.labelFontSize),
//                                       textAlign: TextAlign.left),
//                                 ),
//                                 Container(
//                                     width: Responsive.width(100, context),
//                                     height: SizeConfig.inputHeight,
//                                     child: TypeAheadField(
//                                       debounceDuration:
//                                           Duration(milliseconds: 0),
//                                       animationDuration:
//                                           Duration(milliseconds: 0),
//                                       hideKeyboard: true,
//                                       textFieldConfiguration:
//                                           TextFieldConfiguration(
//                                         textAlign: TextAlign.left,
//                                         controller: this
//                                             .autoInsuranceProviderDropController,
//                                         style: inputTextStyle(
//                                             SizeConfig.inputFontSize),
//                                         decoration: InputDecoration(
//                                           focusedBorder:
//                                               inputFocusedBorderStyle(),
//                                           enabledBorder: inputBorderStyle(),
//                                           hintText: '--Insurance Provider--',
//                                           hintStyle: placeholderStyle(
//                                               SizeConfig.labelFontSize),
//                                           contentPadding:
//                                               EdgeInsets.fromLTRB(5, 10, 3, 10),
//                                         ),
//                                       ),
//                                       suggestionsBoxDecoration:
//                                           SuggestionsBoxDecoration(
//                                               elevation: 5,
//                                               constraints: BoxConstraints(
//                                                   maxHeight: 250)),
//                                       suggestionsCallback: (pattern) async {
//                                         return suggestion;
//                                       },
//                                       itemBuilder: (context, suggestion) {
//                                         suggestion as dynamic;
//
//                                         return ListTile(
//                                           title: AutoSizeText(
//                                               suggestion['details'].toString()),
//                                         );
//                                       },
//                                       onSuggestionSelected: (suggestion) {
//                                         try {
//                                           suggestion as dynamic;
//
//                                           setState(() {
//                                             this.autoInsuranceProvider =
//                                                 suggestion['name'];
//                                             this
//                                                 .autoInsuranceProviderDropController
//                                                 .text = suggestion['details'];
//                                             //print(manualInsuranceProvider);
//                                           });
//                                         } catch (e) {
//                                           print(e);
//                                         }
//                                       },
//                                     ))
//                               ],
//                             )),
//                         Container(
//                             width: Responsive.width(80, context),
//                             margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   width: Responsive.width(100, context),
//                                   margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                                   child: AutoSizeText("Insurance Renewal date",
//                                       style: inputLabelStyle(
//                                           SizeConfig.labelFontSize),
//                                       textAlign: TextAlign.left),
//                                 ),
//                                 Container(
//                                   width: Responsive.width(100, context),
//                                   height: SizeConfig.inputHeight,
//                                   child: DateTimeField(
//                                     controller: autoInsuranceRenewalController,
//                                     textAlign: TextAlign.left,
//                                     format: DateFormat('dd-MM-yyyy'),
//                                     readOnly: true,
//                                     style: inputTextStyle(
//                                         SizeConfig.inputFontSize),
//                                     decoration: InputDecoration(
//                                       hintText: "DD-MM-YYYY",
//                                       hintStyle: placeholderStyle(
//                                           SizeConfig.labelFontSize),
//                                       suffixIcon: Container(
//                                         child: Icon(Icons.calendar_today,
//                                             size: SizeConfig.labelFontSize,
//                                             color: Colors.black38),
//                                         margin:
//                                             EdgeInsets.fromLTRB(15, 0, 0, 0),
//                                       ),
//                                       focusedBorder: inputFocusedBorderStyle(),
//                                       enabledBorder: inputBorderStyle(),
//                                       contentPadding:
//                                           EdgeInsets.fromLTRB(5, 10, 0, 0),
//                                     ),
//                                     onShowPicker: (context, currentValue) {
//                                       return showDatePicker(
//                                           context: context,
//                                           firstDate: DateTime(1990, 1, 1),
//                                           initialDate: currentValue ??
//                                               DateTime(2000, 6, 16),
//                                           lastDate: DateTime(2030, 12, 30));
//                                     },
//                                   ),
//                                 )
//                               ],
//                             )),
//                       ],
//                       initiallyExpanded: carAuto ? true : false,
//                     )),
//                 Container(
//                   width: Responsive.width(100, context),
//                   margin: EdgeInsets.only(bottom: 2, top: 0),
//                   child: AutoSizeText(
//                       "Ready to provide theory tuition at £20 per hour?",
//                       style: inputLabelStyleDark(SizeConfig.labelFontSize),
//                       textAlign: TextAlign.left),
//                 ),
//                 Container(
//                   width: Responsive.width(100, context),
//                   height: 3 * SizeConfig.blockSizeVertical,
//                   margin: EdgeInsets.only(bottom: 5, top: 0),
//                   alignment: Alignment.bottomLeft,
//                   //color: Colors.black12,
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       return Row(
//                         children: [
//                           Container(
//                               //color:Colors.black26,
//                               width: constraints.maxWidth * 0.1,
//                               height: 2 * SizeConfig.blockSizeVertical,
//                               alignment: Alignment.topLeft,
//                               padding: EdgeInsets.all(0),
//                               child: Transform.scale(
//                                 scale: .1 * SizeConfig.blockSizeVertical,
//                                 child: Radio(
//                                   value: 1,
//                                   groupValue: _radValue1,
//                                   activeColor: Dark,
//                                   onChanged: (int? value) {
//                                     setState(() {
//                                       _radValue1 = value!;
//                                     });
//                                   },
//                                 ),
//                               )),
//                           Container(
//                             width: constraints.maxWidth * 0.1,
//                             height: 2 * SizeConfig.blockSizeVertical,
//                             alignment: Alignment.bottomLeft,
//                             //margin: EdgeInsets.only(left: constraints.maxWidth*0.02),
//                             //color: Colors.black26,
//                             child: AutoSizeText("Yes",
//                                 style: inputLabelStyleDark(
//                                     SizeConfig.labelFontSize),
//                                 textAlign: TextAlign.left),
//                           ),
//                           Container(
//                               width: constraints.maxWidth * 0.1,
//                               height: 4 * SizeConfig.blockSizeVertical,
//                               alignment: Alignment.topLeft,
//                               padding: EdgeInsets.all(0),
//                               child: Transform.scale(
//                                 scale: .1 * SizeConfig.blockSizeVertical,
//                                 child: Radio(
//                                   value: 0,
//                                   groupValue: _radValue1,
//                                   activeColor: Dark,
//                                   onChanged: (int? value) {
//                                     setState(() {
//                                       _radValue1 = value!;
//                                     });
//                                   },
//                                 ),
//                               )),
//                           Container(
//                             width: constraints.maxWidth * 0.1,
//                             height: 2 * SizeConfig.blockSizeVertical,
//                             alignment: Alignment.bottomLeft,
//                             //margin: EdgeInsets.only(left: constraints.maxWidth*0.02),
//                             //color: Colors.black26,
//                             child: AutoSizeText("No",
//                                 style: inputLabelStyleDark(
//                                     SizeConfig.labelFontSize),
//                                 textAlign: TextAlign.left),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 Container(
//                   width: Responsive.width(100, context),
//                   margin: EdgeInsets.only(bottom: 2, top: 0),
//                   child: AutoSizeText(
//                       "Are you ok to test the driver in his/her car?",
//                       style: inputLabelStyleDark(SizeConfig.labelFontSize),
//                       textAlign: TextAlign.left),
//                 ),
//                 Container(
//                   width: Responsive.width(100, context),
//                   height: 3 * SizeConfig.blockSizeVertical,
//                   margin: EdgeInsets.only(bottom: 5, top: 0),
//                   alignment: Alignment.bottomLeft,
//                   //color: Colors.black12,
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       return Row(
//                         children: [
//                           Container(
//                               //color:Colors.black26,
//                               width: constraints.maxWidth * 0.1,
//                               height: 2 * SizeConfig.blockSizeVertical,
//                               alignment: Alignment.topLeft,
//                               padding: EdgeInsets.all(0),
//                               child: Transform.scale(
//                                 scale: .1 * SizeConfig.blockSizeVertical,
//                                 child: Radio(
//                                   value: 1,
//                                   groupValue: _radValue2,
//                                   activeColor: Dark,
//                                   onChanged: (int? value) {
//                                     setState(() {
//                                       _radValue2 = value!;
//                                     });
//                                   },
//                                 ),
//                               )),
//                           Container(
//                             width: constraints.maxWidth * 0.1,
//                             height: 2 * SizeConfig.blockSizeVertical,
//                             alignment: Alignment.bottomLeft,
//                             //margin: EdgeInsets.only(left: constraints.maxWidth*0.02),
//                             //color: Colors.black26,
//                             child: AutoSizeText("Yes",
//                                 style: inputLabelStyleDark(
//                                     SizeConfig.labelFontSize),
//                                 textAlign: TextAlign.left),
//                           ),
//                           Container(
//                               width: constraints.maxWidth * 0.1,
//                               height: 4 * SizeConfig.blockSizeVertical,
//                               alignment: Alignment.topLeft,
//                               padding: EdgeInsets.all(0),
//                               child: Transform.scale(
//                                 scale: .1 * SizeConfig.blockSizeVertical,
//                                 child: Radio(
//                                   value: 0,
//                                   groupValue: _radValue2,
//                                   activeColor: Dark,
//                                   onChanged: (int? value) {
//                                     setState(() {
//                                       _radValue2 = value!;
//                                     });
//                                   },
//                                 ),
//                               )),
//                           Container(
//                             width: constraints.maxWidth * 0.1,
//                             height: 2 * SizeConfig.blockSizeVertical,
//                             alignment: Alignment.bottomLeft,
//                             //margin: EdgeInsets.only(left: constraints.maxWidth*0.02),
//                             //color: Colors.black26,
//                             child: AutoSizeText("No",
//                                 style: inputLabelStyleDark(
//                                     SizeConfig.labelFontSize),
//                                 textAlign: TextAlign.left),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 Container(
//                   width: Responsive.width(100, context),
//                   margin: EdgeInsets.only(bottom: 2, top: 0),
//                   child: AutoSizeText(
//                       "Are you ok to provide pass assist classes?",
//                       style: inputLabelStyleDark(SizeConfig.labelFontSize),
//                       textAlign: TextAlign.left),
//                 ),
//                 Container(
//                   width: Responsive.width(100, context),
//                   height: 3 * SizeConfig.blockSizeVertical,
//                   margin: EdgeInsets.only(bottom: 5, top: 0),
//                   alignment: Alignment.bottomLeft,
//                   //color: Colors.black12,
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       return Row(
//                         children: [
//                           Container(
//                               //color:Colors.black26,
//                               width: constraints.maxWidth * 0.1,
//                               height: 2 * SizeConfig.blockSizeVertical,
//                               alignment: Alignment.topLeft,
//                               padding: EdgeInsets.all(0),
//                               child: Transform.scale(
//                                 scale: .1 * SizeConfig.blockSizeVertical,
//                                 child: Radio(
//                                   value: 1,
//                                   groupValue: _radValue3,
//                                   activeColor: Dark,
//                                   onChanged: (int? value) {
//                                     setState(() {
//                                       _radValue3 = value!;
//                                     });
//                                   },
//                                 ),
//                               )),
//                           Container(
//                             width: constraints.maxWidth * 0.1,
//                             height: 2 * SizeConfig.blockSizeVertical,
//                             alignment: Alignment.bottomLeft,
//                             //margin: EdgeInsets.only(left: constraints.maxWidth*0.02),
//                             //color: Colors.black26,
//                             child: AutoSizeText("Yes",
//                                 style: inputLabelStyleDark(
//                                     SizeConfig.labelFontSize),
//                                 textAlign: TextAlign.left),
//                           ),
//                           Container(
//                               width: constraints.maxWidth * 0.1,
//                               height: 4 * SizeConfig.blockSizeVertical,
//                               alignment: Alignment.topLeft,
//                               padding: EdgeInsets.all(0),
//                               child: Transform.scale(
//                                 scale: .1 * SizeConfig.blockSizeVertical,
//                                 child: Radio(
//                                   value: 0,
//                                   groupValue: _radValue3,
//                                   activeColor: Dark,
//                                   onChanged: (int? value) {
//                                     setState(() {
//                                       _radValue3 = value!;
//                                     });
//                                   },
//                                 ),
//                               )),
//                           Container(
//                             width: constraints.maxWidth * 0.1,
//                             height: 2 * SizeConfig.blockSizeVertical,
//                             alignment: Alignment.bottomLeft,
//                             //margin: EdgeInsets.only(left: constraints.maxWidth*0.02),
//                             //color: Colors.black26,
//                             child: AutoSizeText("No",
//                                 style: inputLabelStyleDark(
//                                     SizeConfig.labelFontSize),
//                                 textAlign: TextAlign.left),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 Container(
//                   width: Responsive.width(100, context),
//                   margin: EdgeInsets.only(bottom: 2, top: 0),
//                   child: AutoSizeText(
//                       "Would you like to receive leads for driving lessons?",
//                       style: inputLabelStyleDark(SizeConfig.labelFontSize),
//                       textAlign: TextAlign.left),
//                 ),
//                 Container(
//                   width: Responsive.width(100, context),
//                   height: 3 * SizeConfig.blockSizeVertical,
//                   margin: EdgeInsets.only(bottom: 10, top: 0),
//                   alignment: Alignment.bottomLeft,
//                   //color: Colors.black12,
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       return Row(
//                         children: [
//                           Container(
//                               //color:Colors.black26,
//                               width: constraints.maxWidth * 0.1,
//                               height: 2 * SizeConfig.blockSizeVertical,
//                               alignment: Alignment.topLeft,
//                               padding: EdgeInsets.all(0),
//                               child: Transform.scale(
//                                 scale: .1 * SizeConfig.blockSizeVertical,
//                                 child: Radio(
//                                   value: 1,
//                                   groupValue: _radValue4,
//                                   activeColor: Dark,
//                                   onChanged: (int? value) {
//                                     setState(() {
//                                       _radValue4 = value!;
//                                     });
//                                   },
//                                 ),
//                               )),
//                           Container(
//                             width: constraints.maxWidth * 0.1,
//                             height: 2 * SizeConfig.blockSizeVertical,
//                             alignment: Alignment.bottomLeft,
//                             //margin: EdgeInsets.only(left: constraints.maxWidth*0.02),
//                             //color: Colors.black26,
//                             child: AutoSizeText("Yes",
//                                 style: inputLabelStyleDark(
//                                     SizeConfig.labelFontSize),
//                                 textAlign: TextAlign.left),
//                           ),
//                           Container(
//                               width: constraints.maxWidth * 0.1,
//                               height: 4 * SizeConfig.blockSizeVertical,
//                               alignment: Alignment.topLeft,
//                               padding: EdgeInsets.all(0),
//                               child: Transform.scale(
//                                 scale: .1 * SizeConfig.blockSizeVertical,
//                                 child: Radio(
//                                   value: 0,
//                                   groupValue: _radValue4,
//                                   activeColor: Dark,
//                                   onChanged: (int? value) {
//                                     setState(() {
//                                       _radValue4 = value!;
//                                     });
//                                   },
//                                 ),
//                               )),
//                           Container(
//                             width: constraints.maxWidth * 0.1,
//                             height: 2 * SizeConfig.blockSizeVertical,
//                             alignment: Alignment.bottomLeft,
//                             //margin: EdgeInsets.only(left: constraints.maxWidth*0.02),
//                             //color: Colors.black26,
//                             child: AutoSizeText("No",
//                                 style: inputLabelStyleDark(
//                                     SizeConfig.labelFontSize),
//                                 textAlign: TextAlign.left),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
//
//   Widget confirmationStep(BuildContext context, BoxConstraints constraints) {
//     return Container(
//         width: Responsive.width(90, context),
//         //color: Colors.black12,
//         //alignment: Alignment.center,
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
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: Responsive.width(100, context),
//                           margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
//                           child: AutoSizeText("Comments",
//                               style: inputLabelStyle(SizeConfig.labelFontSize),
//                               textAlign: TextAlign.left),
//                         ),
//                         Container(
//                             width: Responsive.width(100, context),
//                             height: SizeConfig.inputHeight,
//                             child: TextField(
//                                 controller: commentController,
//                                 maxLines: 4,
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
//                   width: Responsive.width(100, context),
//                   margin: EdgeInsets.only(bottom: 10, top: 0),
//                   child: AutoSizeText("*I confirm that",
//                       style: inputLabelStyle(SizeConfig.labelFontSize),
//                       textAlign: TextAlign.left),
//                 ),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.only(bottom: 10, top: 0),
//                     child: LayoutBuilder(builder: (context, constraints) {
//                       return Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                               width: constraints.maxWidth * 0.1,
//                               height: 4 * SizeConfig.blockSizeVertical,
//                               //color: Colors.black12,
//                               alignment: Alignment.topLeft,
//                               padding: EdgeInsets.all(0),
//                               child: Transform.scale(
//                                 scale: .1 * SizeConfig.blockSizeVertical,
//                                 child: Checkbox(
//                                   value: checkboxValue1,
//                                   onChanged: (val) {
//                                     setState(() => checkboxValue1 = val!);
//                                   },
//                                   activeColor: Dark,
//                                 ),
//                               )),
//                           Container(
//                             width: constraints.maxWidth * 0.85,
//                             height: 4 * SizeConfig.blockSizeVertical,
//                             alignment: Alignment.centerLeft,
//                             child: LayoutBuilder(
//                               builder: (context, constraints) {
//                                 return Container(
//                                     child: AutoSizeText(
//                                         'I\'ll not try to create a side deal with the students',
//                                         style: inputLabelStyleDark(
//                                             SizeConfig.labelFontSize)));
//                               },
//                             ),
//                           )
//                         ],
//                       );
//                     })),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.only(bottom: 10, top: 0),
//                     child: LayoutBuilder(builder: (context, constraints) {
//                       return Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                               width: constraints.maxWidth * 0.1,
//                               height: 4 * SizeConfig.blockSizeVertical,
//                               alignment: Alignment.topLeft,
//                               padding: EdgeInsets.all(0),
//                               //color: Colors.black12,
//                               child: Transform.scale(
//                                 alignment: Alignment.topCenter,
//                                 scale: .1 * SizeConfig.blockSizeVertical,
//                                 child: Checkbox(
//                                   value: checkboxValue2,
//                                   onChanged: (val) {
//                                     setState(() => checkboxValue2 = val!);
//                                   },
//                                   activeColor: Dark,
//                                 ),
//                               )),
//                           Container(
//                             width: constraints.maxWidth * 0.85,
//                             height: 4 * SizeConfig.blockSizeVertical,
//                             alignment: Alignment.centerLeft,
//                             child: LayoutBuilder(
//                               builder: (context, constraints) {
//                                 return Container(
//                                     child: AutoSizeText(
//                                         'I am contractually bound to NOT sell private lessons to students sent by MockDrivingTest.com',
//                                         style: inputLabelStyleDark(
//                                             SizeConfig.labelFontSize)));
//                               },
//                             ),
//                           )
//                         ],
//                       );
//                     })),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.only(bottom: 10, top: 0),
//                     child: LayoutBuilder(builder: (context, constraints) {
//                       return Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                               width: constraints.maxWidth * 0.1,
//                               height: 4 * SizeConfig.blockSizeVertical,
//                               alignment: Alignment.topLeft,
//                               padding: EdgeInsets.all(0),
//                               child: Transform.scale(
//                                 scale: .1 * SizeConfig.blockSizeVertical,
//                                 child: Checkbox(
//                                   value: checkboxValue3,
//                                   onChanged: (val) {
//                                     setState(() => checkboxValue3 = val!);
//                                   },
//                                   activeColor: Dark,
//                                 ),
//                               )),
//                           Container(
//                             width: constraints.maxWidth * 0.85,
//                             height: 4 * SizeConfig.blockSizeVertical,
//                             alignment: Alignment.centerLeft,
//                             child: LayoutBuilder(
//                               builder: (context, constraints) {
//                                 return Container(
//                                     child: AutoSizeText(
//                                         'I have full business insurance to provide lessons',
//                                         style: inputLabelStyleDark(
//                                             SizeConfig.labelFontSize)));
//                               },
//                             ),
//                           )
//                         ],
//                       );
//                     })),
//                 Container(
//                     width: Responsive.width(100, context),
//                     margin: EdgeInsets.only(bottom: 10, top: 0),
//                     child: LayoutBuilder(builder: (context, constraints) {
//                       return Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                               width: constraints.maxWidth * 0.1,
//                               height: 4 * SizeConfig.blockSizeVertical,
//                               alignment: Alignment.topLeft,
//                               padding: EdgeInsets.all(0),
//                               child: Transform.scale(
//                                 scale: .1 * SizeConfig.blockSizeVertical,
//                                 child: Checkbox(
//                                   value: checkboxValue4,
//                                   onChanged: (val) {
//                                     setState(() => checkboxValue4 = val!);
//                                   },
//                                   activeColor: Dark,
//                                 ),
//                               )),
//                           Container(
//                             width: constraints.maxWidth * 0.85,
//                             height: 4 * SizeConfig.blockSizeVertical,
//                             alignment: Alignment.centerLeft,
//                             child: LayoutBuilder(
//                               builder: (context, constraints) {
//                                 return Container(
//                                     child: AutoSizeText(
//                                         'I have car insurance to take lessons',
//                                         style: inputLabelStyleDark(
//                                             SizeConfig.labelFontSize)));
//                               },
//                             ),
//                           )
//                         ],
//                       );
//                     })),
//               ],
//             ),
//           ),
//         ));
//   }
//
//   Widget footerActionBar(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           height: Responsive.height(8, context),
//           alignment: Alignment.centerRight,
//           child: ButtonBar(
//             alignment: MainAxisAlignment.end,
//             mainAxisSize: MainAxisSize.max,
//             // this will take space as minimum as posible(to center)
//             children: <Widget>[
//               if (this.current_step > 0)
//                 Container(
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                     child: ButtonTheme(
//                       minWidth: Responsive.width(25, context),
//                       height: Responsive.height(6, context),
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
//                               _multiStepperWidget1.currentState!
//                                   .changeStep(this.current_step);
//                               try {
//                                 list_view_scrollCtrl.jumpTo(0);
//                               } catch (e) {}
//                             }
//                           });
//                         },
//                       ),
//                     )),
//               if (this.current_step < 4)
//                 Container(
//                   margin: EdgeInsets.fromLTRB(Responsive.width(2, context), 0,
//                       Responsive.width(2, context), 0),
//                   alignment: Alignment.center,
//                   child: ButtonTheme(
//                     minWidth: Responsive.width(20, context),
//                     height: Responsive.height(6, context),
//                     child: ElevatedButton(
//                       child: AutoSizeText(
//                         'Next',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 2 * SizeConfig.blockSizeVertical,
//                         ),
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           if (this.current_step < 4) {
//                             if ((this.current_step == 0 && !validateStep_0()) ||
//                                 (this.current_step == 1 && !validateStep_1()) ||
//                                 (this.current_step == 3 &&
//                                     (!validateManualCarDetails() ||
//                                         !validateAutoCarDetails()))) {
//                               Toast.show("Please filled all required(*) field.",
//                                   textStyle: context,
//                                   duration: Toast.lengthLong,
//                                   gravity: Toast.bottom);
//                             } else {
//                               setState(() {
//                                 this.current_step = this.current_step + 1;
//                                 _multiStepperWidget1.currentState!
//                                     .changeStep(this.current_step);
//                                 try {
//                                   list_view_scrollCtrl.jumpTo(0);
//                                 } catch (e) {}
//                               });
//                             }
//                           }
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               if (this.current_step == 4)
//                 Container(
//                   margin: EdgeInsets.fromLTRB(
//                       Responsive.width(2, context), 0, 0, 0),
//                   child: ButtonTheme(
//                     minWidth: Responsive.width(25, context),
//                     height: Responsive.height(6, context),
//                     buttonColor: Color(0xFFed1c24),
//                     child: ElevatedButton(
//                       child: AutoSizeText(
//                         'Submit',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 2 * SizeConfig.blockSizeVertical),
//                       ),
//                       onPressed: () {
//                         saveUserData();
//                       },
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }
