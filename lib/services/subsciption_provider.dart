import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:Smart_Theory_Test/Constants/global.dart';
import 'package:flutter/src/material/card.dart' as MCard;
import 'package:http/http.dart' as http;
import 'package:Smart_Theory_Test/Constants/app_colors.dart';
import 'package:Smart_Theory_Test/external.dart';
import 'package:Smart_Theory_Test/locater.dart';
import 'package:Smart_Theory_Test/main.dart';
import 'package:Smart_Theory_Test/responsive/size_config.dart';
import 'package:Smart_Theory_Test/services/navigation_service.dart';
import 'package:Smart_Theory_Test/utils/app_colors.dart';
import 'package:Smart_Theory_Test/views/Login/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/Autentication_status.dart';

enum Entitlement { unpaid, paid }

class SubscriptionProvider extends ChangeNotifier {
  Entitlement entitlement = Entitlement.unpaid;

  List<Package> package = [];

  fetchOffer() async {
    final offerList = await Purchases.getOfferings().catchError((e) {
      print('******************* $e');
    });
    print('******************* $offerList');
    package = offerList.current!.availablePackages;
    log("======= SUBSCRIPTION ======= ${package.first.storeProduct}");
    isUserPurchaseTest();

    notifyListeners();
  }

  isUserPurchaseTest({bool isLogin = false, BuildContext? context}) {
    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      EntitlementInfo? entitlementInfo =
          customerInfo.entitlements.active['One time purchase'];
      print('CUSTOMER INFO $customerInfo');
      if (entitlementInfo != null) {
        if (customerInfo.entitlements.active['One time purchase']!.isActive ==
            true) {
          entitlement = Entitlement.paid;
          // Fluttertoast.showToast(msg: "${entitlement}");
        } else {
          print(
              'AppConstant.userModel?.planType ${isLogin} ${AppConstant.userModel?.planType}');
          // Fluttertoast.showToast(msg: "${entitlement}");
          entitlement = Entitlement.unpaid;
          if (isLogin && AppConstant.userModel?.planType == "free") {
            var sharedPref = await SharedPreferences.getInstance();
            var data = sharedPref.getBool('theoryTestPractice');
            print('UserData.userId CHECK_USER ++++ ${isLogin} $data');
            if (data == null) {
              theoryTestPractice(context: context!);
            }
          }
        }
      } else {
        if (isLogin && AppConstant.userModel?.planType == "free") {
          var sharedPref = await SharedPreferences.getInstance();
          var data = sharedPref.getBool('theoryTestPractice');
          print('UserData.userId CHECK_USER ++++ ${isLogin} $data');
          if (data == null) {
            theoryTestPractice(context: context!);
          }
        }
        // Fluttertoast.showToast(msg: "${entitlement}");
      }
      notifyListeners();
    });
  }

  // checkActiveUser({bool isLogin = false, BuildContext? context}) {
  //   Purchases.logIn(UserData.userId.toString()).then((value) async {
  //     print(
  //         '+++++++++++++++++++TTTTT   ${jsonEncode(value.customerInfo.entitlements.active['One time purchase']?.isActive)}');
  //     if ((value.customerInfo.entitlements.active['One time purchase'] !=
  //             null) &&
  //         value.customerInfo.entitlements.active['One time purchase']!
  //                 .isActive ==
  //             true) {
  //       print('UserData.userId CHECK_USER ====');
  //       entitlement = Entitlement.paid;
  //
  //       // var sharedPref = await SharedPreferences.getInstance();
  //       // var data = sharedPref.getBool('isOpen');
  //       notifyListeners();
  //     } else {
  //       entitlement = Entitlement.unpaid;
  //       if (isLogin && AppConstant.userModel?.planType == "free") {
  //         var sharedPref = await SharedPreferences.getInstance();
  //         var data = sharedPref.getBool('theoryTestPractice');
  //         print('UserData.userId CHECK_USER ++++ ${isLogin} $data');
  //         if (data == null) {
  //           theoryTestPractice(context: context!);
  //         }
  //       }
  //       notifyListeners();
  //     }
  //
  //     print(
  //         'UserData.userId CHECK_USER ${UserData.userId} Purchases.logIn ${jsonEncode(value.customerInfo)}');
  //     notifyListeners();
  //   }).catchError((e) {
  //     // entitlement = Entitlement.unpaid;
  //     notifyListeners();
  //   });
  // }

  updateUserPlan(String planType) async {
    final url = Uri.parse('$api/api/update_plan');
    Map<String, String> body = {
      'id': AppConstant.userModel!.userId.toString(),
      'price': package.first.storeProduct.price.toString(),
      'plan_type': planType,
    };
    print('UPDATE PLAN URL $url');
    print('UPDATE PLAN ${jsonEncode(body)}');
    final response = await http.post(
      url,
      body: body,
    );
    if (response.statusCode == 200) {
      print('UPDATE ${response.body}');
      // var data = jsonDecode(response.body);
      // Fluttertoast.showToast(msg: data['message'], gravity: ToastGravity.TOP);
      notifyListeners();
    } else {
      print('UPDATE ${response.body}');
    }
  }

  purchasePackage(Package package, BuildContext context) async {
    loading(value: true);
    try {
      loading(value: true);
      await Purchases.purchasePackage(package).then((value) {
        loading(value: false);
        print(
            'HHHHHHHHH ${jsonEncode(value.entitlements.active['One time purchase']?.isActive)}');
        isUserPurchaseTest();
        updateUserPlan(
            value.entitlements.active['One time purchase']?.isActive == true
                ? "paid"
                : AppConstant.userModel?.planType == "gift"
                    ? "gift"
                    : "free");
        isUserPurchaseTest();
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

  payWallBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isDismissible: false,
        // enableDrag: false,
        shape: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        backgroundColor: Colors.white,
        context: context,
        builder: (_) => PopScope(
              canPop: false,
              child: Consumer<SubscriptionProvider>(builder: (context, val, _) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 20),
                          Text("Purchase",
                              style: AppTextStyle.titleStyle.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54)),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                padding: EdgeInsets.all(0),
                                visualDensity: VisualDensity.comfortable,
                                iconSize: 20,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.clear)),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            purchasePackage(val.package.first, context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                                color: AppColors.borderblue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(),
                                Text("${val.package.first.storeProduct.title}",
                                    style: AppTextStyle.titleStyle.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black54)),
                                Text(
                                    "${val.package.first.storeProduct.description}",
                                    style: AppTextStyle.disStyle.copyWith(
                                        // fontSize: 15,

                                        color: Colors.grey)),
                                Text(
                                  "${val.package.first.storeProduct.priceString}",
                                  style: AppTextStyle.disStyle
                                      .copyWith(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                );
              }),
            ));
  }

  theoryTestPractice({BuildContext? context}) {
    return showDialog(
      context: context!,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Dialog(
          insetPadding: EdgeInsets.all(20),
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                  begin: Alignment(0.0, -1.0),
                  end: Alignment(0.0, 1.0),
                  colors: [Dark, Light],
                  stops: [0.0, 1.0],
                )),
            child: MCard.Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 0.0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Theory Test Practice Module",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize:
                                    SizeConfig.blockSizeHorizontal * 4.5))),
                    Container(
                      //width: constraints.maxWidth,
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Icon(Icons.check_circle,
                                    size: SizeConfig.blockSizeHorizontal * 4,
                                    color: Colors.green),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("The only AI powered app with AI "),
                                    Text(
                                        "recommendations to help you learn fast"),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Icon(Icons.check_circle,
                                    size: SizeConfig.blockSizeHorizontal * 4,
                                    color: Colors.green),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                  child: Text(
                                "3 times more practice questions than any app",
                              ))
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Icon(
                                  Icons.check_circle,
                                  size: SizeConfig.blockSizeHorizontal * 4,
                                  color: Colors.green,
                                ),
                              ),
                              // SizedBox(
                              //   width:
                              //       constraints.maxWidth * 0.02,
                              // ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text('Licensed by DVSA'
                                    //"For each correct answer, earn 1 token! Answer 400 questions correctly and get your DVSA Theory Test free!",
                                    ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 10),
                              child: GestureDetector(
                                  onTap: () async {
                                    callDialog();
                                    payWallBottomSheet(context);
                                  },
                                  child: Container(
                                      // width: constraints.maxWidth * 0.8,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Dark,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Buy now",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                SizeConfig.blockSizeHorizontal *
                                                    4),
                                      )))),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 10),
                            child: GestureDetector(
                              onTap: () {
                                callDialog();
                                Navigator.pop(context);
                              },
                              child: Container(
                                // width: constraints.maxWidth * 0.8,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Dark,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
}
