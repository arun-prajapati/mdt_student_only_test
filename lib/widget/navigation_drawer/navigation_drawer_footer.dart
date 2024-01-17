import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../responsive/percentage_mediaquery.dart';

class NavigationFotter extends StatelessWidget {
  NavigationFotter({Key? key}) : super(key: key);

  late String _twitterUrl;
  late String _instaGramUrl;
  late String _youTubeUrl;
  late String _facebookUrl;
  late String _tandc;
  void _launchURL(String _url) async {
    print("hello");
    try {
      await launch(_url);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.width(100, context),
      height: Responsive.height(5, context),
      decoration: BoxDecoration(
        // color: Color(0xff76DECD),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Responsive.width(5, context)),
          topRight: Radius.circular(Responsive.width(5, context)),
        ),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _tandc =
                    "https://mockdrivingtest.com/static/terms-and-conditions-of-use";
                print(_tandc);
                _launchURL(_tandc);
              },
              child: Text(
                'Terms & Conditions',
                textAlign: TextAlign.center,
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    //3 * SizeConfig.blockSizeVertical,
                    color: Colors.black),
              ),
            ),
            // Container(
            //   //width: constraints.maxWidth * 0.7,
            //   // margin: EdgeInsets.fromLTRB(
            //   //     0.0, constraints.maxHeight * 0.05, 0.0, 0.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       GestureDetector(
            //           onTap: () {
            //             _facebookUrl =
            //                 "https://www.facebook.com/mockdrivingtest/";
            //             print(_facebookUrl);
            //             _launchURL(_facebookUrl);
            //           },
            //           child: Icon(
            //             FontAwesomeIcons.facebook,
            //             color: Colors.white,
            //             size: 20,
            //           )),
            //
            //       // iconSize: 3.5 * SizeConfig.blockSizeVertical,
            //       SizedBox(width: 5),
            //       //color: Colors.white,
            //       GestureDetector(
            //           onTap: () {
            //             _twitterUrl = "https://twitter.com/DrivingMock";
            //             print(_twitterUrl);
            //             _launchURL(_twitterUrl);
            //           },
            //           child: Icon(FontAwesomeIcons.twitter,
            //               color: Colors.white, size: 20)),
            //
            //       //iconSize: 3.5 * SizeConfig.blockSizeVertical,
            //       SizedBox(width: 5),
            //       GestureDetector(
            //           onTap: () {
            //             _instaGramUrl =
            //                 "https://www.instagram.com/mockdrivingtest/";
            //             print(_instaGramUrl);
            //             _launchURL(_instaGramUrl);
            //           },
            //           child: Icon(
            //             FontAwesomeIcons.instagram,
            //             color: Colors.white,
            //             size: 20,
            //           )),
            //       SizedBox(width: 5),
            //       GestureDetector(
            //           onTap: () {
            //             _youTubeUrl =
            //                 "https://www.youtube.com/channel/UCMCwdFLChj6etWXLwoLmZWw";
            //             print(_youTubeUrl);
            //             _launchURL(_youTubeUrl);
            //           },
            //           child: Icon(FontAwesomeIcons.youtube,
            //               color: Colors.white)),
            //
            //       //iconSize: 3.5 * SizeConfig.blockSizeVertical,
            //     ],
            //   ),
            // )
          ],
        );
      }),
    );
  }
}
