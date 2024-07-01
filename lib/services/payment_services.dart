import 'dart:convert';
import 'dart:developer';

import 'package:Smart_Theory_Test/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Smart_Theory_Test/routing/route_names.dart' as routes;
import 'package:toast/toast.dart';

import '../Constants/global.dart';
import '../enums/Api_status.dart';
import '../locater.dart';
import 'booking_test.dart';
import 'navigation_service.dart';

class PaymentService {
  late Map data;
  late Map userData;
  final BookingService _bookingService = BookingService();
  final NavigationService _navigationService = locator<NavigationService>();
  Status _status = Status.NoThing;
  Status get status => _status;
  String? stripeSecret;
  Map<String, dynamic>? paymentIntentData;

  Future<Map> getStripToken() async {
    final url = Uri.parse("$api/api/get-stripe-api-key");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
      'App-Version': appVersion,
    };
    final response = await http.get(url, headers: header);
    data = jsonDecode(response.body);
    userData = data["data"];
    print("Stripe tokens : $userData");
    return userData;
  }

  Future<Map> saveTokeForPayment(
      double total_cost, String stripeToken, int _userType) async {
    _status = Status.Loading;
    final url = Uri.parse("$api/api/pay-subscription?stripeToken=" +
        stripeToken +
        "&total_cost=" +
        total_cost.toString() +
        "&user_type=" +
        _userType.toString());
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
      'App-Version': appVersion,
    };
    final response = await http.get(url, headers: header);
    _status = Status.Loaded;
    data = jsonDecode(response.body);
    return data;
  }

  Future<Map> buyPremiumPlan(Map body) async {
    _status = Status.Loading;
    final url = Uri.parse("$api/api/pay-premium-plan");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
      'App-Version': appVersion,
    };
    final response = await http.post(url, headers: header, body: body);
    _status = Status.Loaded;
    data = jsonDecode(response.body);
    return data;
  }

  Future<void> makePayment({
    required String amount,
    required String currency,
    required String desc,
    required BuildContext context,
    required Map metaData,
  }) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency, desc);
      log("PaymentIntent : $paymentIntentData");
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          // applePay: true,
          // googlePay: true,
          // testEnv: true,
          // merchantCountryCode: 'US',
          merchantDisplayName: 'Smart Theory Test',
          customerId: paymentIntentData!['customer'],
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
        ));
        displayPaymentSheet(context, metaData);
      }
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet(BuildContext context, Map data) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((_) async {
        if (data['parentPageName'] == "Lesson" ||
            data['parentPageName'] == "PassAssist") {
          Map<String, String> param = {
            'id': data['id'],
            'user_type': data['user_type'],
            'lesson_master_id': data['lesson_master_id'],
            'batch_hash': data['batch_hash'],
            'lesson_type': data['lesson_type'],
            'total_cost': data['total_cost']
          };
          payLessonFee(param).then((value) {
            if (value!["success"] == true) {
              Navigator.of(context).pop();
            }
          });
        } else if (data['parentPageName'] == "Test") {
          Map<String, String> param = {
            'id': data['id'],
            'user_type': data['user_type'],
            'test_cost': data['total_cost'],
            'test_id': data['test_id'],
          };
          payTestFee(param).then((value) {
            if (value!["success"] == true) {
              Navigator.of(context).pop();
            }
          });
        } else if (data['parentPageName'] == "PremiumPlan") {
          payPremiumPlanFee(data).then((value) {
            if (value != null) {
              if (value["success"] == true) {
                Toast.show(value["message"],
                    duration: 10, gravity: Toast.bottom);
              } else {
                Toast.show("Payment failed!!",
                    duration: 4, gravity: Toast.bottom);
              }
            }
          });
        } else if (data['parentPageName'] == "dvsaSubscription") {
          print("dvsa");
          await saveTokeForPayment(
                  double.parse(data['total_cost']), '', data['user_type'])
              .then(
            (value) {
              print("Payment res : $value");
              if (value["success"] == true) {
                Toast.show(
                  "Payment completed!",
                  duration: 4,
                  gravity: Toast.bottom,
                );
                Future.delayed(const Duration(milliseconds: 500)).then((value) {
                  Toast.show(
                    "Press icon on top-right to refresh.",
                    duration: 4,
                    gravity: Toast.bottom,
                  );
                });
              }
              //Navigator.of(context).pop();
            },
          );
        } else if (data['parentPageName'] == "dvsaSubscriptionHome") {
          print("dvsa");
          await saveTokeForPayment(
                  double.parse(data['total_cost']), '', data['user_type'])
              .then(
            (value) {
              print("Payment res : $value");
              if (value["success"] == true) {
                _navigationService.navigateTo(routes.PracticeTheoryTestRoute);
                Toast.show(
                  "Payment completed!",
                  duration: 4,
                  gravity: Toast.bottom,
                );
                Future.delayed(const Duration(milliseconds: 500)).then((value) {
                  Toast.show(
                    "Press icon on top-right to refresh.",
                    duration: 4,
                    gravity: Toast.bottom,
                  );
                });
              }
              //Navigator.of(context).pop();
            },
          );
        }
      });
      print("Payment completed");
    } on Exception catch (e) {
      if (e is StripeException) {
        print("Error from Stripe: ${e.error.localizedMessage}");
        Toast.show("Payment failed!!", duration: 4, gravity: Toast.bottom);
        //Navigator.of(context).pop();
        _navigationService.navigateToReplacement(routes.HomePageRoute);
      } else {
        print("Unforeseen error: ${e}");
      }
    } catch (e) {
      print("exception:$e");
    }
  }

  Future<Map?> payPremiumPlanFee(Map params) async {
    try {
      Map response = await buyPremiumPlan(params);
      return response;
    } catch (e) {
      print("Ex : $e");
      return null;
    }
  }

  Future<Map?> payLessonFee(Map<String, String> params) async {
    try {
      Map response = await _bookingService.postPayLessonFee(params);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map?> payTestFee(Map<String, String> params) async {
    try {
      Map response = await _bookingService.postPayTestFee(params);
      return response;
    } catch (error) {
      print("error........$error");
      return null;
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(
      String amount, String currency, String description) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
        'description': description
      };
      await getStripToken().then((value) {
        stripeSecret = value["stript_secret"];
      });
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecret',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print("Stripe Response : ${jsonDecode(response.body)}");
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    var a;
    if (amount.contains('.')) {
      a = (double.parse(amount)) * 100;
    } else {
      a = (int.parse(amount)) * 100;
    }
    print(a.runtimeType);
    return a.floor().toString();
  }
}
