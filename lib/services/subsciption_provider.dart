import 'dart:convert';
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

import '../enums/Autentication_status.dart';

enum Entitlement { unpaid, paid }

class SubscriptionProvider extends ChangeNotifier {
  Entitlement entitlement = Entitlement.unpaid;

  List<Package> package = [];

  Future fetchOffer() async {
    final offerList = await Purchases.getOfferings();

    package = offerList.current!.availablePackages;
    log("======= SUBSCRIPTION ======= ${package.first.storeProduct}");
    isUserPurchaseTest();

    notifyListeners();
  }

  isUserPurchaseTest() {
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      EntitlementInfo? entitlementInfo =
          customerInfo.entitlements.all['One time purchase'];
      print('CUSTOMER INFO $customerInfo');
      if (entitlementInfo != null) {
        if (entitlementInfo.isActive) {
          entitlement = Entitlement.paid;
          Fluttertoast.showToast(msg: "${entitlement}");
        } else {
          Fluttertoast.showToast(msg: "${entitlement}");
          entitlement = Entitlement.unpaid;
        }
      } else {
        Fluttertoast.showToast(msg: "${entitlement}");
      }
      notifyListeners();
    });
  }

  checkActiveUser() {
    Purchases.logIn(UserData.userId.toString()).then((value) {
      if (value.customerInfo.entitlements.active == true) {
        entitlement = Entitlement.paid;
        notifyListeners();
      } else {
        entitlement = Entitlement.unpaid;
        notifyListeners();
      }
      print(
          'UserData.userId ${UserData.userId} Purchases.logIn ${jsonEncode(value.customerInfo)}');
      notifyListeners();
    }).catchError((e) {
      entitlement = Entitlement.unpaid;
      notifyListeners();
    });
  }
}

class PurchaseSub {
  static String _key = Platform.isIOS
      ? "appl_GdgNRIxoZhglmcKEnSmJXqGilIb"
      : "goog_pMyIissxGyDEYrqhGGoJmLLVcne";

  static Future init() async {
    PurchasesConfiguration configuration = PurchasesConfiguration(_key);
    await Purchases.configure(configuration);
    configuration.shouldShowInAppMessagesAutomatically = true;
  }

  static Future<bool> purchasePackage(
      Package package, BuildContext context) async {
    loading(value: true);
    try {
      loading(value: true);
      await Purchases.purchasePackage(package).then((value) {
        loading(value: false);
        print('HHHHHHHHH');
        context.read<SubscriptionProvider>().checkActiveUser();
        context.read<SubscriptionProvider>().isUserPurchaseTest();
      }).catchError((e) {
        loading(value: false);
        print("ERROR ====== $e");
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
