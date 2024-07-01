import 'dart:io';

import 'package:Smart_Theory_Test/Constants/app_colors.dart';
import 'package:Smart_Theory_Test/datamodels/user_location.dart';
import 'package:Smart_Theory_Test/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const int delay = 15;
const String kGoogleApiKey = "AIzaSyBa4FdOlhksMcExaWa-z_EHeNppLz6c2ug";
// const String api = 'https://mdt.developersforflutter.com';
const String api = 'https://mockdrivingtest.com';
// const String api = 'https://mockdvsatest.co.uk';
// const String api = 'http://192.168.1.41';
const String imageBaseUrl = 'https://mockdrivingtest.com';
const String stripePublic = "pk_live_uvawPT4fmctau9Zh6fyHH3Rd00kcvCqEv9";

Future<void> launchSocialURL(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    // showToast("URL not found");
    throw Exception('Could not launch $url');
  }
}

class AppConstant {
  static String highwayCodeLink =
      "https://www.gov.uk/guidance/the-highway-code";
  static String theoryTestGuidance =
      "https://mockdrivingtest.com/static/theory-test-guidance";
  static String bookTheoryTest = "https://www.gov.uk/book-theory-test";
  static String privacyPolicy =
      "https://www.smarttheorytest.com/privacy-policy";
  static String termsAndCondition =
      "https://mockdrivingtest.com/uk-en/static/terms-and-conditions-of-use";
  static String trafficSigns =
      "https://assets.publishing.service.gov.uk/media/656ef4271104cf0013fa74ef/know-your-traffic-signs-dft.pdf";
  static String platformRedirect = Platform.isIOS
      ? "https://apps.apple.com/us/app/smart-theory-test/id6479045269"
      : "https://play.google.com/store/apps/details?id=com.vinsolutions.appsmarttheorytest";
  static UserModel? userModel;
}

showValidationDialog(BuildContext context, String message) {
  //print("valid");
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text('Smart Theory Test', style: AppTextStyle.appBarStyle),
            content: Text(
              message,
              style: AppTextStyle.disStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                  color: AppColors.black,
                  height: 1.3),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (message == "Check for update") {
                    launchSocialURL(AppConstant.platformRedirect);
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Ok',
                  style: AppTextStyle.textStyle.copyWith(
                      fontSize: 16, color: Dark, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      });
}
