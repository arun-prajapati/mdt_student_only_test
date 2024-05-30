import 'package:Smart_Theory_Test/external.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../custom_button.dart';
import '../locater.dart';
import '../services/auth.dart';
import '../services/navigation_service.dart';
import '../services/practise_theory_test_services.dart';
import '../utils/appImages.dart';
import '../utils/app_colors.dart';
import '../widget/CustomSwitch/CustomSwitch.dart';

class TestSettingDialogBox extends StatefulWidget {
  final StringCallback onSetValue;
  final List categories_list;

  TestSettingDialogBox(
      {Key? key, required this.onSetValue, required this.categories_list});

  // : super(key: key);

  @override
  _TestSettingDialogBox createState() => _TestSettingDialogBox();
}

class _TestSettingDialogBox extends State<TestSettingDialogBox> {
  TextStyle _answerTextStyle = TextStyle(
      fontSize: 18, color: Colors.black87, fontWeight: FontWeight.normal);
  TextStyle _categoryTextStyle = AppTextStyle.textStyle
      .copyWith(fontWeight: FontWeight.w400, color: AppColors.black);
  final NavigationService _navigationService = locator<NavigationService>();
  String seledtedCategoryId = "0";
  List categories = [];
  bool isAllCategoriesSelected = true;
  final PractiseTheoryTestServices test_api_services =
      new PractiseTheoryTestServices();
  final UserProvider auth_services = new UserProvider();

  Future<List> getCategoriesFromApi() async {
    List response = await test_api_services.getCategories(context);
    return response;
  }

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    loading(value: true);
    getCategoriesFromApi().then((response_list) {
      widget.categories_list.clear();
      widget.categories_list.addAll(response_list);
      var idList = [];
      print('widget.categories_list ${widget.categories_list}');
      for (var e in widget.categories_list) {
        Map category = e;
        // print(
        //     '=========== ${AppConstant.userModel?.planType} ${category['isFree']}');
        // if (category['isFree'] == "free" &&
        //     (AppConstant.userModel?.planType == "free" ||
        //         AppConstant.userModel?.planType == "gift")) {
        //   category['selected'] = true;
        //   if (category['isFree'] == "free" &&
        //       (AppConstant.userModel?.planType == "free" ||
        //           AppConstant.userModel?.planType == "gift")) {
        idList.add(category['id']);
        idList.join();
        var data = idList.join(",");
        seledtedCategoryId = data;
        print('------------ IF $data');
        // }
        // } else if (AppConstant.userModel?.planType == "gift" ||
        //     AppConstant.userModel?.planType == "paid") {
        //   category['selected'] = true;
        //   idList.add(category['id']);
        //   idList.join();
        //   var data = idList.join(",");
        //   seledtedCategoryId = data;
        //   print('------------ ELSE $data');
        // }
        categories.add(category);
        resetAll(true);
        print('widget.categories_list ${category}');
      }
      loading(value: false);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // height: Responsive.height(56, context),
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.fromLTRB(8, 5, 0, 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.only(left: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('Select the topic you would like to revise',
                            style: AppTextStyle.textStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.black)),
                      ),
                      SizedBox(width: 5),
                      Padding(
                        padding: EdgeInsets.only(right: 30),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.close,
                                size: 22, color: Colors.black)),
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 10),
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // AutoSizeText("Select Category",
                      //     style: TextStyle(
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.w500,
                      //         color: Colors.black)),
                      Text('Select All',
                          style: AppTextStyle.textStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              height: 1,
                              color: AppColors.black)),
                      ActionChip(
                        backgroundColor: AppColors.transparent,
                        pressElevation: 0,
                        padding: EdgeInsets.all(0),
                        labelPadding: EdgeInsets.all(0),
                        visualDensity: VisualDensity.comfortable,
                        onPressed: isAllCategoriesSelected
                            ? () {
                                seledtedCategoryId = "0";
                                resetAll(false);
                              }
                            : () {
                                resetAll(true);
                                if (isAllCategoriesSelected) {
                                  var idList = [];
                                  for (var d in categories) {
                                    // if (d['isFree'] == "free" &&
                                    //     (AppConstant.userModel?.planType ==
                                    //             "free" ||
                                    //         AppConstant.userModel?.planType ==
                                    //             "gift")) {
                                    idList.add(d['id']);
                                    print('ID LISTTTTT $idList');
                                    idList.join();
                                    var data = idList.join(",");
                                    seledtedCategoryId = data;
                                    print('------------ $data');
                                    // }
                                  }
                                } else {
                                  seledtedCategoryId = "0";
                                }
                                print('$seledtedCategoryId');
                                setState(() {});
                              },
                        label: Image.asset(
                          isAllCategoriesSelected
                              ? AppImages.checkedbox
                              : AppImages.checkBox,
                          height: isAllCategoriesSelected ? 23 : 20,
                          width: isAllCategoriesSelected ? 23 : 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: categories.length,
                        itemBuilder: (c, index) => Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                      "${categories[index]['name']}".toString(),
                                      style: AppTextStyle.textStyle.copyWith(
                                          fontWeight: FontWeight.w500)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  child: ActionChip(
                                    backgroundColor: AppColors.transparent,
                                    pressElevation: 0,
                                    padding: EdgeInsets.all(0),
                                    labelPadding: EdgeInsets.all(0),
                                    visualDensity: VisualDensity.comfortable,
                                    onPressed: () => {
                                      setState(() {
                                        resetAll(false);
                                        seledtedCategoryId =
                                            categories[index]['id'].toString();
                                        categories[index]['selected'] = true;
                                      })
                                    },
                                    label: Image.asset(
                                      categories[index]['selected'] == true
                                          ? AppImages.checkedbox
                                          : AppImages.checkBox,
                                      height:
                                          categories[index]['selected'] == true
                                              ? 23
                                              : 20,
                                      width:
                                          categories[index]['selected'] == true
                                              ? 23
                                              : 20,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 55, right: 55, bottom: 15, top: 15),
                  child: CustomButton(
                    title: 'Continue',
                    onTap: () {
                      // Navigator.pop(context, true);

                      // auth_services.changeView = false;

                      if (!isAllCategoriesSelected &&
                          seledtedCategoryId == "0") {
                        Fluttertoast.showToast(
                            msg: 'Please select category',
                            gravity: ToastGravity.TOP);
                      } else {
                        this.widget.onSetValue(seledtedCategoryId);
                      }
                      // setState(() {});
                      print(
                          'LLLL [[[[[[[[[[[  ${seledtedCategoryId} ${context.read<UserProvider>().changeView}');
                    },
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  resetAll(bool isAllSelect) {
    categories.asMap().forEach((index, category) {
      setState(() {
        // if (categories[index]['isFree'] == "free" &&
        //     (AppConstant.userModel?.planType == "free" ||
        //         AppConstant.userModel?.planType == "gift")) {
        //   categories[index]['selected'] = isAllSelect ? true : false;
        // } else if (AppConstant.userModel?.planType == "gift" ||
        //     AppConstant.userModel?.planType == "paid") {
        categories[index]['selected'] = isAllSelect ? true : false;
        // }
        isAllCategoriesSelected = isAllSelect;
      });
    });
  }

  // Widget? GetPremium(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return PopScope(
  //           canPop: false,
  //           child: Dialog(
  //             insetPadding: EdgeInsets.all(20),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10)), //this right here
  //             child: Container(
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10.0),
  //                   gradient: LinearGradient(
  //                     begin: Alignment(0.0, -1.0),
  //                     end: Alignment(0.0, 1.0),
  //                     colors: [Dark, Light],
  //                     stops: [0.0, 1.0],
  //                   )),
  //               // height: Responsive.height(25, context),
  //               child: Padding(
  //                 padding: EdgeInsets.all(4),
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                       color: AppColors.white,
  //                       borderRadius: BorderRadius.circular(10)),
  //                   child: Padding(
  //                     padding: EdgeInsets.all(15),
  //                     child: Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Container(
  //                             alignment: Alignment.topLeft,
  //                             child: Text('Go For Premium !!!!',
  //                                 style: AppTextStyle.titleStyle)),
  //                         SizedBox(height: 8),
  //                         Text(
  //                           'Buy premium license now to unlock exclusive content and maximize your learning experience.',
  //                           style: AppTextStyle.disStyle.copyWith(
  //                               fontWeight: FontWeight.w300,
  //                               color: AppColors.black),
  //                         ),
  //                         SizedBox(height: 18),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           crossAxisAlignment: CrossAxisAlignment.end,
  //                           children: [
  //                             // margin: const EdgeInsets.only(right: 10),
  //                             Expanded(
  //                               child: GestureDetector(
  //                                 onTap: () async {
  //                                   payWallBottomSheet();
  //                                 },
  //                                 child: Container(
  //                                     // width: constraints.maxWidth * 0.8,
  //                                     padding:
  //                                         EdgeInsets.symmetric(vertical: 8),
  //                                     decoration: BoxDecoration(
  //                                       color: Dark,
  //                                       borderRadius: BorderRadius.all(
  //                                           Radius.circular(5)),
  //                                     ),
  //                                     alignment: Alignment.center,
  //                                     child: Text(
  //                                       "Buy now",
  //                                       style: TextStyle(
  //                                           color: Colors.white,
  //                                           fontWeight: FontWeight.w500,
  //                                           fontSize:
  //                                               SizeConfig.blockSizeHorizontal *
  //                                                   4),
  //                                     )),
  //                               ),
  //                             ),
  //                             SizedBox(width: 18),
  //                             Expanded(
  //                               child: GestureDetector(
  //                                 onTap: () {
  //                                   Navigator.pop(context, false);
  //                                 },
  //                                 child: Container(
  //                                     // width: constraints.maxWidth * 0.8,
  //                                     padding:
  //                                         EdgeInsets.symmetric(vertical: 8),
  //                                     decoration: BoxDecoration(
  //                                       color: Dark,
  //                                       borderRadius: BorderRadius.all(
  //                                           Radius.circular(5)),
  //                                     ),
  //                                     alignment: Alignment.center,
  //                                     child: Text(
  //                                       "Cancel",
  //                                       style: TextStyle(
  //                                           color: Colors.white,
  //                                           fontWeight: FontWeight.w500,
  //                                           fontSize:
  //                                               SizeConfig.blockSizeHorizontal *
  //                                                   4),
  //                                     )),
  //                               ),
  //                             ),
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  //   return null;
  // }

  // payWallBottomSheet() {
  //   showModalBottomSheet(
  //       isDismissible: false,
  //       // enableDrag: false,
  //       shape: OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.white),
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(20),
  //             topRight: Radius.circular(20),
  //           )),
  //       backgroundColor: Colors.white,
  //       context: context,
  //       builder: (_) => PopScope(
  //             canPop: false,
  //             child: Consumer<SubscriptionProvider>(builder: (c, val, _) {
  //               return Padding(
  //                 padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         SizedBox(width: 20),
  //                         Text("Purchase",
  //                             style: AppTextStyle.titleStyle.copyWith(
  //                                 fontSize: 15,
  //                                 fontWeight: FontWeight.w600,
  //                                 color: Colors.black54)),
  //                         Align(
  //                           alignment: Alignment.topRight,
  //                           child: IconButton(
  //                               padding: EdgeInsets.all(0),
  //                               visualDensity: VisualDensity.comfortable,
  //                               iconSize: 20,
  //                               onPressed: () {
  //                                 Navigator.pop(context);
  //                               },
  //                               icon: Icon(Icons.clear)),
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(height: 10),
  //                     Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
  //                       child: GestureDetector(
  //                         onTap: () {
  //                           Navigator.pop(context);
  //                           Navigator.pop(context);
  //                           purchasePackage(val.package.first, context);
  //                         },
  //                         child: Container(
  //                           padding: EdgeInsets.symmetric(
  //                               vertical: 10, horizontal: 20),
  //                           decoration: BoxDecoration(
  //                               color: AppColors.borderblue.withOpacity(0.1),
  //                               borderRadius: BorderRadius.circular(5)),
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Row(),
  //                               Text("${val.package.first.storeProduct.title}",
  //                                   style: AppTextStyle.titleStyle.copyWith(
  //                                       fontSize: 15,
  //                                       fontWeight: FontWeight.w600,
  //                                       color: Colors.black54)),
  //                               Text(
  //                                   "${val.package.first.storeProduct.description}",
  //                                   style: AppTextStyle.disStyle.copyWith(
  //                                       // fontSize: 15,

  //                                       color: Colors.grey)),
  //                               Text(
  //                                 "${val.package.first.storeProduct.priceString}",
  //                                 style: AppTextStyle.disStyle
  //                                     .copyWith(color: Colors.black),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(height: 40),
  //                   ],
  //                 ),
  //               );
  //             }),
  //           ));
  // }

  // purchasePackage(Package package, BuildContext context) async {
  //   loading(value: true);
  //   try {
  //     loading(value: true);
  //     await Purchases.purchasePackage(package).then((value) {
  //       loading(value: false);
  //       print('HHHHHHHHH ${value.entitlements.all}');
  //       context.read<SubscriptionProvider>().updateUserPlan(
  //           value.entitlements.active['One time purchase']?.isActive == true
  //               ? "paid"
  //               : AppConstant.userModel?.planType == "gift"
  //                   ? "gift"
  //                   : "free");
  //       context
  //           .read<SubscriptionProvider>()
  //           .isUserPurchaseTest(context: context);
  //       Navigator.pop(context);
  //     }).catchError((e) {
  //       loading(value: false);
  //       print("ERROR ====== $e");

  //       return e;
  //     });
  //   } catch (e) {
  //     loading(value: false);
  //     print("ERROR ====== $e");
  //   }
  // }
}
