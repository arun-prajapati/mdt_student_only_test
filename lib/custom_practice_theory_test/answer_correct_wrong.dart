import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:student_app/custom_button.dart';
import 'package:student_app/utils/appImages.dart';

import '../Constants/app_colors.dart';
import '../responsive/size_config.dart';
import '../utils/app_colors.dart';

showCorrectAnswerDialog(BuildContext context, String explanation) {
  //print("valid");
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: SizedBox(
            height: 150,
            width: 140,
            child: Image.asset(
              AppImages.goodJob,
              //fit: BoxFit.cover,
            ),
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
          title: Text(''),
          actionsAlignment: MainAxisAlignment.center,
          // contentPadding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 5.0),
          content: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: AppColors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppImages.ohhNoo,
                  fit: BoxFit.cover,
                  height: 110,
                  width: 110,
                ),
                GradientText(
                  'Ohh No!',
                  colors: [
                    AppColors.red1,
                    AppColors.red2,
                  ],
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 30,
                    decorationThickness: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  explanation,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 65, vertical: 10),
              child: CustomButton(
                padding: EdgeInsets.symmetric(vertical: 11),
                title: 'Ok,Continue',
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            // TextButton(
            //   onPressed:
            //   child: Text(
            //     "Ok",
            //     style: TextStyle(color: Dark, fontSize: 18),
            //   ),
            // ),
          ],
        );
      });
}
