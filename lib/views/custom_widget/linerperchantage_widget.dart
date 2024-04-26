import 'package:Smart_Theory_Test/constants/global.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:Smart_Theory_Test/utils/app_colors.dart';

class LinearPercentIndicatorWidget extends StatelessWidget {
  final String? perTitle;
  final double progress;
  final String? textTitle;
  final String? isFree;
  final String? planType;
  final String? total;

  const LinearPercentIndicatorWidget(
      {super.key,
      this.perTitle,
      this.textTitle,
      this.isFree,
      this.planType,
      this.total,
      this.progress = 0.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            children: [
              Text("${textTitle} ",
                  style: AppTextStyle.textStyle
                      .copyWith(fontWeight: FontWeight.w500)),
              SizedBox(width: 5),
              planType == "paid" || planType == "gift"
                  ? SizedBox()
                  : Expanded(
                      flex: 0,
                      child: Image.asset(
                          isFree == "free" &&
                                  (planType == "free" || planType == "gift")
                              ? "assets/images/free.png"
                              : "assets/images/premium.png",
                          height: isFree == "free" &&
                                  (planType == "free" || planType == "gift")
                              ? 18
                              : 15),
                    ),
            ],
          ),
          //TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
        ),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 5),
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
                  percent: progress,
                ),
              ),
              SizedBox(width: 19),
              Text("${progress * 100 ~/ 1} %",
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
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Column(
            children: [
              Text("${perTitle} of $total attempted",
                  style: AppTextStyle.textStyle
                      .copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        SizedBox(height: 10),
        Divider(color: AppColors.black.withOpacity(0.05), thickness: 1),
      ],
    );
  }
}
