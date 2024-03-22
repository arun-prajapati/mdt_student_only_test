import 'dart:developer';
import 'dart:io';

import 'package:Smart_Theory_Test/external.dart';
import 'package:Smart_Theory_Test/locater.dart';
import 'package:Smart_Theory_Test/main.dart';
import 'package:Smart_Theory_Test/services/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
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
    // if (Platform.isAndroid) {
    // final offering = await PurchaseSub().fetchOffer();
    final offerList = await Purchases.getOfferings();
    // if (offering.isEmpty) {

    //   showToast("No plans found");
    // } else {
    package = offerList.current!.availablePackages;
    log("======= SUBSCRIPTION ======= ${package.first.storeProduct}");
    isUserPurchaseTest();
    // Purchases.purchasePackage(offerList.current!.availablePackages.first);
    notifyListeners();
    // }
  }

  isUserPurchaseTest() {
    Purchases.getCustomerInfo().then((value) async {
      print('INFOOOOOOOO ${value.originalAppUserId} ');
      // Fluttertoast.showToast(msg: "${value.entitlements}");
    });
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      EntitlementInfo? entitlementInfo =
          customerInfo.entitlements.all['One time purchase'];
      print('CUSTOMER INFO $customerInfo');
      if (entitlementInfo != null) {
        if (entitlementInfo.isActive) {
          _entitlement = Entitlement.paid;

          Fluttertoast.showToast(msg: "${entitlement}");
        } else {
          Fluttertoast.showToast(msg: "${entitlement}");
          _entitlement = Entitlement.unpaid;
        }
      } else {
        Fluttertoast.showToast(msg: "${entitlement}");
      }
      // Fluttertoast.showToast(msg: "${customerInfo.entitlements}");
      // notifyListeners();
    });
  }
// }
}

final NavigationService _navigationService = locator<NavigationService>();

class PurchaseSub {
  static String _key = Platform.isIOS
      ? "appl_GdgNRIxoZhglmcKEnSmJXqGilIb"
      : "goog_pMyIissxGyDEYrqhGGoJmLLVcne";

  static Future init() async {
    PurchasesConfiguration configuration = PurchasesConfiguration(_key);
    await Purchases.configure(configuration);
    configuration.shouldShowInAppMessagesAutomatically = true;
    // Purchases.logIn("${Global.userModel?.id}");
    // print('APP USERID ${configuration.appUserID}');
  }

  static Future<bool> purchasePackage(
      Package package, BuildContext context) async {
    loading(value: true);
    try {
      loading(value: true);
      // await Purchases.purchasePackage(packageToPurchase).
      await Purchases.purchasePackage(package).then((value) {
        loading(value: false);
        print('HHHHHHHHH');
        // Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
        context.read<SubscriptionProvider>().isUserPurchaseTest();
      }).catchError((e) {
        loading(value: false);
        print("ERROR ====== $e");
        // Fluttertoast.showToast(msg: e.toString());
        return e;
      });
      return true;
    } catch (e) {
      loading(value: false);
      print("ERROR ====== $e");
      return false;
    }
  }
}
