import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:Smart_Theory_Test/datamodels/ai_data_model.dart';
import 'package:Smart_Theory_Test/external.dart';
import 'package:Smart_Theory_Test/services/subsciption_provider.dart';
import 'package:Smart_Theory_Test/views/DashboardGridView/TheoryTab.dart';
import 'package:Smart_Theory_Test/views/Home/home_content_mobile.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Smart_Theory_Test/Constants/app_colors.dart';
import 'package:Smart_Theory_Test/custom_button.dart';
import 'package:Smart_Theory_Test/json_model.dart';
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

  // final _controller = ScrollController();
  final PractiseTheoryTestServices test_api_services =
      new PractiseTheoryTestServices();
  final PaymentService _paymentService = new PaymentService();
  PageController _controller = PageController();

  // final AuthProvider auth_services = new AuthProvider();
  var haseMore = false;
  bool isTestStarted = false;
  int selectedQuestionIndex = 0;
  int? selectedOptionIndex;
  int gainPoint = 0;
  int currentQuestionCount = 1;
  int wrongAnswerPoint = 0;
  var questionMap = {};
  bool showblur = false;

  // late int _userId;
  String category_id = "0";

  // Map? walletDetail = null;
  int selectedCategoryIndex = 0;
  int page = 1;
  List questionsList = [];

  // List categoryFromQuestionsList = [];
  List<PracticeTestCategoryModel> categoryList = [];
  List responseList = [];
  List testQuestionsForResult = [];
  List resultRecordsList = [];
  late Map recordOtherData;

  // String userName = '';

  //
  // getData() async {
  //   return getCategoriesFromApi().then((response_list) {
  //     responseList.clear();
  //     responseList.addAll(response_list);
  //     print("------------ responseList ${responseList}");
  //     setState(() {});
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // getNewCat();
    Future.delayed(Duration.zero, () {
      this.initializeApi("Loading...");
    });
    // getTheoryContent(
    //     '${context.read<SubscriptionProvider>().entitlement == Entitlement.unpaid && AppConstant.userModel?.planType == "free" ? "no" : "yes"}');
    // getData();
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
  // Future<int> getUserDetail() async {
  //   Map response =
  //       await Provider.of<UserProvider>(context, listen: false).getUserData();
  //   _userId = response['id'];
  //   // userName = "${response['first_name']} ${response['last_name']}";
  //   return _userId;
  // }

  /// =========== ///
  // Future<Widget> getNewCat() async {
  //   final url = Uri.parse("$api/api/get-categories");
  //   SharedPreferences storage = await SharedPreferences.getInstance();
  //   String token = storage.getString('token').toString();
  //   Map<String, String> header = {
  //     'token': token,
  //   };
  //   final response = await http.get(url, headers: header);
  //   if (response.statusCode == 200) {
  //     log("++++++++++++++++= ${response.body}");
  //     var parsedData = jsonDecode(response.body);
  //     if (parsedData['success'] == true) {
  //       categoryList = (parsedData['data'] as List)
  //           .map(
  //             (e) => PracticeTestCategoryModel.fromJson(e),
  //           )
  //           .toList();
  //       setState(() {});
  //       return SizedBox();
  //     } else {
  //       categoryList = [];
  //       setState(() {});
  //       return SizedBox();
  //     }
  //   } else {
  //     return SizedBox();
  //   }
  // }

  /// ==========///
  //Call APi Services
  Future<List> getCategoriesFromApi() async {
    List response = await test_api_services.getCategories(context);
    return response;
  }

  getCountFromCategory() async {
    final url = Uri.parse(
        "$api/api/get-categories?is_paid=${AppConstant.userModel?.planType == "free" ? "no" : "yes"}&category_id=$category_id");
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    print('URL getCategories ****************** $url');
    final response = await http.get(url, headers: header);
    var data = jsonDecode(response.body);
    log("RESPONSE getTestQuestions ++++++++++++++++ ${response.body}");
    questionMap = data;
    // gainPoint = questionMap['correct_question_count'];
    // wrongAnswerPoint = questionMap['incorrect_question_count'];
    setState(() {});
    print('============== ${questionMap['attempt_question_count']}');
  }

  Future<Map> getTheoryContent(String isFree) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final url = Uri.parse('$api/api/ai_get_theory_content/$isFree');
    final response = await http.get(url, headers: header);
    print("URL +++++++ $url");
    if (response.statusCode == 200) {
      var parsedData = jsonDecode(response.body);
      if (parsedData['success'] == true) {
        responseList.clear();
        List<TheoryContentModel> data = (parsedData["message"] as List)
            .map((e) => TheoryContentModel.fromJson(e))
            .toList();
        responseList.addAll(data);
        print("RESPONESE +++++++ $parsedData");
      }
    } else {
      log('ERORRRR ${response.body}');
    }

    return jsonDecode(response.body);
  }

  //call api for getQuestions
  // Future<List> getQuestionsFromApi() async {
  //   List response = await test_api_services.getTestQuestions(category_id, page);
  //
  //   return response;
  // }

  Future<List> getTestQuestions(String _categoryId) async {
    String URL = "$api/api/get-questions?category_id=" +
        _categoryId.toString() +
        "&page=$page";
    final url = Uri.parse(URL);
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token').toString();
    Map<String, String> header = {
      'token': token,
    };
    final response = await http.get(url, headers: header);
    var data = jsonDecode(response.body);
    print("getTestQuestions URL ${URL}");
    log("RESPONSE getTestQuestions ++++++++++++++++ ${response.body}");

    // questionMap = data;
    questionsList = data['data'];
    // categoryFromQuestionsList = data['category_list'];
    haseMore = data['hasMoreResults'] == 1 ? true : false;

    setState(() {});
    return data['data'];
  }

  // Future<List> getCategoryFromQuestions() async {
  //   List response =
  //       await test_api_services.getCategoryFromQuestionList(category_id);
  //
  //   return response;
  // }

  // Future<int> getHasMoreResult() async {
  //   var response = await test_api_services.getHasMoreResult(category_id, page);
  //   if (response > 0) {
  //     haseMore = true;
  //     setState(() {});
  //   }
  //   return response;
  // }

  //call api for getQuestions
  // Future<Map> getAllRecordsFromApi() async {
  //   Map response = await test_api_services.getAllRecords(2, _userId);
  //   return response;
  // }

  //call api for getQuestions
  Future<Map> submitTestByApi() async {
    log("Results : $testQuestionsForResult");
    log("Category id : $category_id");
    Map response = await test_api_services.submitTest(
      2,
      AppConstant.userModel!.userId!,
      testQuestionsForResult,
      category_id,
    );
    return response;
  }

  Future<Map> resetTestByApi() async {
    Map response = await test_api_services.resetTest(
      category_id,
    );
    return response;
  }

  PageController scrollController = PageController();

  initializeApi(String loaderMessage) async {
    // auth_services.changeView = false;
    // setState(() {});
    await context.read<SubscriptionProvider>().fetchOffer();
    checkInternet();
    // CustomSpinner.showLoadingDialog(context, _keyLoader, loaderMessage);
    // getUserDetail().then((user_id) {
    //   getAllRecordsFromApi().then((records_list) {
    //     setState(() {
    //       walletDetail = records_list['other_data'];
    //       resultRecordsList = records_list['test_record'] as List;
    //     });
    //     Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ToastContext().init(context);
    print(
        "auth_services.changeView ${context.read<UserProvider>().changeView}");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: context.read<UserProvider>().changeView
          ? TestSettingDialogBox(
              categories_list: responseList,
              onSetValue: (_categoryId) {
                log("Category id : $_categoryId");
                // if (_categoryId == 0) {
                //   Fluttertoast.showToast(
                //       msg: 'Please select category', gravity: ToastGravity.TOP);
                // } else {
                gainPoint = 0;
                questionsList = [];
                testQuestionsForResult = [];
                selectedQuestionIndex = 0;
                selectedCategoryIndex = 0;
                selectedOptionIndex = null;
                category_id = _categoryId;
                getCountFromCategory();
                CustomSpinner.showLoadingDialog(
                    context, _keyLoader, "Test loading...");
                getTestQuestions(category_id).then((response_list) {
                  questionsList = response_list;
                  if (AppConstant.userModel?.planType != "free"&&questionsList.isNotEmpty) {
                    if (questionsList[selectedQuestionIndex]
                            ['attempt_question_count'] !=
                        0) {
                      currentQuestionCount =
                          questionsList[selectedQuestionIndex]
                                  ['attempt_question_count'] +
                              1;
                    }
                    gainPoint = questionsList[selectedQuestionIndex]
                        ['correct_question_count'];
                    wrongAnswerPoint = questionsList[selectedQuestionIndex]
                        ['incorrect_question_count'];
                  } else {
                    if(questionsList.isNotEmpty){
                    if (questionMap['attempt_question_count'] != 0) {
                      currentQuestionCount =
                          questionMap['attempt_question_count'] + 1;
                    }
                    gainPoint = questionMap['correct_question_count'];
                    wrongAnswerPoint = questionMap['incorrect_question_count'];}
                  }

                  // else {
                  setState(() => isTestStarted = true);
                  Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                      .pop();
                  if (
                  // currentQuestionCount >=
                          questionMap['attempt_question_count'] >=
                          questionMap['total_question_count'] &&
                      !category_id.contains(',')) {
                    testResetAlertBox(context, isInit: true);
                  }
                  // }

                  // context.read<AuthProvider>().changeView = true;

                  // getHasMoreResult();
                });
                // getCategoryFromQuestions().then((category) {
                //   categoryFromQuestionsList = category;
                // });
                // }
              },
            )
          : Stack(
              children: <Widget>[
                CustomAppBar(
                  preferedHeight: Responsive.height(11, context),
                  title: 'Practice Theory Test Questions',
                  textWidth: Responsive.width(35, context),
                  iconLeft: Icons.arrow_back,
                  // iconRight: Icons.refresh_rounded,
                  onTap1: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => HomeScreen()),
                        (route) => false);
                  },
                  // onTapRightbtn: () {
                  //   initializeApi("Refreshing...");
                  // },
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(
                        //Responsive.width(3, context),
                        0,
                        MediaQuery.of(context).size.height * 0.115,
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
                      return questionsList.isEmpty && !haseMore
                          ? Center(child: Text("No question found"))
                          : PageView.builder(
                              controller: _controller,
                              allowImplicitScrolling: false,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: questionsList.length,
                              // onPageChanged: (val) async {
                              //   if (val == questionsList.length - 1) {
                              //     page++;
                              //     await getTestQuestions(category_id, page + 1,
                              //         isMore: true);
                              //   }
                              //   print(
                              //       'value---------- ${val} ${questionsList.length}');
                              // },
                              itemBuilder: (c, index) {
                                if (index == questionsList.length - 1 &&
                                    haseMore) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                        child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          color: Dark),
                                    )),
                                  );
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: const FractionalOffset(
                                                0.0, 0.0),
                                            end: const FractionalOffset(
                                                1.0, 0.0),
                                            colors: [
                                              Color(0xFF79e6c9)
                                                  .withOpacity(0.1),
                                              Color(0xFF38b8cd)
                                                  .withOpacity(0.1),
                                            ],
                                            stops: [0.0, 1.0],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: AppColors.grey
                                                  .withOpacity(.30)),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                                "${questionsList[selectedQuestionIndex]['category']}",
                                                style: AppTextStyle.textStyle
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 18)),
                                            // SizedBox(height: 10),

                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text("Correct : $gainPoint",
                                                        style: AppTextStyle
                                                            .textStyle
                                                            .copyWith(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .green)),
                                                    // Text(
                                                    //     "Correct : $gainPoint/${questionsList[selectedQuestionIndex]['total_question_count']}",
                                                    //     style: AppTextStyle
                                                    //         .textStyle
                                                    //         .copyWith(
                                                    //             fontSize: 15,
                                                    //             fontWeight:
                                                    //                 FontWeight
                                                    //                     .w400,
                                                    //             color: Colors
                                                    //                 .green)),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                        "Incorrect : $wrongAnswerPoint",
                                                        style: AppTextStyle
                                                            .textStyle
                                                            .copyWith(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .red)),
                                                    // Text(
                                                    //     "Incorrect : $wrongAnswerPoint/${questionsList[selectedQuestionIndex]['total_question_count']}",
                                                    //     style: AppTextStyle
                                                    //         .textStyle
                                                    //         .copyWith(
                                                    //             fontSize: 15,
                                                    //             fontWeight:
                                                    //                 FontWeight
                                                    //                     .w400,
                                                    //             color: Colors
                                                    //                 .red)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, top: 5),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            "Question $currentQuestionCount of ${AppConstant.userModel?.planType != "free" ? questionsList[selectedQuestionIndex]['total_question_count'] : questionMap['total_question_count']}",
                                            style: AppTextStyle.textStyle
                                                .copyWith(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black)),
                                      ),
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            if (isTestStarted)
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 10, 20, 2),
                                                child: LayoutBuilder(
                                                  builder:
                                                      (context, _constraints) {
                                                    return testQuestionWidget(
                                                      context,
                                                      _constraints,
                                                      questionsList[
                                                          selectedQuestionIndex],
                                                    );
                                                  },
                                                ),
                                              ),
                                            if (selectedOptionIndex != null &&
                                                isTestStarted)
                                              answerExplanation(
                                                questionsList[
                                                    selectedQuestionIndex],
                                              ),
                                            if (selectedOptionIndex != null &&
                                                isTestStarted)
                                              answerStatus(
                                                questionsList[
                                                    selectedQuestionIndex],
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (!isTestStarted)
                                      startButtonWidget(context, constraints),
                                    if (isTestStarted)
                                      AppConstant.userModel?.planType ==
                                                  "free" &&
                                              currentQuestionCount > 10
                                          ? SizedBox()
                                          : nextButtonWidget(
                                              context, constraints),
                                  ],
                                );
                              });
                    })),
              ],
            ),
    );
    // }
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
                visualDensity: VisualDensity.comfortable,
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
    return Consumer<SubscriptionProvider>(builder: (context, data, _) {
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
                    question,
                  )),
            ],
          ),
          // if (question['type'] == 1 &&
          //     AppConstant.userModel?.planType == "free")
          //   SizedBox(),
          if (AppConstant.userModel?.planType == "free" &&
              // question['type'] == 1 ||
              currentQuestionCount > 10)
            Container(
              width: Responsive.height(100, context),
              height: Responsive.height(100, context),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 1),
                child: Container(
                    color: Colors.white.withOpacity(0.9),
                    padding: EdgeInsets.only(
                      top: Responsive.height(20, context),
                    ),
                    alignment: Alignment.topCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(top: 20),
                          width: constraints.maxWidth * 0.90,
                          child:
                              AutoSizeText('Please buy now for more questions.',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.textStyle.copyWith(
                                    fontWeight: FontWeight.w400,
                                  )),
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
                                // resetTestByApi();
                                subscriptionConfirmAlert(context);
                              },
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Container(
                                      width: constraints.maxWidth * 1,
                                      height: constraints.maxHeight * 1,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                        child: AutoSizeText('Buy Now',
                                            textAlign: TextAlign.center,
                                            style:
                                                AppTextStyle.textStyle.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            )),
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
                                      'Please purchase license to access more question in this category',
                                      style: AppTextStyle.disStyle.copyWith(
                                          fontWeight: FontWeight.w400))),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            )
          else ...[SizedBox()]
        ],
      );
    });
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

  // void updateQuestionCount(int newSelectedCategoryIndex) {
  //   int count = 0;
  //   for (var data in categoryFromQuestionsList) {
  //     if (selectedOptionIndex != null &&
  //         questionsList[selectedQuestionIndex]['category_id'] == data['id']) {
  //       count++;
  //     }
  //   }
  //   setState(() {
  //     currentQuestionCount = count;
  //     selectedCategoryIndex = newSelectedCategoryIndex;
  //   });
  //   print(
  //       '@@@@@@@@@========== $currentQuestionCount $newSelectedCategoryIndex');
  // }

  Widget nextButtonWidget(BuildContext context, BoxConstraints constraints) {
    return LayoutBuilder(
      builder: (context, constraints) {
        print('index: $selectedQuestionIndex');
        // print('Length: ${questionsList.length}');
        // print('walletDetail: ${walletDetail}');
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 0),
          child: Consumer<SubscriptionProvider>(builder: (context, val, _) {
            return CustomButton(
              padding: EdgeInsets.symmetric(vertical: 12),
              onTap: (selectedOptionIndex == null &&
                      (questionsList[selectedQuestionIndex]['type'] == 0 ||
                          (questionsList[selectedQuestionIndex]['type'] == 1 &&
                              val.entitlement == Entitlement.paid)))
                  ? () {
                      // resetTestByApi();
                      print('IFFFF ------------');
                    }
                  : () {
                      // getCountFromCategory();
                      // resetTestByApi();
                      if (questionMap['attempt_question_count'] >
                          questionMap['total_question_count'] &&
                          !category_id.contains(',')) {
                        testResetAlertBox(context);
                      } else {
                        if (selectedOptionIndex != null) {
                          if (questionMap['total_question_count'] ==
                              currentQuestionCount) {
                            currentQuestionCount = 1;
                          } else {
                            // if (selectedQuestionIndex != 0) {
                            currentQuestionCount += 1;
                            // }
                          }
                        }

                        print(
                            'ELSE------------ ${currentQuestionCount} == ${category_id.contains(',')}');
                        if (AppConstant.userModel?.planType == "free") {
                          testQuestionsForResult.clear();
                          testQuestionsForResult.add({
                            'questionId': questionsList[selectedQuestionIndex]
                                ['id'],
                            'type': questionsList[selectedQuestionIndex]
                                ['type'],
                            'question': questionsList[selectedQuestionIndex]
                                ['title'],
                            'correct': (selectedOptionIndex != null &&
                                    questionsList[selectedQuestionIndex]
                                                ['options'][selectedOptionIndex]
                                            ['correct'] ==
                                        true)
                                ? 'Correct Answer'
                                : 'Wrong Answer',
                            "alternative_questions_id":
                                questionsList[selectedQuestionIndex]
                                    ['alternative_questions_id'],
                          });
                        } else if (AppConstant.userModel?.planType != "free") {
                          testQuestionsForResult.clear();
                          testQuestionsForResult.add({
                            'questionId': questionsList[selectedQuestionIndex]
                                ['id'],
                            'type': questionsList[selectedQuestionIndex]
                                ['type'],
                            'question': questionsList[selectedQuestionIndex]
                                ['title'],
                            'correct': (selectedOptionIndex != null &&
                                    questionsList[selectedQuestionIndex]
                                                ['options'][selectedOptionIndex]
                                            ['correct'] ==
                                        true)
                                ? 'Correct Answer'
                                : 'Wrong Answer',
                            "alternative_questions_id":
                                questionsList[selectedQuestionIndex]
                                    ['alternative_questions_id'],
                          });
                        }

                        if (selectedOptionIndex != null) {
                          if ((selectedQuestionIndex + 1) <
                              questionsList.length) {
                            _controller.animateTo(0,
                                duration: Duration(microseconds: 1000),
                                curve: Curves.slowMiddle);
                            setState(() {
                              selectedOptionIndex = null;
                              selectedQuestionIndex += 1;
                            });
                            // if (AppConstant.userModel?.planType != "free") {
                            submitTestByApi().then((value) {});
                            // resetTestByApi();
                            // }
                          } else {
                            if (questionMap['attempt_question_count'] <
                                questionMap['total_question_count'] &&
                                !category_id.contains(',')) {
                              submitTestByApi();
                              // testResetAlertBox(context);
                            }
                            print('opopoposz ${questionMap['attempt_question_count']} > ${questionMap['total_question_count'] }');
                          }
                        }
                        // else {
                        //   if (AppConstant.userModel?.planType == "free") {
                        //     CustomSpinner.showLoadingDialog(
                        //         context, _keyLoader, "Test Submitting...");
                        //     // submitTestByApi().then((value) {
                        //     //   Navigator.of(_keyLoader.currentContext!,
                        //     //           rootNavigator: true)
                        //     //       .pop();
                        //     testCompleAlertBox(context);
                        //     // });
                        //   }
                        // }
                        if (AppConstant.userModel?.planType != "free") {
                          if (selectedQuestionIndex ==
                                  questionsList.length - 1 &&
                              haseMore) {
                            CustomSpinner.showLoadingDialog(
                                context, _keyLoader, "Load more question...");
                            page++;
                            // questionsList.clear();
                            selectedQuestionIndex = 0;

                            getTestQuestions(category_id).then((value) {
                              questionsList = value;
                              setState(() {});
                              Navigator.of(_keyLoader.currentContext!,
                                      rootNavigator: true)
                                  .pop();
                            });
                          }
                        }
                      }
                      // resetTestByApi();
                      // if (AppConstant.userModel?.planType == "free" &&
                      //     currentQuestionCount > 10) {
                      //   showblur = true;
                      // }
                      // if (!haseMore) {
                      //   testResetAlertBox(context);
                      // }
                      // setState(() {});
                      print(
                          'testQuestionsForResult ${testQuestionsForResult.length}');
                      print(
                          'type------------ ${currentQuestionCount}  ${questionMap['total_question_count']} ${questionsList.length}');
                    },
              title: currentQuestionCount != questionMap['total_question_count']
                  ? AppConstant.userModel?.planType == "free" &&
                          currentQuestionCount > 10
                      ? 'Test Submit'
                      : 'Next'
                  : 'Test Reset',
            );
          }),
        );
      },
    );
  }

  calculatePoint(question) {
    if (selectedOptionIndex != null &&
        question['options'][selectedOptionIndex]['correct'] == true) {
      if (questionsList[selectedQuestionIndex]['total_question_count'] >
          currentQuestionCount) {
        gainPoint = 0;
      } else {
        gainPoint += 1;
      }
      log("Points earned : $gainPoint");
    }
    if ((selectedOptionIndex != null &&
        questionsList[selectedQuestionIndex]['options'][selectedOptionIndex]
                ['correct'] ==
            false)) {
      if (questionMap['total_question_count'] > currentQuestionCount) {
        wrongAnswerPoint = 0;
      } else {
        wrongAnswerPoint += 1;
      }
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
                    insetPadding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    //this right here
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
                                          ((questionsList.length - 1)
                                              .toString()),
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
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => HomeScreen()),
                                            (route) => false);
                                        // Navigator.of(context).pop();
                                        // Navigator.of(context).pop();
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

  Future<void> testResetAlertBox(BuildContext parent_context,
      {bool isInit = false}) async {
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
                    insetPadding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    //this right here
                    child: Container(
                      // height: Responsive.height(30, parent_context),
                      padding: EdgeInsets.fromLTRB(10, 12, 10, 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        //  mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Test Reset",
                                      style: AppTextStyle.titleStyle.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      "Reset test will reset all your question",
                                      style: AppTextStyle.disStyle.copyWith(
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                      "Are you sure you want to reset your test?",
                                      style: AppTextStyle.disStyle.copyWith(
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 38),
                                    child: isInit
                                        ? CustomButton(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            onTap: () {
                                              // _navigationService.goBack();
                                              CustomSpinner.showLoadingDialog(
                                                  context,
                                                  _keyLoader,
                                                  "Test Reset...");
                                              resetTestByApi().then((value) {
                                                Navigator.of(
                                                        _keyLoader
                                                            .currentContext!,
                                                        rootNavigator: true)
                                                    .pop();
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            HomeScreen()),
                                                    (route) => false);
                                              });
                                            },
                                            title: 'OK',
                                          )
                                        : Row(
                                            children: [
                                              Expanded(
                                                child: CustomButton(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  onTap: () {
                                                    // _navigationService.goBack();
                                                    CustomSpinner
                                                        .showLoadingDialog(
                                                            context,
                                                            _keyLoader,
                                                            "Test Reset...");
                                                    resetTestByApi()
                                                        .then((value) {
                                                      Navigator.of(
                                                              _keyLoader
                                                                  .currentContext!,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                      Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  HomeScreen()),
                                                          (route) => false);
                                                    });
                                                  },
                                                  title: 'Yes',
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              Expanded(
                                                child: CustomButton(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  onTap: () {
                                                    _navigationService.goBack();
                                                  },
                                                  title: 'No',
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
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
          return new PopScope(
              onPopInvoked: (val) async => false,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: Responsive.width(2, parent_context),
                      right: Responsive.width(2, parent_context)),
                  child: Dialog(
                    insetPadding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    //this right here
                    child: Container(
                      // height: Responsive.height(30, parent_context),
                      padding: EdgeInsets.fromLTRB(10, 25, 10, 25),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Column(children: [
                              // SizedBox(
                              //   height: 30,
                              // ),
                              Text(
                                "Are you sure you want to buy now for more questions?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF595959),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Total charges: ${context.read<SubscriptionProvider>().package.first.storeProduct.priceString}"
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
                                        title: 'Buy Now',
                                        onTap: () {
                                          payWallBottomSheet();
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: CustomButton(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        title: 'Cancel',
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
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

  payWallBottomSheet() {
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
              child: Consumer<SubscriptionProvider>(builder: (c, val, _) {
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

  purchasePackage(Package package, BuildContext context) async {
    loading(value: true);
    try {
      loading(value: true);
      await Purchases.purchasePackage(package).then((value) {
        loading(value: false);
        print('HHHHHHHHH');
        context.read<SubscriptionProvider>().updateUserPlan(
            value.entitlements.active['One time purchase']?.isActive == true
                ? "paid"
                : AppConstant.userModel?.planType == "gift"
                    ? "gift"
                    : "free");
        context
            .read<SubscriptionProvider>()
            .isUserPurchaseTest(context: context);
        context.read<SubscriptionProvider>().isUserPurchaseTest();
      }).catchError((e) {
        loading(value: false);
        print("ERROR ====== $e");

        return e;
      });
    } catch (e) {
      loading(value: false);
      print("ERROR ====== $e");
    }
  }
}

typedef IntCallback = Function(int num);
