import 'package:flutter/material.dart';

InputBorder inputBorderStyle() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
      borderSide: BorderSide(
          color: Colors.black26, style: BorderStyle.solid, width: 1.0));
}

InputBorder inputFocusedBorderStyle() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
      borderSide: BorderSide(
          color: Colors.blue[200]!, style: BorderStyle.solid, width: 1.0));
}

Decoration textAreaBorderLikeAsInput() {
  return BoxDecoration(
    border:
        Border.all(color: Colors.black26, style: BorderStyle.solid, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(2)),
  );
}

TextStyle inputLabelStyleWithBold(double fontSize_) {
  return TextStyle(
      fontSize: fontSize_, color: Colors.black, fontWeight: FontWeight.w700);
}

TextStyle inputLabelStyleDark(double fontSize_) {
  return TextStyle(
      fontSize: fontSize_, color: Colors.black, fontWeight: FontWeight.w500);
}

TextStyle inputLabelStyle(double fontSize_) {
  return TextStyle(
      fontSize: fontSize_, color: Colors.black54, fontWeight: FontWeight.w500);
}

TextStyle inputTextStyle(double fontSize_) {
  return TextStyle(
      fontSize: fontSize_, color: Colors.black, fontWeight: FontWeight.w500);
}

TextStyle placeholderStyle(double fontSize_) {
  return TextStyle(
      fontSize: fontSize_, color: Colors.black38, fontWeight: FontWeight.w500);
}

TextStyle headingStyle(double fontSize_) {
  return TextStyle(
      fontSize: fontSize_, color: Colors.black, fontWeight: FontWeight.w500);
}

TextStyle contentStyle(double fontSize_) {
  return TextStyle(
      fontSize: fontSize_, color: Colors.black, fontWeight: FontWeight.w400);
}

TextStyle subHeadingStyle(double fontSize_) {
  return TextStyle(
      fontSize: fontSize_, color: Colors.black54, fontWeight: FontWeight.w500);
}

TextStyle content1Style(double fontSize_) {
  return TextStyle(
      fontSize: fontSize_, color: Colors.white, fontWeight: FontWeight.w600);
}
