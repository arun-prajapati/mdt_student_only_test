// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'package:provider/provider.dart';
import 'package:student_app/custom_button.dart';
import 'package:student_app/utils/app_colors.dart';
import 'package:student_app/widget/CustomAppBar.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  TextEditingController code = TextEditingController();

  final submittedPinTheme = PinTheme(
    width: 60,
    height: 60,
    textStyle: TextStyle(
      fontSize: 28,
      color: AppColors.black,
      fontWeight: FontWeight.w700,
      decorationColor: AppColors.black,
    ),
    decoration: BoxDecoration(
      color: AppColors.borderblue,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: AppColors.black),
    ),
  );
  final focusPinTheme = PinTheme(
    width: 60,
    height: 60,
    textStyle: TextStyle(
      fontSize: 22,
      color: AppColors.black,
      fontWeight: FontWeight.w700,
      decorationColor: AppColors.black,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: AppColors.black),
    ),
  );
  int secondsRemaining = 1 * 60;
  bool enableResend = false;
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    secondsRemaining = 60;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Duration clockTimer = Duration(seconds: secondsRemaining);

    String timerText =
        '0${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(left: 22, right: 22, bottom: 25, top: 20),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter OTP Verification",
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Please type the verification code we sent to +",
                    style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackgrey),
                    maxLines: 2,
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Pinput(
                      controller: code,
                      autofocus: true,
                      length: 6,
                      defaultPinTheme: submittedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      focusedPinTheme: focusPinTheme,
                      androidSmsAutofillMethod:
                          AndroidSmsAutofillMethod.smsRetrieverApi,
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      onSubmitted: (pin) async {},
                    ),
                  ),
                  //SizedBox(height: 2),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      secondsRemaining == 0 ? '' : timerText,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: enableResend
                          ? () {
                              secondsRemaining = 60;
                              enableResend = false;
                              setState(() {});
                            }
                          : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t receive the Code? ",
                          ),
                          Text(
                            "Resend Code",
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(height: 15),
                ],
              ),
            ),
          ),
          CustomButton(
            title: "Confirm",
          )
        ],
      ),
    ));
  }
}
