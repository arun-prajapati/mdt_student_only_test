import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../services/navigation_service.dart';
import '../../utils/app_colors.dart';
import '../../widget/CustomAppBar.dart';

class TestStructure extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomAppBar(
              title: 'Mock Test Structure',
              textWidth: Responsive.width(48, context),
              iconLeft: FontAwesomeIcons.arrowLeft,
              preferedHeight: Responsive.height(15, context),
              onTap1: () {
                _navigationService.goBack();
              },
              iconRight: null),
          Container(
              width: Responsive.width(100, context),
              height: Responsive.height(100, context),
              margin: EdgeInsets.fromLTRB(
                  0.0, Responsive.height(19, context), 0.0, 0.0),
              child: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      testStructureCustom(constraints,
                          no: 01,
                          text:
                              'You make a test booking via www.mockdrivingtest.com '
                              'choose a date, time and test location convenient to you'),
                      testStructureCustom(constraints,
                          no: 02,
                          text:
                              'At the agreed time slot, an Approved Driving Instructor '
                              '(ADI) will meet you at the pre-agreed location.'),
                      testStructureCustom(constraints,
                          no: 03,
                          text:
                              'Student and ADI verify each other based upon the information'
                              ' provided by Mock Driving Test portal 24 hours in advance of the test'),
                      testStructureCustom(constraints,
                          no: 04,
                          text:
                              'The ADI will conduct a mock test in an environment resembling '
                              'the DVSA practical driving test.'),

                      testStructureCustom(constraints,
                          no: 05,
                          text:
                              'The ADI will give you verbal feedback after the test and a'
                              ' detailed report will be available online within 24 hours of test.'),
                      // Stack(
                      //   children: <Widget>[
                      //     Container(
                      //       width: constraints.maxWidth * 0.99,
                      //       height: constraints.maxHeight * 0.2,
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: constraints.maxWidth * 0.03),
                      //       margin: EdgeInsets.fromLTRB(
                      //           constraints.maxWidth * 0.035,
                      //           constraints.maxHeight * 0.04,
                      //           constraints.maxWidth * 0.035,
                      //           constraints.maxHeight * 0.04),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(
                      //             constraints.maxWidth * 0.07),
                      //         color: const Color(0xffffffff),
                      //         border: Border.all(
                      //             width: constraints.maxWidth * 0.005,
                      //             color: const Color(0xff0e9bcf)),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: const Color(0x29000000),
                      //             offset: Offset(0, 3),
                      //             blurRadius: 6,
                      //           ),
                      //         ],
                      //       ),
                      //       child: Container(
                      //         width: constraints.maxWidth * 0.9,
                      //         margin: EdgeInsets.fromLTRB(
                      //             constraints.maxWidth * 0.01,
                      //             constraints.maxHeight * 0.053,
                      //             0.0,
                      //             0.0),
                      //         child: Text(
                      //           'At the agreed time slot, an Approved Driving Instructor (ADI) will meet you at the pre-agreed location.',
                      //           style: TextStyle(
                      //             fontFamily: 'Poppins',
                      //             fontSize: 16,
                      //             color: const Color(0xad060606),
                      //             letterSpacing: 0.132,
                      //           ),
                      //           textAlign: TextAlign.left,
                      //         ),
                      //       ),
                      //     ),
                      //     Positioned(
                      //       top: constraints.maxHeight * 0.01,
                      //       left: constraints.maxWidth * 0.11,
                      //       child: Container(
                      //         width: constraints.maxWidth * 0.3,
                      //         height: constraints.maxHeight * 0.075,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(
                      //               constraints.maxWidth * 0.02),
                      //           color: const Color(0xff22a9ee),
                      //           border: Border.all(
                      //               width: constraints.maxWidth * 0.003,
                      //               color: const Color(0xff707070)),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: const Color(0x29000000),
                      //               offset: Offset(0, 3),
                      //               blurRadius: 6,
                      //             ),
                      //           ],
                      //         ),
                      //         child: Center(
                      //           child: Container(
                      //             width: constraints.maxWidth * 0.24,
                      //             child: FittedBox(
                      //               fit: BoxFit.contain,
                      //               child: Text(
                      //                 'Step 02',
                      //                 style: TextStyle(
                      //                   fontFamily: 'Rift Soft',
                      //                   fontSize: 17,
                      //                   color: const Color(0xffffffff),
                      //                   letterSpacing: 2.55,
                      //                   fontWeight: FontWeight.w300,
                      //                 ),
                      //                 textAlign: TextAlign.center,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Stack(
                      //   children: <Widget>[
                      //     Container(
                      //       width: constraints.maxWidth * 0.99,
                      //       height: constraints.maxHeight * 0.24,
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: constraints.maxWidth * 0.03),
                      //       margin: EdgeInsets.fromLTRB(
                      //           constraints.maxWidth * 0.035,
                      //           constraints.maxHeight * 0.04,
                      //           constraints.maxWidth * 0.035,
                      //           constraints.maxHeight * 0.04),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(
                      //             constraints.maxWidth * 0.07),
                      //         color: const Color(0xffffffff),
                      //         border: Border.all(
                      //             width: constraints.maxWidth * 0.005,
                      //             color: const Color(0xff0e9bcf)),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: const Color(0x29000000),
                      //             offset: Offset(0, 3),
                      //             blurRadius: 6,
                      //           ),
                      //         ],
                      //       ),
                      //       child: Container(
                      //         margin: EdgeInsets.fromLTRB(
                      //             constraints.maxWidth * 0.01,
                      //             constraints.maxHeight * 0.053,
                      //             0.0,
                      //             0.0),
                      //         child: Text(
                      //           'Student and ADI verify each other based upon the information provided by Mock Driving Test portal 24 hours in advance of the test',
                      //           style: TextStyle(
                      //             fontFamily: 'Poppins',
                      //             fontSize: 16,
                      //             color: const Color(0xad060606),
                      //             letterSpacing: 0.132,
                      //             height: 1.1666666666666667,
                      //           ),
                      //           textAlign: TextAlign.left,
                      //         ),
                      //       ),
                      //     ),
                      //     Positioned(
                      //       top: constraints.maxHeight * 0.01,
                      //       left: constraints.maxWidth * 0.11,
                      //       child: Container(
                      //         width: constraints.maxWidth * 0.3,
                      //         height: constraints.maxHeight * 0.075,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(
                      //               constraints.maxWidth * 0.02),
                      //           color: const Color(0xff22a9ee),
                      //           border: Border.all(
                      //               width: constraints.maxWidth * 0.003,
                      //               color: const Color(0xff707070)),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: const Color(0x29000000),
                      //               offset: Offset(0, 3),
                      //               blurRadius: 6,
                      //             ),
                      //           ],
                      //         ),
                      //         child: Center(
                      //           child: Container(
                      //             width: constraints.maxWidth * 0.24,
                      //             child: FittedBox(
                      //               fit: BoxFit.contain,
                      //               child: Text(
                      //                 'Step 03',
                      //                 style: TextStyle(
                      //                   fontFamily: 'Rift Soft',
                      //                   fontSize: 17,
                      //                   color: const Color(0xffffffff),
                      //                   letterSpacing: 2.55,
                      //                   fontWeight: FontWeight.w300,
                      //                 ),
                      //                 textAlign: TextAlign.center,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Stack(
                      //   children: <Widget>[
                      //     Container(
                      //       width: constraints.maxWidth * 0.99,
                      //       height: constraints.maxHeight * 0.2,
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: constraints.maxWidth * 0.03),
                      //       margin: EdgeInsets.fromLTRB(
                      //           constraints.maxWidth * 0.035,
                      //           constraints.maxHeight * 0.04,
                      //           constraints.maxWidth * 0.035,
                      //           constraints.maxHeight * 0.04),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(
                      //             constraints.maxWidth * 0.07),
                      //         color: const Color(0xffffffff),
                      //         border: Border.all(
                      //             width: constraints.maxWidth * 0.005,
                      //             color: const Color(0xff0e9bcf)),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: const Color(0x29000000),
                      //             offset: Offset(0, 3),
                      //             blurRadius: 6,
                      //           ),
                      //         ],
                      //       ),
                      //       child: Container(
                      //           width: constraints.maxWidth * 0.9,
                      //           margin: EdgeInsets.fromLTRB(
                      //               constraints.maxWidth * 0.01,
                      //               constraints.maxHeight * 0.053,
                      //               0.0,
                      //               0),
                      //           child: Text(
                      //             'The ADI will conduct a mock test in an environment resembling the DVSA practical driving test.',
                      //             style: TextStyle(
                      //               fontFamily: 'Poppins',
                      //               fontSize: 16,
                      //               color: const Color(0xad060606),
                      //               letterSpacing: 0.132,
                      //               height: 1.1666666666666667,
                      //             ),
                      //             textAlign: TextAlign.left,
                      //           )),
                      //     ),
                      //     Positioned(
                      //       top: constraints.maxHeight * 0.01,
                      //       left: constraints.maxWidth * 0.11,
                      //       child: Container(
                      //         width: constraints.maxWidth * 0.3,
                      //         height: constraints.maxHeight * 0.075,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(
                      //               constraints.maxWidth * 0.02),
                      //           color: const Color(0xff22a9ee),
                      //           border: Border.all(
                      //               width: constraints.maxWidth * 0.003,
                      //               color: const Color(0xff707070)),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: const Color(0x29000000),
                      //               offset: Offset(0, 3),
                      //               blurRadius: 6,
                      //             ),
                      //           ],
                      //         ),
                      //         child: Center(
                      //           child: Container(
                      //             width: constraints.maxWidth * 0.24,
                      //             child: FittedBox(
                      //               fit: BoxFit.contain,
                      //               child: Text(
                      //                 'Step 04',
                      //                 style: TextStyle(
                      //                   fontFamily: 'Rift Soft',
                      //                   fontSize: 17,
                      //                   color: const Color(0xffffffff),
                      //                   letterSpacing: 2.55,
                      //                   fontWeight: FontWeight.w300,
                      //                 ),
                      //                 textAlign: TextAlign.center,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Stack(
                      //   children: <Widget>[
                      //     Container(
                      //       width: constraints.maxWidth * 0.99,
                      //       height: constraints.maxHeight * 0.24,
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: constraints.maxWidth * 0.03),
                      //       margin: EdgeInsets.fromLTRB(
                      //           constraints.maxWidth * 0.035,
                      //           constraints.maxHeight * 0.04,
                      //           constraints.maxWidth * 0.035,
                      //           constraints.maxHeight * 0.04),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(
                      //             constraints.maxWidth * 0.07),
                      //         color: const Color(0xffffffff),
                      //         border: Border.all(
                      //             width: constraints.maxWidth * 0.005,
                      //             color: const Color(0xff0e9bcf)),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: const Color(0x29000000),
                      //             offset: Offset(0, 3),
                      //             blurRadius: 6,
                      //           ),
                      //         ],
                      //       ),
                      //       child: Container(
                      //           //width: constraints.maxWidth * 0.9,
                      //           margin: EdgeInsets.fromLTRB(
                      //               constraints.maxWidth * 0.01,
                      //               constraints.maxHeight * 0.053,
                      //               0.0,
                      //               0),
                      //           child: Text(
                      //             'The ADI will give you verbal feedback after the test and a detailed report will be available online within 24 hours of test.',
                      //             style: TextStyle(
                      //               fontFamily: 'Poppins',
                      //               fontSize: 16,
                      //               color: const Color(0xad060606),
                      //               letterSpacing: 0.132,
                      //               height: 1.1666666666666667,
                      //             ),
                      //             textAlign: TextAlign.left,
                      //           )),
                      //     ),
                      //     Positioned(
                      //       top: constraints.maxHeight * 0.01,
                      //       left: constraints.maxWidth * 0.11,
                      //       child: Container(
                      //         //width: constraints.maxWidth * 0.3,
                      //         height: constraints.maxHeight * 0.075,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(
                      //               constraints.maxWidth * 0.02),
                      //           color: const Color(0xff22a9ee),
                      //           border: Border.all(
                      //               width: constraints.maxWidth * 0.003,
                      //               color: const Color(0xff707070)),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: const Color(0x29000000),
                      //               offset: Offset(0, 3),
                      //               blurRadius: 6,
                      //             ),
                      //           ],
                      //         ),
                      //         child: Center(
                      //           child: Container(
                      //             width: constraints.maxWidth * 0.24,
                      //             child: FittedBox(
                      //               fit: BoxFit.contain,
                      //               child: Text(
                      //                 'Step 05',
                      //                 style: TextStyle(
                      //                   fontFamily: 'Rift Soft',
                      //                   fontSize: 17,
                      //                   color: const Color(0xffffffff),
                      //                   letterSpacing: 2.55,
                      //                   fontWeight: FontWeight.w300,
                      //                 ),
                      //                 textAlign: TextAlign.center,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                );
              })),
        ],
      ),
    );
  }

  Stack testStructureCustom(BoxConstraints constraints,
      {required String text, required int no}) {
    return Stack(
      children: <Widget>[
        Container(
          width: constraints.maxWidth * 0.99,
          height: constraints.maxHeight * 0.20,
          padding:
              EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.02),
          margin: EdgeInsets.fromLTRB(
              constraints.maxWidth * 0.035,
              constraints.maxHeight * 0.04,
              constraints.maxWidth * 0.035,
              constraints.maxHeight * 0.04),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(constraints.maxWidth * 0.07),
            color: const Color(0xffffffff),
            border: Border.all(
                width: constraints.maxWidth * 0.005,
                color: const Color(0xff0e9bcf)),
            boxShadow: [
              BoxShadow(
                color: const Color(0x29000000),
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Container(
            width: constraints.maxWidth * 0.9,
            margin: EdgeInsets.fromLTRB(constraints.maxWidth * 0.02,
                constraints.maxHeight * 0.054, 0.0, 0.0),
            child: Text(
              text,
              //'You make a test booking via www.mockdrivingtest.com (
              // choose a date, time and test location convenient to you)',
              style: AppTextStyle.disStyle.copyWith(
                  color: AppColors.black, fontWeight: FontWeight.w400),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Positioned(
          top: constraints.maxHeight * 0.01,
          left: constraints.maxWidth * 0.11,
          child: Container(
            width: constraints.maxWidth * 0.31,
            height: constraints.maxHeight * 0.065,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(constraints.maxWidth * 0.02),
              color: const Color(0xff22a9ee),
              border: Border.all(
                  width: constraints.maxWidth * 0.003,
                  color: const Color(0xff707070)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Step $no',
                style: TextStyle(
                  fontFamily: 'Rift Soft',
                  fontSize: 18,
                  color: const Color(0xffffffff),
                  letterSpacing: 2.55,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NewRecipeModel {
  int? status;
  String? message;
  NewRecipeResult? result;

  NewRecipeModel({this.status, this.message, this.result});

  NewRecipeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result = json['result'] != null
        ? new NewRecipeResult.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class NewRecipeResult {
  String? id;
  String? title;
  String? description;
  String? imageUrl;
  int? serves;
  String? prepTime;
  String? cookTime;
  int? calories;
  int? protein;
  int? carbs;
  int? fat;
  List<GetResourcesNutritionMeal>? getResourcesNutritionMeal;

  NewRecipeResult(
      {this.id,
      this.title,
      this.description,
      this.imageUrl,
      this.serves,
      this.prepTime,
      this.cookTime,
      this.calories,
      this.protein,
      this.carbs,
      this.fat,
      this.getResourcesNutritionMeal});

  NewRecipeResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    serves = json['serves'];
    prepTime = json['prepTime'];
    cookTime = json['cookTime'];
    calories = json['calories'];
    protein = json['protein'];
    carbs = json['carbs'];
    fat = json['fat'];
    if (json['getResourcesNutritionMeal'] != null) {
      getResourcesNutritionMeal = <GetResourcesNutritionMeal>[];
      json['getResourcesNutritionMeal'].forEach((v) {
        getResourcesNutritionMeal!
            .add(new GetResourcesNutritionMeal.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['imageUrl'] = this.imageUrl;
    data['serves'] = this.serves;
    data['prepTime'] = this.prepTime;
    data['cookTime'] = this.cookTime;
    data['calories'] = this.calories;
    data['protein'] = this.protein;
    data['carbs'] = this.carbs;
    data['fat'] = this.fat;
    if (this.getResourcesNutritionMeal != null) {
      data['getResourcesNutritionMeal'] =
          this.getResourcesNutritionMeal!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetResourcesNutritionMeal {
  String? id;
  String? resourceLibraryId;
  String? categoryId;
  String? type;
  String? qtyType;
  String? foodName;
  int? weight;
  String? calories;
  String? protein;
  String? carbs;
  String? fat;
  String? image;

  GetResourcesNutritionMeal(
      {this.id,
      this.resourceLibraryId,
      this.categoryId,
      this.type,
      this.qtyType,
      this.foodName,
      this.weight,
      this.calories,
      this.protein,
      this.carbs,
      this.fat,
      this.image});

  GetResourcesNutritionMeal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resourceLibraryId = json['resourceLibraryId'];
    categoryId = json['categoryId'];
    type = json['type'];
    qtyType = json['qtyType'];
    foodName = json['foodName'];
    weight = json['weight'];
    calories = json['calories'];
    protein = json['protein'];
    carbs = json['carbs'];
    fat = json['fat'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['resourceLibraryId'] = this.resourceLibraryId;
    data['categoryId'] = this.categoryId;
    data['type'] = this.type;
    data['qtyType'] = this.qtyType;
    data['foodName'] = this.foodName;
    data['weight'] = this.weight;
    data['calories'] = this.calories;
    data['protein'] = this.protein;
    data['carbs'] = this.carbs;
    data['fat'] = this.fat;
    data['image'] = this.image;
    return data;
  }
}
