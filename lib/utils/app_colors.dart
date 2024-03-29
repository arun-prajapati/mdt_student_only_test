import 'package:flutter/material.dart';

class AppColors {
  static Color transparent = Colors.transparent;
  static Color black = Colors.black;
  static Color white = Colors.white;
  static Color secondary = Color(0xFF0E9BD0);
  static Color primary = Color(0xFF78E6C9);
  static Color blueGrad1 = Color(0xFF7994D8);
  static Color blueGrad2 = Color(0xFF728DD2);
  static Color blueGrad3 = Color(0xFF5C75BC);
  static Color blueGrad4 = Color(0xFF4C64AC);
  static Color blueGrad5 = Color(0xFF425AA3);
  static Color blueGrad6 = Color(0xFF3F57A0);
  static Color blueGrad7 = Color(0xFF2A428B);
  static Color borderblue = Color(0xFF4B7BA1);
  static Color bgColor = Color(0xFFF3F9FB);
  static Color grey = Colors.grey;
  static Color blackgrey = Color(0xFF040404);
  static Color red1 = Color(0xFFFE5050);
  static Color red2 = Color(0xFFBC0A0A);
}

class AppTextStyle {
  static TextStyle titleStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.black);
  static TextStyle appBarStyle = AppTextStyle.titleStyle.copyWith(fontSize: 19);
  static TextStyle textStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.black);
  static TextStyle disStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.grey,
  );

  static TextStyle boldStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  // static double font = 16.0;
  // static double fontTitle = 18.0;
  // static double fontDis = 14.0;
}
