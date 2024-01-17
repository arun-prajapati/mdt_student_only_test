import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../Constants/app_colors.dart';
import '../responsive/percentage_mediaquery.dart';
import '../responsive/size_config.dart';
import '../services/practise_theory_test_services.dart';
import '../views/Driver/PracticeTheoryTest.dart';

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
        padding: EdgeInsets.fromLTRB(10, 12, 10, 5),
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
              height: Responsive.height(5.5, context),
              //alignment: Alignment.centerLeft,
              child: Center(
                child: Text('Note: Select the topic you would like to revise.',
                    style: TextStyle(fontSize: 16, color: Colors.redAccent)),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: Responsive.width(37, context),
                    height: Responsive.height(3, context),
                    // margin: EdgeInsets.only(top: Responsive.height(0, context)),
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
                    //margin: EdgeInsets.only(top: Responsive.height(0, context)),
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
                      ...categories.map(
                        (category) {
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
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
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
