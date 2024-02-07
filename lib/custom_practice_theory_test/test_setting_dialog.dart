import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_app/custom_button.dart';
import 'package:student_app/utils/appImages.dart';

import '../locater.dart';
import '../services/auth.dart';
import '../services/navigation_service.dart';
import '../services/practise_theory_test_services.dart';
import '../utils/app_colors.dart';
import '../views/Driver/PracticeTheoryTest.dart';

class TestSettingDialogBox extends StatefulWidget {
  final IntCallback onSetValue;
  final List categories_list;

  TestSettingDialogBox({Key? key, required this.onSetValue, required this.categories_list});

  // : super(key: key);

  @override
  _TestSettingDialogBox createState() => _TestSettingDialogBox();
}

class _TestSettingDialogBox extends State<TestSettingDialogBox> {
  TextStyle _answerTextStyle = TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.normal);
  TextStyle _categoryTextStyle = AppTextStyle.textStyle.copyWith(fontWeight: FontWeight.w400, color: AppColors.black);
  final NavigationService _navigationService = locator<NavigationService>();
  int seledtedCategoryId = 0;
  List categories = [];
  bool isAllCategoriesSelected = true;
  final PractiseTheoryTestServices test_api_services = new PractiseTheoryTestServices();
  final UserProvider auth_services = new UserProvider();

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
    return PopScope(
      canPop: false,
      child: Container(
        // height: Responsive.height(56, context),
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.fromLTRB(0, 12, 0, 5),
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
            Expanded(
              flex: 0,
              child: Padding(
                padding: EdgeInsets.only(left: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select the topic you would like to revise', style: AppTextStyle.textStyle.copyWith(fontWeight: FontWeight.w400, color: AppColors.black)),
                    //SizedBox(width: 5),
                    Padding(
                      padding: EdgeInsets.only(right: 18),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.close, size: 22, color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              flex: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // AutoSizeText("Select Category",
                    //     style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w500,
                    //         color: Colors.black)),
                    Text('Select All', style: AppTextStyle.textStyle.copyWith(fontWeight: FontWeight.w500, height: 1, color: AppColors.black)),
                    ActionChip(
                      backgroundColor: AppColors.transparent,
                      pressElevation: 0,
                      padding: EdgeInsets.all(0),
                      labelPadding: EdgeInsets.all(0),
                      visualDensity: VisualDensity.comfortable,
                      onPressed: isAllCategoriesSelected
                          ? () {
                              resetAll(false);
                            }
                          : () {
                              resetAll(true);
                              seledtedCategoryId = 0;
                            },
                      label: Image.asset(
                        isAllCategoriesSelected ? AppImages.checkedbox : AppImages.checkBox,
                        height: isAllCategoriesSelected ? 23 : 20,
                        width: isAllCategoriesSelected ? 23 : 20,
                      ),
                    ),

                    // IconButton(
                    //   iconSize: 3 * SizeConfig.blockSizeVertical,
                    //   padding: EdgeInsets.only(right: 15),
                    //   icon: Icon(
                    //       isAllCategoriesSelected
                    //           ? Icons.check_box
                    //           : Icons.check_box_outline_blank_outlined,
                    //       color: isAllCategoriesSelected
                    //           ? AppColors.blueGrad6
                    //           : AppColors.borderblue.withOpacity(0.3)),
                    //   onPressed: isAllCategoriesSelected
                    //       ? null
                    //       :
                    // ),
                  ],
                ),
              ),
            ),

            // SizedBox(height: 10),
            /* Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                  // height: Responsive.height(32, context),
                  // width: Responsive.width(80, context),
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(bottom: 30, top: 0),
                  child: ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        ...categories.map(
                          (category) {
                            var index = categories.indexOf(category);
                            return Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AutoSizeText(category['name'],
                                      style: _categoryTextStyle),
                                ),
                                Expanded(
                                    flex: 0,
                                    child: ActionChip(
                                      backgroundColor: AppColors.transparent,
                                      pressElevation: 0,
                                      padding: EdgeInsets.all(0),
                                      labelPadding: EdgeInsets.all(0),
                                      visualDensity: VisualDensity.comfortable,
                                      onPressed: () => {
                                        setState(() {
                                          resetAll(false);
                                          seledtedCategoryId = category['id'];
                                          categories[index]['selected'] = true;
                                        })
                                      },
                                      label: Image.asset(
                                        category['selected'] == true
                                            ? AppImages.checkedbox
                                            : AppImages.uncheckedbox,
                                        height: 28,
                                        width: 23,
                                      ),
                                    )
                                    // IconButton(
                                    //   iconSize: 3 * SizeConfig.blockSizeVertical,
                                    //   padding: EdgeInsets.all(0),
                                    //   icon: Icon(
                                    //       category['selected'] == true
                                    //           ? Icons.check_box
                                    //           : Icons.check_box_outline_blank,
                                    //       color: category['selected'] == true
                                    //           ? AppColors.blueGrad6
                                    //           : AppColors.borderblue
                                    //               .withOpacity(0.3)),
                                    //   onPressed: () => {
                                    //     setState(() {
                                    //       resetAll(false);
                                    //       seledtedCategoryId = category['id'];
                                    //       categories[index]['selected'] = true;
                                    //     })
                                    //   },
                                    // ),
                                    ),
                              ],
                            );
                          },
                        ).toList(),
                      ])),
            ),*/
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: List.generate(
                        categories.length,
                        (index) => Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AutoSizeText(categories[index]['name'], style: _categoryTextStyle.copyWith(fontWeight: FontWeight.w500, height: 0.5)),
                                ),
                                Expanded(
                                    flex: 0,
                                    child: ActionChip(
                                      backgroundColor: AppColors.transparent,
                                      pressElevation: 0,
                                      padding: EdgeInsets.all(0),
                                      labelPadding: EdgeInsets.all(0),
                                      visualDensity: VisualDensity.comfortable,
                                      onPressed: () => {
                                        setState(() {
                                          resetAll(false);
                                          seledtedCategoryId = categories[index]['id'];
                                          categories[index]['selected'] = true;
                                        })
                                      },
                                      label: Image.asset(
                                        categories[index]['selected'] == true ? AppImages.checkedbox : AppImages.checkBox,
                                        height: categories[index]['selected'] == true ? 23 : 20,
                                        width: categories[index]['selected'] == true ? 23 : 20,
                                      ),
                                    )
                                    // IconButton(
                                    //   iconSize: 3 * SizeConfig.blockSizeVertical,
                                    //   padding: EdgeInsets.all(0),
                                    //   icon: Icon(
                                    //       category['selected'] == true
                                    //           ? Icons.check_box
                                    //           : Icons.check_box_outline_blank,
                                    //       color: category['selected'] == true
                                    //           ? AppColors.blueGrad6
                                    //           : AppColors.borderblue
                                    //               .withOpacity(0.3)),
                                    //   onPressed: () => {
                                    //     setState(() {
                                    //       resetAll(false);
                                    //       seledtedCategoryId = category['id'];
                                    //       categories[index]['selected'] = true;
                                    //     })
                                    //   },
                                    // ),
                                    ),
                              ],
                            )),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: Padding(
                padding: EdgeInsets.only(left: 55, right: 55, bottom: 20, top: 15),
                child: CustomButton(
                  title: 'Continue',
                  onTap: () {
                    Navigator.pop(context, true);
                    this.widget.onSetValue(seledtedCategoryId);
                    // auth_services.changeView = false;
                    context.read<UserProvider>().changeView = false;
                    setState(() {});
                    // setState(() {});
                    print('LLLL ${seledtedCategoryId} ${widget.onSetValue} ${context.read<UserProvider>().changeView}');
                  },
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                ),
              ),
            ),
            // Container(
            //   height: 5 * SizeConfig.blockSizeVertical,
            //   width: Responsive.width(30, context),
            //   alignment: Alignment.centerRight,
            //   margin: EdgeInsets.only(
            //     top: Responsive.height(2, context),
            //   ),
            //   child: Material(
            //     borderRadius: BorderRadius.circular(10),
            //     color: Dark,
            //     elevation: 5.0,
            //     child: MaterialButton(
            //       onPressed: () {
            //         // Navigator.push(
            //         //     context,
            //         //     MaterialPageRoute(
            //         //         builder: (context) => PracticeTheoryTest()));
            //         Navigator.pop(context, true);
            //         this.widget.onSetValue(seledtedCategoryId);
            //         // auth_services.changeView = false;
            //         context.read<AuthProvider>().changeView = false;
            //         setState(() {});
            //         // setState(() {});
            //         print(
            //             'LLLL ${seledtedCategoryId} ${widget.onSetValue} ${context.read<AuthProvider>().changeView}');
            //       },
            //       child: LayoutBuilder(
            //         builder: (context, constraints) {
            //           return Container(
            //             width: constraints.maxWidth * 1,
            //             height: constraints.maxHeight * 1,
            //             alignment: Alignment.center,
            //             child: AutoSizeText(
            //               'Continue',
            //               style: TextStyle(
            //                 fontFamily: 'Poppins',
            //                 fontSize: 2.2 * SizeConfig.blockSizeVertical,
            //                 fontWeight: FontWeight.w500,
            //                 color: Color.fromRGBO(255, 255, 255, 1.0),
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
