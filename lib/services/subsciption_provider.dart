import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

enum Entitlement { unpaid, paid }

class SubscriptionProvider extends ChangeNotifier {
  Entitlement _entitlement = Entitlement.unpaid;

  Entitlement get entitlement => _entitlement;
  List<Package> package = [];

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
    // CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    // print('========================= ${customerInfo.entitlements}');
    if (Platform.isAndroid) {
      // final offering = await PurchaseSub().fetchOffer();
      final offerList = await Purchases.getOfferings();
      // if (offering.isEmpty) {

      //   showToast("No plans found");
      // } else {
      package = offerList.current!.availablePackages;
      log("======= SUBSCRIPTION ======= ${package.first.storeProduct}");
      // Purchases.purchasePackage(offerList.current!.availablePackages.first);
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

  static Future<bool> purchasePackage(StoreProduct package) async {
    try {
      await Purchases.purchaseStoreProduct(package).catchError((e) {
        print("ERROR ====== $e");
        Fluttertoast.showToast(msg: e.toString());
        return e;
      });
      return true;
    } catch (e) {
      print("ERROR ====== $e");
      return false;
    }
  }
}
