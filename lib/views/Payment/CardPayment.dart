// import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
// import 'package:mdt/widgets/TextFieldMask/masked_textInput_formatter.dart';
// import 'package:mdt/widgets/navigatin_bar/CustomAppBar.dart';
// import 'package:mdt/responsive/percentage_mediaquery.dart';
// import 'package:student_app/routing/route_names.dart' as routes;
// import 'package:mdt/services/navigation_service.dart';
// import 'package:mdt/services/payment_services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mdt/widgets/CustomSpinner.dart';
// import 'package:mdt/services/booking_test.dart';
//
// import 'package:mdt/enums/Api_status.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:toast/toast.dart';
// import '../../Constants/app_colors.dart';
// import '../../locater.dart';
//
// class CardPayment extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _CardPayment();
// }
//
// class _CardPayment extends State<CardPayment> {
//   final NavigationService _navigationService = locator<NavigationService>();
//   final GlobalKey<State> _keyLoader = new GlobalKey<State>();
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final BookingService _bookingService = new BookingService();
//   late Map paramArguments;
//   final PaymentService paymentService = new PaymentService();
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController _dateController = TextEditingController();
//   String _currentSecret = "";
//   late double total_cost;
//   int? _userType;
//   stripe.Card c = stripe.Card(
//     last4: "4242",
//     expMonth: 07,
//     expYear: 2030,
//     country: "GB",
//   );
//
//
//   // final _card = CardFormEditController(
//   //   initialDetails: CardFieldInputDetails(
//   //       complete:
//   //
//   //   ),
//   // );
//   // late final  paymentCardDetail = (
//   //     "brand": '',
//   //     last4: '',
//   //     id: '',
//   //     expMonth: null,
//   //     expYear: null,
//   //     currency: 'GBP'
//   // );
//   // final CreditCard paymentCardDetail = CreditCard(
//   //     addressLine1: '',
//   //     addressLine2: '',
//   //     last4: '',
//   //     number: '',
//   //     expMonth: null,
//   //     expYear: null,
//   //     cvc: null,
//   //     currency: 'GBP');
//
//   Future<int?> getUserType() async {
//     SharedPreferences storage = await SharedPreferences.getInstance();
//     _userType = 2;
//   }
//
//   Future<Map> getStripKeys() async {
//     Map response = await paymentService.getStripToken();
//     return response;
//   }
//
//   Future<Map> generate_payment(String _paymentToken) async {
//     Map response = await paymentService.saveTokeForPayment(
//         total_cost, _paymentToken, _userType!);
//     return response;
//   }
//
//   //call api for pay pass_assist_lesson and book_lesson fee
//   Future<Map?> payLessonFee(Map<String, String> params) async {
//     try {
//       Map response = await _bookingService.postPayLessonFee(params);
//       return response;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }
//
//   //call api for pay test free
//   Future<Map?> payTestFee(Map<String, String> params) async {
//     try {
//       Map response = await _bookingService.postPayTestFee(params);
//       return response;
//     } catch (error) {
//       print("error........$error");
//       return null;
//     }
//   }
//
//   String? _error;
//
//   @override
//   void initState()  {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       CustomSpinner.showLoadingDialog(context, _keyLoader, "Loading...");
//       getUserType().then((value) {
//         getStripKeys().then((value) async {
//           //print(value);
//           Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//           _currentSecret = value['stript_public'];
//           //StripePlatform.instance.initialise(publishableKey: _currentSecret);
//            stripe.Stripe.publishableKey = _currentSecret;
//           await stripe.Stripe.instance.applySettings();
// // Stripe.instance.createToken(CreateTokenParams.card(params: CardTokenParams(type: TokenType.Card))).then((token) => null);
//           // StripePayment.setOptions(
//           //     StripeOptions(publishableKey: _currentSecret));
//         });
//       });
//     });
//
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
//   void setError(dynamic error) {
//     try {
//       Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//     } catch (e) {
//     } finally {
//       // _scaffoldKey.currentState
//       //     .showSnackBar(SnackBar(content: Text(error.toString())));
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(error.toString()),
//           duration: Duration(seconds: 5),
//         ),
//       );
//       setState(() {
//         _error = error.toString();
//       });
//     }
//   }
//
//
//   @override
//   void didChangeDependencies() {
//     final arguments = ModalRoute.of(context)!.settings.arguments as Map;
//     try {
//       paramArguments = arguments;
//       if (arguments['total_cost'] != null)
//         total_cost = arguments['total_cost'] is int
//             ? arguments['total_cost']
//             : double.parse(arguments['total_cost']);
//     } catch (e) {
//       print(e);
//     } finally {
//       super.didChangeDependencies();
//     }
//   }
//
//   Widget build(BuildContext context) {
//     // print("Payment card: $paymentCardDetail");
//     return Scaffold(
//         key: _scaffoldKey,
//         body: Form(
//           key: _formKey,
//           child: Stack(
//             children: <Widget>[
//               CustomAppBar(
//                   preferedHeight: Responsive.height(24, context),
//                   title: 'Payment',
//                   textWidth: Responsive.width(35, context),
//                   iconLeft: Icons.arrow_back,
//                   onTap1: () {
//                     _navigationService.goBack();
//                   },
//                   iconRight: null),
//               GestureDetector(
//                 onTap: () {
//                   FocusScopeNode currentFocus = FocusScope.of(context);
//
//                   if (!currentFocus.hasPrimaryFocus) {
//                     currentFocus.unfocus();
//                   }
//                 },
//                 child: Container(
//                   width: Responsive.width(90, context),
//                   height: Responsive.height(83, context),
//                   margin: EdgeInsets.fromLTRB(
//                       Responsive.width(5, context),
//                       Responsive.height(15, context),
//                       Responsive.width(5, context),
//                       0.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color.fromRGBO(0, 0, 0, 0.16),
//                         blurRadius: 6.0, // soften the shadow
//                         spreadRadius: 5.0, //extend the shadow
//                         offset: Offset(
//                           0.0, // Move to right 10  horizontally
//                           3.0, // Move to bottom 10 Vertically
//                         ),
//                       )
//                     ],
//                   ),
//                   child: LayoutBuilder(builder: (BuildContext, constraints) {
//                     return ListView(
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       children: [
//                         Container(
//                           child: Text("Benifits of Subscription",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 15,
//                                   color: Colors.black)),
//                           padding: EdgeInsets.only(
//                               left: constraints.maxWidth * .05,
//                               right: constraints.maxWidth * .05,
//                               bottom: 10),
//                         ),
//                         Container(
//                             child: Column(
//                           children: [
//                             ListTile(
//                                 leading: Container(
//                                     child: Icon(Icons.circle,
//                                         size: 8, color: Colors.black),
//                                     transform:
//                                         Matrix4.translationValues(0, -8, 0)),
//                                 title: Text(
//                                     'MockDrivingTest.com is here to help you with your Theory Test practice even more by offering you an exclusive chance to practice official DVSA Theory Test Questions.',
//                                     style: TextStyle(
//                                         fontSize: 13, color: Colors.black)),
//                                 horizontalTitleGap: 0,
//                                 minLeadingWidth: 15,
//                                 minVerticalPadding: 5),
//                             ListTile(
//                                 leading: Container(
//                                     child: Icon(Icons.circle,
//                                         size: 8, color: Colors.black),
//                                     transform:
//                                         Matrix4.translationValues(0, -8, 0)),
//                                 title: Text(
//                                     "These questions are divided into 14 comprehensive categories by the DVSA, created specifically to understand the rules of the road and best driving practices defined by the Department for Transport in ‘The Official Highway Code’, ‘The Official DVSA Guide to Driving – the essential skills’ and ‘The Official DVSA Guide to Better Driving’.",
//                                     style: TextStyle(
//                                         fontSize: 13, color: Colors.black)),
//                                 horizontalTitleGap: 0,
//                                 minLeadingWidth: 15,
//                                 minVerticalPadding: 5),
//                             ListTile(
//                                 leading: Container(
//                                     child: Icon(Icons.circle,
//                                         size: 8, color: Colors.black),
//                                     transform:
//                                         Matrix4.translationValues(0, -8, 0)),
//                                 title: Text(
//                                     "Subscribe now and practice 100s of Official DVSA questions that appear in the Theory Test to gain the best knowledge about the roads and get a thorough idea of what is really in store for you during the actual Theory Test.",
//                                     style: TextStyle(
//                                         fontSize: 13, color: Colors.black)),
//                                 horizontalTitleGap: 0,
//                                 minLeadingWidth: 15,
//                                 minVerticalPadding: 5),
//                           ],
//                         )),
//                         Container(
//                             width: constraints.maxWidth * 1,
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: constraints.maxWidth * .05),
//                             margin: EdgeInsets.only(top: 20, bottom: 10),
//                             child: RichText(
//                               text: TextSpan(
//                                 text: 'Total charges: ',
//                                 style: TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.black),
//                                 children: <TextSpan>[
//                                   TextSpan(
//                                       text: '£' + total_cost.toString(),
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           color: Dark))
//                                 ],
//                               ),
//                             )),
//                         // Container(
//                         //   width:100,
//                         //     //height:500,
//                         //     //color:Colors.greenAccent,
//                         //     child: CardFormField(
//                         //       onCardChanged: (card){
//                         //         setState(() {
//                         //           _card = card!;
//                         //         });
//                         //         print("Card : $_card");
//                         //       },
//                         //       controller: CardFormEditController(
//                         //         initialDetails: null,
//                         //     ),
//                         //       style: CardFormStyle(
//                         //       borderColor: Colors.transparent,
//                         //       borderRadius: 0,
//                         //       borderWidth: 2,
//                         //       textColor: Colors.black,
//                         //       placeholderColor: Dark,
//                         //       fontSize: 18,
//                         //       backgroundColor: Colors.transparent
//                         //     ),
//                         //       enablePostalCode: false,
//                         //       countryCode: 'GB',
//                         //     )
//                         // ),
//                         InkWell(
//                           onTap: () async{
//                             print("pay");
//                             //pay();
//                             // Stripe.instance.createToken(params);
//                             // Stripe.instance.createToken(CreateTokenParams.card(params: CardTokenParams())).then((token) => print("Token : $token"));
//                           },
//                           child: Container(
//                               width:100,
//                               //height:500,
//                               //color:Colors.greenAccent,
//                               child:Text("pay")
//                           ),
//                         ),
//
//                         // Container(
//                         //   width: constraints.maxWidth * 1,
//                         //   height: 60,
//                         //   padding: EdgeInsets.symmetric(
//                         //       horizontal: constraints.maxWidth * .05),
//                         //   child: TextFormField(
//                         //     decoration: InputDecoration(
//                         //         border: OutlineInputBorder(),
//                         //         labelText: 'Card No',
//                         //         helperText: '',
//                         //         counterText: '',
//                         //         errorStyle: TextStyle(
//                         //           fontSize: 12.0,
//                         //         )),
//                         //     maxLength: 19,
//                         //     keyboardType: TextInputType.number,
//                         //     inputFormatters: [
//                         //       MaskedTextInputFormatter(
//                         //         mask: '2222 2222 2222 2222',
//                         //         separator: ' ',
//                         //       )
//                         //     ],
//                         //     validator: (value) {
//                         //       if (value == null || value.isEmpty) {
//                         //         return 'Required!';
//                         //       } else {
//                         //         setState(() {
//                         //           paymentCardDetail.copyWith.call(id: value);
//                         //         });
//                         //         print(paymentCardDetail);
//                         //         return null;
//                         //       }
//                         //     },
//                         //   ),
//                         // ),
//                         // Row(
//                         //   children: [
//                         //     Container(
//                         //       width: constraints.maxWidth * .63,
//                         //       height: 60,
//                         //       padding: EdgeInsets.symmetric(
//                         //           horizontal: constraints.maxWidth * .05),
//                         //       margin: EdgeInsets.only(bottom: 15),
//                         //       child: TextFormField(
//                         //         decoration: InputDecoration(
//                         //             border: OutlineInputBorder(),
//                         //             labelText: 'Expiry Date(MM/YY)',
//                         //             helperText: ' ',
//                         //             counterText: ''),
//                         //         onSaved: (val) {},
//                         //         controller: _dateController,
//                         //         maxLength: 5,
//                         //         keyboardType: TextInputType.datetime,
//                         //         inputFormatters: [
//                         //           MaskedTextInputFormatter(
//                         //             mask: 'MM/YY',
//                         //             separator: '/',
//                         //           )
//                         //         ],
//                         //         validator: (value) {
//                         //           if (value == null || value.isEmpty) {
//                         //             return 'Required!';
//                         //           } else {
//                         //             var date = value.split('/');
//                         //             setState(() {
//                         //               if (date[0] != null)
//                         //                 paymentCardDetail.expMonth =
//                         //                     int.parse(date[0]);
//                         //               if (date[1] != null)
//                         //                 paymentCardDetail.expYear =
//                         //                     int.parse(date[1]);
//                         //             });
//                         //             return null;
//                         //           }
//                         //         },
//                         //       ),
//                         //     ),
//                         //     Container(
//                         //       width: constraints.maxWidth * .35,
//                         //       height: 60,
//                         //       padding: EdgeInsets.symmetric(
//                         //           horizontal: constraints.maxWidth * .05),
//                         //       margin: EdgeInsets.only(
//                         //           bottom: 15, left: constraints.maxWidth * .02),
//                         //       child: TextFormField(
//                         //         decoration: const InputDecoration(
//                         //             border: OutlineInputBorder(),
//                         //             labelText: 'CVV',
//                         //             helperText: ' ',
//                         //             counterText: ''),
//                         //         validator: (value) {
//                         //           if (value == null || value.isEmpty) {
//                         //             return 'Required!';
//                         //           } else {
//                         //             setState(() {
//                         //               paymentCardDetail.cvc = value;
//                         //             });
//                         //             return null;
//                         //           }
//                         //         },
//                         //         maxLength: 3,
//                         //         enableSuggestions: false,
//                         //         keyboardType: TextInputType.number,
//                         //       ),
//                         //     ),
//                         //   ],
//                         // ),
//                         // Container(
//                         //   height: 45,
//                         //   margin: EdgeInsets.only(top: 0, bottom: 40),
//                         //   padding: EdgeInsets.only(
//                         //       left: constraints.maxWidth * 0.25,
//                         //       right: constraints.maxWidth * 0.25),
//                         //   child: ElevatedButton(
//                         //     style: ButtonStyle(
//                         //         elevation:
//                         //             MaterialStateProperty.all<double>(10),
//                         //         backgroundColor:
//                         //             MaterialStateProperty.all<Color>(
//                         //                 Dark),
//                         //         shape: MaterialStateProperty.all<
//                         //                 RoundedRectangleBorder>(
//                         //             RoundedRectangleBorder(
//                         //                 borderRadius: BorderRadius.only(
//                         //                   bottomRight: Radius.circular(
//                         //                       constraints.maxHeight * 0.5),
//                         //                   topRight: Radius.circular(
//                         //                       constraints.maxHeight * 0.5),
//                         //                   bottomLeft: Radius.circular(
//                         //                       constraints.maxHeight * 0.5),
//                         //                 ),
//                         //                 side: BorderSide(color: Dark)))),
//                         //     onPressed: () async {
//                               // final form = _formKey.currentState;
//                               // if (form!.validate()) {
//                               //   CustomSpinner.showLoadingDialog(
//                               //       context, _keyLoader, "Wait...");
//                               //   Stripe.instance.createToken;
//                               //   Stripe.createTokenWithCard(
//                               //     paymentCardDetail,
//                               //   ).then((token) {
//                               //     String _paymentToken =
//                               //         token.tokenId.toString();
//                               //     if (paramArguments['parentPageName'] ==
//                               //             routes
//                               //                 .BookPassAssistLessonsFormRoute ||
//                               //         paramArguments['parentPageName'] ==
//                               //             routes.BookLessionFormRoute)
//                               //       payForBookingLesson(_paymentToken);
//                               //     else if (paramArguments['parentPageName'] ==
//                               //         routes.BookTestFormRoute)
//                               //       payForBookTest(_paymentToken);
//                               //     else if (paramArguments['parentPageName'] ==
//                               //         routes.PracticeTheoryTestRoute)
//                               //       payForSubscriptionDVSA(_paymentToken);
//                               //     else if (paramArguments['parentPageName'] ==
//                               //         routes.TheoryRecommendationsRoute)
//                               //       payForSubscriptionDVSA(_paymentToken);
//                               //   }).catchError(setError);
//                               // }
//                         //       final paymentMethod =
//                         //           await Stripe.instance.createPaymentMethod(PaymentMethodParams.card(paymentMethodData: PaymentMethodData(billingDetails: null,shippingDetails: null)));
//                         //     },
//                         //     child: LayoutBuilder(
//                         //       builder: (context, constraints) {
//                         //         return Container(
//                         //           width: constraints.maxWidth * 0.50,
//                         //           child: FittedBox(
//                         //             fit: BoxFit.contain,
//                         //             child: Text(
//                         //               'Payment',
//                         //               style: TextStyle(
//                         //                 fontFamily: 'Poppins',
//                         //                 fontSize: 50,
//                         //                 fontWeight: FontWeight.w700,
//                         //                 color:
//                         //                     Color.fromRGBO(255, 255, 255, 1.0),
//                         //               ),
//                         //             ),
//                         //           ),
//                         //         );
//                         //       },
//                         //     ),
//                         //   ),
//                         // ),
//                       ],
//                     );
//                   }),
//                 ),
//               )
//             ],
//           ),
//         ));
//   }
//
//   //Pass Assist and book lesson
//   void payForBookingLesson(String _paymentToken) {
//     Map<String, String> param = {
//       'id': paramArguments['id'],
//       'user_type': paramArguments['user_type'],
//       'stripeToken': _paymentToken,
//       'lesson_master_id': paramArguments['lesson_master_id'],
//       'batch_hash': paramArguments['batch_hash'],
//       'lesson_type': paramArguments['lesson_type'],
//       'total_cost': paramArguments['total_cost']
//     };
//     payLessonFee(param).then((response) {
//       Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//       Toast.show(
//         response!['message'],
//         duration: Toast.lengthLong,
//         gravity: Toast.bottom,
//       );
//       _navigationService.navigateToReplacement(routes.MyBookingRoute);
//     }).catchError(setError);
//   }
//
//   void payForBookTest(String _paymentToken) {
//     Map<String, String> param = {
//       'id': paramArguments['id'],
//       'user_type': paramArguments['user_type'],
//       'stripeToken': _paymentToken,
//       'test_cost': paramArguments['total_cost'],
//       'test_id': paramArguments['test_id']
//     };
//     payTestFee(param).then((response) {
//       Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//       Toast.show(
//         response!['message'],
//         duration: Toast.lengthLong,
//         gravity: Toast.bottom,
//       );
//       _navigationService.navigateToReplacement(routes.MyBookingRoute);
//     }).catchError(setError);
//   }
//
//   void payForSubscriptionDVSA(String _paymentToken) {
//     generate_payment(_paymentToken).then((value) {
//       if (value['success'] == true && paramArguments != null) {
//         Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//         Toast.show(
//           value['message'],
//           duration: Toast.lengthLong,
//           gravity: Toast.bottom,
//         );
//         _navigationService
//             .navigateToReplacement(routes.PracticeTheoryTestRoute);
//       } else {
//         Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//         // _scaffoldKey.currentState!
//         //     .showSnackBar(SnackBar(content: Text('Failed! Try again.')));
//       }
//     });
//   }
// }
