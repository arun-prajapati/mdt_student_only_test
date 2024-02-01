import 'package:flutter/material.dart';
import 'package:student_app/utils/app_colors.dart';
import 'package:student_app/views/DrawerScreens/FAQ.dart';
import 'package:student_app/views/WebView.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/global.dart';
import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../services/navigation_service.dart';
import '../../widget/CustomAppBar.dart';
import 'adiFAQ.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Help();
}

class _Help extends State<Help> {
  final NavigationService _navigationService = locator<NavigationService>();

  late String _termConditionUrl;
  late int _userType = 2;

  void _launchURL(String _url) async {
    print("hello");
    try {
      await launch(_url);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: CustomAppBar(
                title: 'Help',
                textWidth: Responsive.width(18, context),
                iconLeft: Icons.arrow_back,
                preferedHeight: Responsive.height(9, context),
                onTap1: () {
                  _navigationService.goBack();
                },
                iconRight: null),
          ),
          Positioned(
            top: 110,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white),
              child: LayoutBuilder(builder: (context, constraints) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          _termConditionUrl =
                              "$api/static/terms-and-conditions-of-use";
                          print(_termConditionUrl);
                          _launchURL(_termConditionUrl);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Terms and Conditions',
                              style: AppTextStyle.textStyle.copyWith(
                                  height: 1.2, fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                                onTap: () {
                                  _termConditionUrl =
                                      "$api/static/terms-and-conditions-of-use";
                                  print(_termConditionUrl);
                                  _launchURL(_termConditionUrl);
                                },
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 26,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Divider(
                          height: constraints.maxHeight * 0.03,
                          color: Colors.grey),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebViewContainer(
                                    'https://mockdrivingtest.com/static/privacy-policy',
                                    'Privacy Policy')),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Privacy Policy',
                              style: AppTextStyle.textStyle.copyWith(
                                  height: 1.2, fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebViewContainer(
                                            'https://mockdrivingtest.com/static/privacy-policy',
                                            'Privacy Policy')),
                                  );
                                },
                                child: Icon(Icons.keyboard_arrow_right)),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Divider(
                          height: constraints.maxHeight * 0.03,
                          color: Colors.grey),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          print("userType....$_userType");
                          _userType == 2
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TileApp(),
                                  ),
                                )
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdiFaq(),
                                  ),
                                );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'FAQs',
                              style: AppTextStyle.textStyle.copyWith(
                                  height: 1.2, fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                                onTap: () {
                                  print("userType....$_userType");
                                  _userType == 2
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TileApp(),
                                          ),
                                        )
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AdiFaq(),
                                          ),
                                        );
                                },
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 26,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Divider(
                          height: constraints.maxHeight * 0.03,
                          color: Colors.grey),
                      SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Version',
                            style: AppTextStyle.textStyle.copyWith(
                                height: 1.2, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '1.0.0',
                            style: AppTextStyle.textStyle.copyWith(
                                height: 1.2,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
