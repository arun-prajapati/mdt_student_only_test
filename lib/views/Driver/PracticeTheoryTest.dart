import 'dart:developer';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:student_app/Constants/app_colors.dart';
import 'package:toast/toast.dart';

import '../../Constants/global.dart';
import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/auth.dart';
import '../../services/navigation_service.dart';
import '../../services/payment_services.dart';
import '../../services/practise_theory_test_services.dart';
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
  final AuthProvider auth_services = new AuthProvider();
  bool isTestStarted = false;
  int selectedQuestionIndex = 0;
  int? selectedOptionIndex;
  int gainPoint = 0;
  late int _userId;
  int category_id = 0;
  Map? walletDetail = null;
  static int? selectedCategoryIndex;
  List questionsList = [];
  List testQuestionsForResult = [];
  List resultRecordsList = [];
  late Map recordOtherData;

  String userName = '';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      this.initializeApi("Loading...");
    });
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
        await Provider.of<AuthProvider>(context, listen: false).getUserData();
    _userId = response['id'];
    userName = "${response['first_name']} ${response['last_name']}";
    return _userId;
  }

  //Call APi Services
  Future<List> getCategoriesFromApi() async {
    List response = await test_api_services.getCategories();
    return response;
  }

  //call api for getQuestions
  Future<List> getQuestionsFromApi() async {
    List response = await test_api_services.getTestQuestions(category_id);
    print(response);
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

  showCorrectAnswerDialog(BuildContext context, String explanation) {
    //print("valid");
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: SizedBox(
              width: SizeConfig.blockSizeHorizontal * 30,
              height: SizeConfig.blockSizeHorizontal * 30,
              child: Image.asset("assets/good_job.png"),
            ),
            actionsAlignment: MainAxisAlignment.center,
            contentPadding: EdgeInsets.fromLTRB(24.0, 15.0, 24.0, 5.0),
            content: Text(
              explanation,
              style: TextStyle(
                fontSize: 2 * SizeConfig.blockSizeVertical,
                color: Colors.black87,
                fontWeight: FontWeight.normal,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Ok",
                  style: TextStyle(color: Dark, fontSize: 18),
                ),
              ),
            ],
          );
        });
  }

  showWrongAnswerDialog(BuildContext context, String explanation) {
    //print("valid");
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: SizedBox(
              width: SizeConfig.blockSizeHorizontal * 30,
              height: SizeConfig.blockSizeHorizontal * 30,
              child: Image.asset(
                "assets/ohh-no.png",
                fit: BoxFit.contain,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            contentPadding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 5.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ohh no!',
                  style: GoogleFonts.caveat(
                    fontSize: 50,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 1,
                ),
                Text(
                  explanation,
                  style: TextStyle(
                    fontSize: 2 * SizeConfig.blockSizeVertical,
                    color: Colors.black87,
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Ok",
                  style: TextStyle(color: Dark, fontSize: 18),
                ),
              ),
            ],
          );
        });
  }

  initializeApi(String loaderMessage) {
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
    log(userName);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          CustomAppBar(
            preferedHeight: Responsive.height(24, context),
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
                  Responsive.width(3, context),
                  Responsive.height(15, context),
                  Responsive.width(3, context),
                  0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      offset: Offset(1, 2),
                      blurRadius: 5.0)
                ],
              ),
              height: Responsive.height(83, context),
              width: Responsive.width(100, context),
              padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
              child: LayoutBuilder(builder: (context, constraints) {
                return Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Container(
                        child: Column(
                          children: [
                            // if (!isTestStarted)
                            //   cardHeader(context, constraints),
                            Container(
                              width: constraints.maxWidth * 1,
                              padding: isTestStarted
                                  ? EdgeInsets.only(
                                      top: constraints.maxHeight * .03)
                                  : EdgeInsets.all(0),
                              height: isTestStarted
                                  ? constraints.maxHeight * .91
                                  : constraints.maxHeight * .78,
                              child: ListView(
                                controller: _controller,
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.only(top: 10),
                                shrinkWrap: true,
                                children: [
                                  if (!isTestStarted)
                                    scoreRecordsGrid(context, constraints),
                                  if (isTestStarted)
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 10, 20, 2),
                                        child: LayoutBuilder(
                                            builder: (context, _constraints) {
                                          return testQuestionWidget(
                                              context,
                                              _constraints,
                                              questionsList[
                                                  selectedQuestionIndex]);
                                        })),
                                  if (selectedOptionIndex != null &&
                                      isTestStarted)
                                    answerExplanation(
                                        questionsList[selectedQuestionIndex]),
                                  if (selectedOptionIndex != null &&
                                      isTestStarted)
                                    answerStatus(
                                        questionsList[selectedQuestionIndex]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isTestStarted)
                        startButtonWidget(context, constraints),
                      if (isTestStarted) nextButtonWidget(context, constraints),
                    ]));
              })),
        ],
      ),
    );
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
      barrierColor: Colors.black45,
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
              // RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(12.0)),
              insetAnimationCurve: Curves.easeOutBack,
              insetPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              backgroundColor: Colors.transparent,
              child: Container(
                height: Responsive.height(80, context),
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Container(
                    //   color: Colors.red,
                    //   child: IconButton(
                    //       color: Colors.white,
                    //       icon: Icon(Icons.close_rounded,
                    //           size: 2 * SizeConfig.blockSizeVertical,
                    //           color: Colors.white),
                    //       onPressed: () {
                    //         Navigator.of(context_).pop();
                    //       }),
                    //   //transform: Matrix4.translationValues(0, 0, 0),
                    // ),
                    Container(
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
                                          fontSize: 1.8 *
                                              SizeConfig.blockSizeVertical,
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
                                          fontSize: 1.8 *
                                              SizeConfig.blockSizeVertical,
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
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                color: Colors.black),
                                            padding:
                                                EdgeInsets.only(right: 10)),
                                        title: AutoSizeText(
                                            'Subscribe to our DVSA Theory Test practice module for just £ 9.99.',
                                            style: TextStyle(
                                                fontSize: 1.8 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                color: Colors.black)),
                                        horizontalTitleGap: 0,
                                        minLeadingWidth: 15,
                                        minVerticalPadding: 5),
                                    ListTile(
                                        leading: Container(
                                            child: Icon(Icons.circle,
                                                size: 1 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                color: Colors.black),
                                            padding:
                                                EdgeInsets.only(right: 10)),
                                        title: AutoSizeText(
                                            "Answer 400 questions correctly and earn 1 token for every correctly answered question.",
                                            style: TextStyle(
                                                fontSize: 1.8 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                color: Colors.black)),
                                        horizontalTitleGap: 0,
                                        minLeadingWidth: 15,
                                        minVerticalPadding: 5),
                                    ListTile(
                                        leading: Container(
                                            child: Icon(Icons.circle,
                                                size: 1 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                color: Colors.black),
                                            padding:
                                                EdgeInsets.only(right: 10)),
                                        title: AutoSizeText(
                                            "The 400 tokens will be split into 2 parts: 200 for the DVSA Theory Test practice module questions and the remaining 200 for MockDrivingTest.com’s sample MCQ based on the actual test pattern.",
                                            style: TextStyle(
                                                fontSize: 1.8 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                color: Colors.black)),
                                        horizontalTitleGap: 0,
                                        minLeadingWidth: 15,
                                        minVerticalPadding: 5),
                                    ListTile(
                                        leading: Container(
                                            child: Icon(Icons.circle,
                                                size: 1 *
                                                    SizeConfig
                                                        .blockSizeVertical,
                                                color: Colors.black),
                                            padding:
                                                EdgeInsets.only(right: 10)),
                                        title: AutoSizeText(
                                            "After earning 200 tokens in each category, you will be eligible for our free DVSA Theory test",
                                            style: TextStyle(
                                                fontSize: 1.8 *
                                                    SizeConfig
                                                        .blockSizeVertical,
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 2, vertical: 10),
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
                                        fontSize:
                                            2 * SizeConfig.blockSizeVertical,
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
                                        fontSize:
                                            2 * SizeConfig.blockSizeVertical,
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
                                          height:
                                              Responsive.height(15, context_),
                                          margin: EdgeInsets.only(
                                              left:
                                                  Responsive.width(3, context_),
                                              right: Responsive.width(
                                                  2, context_)),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2.0),
                                              color: Color.fromRGBO(
                                                  0, 204, 204, 1.0)),
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
                                                      fontWeight:
                                                          FontWeight.w300,
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
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.white)),
                                              SizedBox(
                                                  height: Responsive.width(
                                                      4, context_)),
                                              AutoSizeText("Remaining",
                                                  style: TextStyle(
                                                      fontSize: 1.7 *
                                                          SizeConfig
                                                              .blockSizeVertical,
                                                      fontWeight:
                                                          FontWeight.w300,
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
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.white))
                                            ],
                                          )),
                                      Container(
                                        width: Responsive.width(30, context_),
                                        height: Responsive.height(15, context_),
                                        margin: EdgeInsets.only(
                                            left: Responsive.width(3, context_),
                                            right:
                                                Responsive.width(2, context_)),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                            color: Color.fromRGBO(
                                                115, 89, 255, 1.0)),
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
                                                        ? walletDetail![
                                                            'mdt_bal']
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget scoreRecordsGrid(BuildContext context, BoxConstraints constraints) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          color: Colors.black12,
          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
          margin: EdgeInsets.only(bottom: 10),
          width: constraints.maxWidth * 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: constraints.maxWidth * .30,
                padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                child: AutoSizeText(
                  'Category',
                  style: TextStyle(
                      fontSize: 2 * SizeConfig.blockSizeVertical,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              Container(
                width: constraints.maxWidth * .225,
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: AutoSizeText(
                  'MDT S.',
                  style: TextStyle(
                      fontSize: 2 * SizeConfig.blockSizeVertical,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              // Container(
              //   width: constraints.maxWidth * .225,
              //   padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              //   child: AutoSizeText(
              //     'DVSA S.',
              //     style: TextStyle(
              //         fontSize: 2 * SizeConfig.blockSizeVertical,
              //         fontWeight: FontWeight.w600,
              //         color: Colors.black),
              //   ),
              // ),
              Container(
                width: constraints.maxWidth * .23,
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: AutoSizeText(
                  'Date',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 2 * SizeConfig.blockSizeVertical,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        if (resultRecordsList.length == 0)
          Container(
            margin: EdgeInsets.only(
              top: Responsive.height(5, context),
            ),
            child: Text(
              "No Record",
              style: TextStyle(
                fontSize: 2 * SizeConfig.blockSizeVertical,
              ),
            ),
          ),
        ...resultRecordsList.map(
          (record) => scoreRecordRow(
            constraints,
            record,
          ),
        ),
      ],
    );
  }

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

  Widget testQuestionWidget(
      BuildContext context, BoxConstraints constraints, question) {
    TextStyle _questionTextStyle = TextStyle(
        fontSize: 2.5 * SizeConfig.blockSizeVertical,
        color: Colors.redAccent,
        fontWeight: FontWeight.w500);
    return Stack(children: <Widget>[
      Column(
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 25),
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
                  if (question['title'] != '')
                    AutoSizeText(
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
              )),
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
                      child: AutoSizeText(
                        'Question Source: DVSA',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 2.5 * SizeConfig.blockSizeVertical,
                            color: Dark),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 20),
                      width: constraints.maxWidth * 0.90,
                      child: AutoSizeText(
                        'Please subscribe for DVSA questions.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 2.5 * SizeConfig.blockSizeVertical,
                            color: Colors.black),
                      ),
                    ),
                    Container(
                      height: 6 * SizeConfig.blockSizeVertical,
                      width: constraints.maxWidth * 0.50,
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 10),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: Dark,
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () {
                            subscriptionConfirmAlert(context);
                          },
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Container(
                                  width: constraints.maxWidth * 1,
                                  height: constraints.maxHeight * 1,
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: constraints.maxWidth * 1,
                                    child: AutoSizeText(
                                      'Subscribe',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize:
                                              2 * SizeConfig.blockSizeVertical,
                                          color: Colors.white),
                                    ),
                                  ));
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 20),
                      width: constraints.maxWidth * 0.90,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: constraints.maxWidth * 0.18,
                              alignment: Alignment.topCenter,
                              child: Text("NOTE: ",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          1.8 * SizeConfig.blockSizeVertical))),
                          Container(
                              width: constraints.maxWidth * 0.72,
                              child: Text(
                                  "You can now either subscribe to DVSA module to get "
                                  "full access to the app or skip next 10 questions to move forwards.",
                                  style: TextStyle(
                                      //fontWeight: FontWeight.bold,
                                      fontSize:
                                          2 * SizeConfig.blockSizeVertical))),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        )
    ]);
  }

  Widget radioSingleOptionUI(
      BoxConstraints constraints, option, int option_no, question) {
    TextStyle _answerTextStyle = TextStyle(
        fontSize: 2.5 * SizeConfig.blockSizeVertical,
        color: Colors.black87,
        fontWeight: FontWeight.normal);
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: constraints.maxWidth * .10,
            child: AutoSizeText((option_no + 1).toString() + '.',
                style: _answerTextStyle),
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
              )),
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

  Widget answerExplanation(Map question) {
    TextStyle _headingText = TextStyle(
        fontSize: 2.2 * SizeConfig.blockSizeVertical,
        color: Colors.black,
        fontWeight: FontWeight.w600);
    TextStyle _explanationText = TextStyle(
        fontSize: 2 * SizeConfig.blockSizeVertical,
        color: Colors.black87,
        fontWeight: FontWeight.normal);
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
        ));
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
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: Dark,
          elevation: 5.0,
          child: MaterialButton(
            onPressed: () {
              CustomSpinner.showLoadingDialog(
                  context, _keyLoader, "Loading...");
              getCategoriesFromApi().then((response_list) {
                log("Category : $response_list");
                Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                    .pop();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return TestSettingDialogBox(
                        parentConstraints: constraints,
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
                            setState(() => {isTestStarted = true});
                          });
                        },
                      );
                    });
              });
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
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
                    ));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget nextButtonWidget(BuildContext context, BoxConstraints constraints) {
    return Container(
      height: 5.5 * SizeConfig.blockSizeVertical,
      width: constraints.maxWidth * .4,
      alignment: Alignment.center,
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: (selectedOptionIndex == null &&
                (questionsList[selectedQuestionIndex]['type'] == 0 ||
                    (questionsList[selectedQuestionIndex]['type'] == 1 &&
                        walletDetail!['dvsa_subscription'] > 0)))
            ? Colors.black26
            : Dark,
        elevation: selectedOptionIndex == null ? 0 : 5.0,
        child: MaterialButton(
          onPressed: (selectedOptionIndex == null &&
                  (questionsList[selectedQuestionIndex]['type'] == 0 ||
                      (questionsList[selectedQuestionIndex]['type'] == 1 &&
                          walletDetail!['dvsa_subscription'] > 0)))
              ? null
              : () {
                  testQuestionsForResult.add({
                    'questionId': questionsList[selectedQuestionIndex]['id'],
                    'type': questionsList[selectedQuestionIndex]['type'],
                    'question': questionsList[selectedQuestionIndex]['title'],
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
                  } else {
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: constraints.maxWidth * 0.9,
                child: AutoSizeText(
                  selectedQuestionIndex < questionsList.length - 1
                      ? walletDetail!['dvsa_subscription'] <= 0 &&
                              questionsList[selectedQuestionIndex]['type'] == 1
                          ? 'Skip'
                          : 'Next'
                      : 'Test Submit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 2.5 * SizeConfig.blockSizeVertical,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(255, 255, 255, 1.0),
                  ),
                ),
              );
            },
          ),
        ),
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
                      height: Responsive.height(30, parent_context),
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(children: [
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Test finished!",
                                style: TextStyle(
                                    color: Color(0xFF595959),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 26),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Total score: " +
                                    gainPoint.toString() +
                                    " / " +
                                    ((questionsList.length).toString()),
                                style: TextStyle(
                                    color: Color(0xFF797979),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 40,
                                width: 100,
                                alignment: Alignment.bottomCenter,
                                child: Material(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                  ),
                                  color: Dark,
                                  elevation: 5.0,
                                  child: MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() => {isTestStarted = false});
                                      Future.delayed(
                                          Duration(microseconds: 300), () {
                                        this.initializeApi("Updating...");
                                      });
                                    },
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return Container(
                                          width: constraints.maxWidth * 0.35,
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Text(
                                              'Ok',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 40,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1.0),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
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
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 100,
                                    alignment: Alignment.bottomCenter,
                                    child: Material(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                        bottomLeft: Radius.circular(30),
                                      ),
                                      color: Dark,
                                      elevation: 5.0,
                                      child: MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          showLoader("Loading");
                                          isTestStarted = false;
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
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width:
                                                  constraints.maxWidth * 0.35,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1.0),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    height: 40,
                                    width: 100,
                                    alignment: Alignment.bottomCenter,
                                    child: Material(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                        bottomLeft: Radius.circular(30),
                                      ),
                                      color: Colors.black45,
                                      elevation: 5.0,
                                      child: MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              width:
                                                  constraints.maxWidth * 0.35,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  'No',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1.0),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ]),
                          )
                        ],
                      ),
                    ),
                  )));
        });
  }

  @override
  void didChangeDependencies() {
    print("dependendcies");
    super.didChangeDependencies();
  }
}

typedef IntCallback = Function(int num);

class TestSettingDialogBox extends StatefulWidget {
  final BoxConstraints parentConstraints;
  final IntCallback onSetValue;
  final List categories_list;

  const TestSettingDialogBox(
      {Key? key,
      required this.parentConstraints,
      required this.onSetValue,
      required this.categories_list})
      : super(key: key);

  @override
  _TestSettingDialogBox createState() => _TestSettingDialogBox();
}

class _TestSettingDialogBox extends State<TestSettingDialogBox> {
  TextStyle _answerTextStyle = TextStyle(
      fontSize: 18, color: Colors.black87, fontWeight: FontWeight.normal);
  TextStyle _categoryTextStyle = TextStyle(
      fontSize: 2 * SizeConfig.blockSizeVertical,
      color: Colors.black87,
      fontWeight: FontWeight.normal);
  int seledtedCategoryId = 0;
  List categories = [];
  bool isAllCategoriesSelected = true;
  final PractiseTheoryTestServices test_api_services =
      new PractiseTheoryTestServices();

  @override
  void initState() {
    super.initState();
    for (var e in widget.categories_list) {
      Map category = e;
      category['selected'] = true;
      categories.add(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      insetAnimationCurve: Curves.easeOutBack,
      insetPadding: EdgeInsets.all(20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        height: Responsive.height(55, context),
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            // Container(
            //   width: Responsive.width(100, context),
            //   alignment: Alignment.centerLeft,
            //   margin: EdgeInsets.only(bottom: 10),
            //   child: Text("Select Mode Type*",
            //       style: TextStyle(
            //           fontSize: 15,
            //           fontWeight: FontWeight.w300,
            //           color: Colors.black38)),
            // ),
            // Row(
            //   children: [
            //     Container(
            //       width: Responsive.width(25, context),
            //       height: Responsive.height(5, context),
            //       alignment: Alignment.topLeft,
            //       child: Row(
            //         children: [
            //           Container(
            //             alignment: Alignment.centerLeft,
            //             width: 30,
            //             height: 30,
            //             child: Radio<String>(
            //               activeColor: Dark,
            //               value: 'mdt',
            //               groupValue: _modeType,
            //               onChanged: (val) {
            //                 setState(() {
            //                   _modeType = val;
            //                 });
            //               },
            //             ),
            //           ),
            //           Container(
            //             alignment: Alignment.centerLeft,
            //             child: FlatButton(
            //               padding: EdgeInsets.all(0),
            //               height: 20,
            //               minWidth: 30,
            //               child: Text('MDT', style: _answerTextStyle),
            //               onPressed: () => {
            //                 setState(() {
            //                   _modeType = 'mdt';
            //                 })
            //               },
            //             ),
            //           )
            //         ],
            //       ),
            //     ),
            //     Container(
            //       width: Responsive.width(25, context),
            //       height: Responsive.height(5, context),
            //       alignment: Alignment.topLeft,
            //       child: Row(
            //         children: [
            //           Container(
            //             alignment: Alignment.centerLeft,
            //             width: 30,
            //             height: 30,
            //             child: Radio<String>(
            //               activeColor: Dark,
            //               value: 'dvsa',
            //               groupValue: _modeType,
            //               onChanged: (val) {
            //                 setState(() {
            //                   _modeType = val;
            //                 });
            //               },
            //             ),
            //           ),
            //           Container(
            //             alignment: Alignment.centerLeft,
            //             child: FlatButton(
            //               padding: EdgeInsets.all(0),
            //               height: 20,
            //               minWidth: 30,
            //               child: Text('DVSA', style: _answerTextStyle),
            //               onPressed: () => {
            //                 setState(() {
            //                   _modeType = 'dvsa';
            //                 })
            //               },
            //             ),
            //           )
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            Container(
              width: Responsive.width(100, context),
              height: Responsive.height(4, context),
              alignment: Alignment.centerLeft,
              child: AutoSizeText('Note: Select either all or at least one',
                  style: TextStyle(
                      fontSize: 2 * SizeConfig.blockSizeVertical,
                      color: Colors.redAccent)),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: Responsive.width(37, context),
                  height: Responsive.height(4, context),
                  margin: EdgeInsets.only(top: Responsive.height(0, context)),
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText("Select Category*",
                      style: TextStyle(
                          fontSize: 2.2 * SizeConfig.blockSizeVertical,
                          fontWeight: FontWeight.w300,
                          color: Colors.black38)),
                ),
                Container(
                  width: Responsive.width(37, context),
                  height: Responsive.height(4, context),
                  margin: EdgeInsets.only(top: Responsive.height(0, context)),
                  alignment: Alignment.centerRight,
                  transform: Matrix4.translationValues(10, 0, 0),
                  child: TextButton(
                    child: AutoSizeText('Select All',
                        style: TextStyle(
                            fontSize: 2.2 * SizeConfig.blockSizeVertical,
                            fontWeight: FontWeight.w600)),
                    onPressed: isAllCategoriesSelected
                        ? null
                        : () {
                            resetAll(true);
                            seledtedCategoryId = 0;
                          },
                  ),
                )
              ],
            ),
            Container(
                height: Responsive.height(35, context),
                width: Responsive.width(80, context),
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(bottom: 0, top: 0),
                child: ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      ...categories.map((category) {
                        var index = categories.indexOf(category);
                        return Container(
                          width: Responsive.width(80, context),
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                width: Responsive.width(57, context),
                                child: SizedBox(
                                  width: Responsive.width(55, context),
                                  child: AutoSizeText(category['name'],
                                      style: _categoryTextStyle),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.topRight,
                                  height: 25,
                                  width: Responsive.width(19, context),
                                  child: IconButton(
                                    iconSize: 3 * SizeConfig.blockSizeVertical,
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(
                                        category['selected'] == true
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: category['selected'] == true
                                            ? Dark
                                            : Colors.black),
                                    onPressed: () => {
                                      setState(() {
                                        resetAll(false);
                                        seledtedCategoryId = category['id'];
                                        categories[index]['selected'] = true;
                                      })
                                    },
                                  ))
                            ],
                          ),
                        );
                      }).toList()
                    ])),
            Container(
              height: 5 * SizeConfig.blockSizeVertical,
              width: Responsive.width(30, context),
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(
                top: Responsive.height(2, context),
              ),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                color: Dark,
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                    this.widget.onSetValue(seledtedCategoryId);
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        width: constraints.maxWidth * 1,
                        height: constraints.maxHeight * 1,
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          'Continue',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 2.2 * SizeConfig.blockSizeVertical,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(255, 255, 255, 1.0),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  resetAll(bool isAllSelect) {
    isAllCategoriesSelected = isAllSelect;
    categories.asMap().forEach((index, category) {
      setState(() {
        categories[index]['selected'] = isAllSelect ? true : false;
      });
    });
  }
}
