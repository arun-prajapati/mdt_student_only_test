import 'package:flutter/material.dart';

import '../responsive/percentage_mediaquery.dart';
import '../responsive/size_config.dart';
import '../utils/app_colors.dart';

class CustomAppBar extends StatelessWidget {
//  final double preferedHeight;
//  final String title;
//  CustomAppBar({this.preferedHeight, this.title});
  CustomAppBar(
      {Key? key,
      this.preferedHeight,
      this.title,
      this.subtitle = '',
      this.iconLeft,
      this.iconRight,
      this.isRightBtn = false,
      this.rightBtnText,
      this.rightBtnLabel,
      this.textWidth,
      this.onTap1,
      this.hasIcon,
      this.onTapRightbtn})
      : super(key: key);
  final double? preferedHeight;
  final String? title;
  final String? subtitle;
  final bool? hasIcon;
  final IconData? iconLeft;
  final IconData? iconRight;
  final bool isRightBtn;
  final String? rightBtnText;
  final String? rightBtnLabel;
  final double? textWidth;
  final VoidCallback? onTap1;
  final VoidCallback? onTapRightbtn;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    return Container(
      child: Container(
          width: Responsive.width(100, context),
          height: preferedHeight! + MediaQuery.of(context).padding.top,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.only(
            //   bottomLeft: Radius.circular(Responsive.height(3.5, context)),
            //   bottomRight: Radius.circular(Responsive.height(3.5, context)),
            // ),
            // gradient: LinearGradient(
            //   begin: Alignment(0.0, -1.0),
            //   end: Alignment(0.0, 1.0),
            //   colors: [Dark, Light],
            //   stops: [0.0, 1.0],
            // ),

            gradient: LinearGradient(
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              colors: [
                Color(0xFF79e6c9).withOpacity(0.5),
                Color(0xFF38b8cd).withOpacity(0.5),
              ],
              stops: [0.0, 1.0],
            ),
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            return SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 0,
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black12),
                        child: GestureDetector(
                          onTap: () {
                            this.onTap1!();
                          },
                          child: Icon(
                            iconLeft,
                            color: Colors.black,
                            size: currentOrientation == Orientation.portrait
                                ? (3.4 * SizeConfig.blockSizeVertical)
                                : (3.4 * SizeConfig.blockSizeHorizontal),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      flex: 0,
                      child: Container(
                        // width: Responsive.width(65, context),
                        // margin: EdgeInsets.fromLTRB(
                        //     Responsive.width(5, context),
                        //     Responsive.height(
                        //         currentOrientation == Orientation.portrait
                        //             ? 1
                        //             : 1,
                        //         context),
                        //     0.0,
                        //     0.0),
                        alignment: Alignment.topLeft,
                        child: Text(
                          '${title}',
                          style: AppTextStyle.appBarStyle,
                        ),
                      ),
                    ),
                    if (isRightBtn)
                      Expanded(
                        flex: 0,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                              height: 45,
                              // width: constraints.maxWidth * .50,
                              alignment: Alignment.centerRight,
                              // margin: EdgeInsets.only(
                              //     top: constraints.maxWidth * 0.07),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 30,
                                    alignment: Alignment.topRight,
                                    // margin: EdgeInsets.only(right: 10),
                                    width: constraints.maxWidth * 0.25,
                                    child: Material(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(
                                            constraints.maxHeight * 0.5),
                                        topRight: Radius.circular(
                                            constraints.maxHeight * 0.5),
                                        bottomLeft: Radius.circular(
                                            constraints.maxHeight * 0.5),
                                      ),
                                      color: Color(0xFFed1c24),
                                      elevation: 5.0,
                                      child: MaterialButton(
                                        onPressed: () =>
                                            {this.onTapRightbtn!()},
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                                width: constraints.maxWidth * 1,
                                                alignment: Alignment.center,
                                                height: 30,
                                                child: SizedBox(
                                                  width:
                                                      constraints.maxWidth * 1,
                                                  child: Text(
                                                    rightBtnText!,
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 13,
                                                        color: Colors.white),
                                                  ),
                                                ));
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 12,
                                    alignment: Alignment.bottomRight,
                                    margin: EdgeInsets.only(top: 3, right: 10),
                                    width: constraints.maxWidth * 0.70,
                                    child: Text(
                                      rightBtnLabel!,
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 11,
                                          color: Colors.white54),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                    if (!isRightBtn)
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            // width: Responsive.width(19, context),
                            // height: constraints.maxHeight * .90,
                            alignment: Alignment.topRight,
                            // margin: EdgeInsets.only(
                            //     right: Responsive.width(2, context),
                            //     top: Responsive.width(2, context)),
                            child: GestureDetector(
                              onTap: () {
                                this.onTapRightbtn!();
                              },
                              child: hasIcon == true
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      // crossAxisAlignment:
                                      //     CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Next',
                                          style: AppTextStyle.appBarStyle,
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          iconRight,
                                          color: Colors.black,
                                          size: currentOrientation ==
                                                  Orientation.portrait
                                              ? (3 *
                                                  SizeConfig.blockSizeVertical)
                                              : (3 *
                                                  SizeConfig
                                                      .blockSizeHorizontal),
                                        ),
                                      ],
                                    )
                                  : Icon(
                                      iconRight,
                                      color: Colors.black,
                                      size: currentOrientation ==
                                              Orientation.portrait
                                          ? (3 * SizeConfig.blockSizeVertical)
                                          : (3 *
                                              SizeConfig.blockSizeHorizontal),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    // Container(
                    //   width: Responsive.width(65, context),
                    //   margin: EdgeInsets.fromLTRB(
                    //       Responsive.width(15, context),
                    //       Responsive.height(
                    //           currentOrientation == Orientation.portrait
                    //               ? 1
                    //               : 4,
                    //           context),
                    //       0.0,
                    //       0.0),
                    //   alignment: Alignment.bottomLeft,
                    //   child: AutoSizeText(
                    //     '$subtitle',
                    //     style: TextStyle(
                    //         color: Color.fromARGB(255, 8, 31, 14),
                    //         fontFamily: 'Poppins',
                    //         fontSize: 1.85 *
                    //             (currentOrientation == Orientation.portrait
                    //                 ? SizeConfig.blockSizeVertical
                    //                 : SizeConfig.blockSizeHorizontal),
                    //         decoration: null,
                    //         fontStyle: FontStyle.italic),
                    //   ),
                    // )
                  ],
                ),
              ),
            );
          })),
    );
  }
}
