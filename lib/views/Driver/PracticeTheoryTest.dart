import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_app/Constants/app_colors.dart';
import 'package:student_app/custom_button.dart';
import 'package:student_app/json_model.dart';
import 'package:toast/toast.dart';

import '../../Constants/global.dart';
import '../../custom_practice_theory_test/answer_correct_wrong.dart';
import '../../custom_practice_theory_test/test_setting_dialog.dart';
import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/auth.dart';
import '../../services/navigation_service.dart';
import '../../services/payment_services.dart';
import '../../services/practise_theory_test_services.dart';
import '../../utils/app_colors.dart';
import '../../widget/CustomAppBar.dart';
import '../../widget/CustomSpinner.dart';

class PracticeTheoryTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _practiceTheoryTest();
}

class _practiceTheoryTest extends State<PracticeTheoryTest> {
  final NavigationService _navigationService = locator<NavigationService>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final _controller = ScrollController();
  final PractiseTheoryTestServices test_api_services =
      new PractiseTheoryTestServices();
  final PaymentService _paymentService = new PaymentService();

  // final AuthProvider auth_services = new AuthProvider();
  bool isTestStarted = false;
  int selectedQuestionIndex = 0;
  int? selectedOptionIndex;
  int gainPoint = 0;
  late int _userId;
  int category_id = 0;
  Map? walletDetail = null;
  static int? selectedCategoryIndex;
  List questionsList = [];
  List<PracticeTestCategoryModel> categoryList = [];
  List responseList = [];
  List testQuestionsForResult = [];
  List resultRecordsList = [];
  late Map recordOtherData;

  String userName = '';

  getData() async {
    return getCategoriesFromApi().then((response_list) {
      responseList.clear();
      responseList.addAll(response_list);
      print("------------ responseList ${jsonEncode(responseList)}");
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    // getNewCat();
    Future.delayed(Duration.zero, () {
      this.initializeApi("Loading...");
    });
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showLoader(String message) {
    CustomSpinner.showLoadingDialog(context, _keyLoader, message);
  }

  void closeLoader() {
    try {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    } catch (e) {}
  }

  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  //Call APi Services
  Future<int> getUserDetail() async {
    Map response =
        await Provider.of<UserProvider>(context, listen: false).getUserData();
    _userId = response['id'];
    userName = "${response['first_name']} ${response['last_name']}";
    return _userId;
  }

  /// =========== ///
  Future<Widget> getNewCat() async {
    final url = Uri.parse("$api/api/get-categories");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      log("++++++++++++++++= ${response.body}");
      var parsedData = jsonDecode(response.body);
      if (parsedData['success'] == true) {
        categoryList = (parsedData['data'] as List)
            .map((e) => PracticeTestCategoryModel.fromJson(e))
            .toList();
        setState(() {});
        return SizedBox();
      } else {
        categoryList = [];
        setState(() {});
        return SizedBox();
      }
    } else {
      return SizedBox();
    }
  }

  /// ==========///
  //Call APi Services
  Future<List> getCategoriesFromApi() async {
    List response = await test_api_services.getCategories();
    return response;
  }

  //call api for getQuestions
  Future<List> getQuestionsFromApi() async {
    List response = await test_api_services.getTestQuestions(category_id);

    return response;
  }

  //call api for getQuestions
  Future<Map> getAllRecordsFromApi() async {
    Map response = await test_api_services.getAllRecords(2, _userId);
    return response;
  }

  //call api for getQuestions
  Future<Map> submitTestByApi() async {
    log("Results : $testQuestionsForResult");
    log("Category id : $category_id");
    Map response = await test_api_services.submitTest(
        2, _userId, testQuestionsForResult, category_id);
    return response;
  }

  initializeApi(String loaderMessage) {
    // auth_services.changeView = false;
    // setState(() {});
    checkInternet();
    CustomSpinner.showLoadingDialog(context, _keyLoader, loaderMessage);
    getUserDetail().then((user_id) {
      getAllRecordsFromApi().then((records_list) {
        setState(() {
          walletDetail = records_list['other_data'];
          resultRecordsList = records_list['test_record'] as List;
        });
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ToastContext().init(context);
    print(
        "auth_services.changeView ${context.read<UserProvider>().changeView}");
    if (context.read<UserProvider>().changeView) {
      getCategoriesFromApi().then((response_list) {
        // Navigator.pop(context);
        log("Category &&&& : $response_list");
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        showModalBottomSheet(
            isDismissible: false,
            shape: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            context: context,
            builder: (BuildContext context) {
              // Navigator.pop(context);
              return TestSettingDialogBox(
                categories_list: response_list,
                onSetValue: (_categoryId) {
                  log("Category id : $_categoryId");
                  gainPoint = 0;
                  questionsList = [];
                  testQuestionsForResult = [];
                  selectedQuestionIndex = 0;
                  selectedOptionIndex = null;
                  category_id = _categoryId;
                  CustomSpinner.showLoadingDialog(
                      context, _keyLoader, "Test loading...");
                  getQuestionsFromApi().then((response_list) {
                    Navigator.of(_keyLoader.currentContext!,
                            rootNavigator: true)
                        .pop();
                    questionsList = response_list;
                    setState(() => isTestStarted = true);
                    // context.read<AuthProvider>().changeView = true;
                    setState(() {});
                  });
                },
              );
            });
      });
      // getCategoriesFromApi().then((value) {
      //   responseList = value;
      //   return TestSettingDialogBox(
      //     categories_list: value,
      //     onSetValue: (_categoryId) {
      //       log("Category id : $_categoryId");
      //       gainPoint = 0;
      //       questionsList = [];
      //       testQuestionsForResult = [];
      //       selectedQuestionIndex = 0;
      //       selectedOptionIndex = null;
      //       category_id = _categoryId;
      //       CustomSpinner.showLoadingDialog(
      //           context, _keyLoader, "Test loading...");
      //       getQuestionsFromApi().then((response_list) {
      //         Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
      //             .pop();
      //         questionsList = response_list;
      //         setState(() => isTestStarted = true);
      //       });
      //     },
      //   );
      // });
      return SizedBox();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            CustomAppBar(
              preferedHeight: Responsive.height(11, context),
              title: 'Practice Theory Test Questions',
              textWidth: Responsive.width(35, context),
              iconLeft: Icons.arrow_back,
              iconRight: Icons.refresh_rounded,
              onTap1: () {
                _navigationService.goBack();
              },
              onTapRightbtn: () {
                initializeApi("Refreshing...");
              },
            ),
            Container(
                margin: EdgeInsets.fromLTRB(
                    //Responsive.width(3, context),
                    0,
                    MediaQuery.of(context).size.height * 0.104,
                    0,
                    0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                height: Responsive.height(83, context),
                width: Responsive.width(100, context),
                padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                child: LayoutBuilder(builder: (context, constraints) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: constraints.maxWidth * 1,
                          // padding: isTestStarted
                          //     ? EdgeInsets.only(
                          //         top: constraints.maxHeight * .03)
                          //     : EdgeInsets.all(0),
                          height: isTestStarted
                              ? constraints.maxHeight * .85
                              : constraints.maxHeight * .78,
                          child: ListView(
                            controller: _controller,
                            physics: const AlwaysScrollableScrollPhysics(),
                            //padding: EdgeInsets.only(top: 10),
                            shrinkWrap: true,
                            children: [
                              // if (!isTestStarted)
                              //   scoreRecordsGrid(context, constraints),
                              if (isTestStarted)
                                Container(
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 2),
                                    child: LayoutBuilder(
                                        builder: (context, _constraints) {
                                      return testQuestionWidget(
                                          context,
                                          _constraints,
                                          questionsList[selectedQuestionIndex]);
                                    })),
                              if (selectedOptionIndex != null && isTestStarted)
                                answerExplanation(
                                    questionsList[selectedQuestionIndex]),
                              if (selectedOptionIndex != null && isTestStarted)
                                answerStatus(
                                    questionsList[selectedQuestionIndex]),
                            ],
                          ),
                        ),
                        if (!isTestStarted)
                          startButtonWidget(context, constraints),
                        if (isTestStarted)
                          nextButtonWidget(context, constraints),
                      ]);
                })),
          ],
        ),
      );
    }
  }

  // Widget cardHeader(BuildContext context, BoxConstraints constraints) {
  //   return Container(
  //     alignment: Alignment.topCenter,
  //     padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
  //     margin: EdgeInsets.only(top: constraints.maxHeight * .02),
  //     width: constraints.maxWidth * 1,
  //     height: constraints.maxHeight * .10,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Container(
  //           height: 5 * SizeConfig.blockSizeVertical,
  //           width: constraints.maxWidth * .45,
  //           child: Material(
  //             borderRadius: BorderRadius.all(Radius.circular(5)),
  //             color: Dark,
  //             elevation: 5.0,
  //             child: MaterialButton(
  //               onPressed: () => {walletUI(context, constraints)},
  //               child: LayoutBuilder(
  //                 builder: (context, constraints) {
  //                   return Container(
  //                       width: constraints.maxWidth * 1,
  //                       height: constraints.maxHeight * 1,
  //                       alignment: Alignment.center,
  //                       child: SizedBox(
  //                         width: constraints.maxWidth * 1,
  //                         child: AutoSizeText(
  //                           "My Tokens: " +
  //                               ((walletDetail != null
  //                                           ? walletDetail!['mdt_bal']
  //                                           : 0) +
  //                                       ((walletDetail != null &&
  //                                               walletDetail![
  //                                                       'dvsa_subscription'] >
  //                                                   0)
  //                                           ? (walletDetail!['dvsa_bal'])
  //                                           : 0))
  //                                   .toString(),
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               fontFamily: 'Poppins',
  //                               fontSize: 2 * SizeConfig.blockSizeVertical,
  //                               color: Colors.white),
  //                         ),
  //                       ));
  //                 },
  //               ),
  //             ),
  //           ),
  //         ),
  //         // if (walletDetail != null &&
  //         //     walletDetail!['dvsa_subscription'] <= 0)
  //         //   Container(
  //         //     width: constraints.maxWidth * .45,
  //         //     height: 5 * SizeConfig.blockSizeVertical,
  //         //     margin: EdgeInsets.only(left: constraints.maxWidth * .08),
  //         //     child: Material(
  //         //       borderRadius: BorderRadius.all(Radius.circular(5)),
  //         //       color: Dark,
  //         //       elevation: 5.0,
  //         //       child: MaterialButton(
  //         //         onPressed: () {
  //         //           subscriptionConfirmAlert(context);
  //         //         },
  //         //         child: LayoutBuilder(
  //         //           builder: (context, constraints) {
  //         //             return Container(
  //         //                 width: constraints.maxWidth * 1,
  //         //                 height: constraints.maxHeight * 1,
  //         //                 alignment: Alignment.center,
  //         //                 child: SizedBox(
  //         //                   width: constraints.maxWidth * 1,
  //         //                   child: AutoSizeText(
  //         //                     "Subscribe for DVSA",
  //         //                     textAlign: TextAlign.center,
  //         //                     style: TextStyle(
  //         //                         fontFamily: 'Poppins',
  //         //                         fontSize:
  //         //                             2 * SizeConfig.blockSizeVertical,
  //         //                         color: Colors.white),
  //         //                   ),
  //         //                 ));
  //         //           },
  //         //         ),
  //         //       ),
  //         //     ),
  //         //   ),
  //       ],
  //     ),
  //   );
  // }

  Future<void> walletUI(
      BuildContext context, BoxConstraints parentConstraints) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (BuildContext context_) {
        return new WillPopScope(
          onWillPop: () {
            return Future.value(true);
          },
          child: Padding(
            padding: EdgeInsets.only(
                left: parentConstraints.maxWidth * .10,
                right: parentConstraints.maxWidth * .10),
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              insetAnimationCurve: Curves.easeOutBack,
              insetPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              backgroundColor: Colors.transparent,
              child: Container(
                height: Responsive.height(80, context),
                alignment: Alignment.topCenter,
                child: Container(
                  height: Responsive.height(70, context),
                  alignment: Alignment.topCenter,
                  // padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white,
                  ),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.close_rounded,
                                  size: 4 * SizeConfig.blockSizeVertical,
                                  color: Colors.black),
                              onPressed: () {
                                Navigator.of(context_).pop();
                              }),
                        ],
                      ),
                      SizedBox(height: 10),
                      walletDetail != null &&
                              walletDetail!['dvsa_subscription'] > 0
                          ? Container()
                          : Container(
                              child: AutoSizeText(
                                  "Increase your chances of passing the Theory Driving Test on your very first attempt with MockDrivingTest.com. We are here to provide you with an exclusive opportunity to get a real test like experience by earning our Theory Mock Driving Test created to emulate the actual DVSA test, for FREE!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize:
                                          1.8 * SizeConfig.blockSizeVertical,
                                      color: Colors.black)),
                              padding: EdgeInsets.only(
                                  left: Responsive.width(2, context),
                                  right: Responsive.width(2, context),
                                  bottom: 10),
                            ),
                      walletDetail != null &&
                              walletDetail!['dvsa_subscription'] > 0
                          ? Container()
                          : Container(
                              child: AutoSizeText("All you have to do:-",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          1.8 * SizeConfig.blockSizeVertical,
                                      color: Colors.black)),
                              padding: EdgeInsets.only(
                                  left: Responsive.width(2, context),
                                  right: Responsive.width(2, context),
                                  bottom: 5),
                            ),
                      walletDetail != null &&
                              walletDetail!['dvsa_subscription'] > 0
                          ? Container()
                          : Container(
                              child: Column(
                              children: [
                                ListTile(
                                    leading: Container(
                                        child: Icon(Icons.circle,
                                            size: 1 *
                                                SizeConfig.blockSizeVertical,
                                            color: Colors.black),
                                        padding: EdgeInsets.only(right: 10)),
                                    title: AutoSizeText(
                                        'Subscribe to our DVSA Theory Test practice module for just £ 9.99.',
                                        style: TextStyle(
                                            fontSize: 1.8 *
                                                SizeConfig.blockSizeVertical,
                                            color: Colors.black)),
                                    horizontalTitleGap: 0,
                                    minLeadingWidth: 15,
                                    minVerticalPadding: 5),
                                ListTile(
                                    leading: Container(
                                        child: Icon(Icons.circle,
                                            size: 1 *
                                                SizeConfig.blockSizeVertical,
                                            color: Colors.black),
                                        padding: EdgeInsets.only(right: 10)),
                                    title: AutoSizeText(
                                        "Answer 400 questions correctly and earn 1 token for every correctly answered question.",
                                        style: TextStyle(
                                            fontSize: 1.8 *
                                                SizeConfig.blockSizeVertical,
                                            color: Colors.black)),
                                    horizontalTitleGap: 0,
                                    minLeadingWidth: 15,
                                    minVerticalPadding: 5),
                                ListTile(
                                    leading: Container(
                                        child: Icon(Icons.circle,
                                            size: 1 *
                                                SizeConfig.blockSizeVertical,
                                            color: Colors.black),
                                        padding: EdgeInsets.only(right: 10)),
                                    title: AutoSizeText(
                                        "The 400 tokens will be split into 2 parts: 200 for the DVSA Theory Test practice module questions and the remaining 200 for MockDrivingTest.com’s sample MCQ based on the actual test pattern.",
                                        style: TextStyle(
                                            fontSize: 1.8 *
                                                SizeConfig.blockSizeVertical,
                                            color: Colors.black)),
                                    horizontalTitleGap: 0,
                                    minLeadingWidth: 15,
                                    minVerticalPadding: 5),
                                ListTile(
                                    leading: Container(
                                        child: Icon(Icons.circle,
                                            size: 1 *
                                                SizeConfig.blockSizeVertical,
                                            color: Colors.black),
                                        padding: EdgeInsets.only(right: 10)),
                                    title: AutoSizeText(
                                        "After earning 200 tokens in each category, you will be eligible for our free DVSA Theory test",
                                        style: TextStyle(
                                            fontSize: 1.8 *
                                                SizeConfig.blockSizeVertical,
                                            color: Colors.black)),
                                    horizontalTitleGap: 0,
                                    minLeadingWidth: 15,
                                    minVerticalPadding: 5),
                              ],
                            )),
                      walletDetail != null &&
                              walletDetail!['dvsa_subscription'] > 0
                          ? Container()
                          : Container(
                              // padding: EdgeInsets.symmetric(
                              //     horizontal: 2, vertical: 10),
                              margin: EdgeInsets.only(
                                  left: Responsive.width(2, context_),
                                  right: Responsive.width(2, context_)),
                              child: Divider(
                                color: Colors.grey.withOpacity(0.4),
                                thickness: 2,
                              ),
                            ),
                      Container(
                        height: Responsive.height(30, context_),
                        margin: EdgeInsets.only(
                            left: Responsive.width(2, context_),
                            right: Responsive.width(2, context_)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AutoSizeText("TOTAL TOKENS",
                                style: TextStyle(
                                    fontSize: 2 * SizeConfig.blockSizeVertical,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black)),
                            AutoSizeText(
                                ((walletDetail != null
                                            ? walletDetail!['mdt_bal']
                                            : 0) +
                                        ((walletDetail != null &&
                                                walletDetail![
                                                        'dvsa_subscription'] >
                                                    0)
                                            ? (walletDetail!['dvsa_bal'])
                                            : 0))
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 2 * SizeConfig.blockSizeVertical,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                            Container(
                              width: Responsive.width(100, context_),
                              margin: EdgeInsets.only(
                                top: Responsive.height(1, context_),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                      width: Responsive.width(30, context_),
                                      height: Responsive.height(15, context_),
                                      margin: EdgeInsets.only(
                                          left: Responsive.width(3, context_),
                                          right: Responsive.width(2, context_)),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          color:
                                              Color.fromRGBO(0, 204, 204, 1.0)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          AutoSizeText("DVSA TOKENS",
                                              style: TextStyle(
                                                  fontSize: 1.7 *
                                                      SizeConfig
                                                          .blockSizeVertical,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white)),
                                          AutoSizeText(
                                              (walletDetail != null
                                                      ? walletDetail![
                                                          'dvsa_bal']
                                                      : 0)
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 2 *
                                                      SizeConfig
                                                          .blockSizeVertical,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white)),
                                          SizedBox(
                                              height: Responsive.width(
                                                  4, context_)),
                                          AutoSizeText("Remaining",
                                              style: TextStyle(
                                                  fontSize: 1.7 *
                                                      SizeConfig
                                                          .blockSizeVertical,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white)),
                                          AutoSizeText(
                                              (200 -
                                                      (walletDetail != null
                                                          ? walletDetail![
                                                              'dvsa_bal']
                                                          : 0))
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 2 *
                                                      SizeConfig
                                                          .blockSizeVertical,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white))
                                        ],
                                      )),
                                  Container(
                                    width: Responsive.width(30, context_),
                                    height: Responsive.height(15, context_),
                                    margin: EdgeInsets.only(
                                        left: Responsive.width(3, context_),
                                        right: Responsive.width(2, context_)),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                        color:
                                            Color.fromRGBO(115, 89, 255, 1.0)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        AutoSizeText("MDT TOKENS",
                                            style: TextStyle(
                                                fontSize: 1.7 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white)),
                                        AutoSizeText(
                                            (walletDetail != null
                                                    ? walletDetail!['mdt_bal']
                                                    : 0)
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 2 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white)),
                                        SizedBox(
                                            height:
                                                Responsive.width(4, context_)),
                                        AutoSizeText("Remaining",
                                            style: TextStyle(
                                                fontSize: 1.7 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white)),
                                        AutoSizeText(
                                            (200 -
                                                    (walletDetail != null
                                                        ? walletDetail![
                                                            'mdt_bal']
                                                        : 0))
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 2 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget scoreRecordsGrid(BuildContext context, BoxConstraints constraints) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: [
  //       Container(
  //         color: Colors.black12,
  //         padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
  //         margin: EdgeInsets.only(bottom: 10),
  //         width: constraints.maxWidth * 1,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Container(
  //               width: constraints.maxWidth * .30,
  //               padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
  //               child: AutoSizeText(
  //                 'Category',
  //                 style: TextStyle(
  //                     fontSize: 2 * SizeConfig.blockSizeVertical,
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.black),
  //               ),
  //             ),
  //             Container(
  //               width: constraints.maxWidth * .225,
  //               padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
  //               child: AutoSizeText(
  //                 'MDT S.',
  //                 style: TextStyle(
  //                     fontSize: 2 * SizeConfig.blockSizeVertical,
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.black),
  //               ),
  //             ),
  //             // Container(
  //             //   width: constraints.maxWidth * .225,
  //             //   padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
  //             //   child: AutoSizeText(
  //             //     'DVSA S.',
  //             //     style: TextStyle(
  //             //         fontSize: 2 * SizeConfig.blockSizeVertical,
  //             //         fontWeight: FontWeight.w600,
  //             //         color: Colors.black),
  //             //   ),
  //             // ),
  //             Container(
  //               width: constraints.maxWidth * .23,
  //               padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
  //               child: AutoSizeText(
  //                 'Date',
  //                 textAlign: TextAlign.left,
  //                 style: TextStyle(
  //                     fontSize: 2 * SizeConfig.blockSizeVertical,
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.black),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       if (resultRecordsList.length == 0)
  //         Container(
  //           margin: EdgeInsets.only(
  //             top: Responsive.height(5, context),
  //           ),
  //           child: Text(
  //             "No Record",
  //             style: TextStyle(
  //               fontSize: 2 * SizeConfig.blockSizeVertical,
  //             ),
  //           ),
  //         ),
  //       ...resultRecordsList.map(
  //         (record) => scoreRecordRow(
  //           constraints,
  //           record,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget scoreRecordRow(BoxConstraints constraints, Map record) {
    return Container(
      color: Colors.black12,
      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: constraints.maxWidth * .30,
            padding: EdgeInsets.fromLTRB(5, 5, 3, 5),
            child: AutoSizeText(
              (record['category_id'] == null || record['category_id'] <= 0)
                  ? 'All'
                  : record['category']['name'],
              style: TextStyle(
                  fontSize: 2 * SizeConfig.blockSizeVertical,
                  fontWeight: FontWeight.w300,
                  color: Colors.black),
            ),
          ),
          Container(
            width: constraints.maxWidth * .225,
            padding: EdgeInsets.fromLTRB(0, 5, 3, 5),
            child: AutoSizeText(
              record['mdt_score'] != null
                  ? (record['mdt_score']).toString()
                  : '---',
              style: TextStyle(
                  fontSize: 2 * SizeConfig.blockSizeVertical,
                  fontWeight: FontWeight.w300,
                  color: Colors.black),
            ),
          ),
          // Container(
          //   width: constraints.maxWidth * .225,
          //   padding: EdgeInsets.fromLTRB(0, 5, 3, 5),
          //   child: AutoSizeText(
          //     record['dvsa_score'] != null
          //         ? (record['dvsa_score']).toString()
          //         : '---',
          //     style: TextStyle(
          //         fontSize: 2 * SizeConfig.blockSizeVertical,
          //         fontWeight: FontWeight.w300,
          //         color: Colors.black),
          //   ),
          // ),
          Container(
            width: constraints.maxWidth * .23,
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: AutoSizeText(
              record['created_at'] != null ? record['created_at'] : '---',
              style: TextStyle(
                fontSize: 2 * SizeConfig.blockSizeVertical,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget radioSingleOptionUI(
      BoxConstraints constraints, option, int option_no, question) {
    TextStyle _answerTextStyle = AppTextStyle.textStyle
        .copyWith(color: Colors.black, fontWeight: FontWeight.w400);
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: constraints.maxWidth * 0.09,
            child:
                Text((option_no + 1).toString() + '.', style: _answerTextStyle),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: constraints.maxWidth * .10,
            transform: Matrix4.translationValues(-10, -12, 0),
            child: Transform.scale(
              scale: .15 * SizeConfig.blockSizeVertical,
              child: Radio(
                activeColor: Dark,
                value: option_no,
                visualDensity: VisualDensity.compact,
                groupValue: selectedOptionIndex,
                onChanged: selectedOptionIndex != null
                    ? null
                    : (val) {
                        setState(() {
                          selectedOptionIndex = val as int;
                        });
                        calculatePoint(question);
                        if (selectedOptionIndex != null &&
                            question['options'][selectedOptionIndex]
                                    ['correct'] ==
                                true) {
                          showCorrectAnswerDialog(
                              context, question['explanation']);
                        } else {
                          showWrongAnswerDialog(
                              context, question['explanation']);
                        }
                      },
              ),
            ),
          ),
          Container(
            width: constraints.maxWidth * .80,
            child: Column(
              children: [
                if (option['optionImg'] != '')
                  GestureDetector(
                    onTap: () {
                      if (selectedOptionIndex == null) {
                        setState(() {
                          selectedOptionIndex = option_no;
                        });
                        calculatePoint(question);
                        if (selectedOptionIndex != null &&
                            question['options'][selectedOptionIndex]
                                    ['correct'] ==
                                true) {
                          showCorrectAnswerDialog(
                              context, question['explanation']);
                        } else {
                          showWrongAnswerDialog(
                              context, question['explanation']);
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 3),
                      height: 10 * SizeConfig.blockSizeVertical,
                      width: constraints.maxWidth * .80,
                      alignment: Alignment.topLeft,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/spinner.gif',
                        image: option['optionImg'],
                        imageErrorBuilder: (context, url, error) => Container(
                          child: Column(
                            children: [
                              new Icon(Icons.error,
                                  color: Colors.grey,
                                  size: 5 * SizeConfig.blockSizeVertical),
                              Text(
                                "Image not found!",
                                style: TextStyle(
                                    fontSize: 2 * SizeConfig.blockSizeVertical,
                                    color: Colors.redAccent),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                if (option['option'] != '')
                  Container(
                    width: constraints.maxWidth * .80,
                    alignment: Alignment.topLeft,
                    child: RichText(
                      text: TextSpan(
                          text: option['option'],
                          style: _answerTextStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              if (selectedOptionIndex == null) {
                                setState(() {
                                  selectedOptionIndex = option_no;
                                });
                                calculatePoint(question);
                                if (selectedOptionIndex != null &&
                                    question['options'][selectedOptionIndex]
                                            ['correct'] ==
                                        true) {
                                  showCorrectAnswerDialog(
                                      context, question['explanation']);
                                } else {
                                  showWrongAnswerDialog(
                                      context, question['explanation']);
                                }
                              }
                            }),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget testQuestionWidget(
      BuildContext context, BoxConstraints constraints, question) {
    TextStyle _questionTextStyle = AppTextStyle.titleStyle
        .copyWith(fontWeight: FontWeight.w500, color: AppColors.black);
    return Stack(
      children: <Widget>[
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 15),
              width: constraints.maxWidth * 1,
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (question['questionImg'] != '')
                    Container(
                      transform: Matrix4.translationValues(0, -5, 0),
                      alignment: Alignment.center,
                      height: 17 * SizeConfig.blockSizeVertical,
                      width: constraints.maxWidth * 1,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/spinner.gif',
                        image: question['questionImg'],
                        imageErrorBuilder: (context, url, error) => Container(
                          child: Column(
                            children: [
                              new Icon(Icons.error,
                                  color: Colors.grey,
                                  size: 5 * SizeConfig.blockSizeVertical),
                              // Text(
                              //   "Image not found!",
                              //   style: TextStyle(
                              //       fontSize: 2 * SizeConfig.blockSizeVertical,
                              //       color: Colors.redAccent),
                              // )
                            ],
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 10),
                  if (question['title'] != '')
                    Text(
                      question['title'],
                      style: _questionTextStyle,
                    ),
                  // Container(
                  //     width: constraints.maxWidth * 1,
                  //     margin: EdgeInsets.only(top: 5),
                  //     child: AutoSizeText(
                  //       question['type'] == 0
                  //           ? 'Question Source: MDT'
                  //           : 'Question Source: DVSA',
                  //       style: TextStyle(
                  //           fontSize: 2 * SizeConfig.blockSizeVertical,
                  //           color: Colors.black26,
                  //           fontWeight: FontWeight.w500),
                  //     ))
                ],
              ),
            ),
            ...question['options'].map((option) => radioSingleOptionUI(
                constraints,
                option,
                question['options'].indexOf(option),
                question)),
          ],
        ),
        if (question['type'] == 1 && walletDetail!['dvsa_subscription'] <= 0)
          Container(
            width: Responsive.height(100, context),
            height: Responsive.height(100, context),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 1),
              child: Container(
                  color: Colors.white.withOpacity(0.8),
                  padding: EdgeInsets.only(
                    top: Responsive.height(20, context),
                  ),
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 3),
                        width: constraints.maxWidth * 0.90,
                        child: AutoSizeText('Question Source: DVSA',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.titleStyle.copyWith(
                                fontWeight: FontWeight.w400, color: Dark)),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 20),
                        width: constraints.maxWidth * 0.90,
                        child: AutoSizeText(
                            'Please subscribe for DVSA questions.',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.textStyle
                                .copyWith(fontWeight: FontWeight.w400)),
                      ),
                      Container(
                        height: 6 * SizeConfig.blockSizeVertical,
                        width: constraints.maxWidth * 0.50,
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 10),
                        child: Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: 5.0,
                          child: GestureDetector(
                            onTap: () {
                              subscriptionConfirmAlert(context);
                            },
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Container(
                                    width: constraints.maxWidth * 1,
                                    height: constraints.maxHeight * 1,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: RadialGradient(
                                          colors: [
                                            AppColors.primary,
                                            AppColors.secondary,
                                            AppColors.secondary,
                                          ],
                                          radius: 10,
                                          focal: Alignment(-1.1, -3.0),
                                        )),
                                    child: SizedBox(
                                      width: constraints.maxWidth * 1,
                                      child: AutoSizeText('Subscribe',
                                          textAlign: TextAlign.center,
                                          style: AppTextStyle.textStyle
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600)),
                                    ));
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                        // alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 20),
                        width: constraints.maxWidth * 0.90,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                // width: constraints.maxWidth * 0.18,
                                alignment: Alignment.topCenter,
                                child: Text("NOTE:   ",
                                    style: AppTextStyle.textStyle.copyWith(
                                        color: AppColors.red1,
                                        fontWeight: FontWeight.w500))),
                            Container(
                                width: constraints.maxWidth * 0.72,
                                child: Text(
                                    // textAlign: TextAlign.justify,
                                    "You can now either subscribe to DVSA module to get "
                                    "full access to the app or skip next 10 questions to move forwards.",
                                    style: AppTextStyle.disStyle.copyWith(
                                        fontWeight: FontWeight.w400))),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          )
      ],
    );
  }

  Widget answerExplanation(Map question) {
    TextStyle _headingText = AppTextStyle.titleStyle
        .copyWith(fontWeight: FontWeight.w500, color: AppColors.black);
    TextStyle _explanationText = AppTextStyle.textStyle.copyWith(
        color: Colors.black, fontWeight: FontWeight.w400, height: 1.2);
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 10),
      padding: EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.topLeft,
      child: RichText(
        text: TextSpan(
          text: 'Explanation: ',
          style: _headingText,
          children: <TextSpan>[
            TextSpan(text: question['explanation'], style: _explanationText),
          ],
        ),
      ),
    );
  }

  Widget answerStatus(Map question) {
    TextStyle _statusText = TextStyle(
        fontSize: 2 * SizeConfig.blockSizeVertical,
        color: (selectedOptionIndex != null &&
                question['options'][selectedOptionIndex]['correct'] == true)
            ? Colors.green
            : Colors.red,
        fontWeight: FontWeight.normal);
    return Container(
        margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        alignment: Alignment.topLeft,
        child: RichText(
          text: TextSpan(
            text: (selectedOptionIndex != null &&
                    question['options'][selectedOptionIndex]['correct'] == true)
                ? 'Right Answer!'
                : 'Wrong Answer!',
            style: _statusText,
          ),
        ));
  }

  Widget startButtonWidget(BuildContext context, BoxConstraints constraints) {
    return Container(
      alignment: Alignment.center,
      height: constraints.maxHeight * .10,
      child: Container(
        height: 6 * SizeConfig.blockSizeVertical,
        width: constraints.maxWidth * .4,
        alignment: Alignment.center,
        child: Material(
          borderRadius: BorderRadius.circular(20),
          color: Dark,
          elevation: 5.0,
          child: MaterialButton(
            onPressed: () {
              CustomSpinner.showLoadingDialog(
                  context, _keyLoader, "Loading...");
              context.read<UserProvider>().changeView = true;
              setState(() {});
              getCategoriesFromApi().then((response_list) {
                log("Category : $response_list");
                Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                    .pop();
                showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return TestSettingDialogBox(
                        categories_list: response_list,
                        onSetValue: (_categoryId) {
                          log("Category id : $_categoryId");
                          gainPoint = 0;
                          questionsList = [];
                          testQuestionsForResult = [];
                          selectedQuestionIndex = 0;
                          selectedOptionIndex = null;
                          category_id = _categoryId;
                          CustomSpinner.showLoadingDialog(
                              context, _keyLoader, "Test loading...");
                          getQuestionsFromApi().then((response_list) {
                            Navigator.of(_keyLoader.currentContext!,
                                    rootNavigator: true)
                                .pop();
                            questionsList = response_list;
                            setState(() => isTestStarted = true);
                          });
                        },
                      );
                    });
              });
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: Container(
                      width: constraints.maxWidth * .9,
                      child: AutoSizeText(
                        'Start Test',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 2.5 * SizeConfig.blockSizeVertical,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(255, 255, 255, 1.0),
                        ),
                      )),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget nextButtonWidget(BuildContext context, BoxConstraints constraints) {
    return Padding(
      padding: EdgeInsets.only(top: 25, bottom: 5),
      child: LayoutBuilder(
        builder: (context, constraints) {
          print('index: $selectedQuestionIndex');
          print('Length: ${questionsList.length}');
          print('walletDetail: ${walletDetail}');
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 5),
            child: CustomButton(
              padding: EdgeInsets.symmetric(vertical: 12),
              onTap: (selectedOptionIndex == null &&
                      (questionsList[selectedQuestionIndex]['type'] == 0 ||
                          (questionsList[selectedQuestionIndex]['type'] == 1 &&
                              walletDetail!['dvsa_subscription'] > 0)))
                  ? null
                  : () {
                      testQuestionsForResult.add({
                        'questionId': questionsList[selectedQuestionIndex]
                            ['id'],
                        'type': questionsList[selectedQuestionIndex]['type'],
                        'question': questionsList[selectedQuestionIndex]
                            ['title'],
                        'correct': (selectedOptionIndex != null &&
                                questionsList[selectedQuestionIndex]['options']
                                        [selectedOptionIndex]['correct'] ==
                                    true)
                            ? 'Correct Answer'
                            : 'Wrong Answer'
                      });
                      if ((selectedQuestionIndex + 1) < questionsList.length) {
                        _controller.animateTo(0,
                            duration: Duration(microseconds: 1000),
                            curve: Curves.slowMiddle);
                        setState(() {
                          selectedOptionIndex = null;
                          selectedQuestionIndex += 1;
                        });
                      }
                      // else if (questionsList[selectedQuestionIndex]['type'] ==
                      //     1) {
                      //   context.read<AuthProvider>().changeView = false;
                      //   setState(() {});
                      // }
                      else {
                        CustomSpinner.showLoadingDialog(
                            context, _keyLoader, "Test Submitting...");
                        submitTestByApi().then((value) {
                          Navigator.of(_keyLoader.currentContext!,
                                  rootNavigator: true)
                              .pop();
                          testCompleAlertBox(context);
                        });
                      }
                    },
              title: selectedQuestionIndex < questionsList.length - 1
                  ? walletDetail!['dvsa_subscription'] <= 0 &&
                          questionsList[selectedQuestionIndex]['type'] == 1
                      ? 'Skip'
                      : 'Next'
                  : 'Test Submit',
            ),
          );
        },
      ),
    );
  }

  calculatePoint(question) {
    if (selectedOptionIndex != null &&
        question['options'][selectedOptionIndex]['correct'] == true) {
      gainPoint += 1;

      log("Points earned : $gainPoint");
    }
  }

  Future<void> testCompleAlertBox(BuildContext parent_context) async {
    return showDialog<void>(
        context: parent_context,
        barrierDismissible: false,
        barrierColor: Colors.black45,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: Responsive.width(5, parent_context),
                      right: Responsive.width(5, parent_context)),
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5.0)), //this right here
                    child: Container(
                      // height: Responsive.height(30, parent_context),
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        //  mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Test finished!",
                                      style: AppTextStyle.titleStyle.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      "Total score: " +
                                          gainPoint.toString() +
                                          " / " +
                                          ((questionsList.length).toString()),
                                      style: AppTextStyle.disStyle.copyWith(
                                          fontWeight: FontWeight.w400)),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 48),
                                    child: CustomButton(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        // setState(() => isTestStarted = false);
                                        // context
                                        //     .read<AuthProvider>()
                                        //     .changeView = true;
                                        // setState(() {});
                                        // Future.delayed(
                                        //     Duration(microseconds: 300), () {
                                        // this.initializeApi("Updating...");
                                        // });
                                      },
                                      title: 'Ok',
                                    ),
                                  ),
                                  // Container(
                                  //   height: 40,
                                  //   width: 100,
                                  //   alignment: Alignment.bottomCenter,
                                  //   child: Material(
                                  //     borderRadius: BorderRadius.circular(10),
                                  //     elevation: 5.0,
                                  //     child: MaterialButton(
                                  //       onPressed: () {
                                  //         Navigator.of(context).pop();
                                  //         Navigator.of(context).pop();
                                  //         setState(() => isTestStarted = false);
                                  //         context.read<AuthProvider>().changeView =
                                  //             true;
                                  //         setState(() {});
                                  //         Future.delayed(
                                  //             Duration(microseconds: 300), () {
                                  //           this.initializeApi("Updating...");
                                  //         });
                                  //       },
                                  //       child: Container(
                                  //        // width: constraints.maxWidth * 0.35,
                                  //         decoration: BoxDecoration(
                                  //             gradient: RadialGradient(
                                  //           colors: [
                                  //             AppColors.primary,
                                  //             AppColors.secondary,
                                  //             AppColors.secondary,
                                  //           ],
                                  //           radius: 10,
                                  //           focal: Alignment(-1.1, -3.0),
                                  //         )),
                                  //         child: Text(
                                  //           'Ok',
                                  //           style: TextStyle(
                                  //             fontFamily: 'Poppins',
                                  //             fontSize: 40,
                                  //             fontWeight: FontWeight.w500,
                                  //             color: AppColors.white,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )
                                ]),
                          )
                        ],
                      ),
                    ),
                  )));
        });
  }

  Future<void> subscriptionConfirmAlert(BuildContext parent_context) async {
    return showDialog<void>(
        context: parent_context,
        barrierDismissible: false,
        barrierColor: Colors.black45,
        builder: (parent_context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: Responsive.width(2, parent_context),
                      right: Responsive.width(2, parent_context)),
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5.0)), //this right here
                    child: Container(
                      height: Responsive.height(30, parent_context),
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Column(children: [
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Are you sure you want to get subscription for DVSA questions?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF595959),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Total charges: £" +
                                    (walletDetail!['subscription_cost'])
                                        .toString(),
                                style: TextStyle(
                                    color: Color(0xFF797979),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: CustomButton(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        title: 'Yes',
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          showLoader("Loading");
                                          isTestStarted = true;
                                          Stripe.publishableKey = stripePublic;
                                          Map params = {
                                            'total_cost': walletDetail![
                                                'subscription_cost'],
                                            'user_type': 2,
                                            'parentPageName': "dvsaSubscription"
                                          };
                                          _paymentService
                                              .makePayment(
                                                  amount: walletDetail![
                                                      'subscription_cost'],
                                                  currency: 'GBP',
                                                  context: parent_context,
                                                  desc:
                                                      'DVSA Subscription by ${userName} (App)',
                                                  metaData: params)
                                              .then((value) => closeLoader());
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: CustomButton(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        title: 'No',
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                    // Container(
                                    //   height: 40,
                                    //   width: 100,
                                    //   alignment: Alignment.bottomCenter,
                                    //   child: Material(
                                    //     borderRadius: BorderRadius.circular(10),
                                    //     color: Dark,
                                    //     elevation: 5.0,
                                    //     child: MaterialButton(onPressed: () {
                                    //
                                    //     }
                                    //         // child: LayoutBuilder(
                                    //         //   builder: (context, constraints) {
                                    //         //     return
                                    //         //     //   Container(
                                    //         //     //   width:
                                    //         //     //       constraints.maxWidth * 0.35,
                                    //         //     //   child: FittedBox(
                                    //         //     //     fit: BoxFit.contain,
                                    //         //     //     child: Text(
                                    //         //     //       'Yes',
                                    //         //     //       style: TextStyle(
                                    //         //     //         fontFamily: 'Poppins',
                                    //         //     //         fontSize: 40,
                                    //         //     //         fontWeight: FontWeight.w500,
                                    //         //     //         color: Color.fromRGBO(
                                    //         //     //             255, 255, 255, 1.0),
                                    //         //     //       ),
                                    //         //     //     ),
                                    //         //     //   ),
                                    //         //     // );
                                    //         //   },
                                    //         // ),
                                    //         ),
                                    //   ),
                                    // ),
                                    // SizedBox(width: 30),
                                    // Container(
                                    //   height: 40,
                                    //   width: 100,
                                    //   alignment: Alignment.bottomCenter,
                                    //   child: Material(
                                    //     borderRadius: BorderRadius.circular(10),
                                    //     color: Colors.black45,
                                    //     elevation: 5.0,
                                    //     child: MaterialButton(
                                    //       onPressed: () {},
                                    //       child: LayoutBuilder(
                                    //         builder: (context, constraints) {
                                    //           return Container(
                                    //             width:
                                    //                 constraints.maxWidth * 0.35,
                                    //             child: FittedBox(
                                    //               fit: BoxFit.contain,
                                    //               child: Text(
                                    //                 'No',
                                    //                 style: TextStyle(
                                    //                   fontFamily: 'Poppins',
                                    //                   fontSize: 40,
                                    //                   fontWeight: FontWeight.w500,
                                    //                   color: Color.fromRGBO(
                                    //                       255, 255, 255, 1.0),
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //           );
                                    //         },
                                    //       ),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              )
                            ]),
                          )
                        ],
                      ),
                    ),
                  )));
        });
  }
}

typedef IntCallback = Function(int num);
