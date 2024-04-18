import 'package:Smart_Theory_Test/responsive/percentage_mediaquery.dart';
import 'package:Smart_Theory_Test/services/navigation_service.dart';
import 'package:Smart_Theory_Test/utils/app_colors.dart';
import 'package:Smart_Theory_Test/widget/CustomAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../locater.dart';

class AIReadingScreen extends StatefulWidget {
  final String data;
  final String heading;

  const AIReadingScreen({super.key, required this.data, required this.heading});

  @override
  State<AIReadingScreen> createState() => _AIReadingScreenState();
}

class _AIReadingScreenState extends State<AIReadingScreen> {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              // width: Responsive.width(100, context),
              height: 130,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.only(
                //   bottomLeft: Radius.circular(Responsive.height(3.5, context)),
                //   bottomRight: Radius.circular(Responsive.height(3.5, context)),
                // ),
                // gradient: LinearGradient(
                //   begin: Alignment(0.0, -1.0),
                //   end: Alignment(0.0, 1.0),
                //   colors: [Dark, Light],
                //   stops: [0.0, 1.0],
                // ),

                gradient: LinearGradient(
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  colors: [
                    Color(0xFF79e6c9).withOpacity(0.5),
                    Color(0xFF38b8cd).withOpacity(0.5),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black12),
                      child: GestureDetector(
                        onTap: () {
                          _navigationService.goBack();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        '${widget.heading}',
                        style: AppTextStyle.appBarStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.125,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 110.0),
                  child: ListView(
                    padding: EdgeInsets.all(0),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Html(
                          data: """${widget.data}""",
                          style: {
                            "p": Style(
                                fontFamily: 'Poppins',
                                textAlign: TextAlign.justify
                                // fontSize: FontSize.small
                                // ,
                                // padding: EdgeInsets.all(6),
                                // backgroundColor: Colors.grey,
                                )
                          },
                          // children: [
                          //   Text("${widget.data}"),
                          // ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
