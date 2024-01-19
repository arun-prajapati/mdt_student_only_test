import 'package:flutter/material.dart';

import '../../../locater.dart';
import '../../../responsive/percentage_mediaquery.dart';
import '../../../services/local_services.dart';
import '../../../services/navigation_service.dart';
import '../../../widget/CustomAppBar.dart';

class HazardPerceptionVideosList extends StatefulWidget {
  HazardPerceptionVideosList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HazardPerceptionVideosList();
}

class _HazardPerceptionVideosList extends State<HazardPerceptionVideosList> {
  LocalServices _localServices = LocalServices();
  final NavigationService _navigationService = locator<NavigationService>();
  List<int> items_ = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    try {
      // SystemChrome.setPreferredOrientations(
      //     [DeviceOrientation.portraitUp]).then((_) {
      _navigationService.goBack();
      return true;
    } catch (e) {
      return false;
    }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: WillPopScope(
            onWillPop: _onBackPressed,
            child: Stack(children: <Widget>[
              CustomAppBar(
                  preferedHeight: Responsive.height(15, context),
                  title: 'Videos For Test',
                  textWidth: Responsive.width(70, context),
                  iconLeft: Icons.arrow_back_ios,
                  onTap1: () {
                    _onBackPressed();
                  }),
              Container(
                  height: Responsive.height(85, context),
                  width: Responsive.width(100, context),
                  margin: EdgeInsets.fromLTRB(
                      0, Responsive.height(16, context), 0, 0),
                  child: ListView(
                    children: [...items_.map((option) => listTtem(option))],
                  ))
            ])));
  }

  Widget listTtem(int option) {
    return Container(
      width: Responsive.width(80, context),
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: Responsive.width(2, context)),
      //color: Colors.black12,
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          // Container(
          //     width: Responsive.width(20, context),
          //     child: Image.asset("assets/video_thumbnail.png")),
          Container(
            width: Responsive.width(75, context),
            child: Column(
              children: [
                ListView.builder(
                  itemBuilder: (context, index) => Column(
                    children: [],
                  ),
                ),
                Container(
                  width: Responsive.width(75, context),
                  padding: EdgeInsets.only(left: 10, top: 5),
                  child: Text("Video Name"),
                  alignment: Alignment.center,
                ),
                // (option % 2) == 0
                //     ? Container(
                //         width: Responsive.width(75, context),
                //         child: Row(
                //           crossAxisAlignment: CrossAxisAlignment.end,
                //           mainAxisAlignment: MainAxisAlignment.end,
                //           children: [
                //             Icon(Icons.check_sharp,
                //                 size: 17, color: Colors.green),
                //             SizedBox(width: 2),
                //             Text("Test Done",
                //                 style: TextStyle(
                //                     fontSize: 12,
                //                     fontWeight: FontWeight.w600,
                //                     color: Colors.green))
                //           ],
                //         ),
                //         alignment: Alignment.bottomRight,
                //       )
                //     : Container(
                //         width: Responsive.width(60, context),
                //         child: Text(""),
                //         alignment: Alignment.topRight,
                //       ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
