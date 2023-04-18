import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal = 0.0;
  static late double blockSizeVertical = 0.0;

  //variables
  static late double labelFontSize;
  static late double inputFontSize;
  static late double inputHeight;
  static late double bookingCircleHeight;
  static late double headingFontSize;
  static late double subHeadingFontSize;
  static late double subHeading2FontSize;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    initializeVariable();
  }

  void initializeVariable() {
    labelFontSize = 2 * SizeConfig.blockSizeVertical;
    headingFontSize = 2 * SizeConfig.blockSizeVertical;
    subHeadingFontSize = 1.85 * SizeConfig.blockSizeVertical;
    subHeading2FontSize = 1.75 * SizeConfig.blockSizeVertical;
    inputFontSize = 2 * SizeConfig.blockSizeVertical;
    inputHeight = 6 * SizeConfig.blockSizeVertical;
    bookingCircleHeight = 6 * SizeConfig.blockSizeVertical;
  }
}
