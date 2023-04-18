import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../Constants/app_colors.dart';
import '../responsive/percentage_mediaquery.dart';
import '../responsive/size_config.dart';

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
      this.onTapRightbtn})
      : super(key: key);
  final double? preferedHeight;
  final String? title;
  final String? subtitle;

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
      child: Stack(
        children: <Widget>[
          Container(
              width: Responsive.width(100, context),
              height: preferedHeight! + MediaQuery.of(context).padding.top,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Responsive.height(3.5, context)),
                  bottomRight: Radius.circular(Responsive.height(3.5, context)),
                ),
                gradient: LinearGradient(
                  begin: Alignment(0.0, -1.0),
                  end: Alignment(0.0, 1.0),
                  colors: [Dark, Light],
                  stops: [0.0, 1.0],
                ),
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                return SafeArea(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: Responsive.width(15, context),
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(
                            left: Responsive.width(5, context),
                            top: Responsive.width(2, context)),
                        child: GestureDetector(
                          onTap: () {
                            this.onTap1!();
                          },
                          child: Icon(
                            iconLeft,
                            color: Colors.white,
                            size: currentOrientation == Orientation.portrait
                                ? (4 * SizeConfig.blockSizeVertical)
                                : (4 * SizeConfig.blockSizeHorizontal),
                          ),
                        ),
                      ),
                      if (isRightBtn)
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                              height: 45,
                              width: constraints.maxWidth * .50,
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.only(
                                  top: constraints.maxWidth * 0.07),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 30,
                                    alignment: Alignment.topRight,
                                    margin: EdgeInsets.only(right: 10),
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
                      if (!isRightBtn)
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: Responsive.width(19, context),
                            height: constraints.maxHeight * .90,
                            alignment: Alignment.topRight,
                            margin: EdgeInsets.only(
                                right: Responsive.width(2, context),
                                top: Responsive.width(2, context)),
                            child: GestureDetector(
                              onTap: () {
                                this.onTapRightbtn!();
                              },
                              child: Icon(
                                iconRight,
                                color: Colors.white,
                                size: currentOrientation == Orientation.portrait
                                    ? (4 * SizeConfig.blockSizeVertical)
                                    : (4 * SizeConfig.blockSizeHorizontal),
                              ),
                            ),
                          ),
                        ),
                      Container(
                        width: Responsive.width(65, context),
                        margin: EdgeInsets.fromLTRB(
                            Responsive.width(15, context),
                            Responsive.height(
                                currentOrientation == Orientation.portrait
                                    ? 1
                                    : 4,
                                context),
                            0.0,
                            0.0),
                        alignment: Alignment.topLeft,
                        child: AutoSizeText(
                          '$title',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 3.2 *
                                (currentOrientation == Orientation.portrait
                                    ? SizeConfig.blockSizeVertical
                                    : SizeConfig.blockSizeHorizontal),
                            decoration: null,
                          ),
                        ),
                      ),
                      Container(
                        width: Responsive.width(65, context),
                        margin: EdgeInsets.fromLTRB(
                            Responsive.width(15, context),
                            Responsive.height(
                                currentOrientation == Orientation.portrait
                                    ? 1
                                    : 4,
                                context),
                            0.0,
                            0.0),
                        alignment: Alignment.bottomLeft,
                        child: AutoSizeText(
                          '$subtitle',
                          style: TextStyle(
                              color: Color.fromARGB(255, 8, 31, 14),
                              fontFamily: 'Poppins',
                              fontSize: 1.85 *
                                  (currentOrientation == Orientation.portrait
                                      ? SizeConfig.blockSizeVertical
                                      : SizeConfig.blockSizeHorizontal),
                              decoration: null,
                              fontStyle: FontStyle.italic),
                        ),
                      )
                    ],
                  ),
                );
              }))
        ],
      ),
    );
  }
}
