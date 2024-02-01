import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionProvider extends ChangeNotifier {
  List<Package> package = [];

  // payment(
  //     {String? name,
  //     String? userId,
  //     String? amount,
  //     String? cprNo,
  //     String? subType}) async {
  //   var response = await DataBaseHelper.post(EndPoints.paymentSystem, {
  //     "name": name,
  //     "user_id": userId,
  //     "subscription_type": subType,
  //     "amount": amount,
  //     "cpr_no": cprNo,
  //   });
  //   var parsedData = jsonDecode(response.body);
  //   if (parsedData['statusCode'] == 200) {
  //     return parsedData;
  //   } else {
  //     return [];
  //   }
  // }
  //
  // subscriptionListGet() async {
  //   var response = await DataBaseHelper.post(
  //       EndPoints.subscriptionList, {"user_id": Global.userModel?.id});
  //   var parsedData = jsonDecode(response.body);
  //   if (parsedData['statusCode'] == 200) {
  //     var list = (parsedData['data'] as List)
  //         .map((e) => SubscriptionListModel.fromJson(e))
  //         .toList();
  //     update();
  //     return subscriptionList.value = list;
  //   } else {
  //     return subscriptionList.value = [];
  //   }
  // }
  //
  // Future<bool> activeSubscriptionPlan() async {
  //   var pref = await SharedPreferences.getInstance();
  //   http.Response response = await http.post(
  //       Uri.parse(EndPoints.activeSubscription),
  //       body: jsonEncode({}),
  //       headers: {
  //         "content-type": "application/json",
  //         "Authorization": "Bearer ${Global.userModel?.id}"
  //       });
  //   var parsedData = jsonDecode(response.body);
  //   if (parsedData['statusCode'] == 200) {
  //     Global.activeSubscriptionModel =
  //         ActiveSubscriptionModel.fromJson(parsedData['data']);
  //     pref.setString('isActivated', jsonEncode(parsedData['data']));
  //     update();
  //     ActiveSubscriptionModel activeData = ActiveSubscriptionModel.fromJson(
  //         await jsonDecode(pref.getString('isActivated').toString()));
  //     Global.activeSubscriptionModel = activeData;
  //     print("SUB PLAN---> $activeData");
  //     return true;
  //   } else {
  //     // update();
  //     return false;
  //   }
  // }
  //
  // Future updateSubscription({String? id, String? subId}) async {
  //   var data = {
  //     "id": id,
  //     "subscription_id": subId,
  //   };
  //   var response =
  //       await DataBaseHelper.post(EndPoints.updateSubscription, data);
  //   var parsedData = jsonDecode(response.body);
  //   print('DATA ENCODEE ------------------------ ${jsonEncode(data)}');
  //   if (parsedData['statusCode'] == 200) {
  //     // snackBar("Plan is successfully updated", color: Colors.green.shade600);
  //     return parsedData;
  //   } else {
  //     return [];
  //   }
  // }
  //
  // Future<bool> deleteSubscriptionPlan(id) async {
  //   http.Response response = await http.post(
  //       Uri.parse(EndPoints.deleteSubscription),
  //       body: jsonEncode({"subscription_id": id}),
  //       headers: await header);
  //   var parsedData = jsonDecode(response.body);
  //   if (parsedData['statusCode'] == 200) {
  //     showToast("Plan is successfully deleted");
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future fetchOffer() async {
    // await Purchases.getProducts(["fitgate_monthly_sub", "fitgate_2bhd_1m"]).then((value) {
    //   for (var val in value) {
    //     log("FETCH PRODUCTS ${val}");
    //   }
    //   log("||||||||||||||||||||||||||||||||| ${value}");
    //   log("|||||||||||||||||||||| ${value.first.identifier}");
    // }).catchError((e) {
    //   print('ERROR ======== $e');
    // });

    if (Platform.isAndroid) {
      // final offering = await PurchaseSub().fetchOffer();
      final offerList = await Purchases.getOfferings();
      // if (offering.isEmpty) {

      //   showToast("No plans found");
      // } else {
      package = offerList.current!.availablePackages;
      log("======= SUBSCRIPTION ======= ${package.first.storeProduct}");
      notifyListeners();
    }
  }
// }
}

class PurchaseSub {
  static String _apikey = "goog_eukgVVvLpywyoySKCkAacdKkoHT";

  static Future init() async {
    PurchasesConfiguration configuration = PurchasesConfiguration(_apikey);
    await Purchases.configure(configuration);
    configuration.shouldShowInAppMessagesAutomatically = true;
    // Purchases.logIn("${Global.userModel?.id}");
    // print('APP USERID ${configuration.appUserID}');
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      return true;
    } catch (e) {
      print("ERROR ====== $e");
      return false;
    }
  }
}
