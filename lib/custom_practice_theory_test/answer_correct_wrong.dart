import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:Smart_Theory_Test/custom_button.dart';
import 'package:Smart_Theory_Test/utils/appImages.dart';

import '../utils/app_colors.dart';

showCorrectAnswerDialog(BuildContext context, String explanation) {
  //print("valid");
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
            shape: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20)),
            title: Image.asset(
              AppImages.good_job,
              // fit: BoxFit.cover,
              height: 82,
              width: 145,
            ),
            actionsAlignment: MainAxisAlignment.center,
            contentPadding: EdgeInsets.fromLTRB(24.0, 15.0, 24.0, 5.0),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GradientText(
                    'Good Job!',
                    colors: [
                      AppColors.blueGrad7,
                      AppColors.blueGrad6,
                      AppColors.blueGrad5,
                      AppColors.blueGrad4,
                      AppColors.blueGrad3,
                      AppColors.blueGrad1,
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
                    style: AppTextStyle.disStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                        height: 1.2),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 65, vertical: 10),
                child: CustomButton(
                  padding: EdgeInsets.symmetric(vertical: 11),
                  title: 'Continue',
                  // fontSize: 15,
                  // isfontSize: true,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ]);
      });
}

showWrongAnswerDialog(BuildContext context, String explanation) {
  //print("valid");
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(20)),
          title: Image.asset(
            AppImages.ohhnoo2,
            //  fit: BoxFit.cover,
            height: 83,
            width: 118,
          ),
          actionsAlignment: MainAxisAlignment.center,
          // contentPadding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 5.0),
          content: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: AppColors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                    style: AppTextStyle.disStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                        height: 1.3),
                  )
                ],
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 65, vertical: 10),
              child: CustomButton(
                padding: EdgeInsets.symmetric(vertical: 11),
                title: 'Continue',
                // isfontSize: true,
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
