import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:student_app/utils/app_colors.dart';

class LinearPercentIndicatorWidget extends StatelessWidget {
  final double perTitle;
  final String? textTitle;

  const LinearPercentIndicatorWidget(
      {super.key, this.perTitle = 0.0, this.textTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Text(textTitle ?? "Hazard Awareness Theory Test",
              style:
                  AppTextStyle.textStyle.copyWith(fontWeight: FontWeight.w500)),
          //TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Expanded(
                child: LinearPercentIndicator(
                  linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xff78E6C9),
                        Color(0xff0E9BD0),
                      ]),
                  backgroundColor: Color(0xfff0f4ec),
                  barRadius: Radius.circular(5),
                  animation: true,
                  lineHeight: 10,
                  // animationDuration: 1000,
                  percent: perTitle,
                ),
              ),
              SizedBox(width: 19),
              Text("${perTitle * 100 ~/ 1} %",
                  style: AppTextStyle.textStyle
                      .copyWith(fontWeight: FontWeight.w500)),
              // SizedBox(
              //   width: 50,
              // ),
              Expanded(
                  child: Text('',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)))
            ],
          ),
        ),
        SizedBox(height: 10),
        Divider(color: AppColors.black.withOpacity(0.05), thickness: 1),
      ],
    );
  }
}
