// // ignore_for_file: unnecessary_new

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// import '../../locater.dart';
// import '../../responsive/percentage_mediaquery.dart';
// import '../../responsive/size_config.dart';
// import '../../services/ai_recommendationservice.dart';
// import '../../services/auth.dart';
// import '../../services/navigation_service.dart';
// import '../../widget/CustomAppBar.dart';
// import '../../widget/CustomSpinner.dart';
// import '../../widget/CustomSwitch/CustomSwitch_AI.dart';
// import '../WebView.dart';

// class LessonRecommendations extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _LessonRecommendations();
// }

// class _LessonRecommendations extends State<LessonRecommendations> {
//   final NavigationService _navigationService = locator<NavigationService>();
//   List<Entry> changingData = List.empty();
//   int? _userId;
//   String? licenceHttpPath = null;
//   final AIRecommondationAPI _aIRecommondationService = AIRecommondationAPI();
//   final GlobalKey<State> _keyLoader = new GlobalKey<State>();

//   List<Entry> chdata = List.empty();
//   List<Entry> redata = List.empty();
//   List<Entry> lnkdata = List.empty();
//   late String adifname;
//   late String adilname;
//   late String requested_date;
//   late String requested_time;
//   late String lesson_Name;
//   late List<dynamic> lesson_link = List.empty();

//   late Entry e;
//   late Entry en;
//   late Entry en_lnk;
//   List<dynamic>? dataSub;
//   @override
//   void initState() {
//     // changingData = changingData.toList();
//     Future.delayed(Duration.zero, () {
//       this.initializeApi("Loading...");
//     });
//     super.initState();
//   }

//   initializeApi(String loaderMessage) {
//     checkInternet();
//     showLoader(loaderMessage);
//     changingData = List.empty();

//     changingData = changingData.toList();
//     if (_aIRecommondationService.type == 'lesson') {
//       getUserDetail().then((user_id) async {
//         await callApiGetRecommendatedLesson().then((datasub) {
//           setState(() {
//             this.changingData =
//                 generateData(_aIRecommondationService.type, dataSub);
//           });
//           closeLoader();
//         });
//       });
//     }
//     if (_aIRecommondationService.type == 'test') {
//       getUserDetail().then((user_id) async {
//         await callApiGetRecommendatedTest().then((datasub) {
//           setState(() {
//             this.changingData =
//                 generateData(_aIRecommondationService.type, dataSub);
//           });
//           closeLoader();
//         });
//       });
//     }
//   }

//   Future<bool> checkInternet() async {
//     print("internet check..1.");
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     print("internet check.2..");
//     print(connectivityResult);
//     if (connectivityResult == ConnectivityResult.mobile) {
//       return true;
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       return true;
//     }
//     return false;
//   }

//   //Call APi Services
//   Future<Map> getUserDetail() async {
//     Map response =
//         await Provider.of<AuthProvider>(context, listen: false).getUserData();
//     licenceHttpPath = response['img_url'];
//     _userId = response['id'];

//     return response;
//   }

//   Future<void> callApiGetRecommendatedLesson() async {
//     // getUserDetail();
//     if (_userId != null)
//       dataSub = await _aIRecommondationService.getrecommondedlesson(_userId!);
//   }

//   Future<void> callApiGetRecommendatedTest() async {
//     // getUserDetail();
//     if (_userId != null)
//       dataSub = await _aIRecommondationService.getrecommondedtest(_userId!);
//   }

//   refresh() {
//     // setState(() {
//     //
//     // });
//   }
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return Scaffold(
//       body: Container(
//         width: Responsive.width(100, context),
//         height: Responsive.height(100, context),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return Container(
//               height: constraints.maxHeight,
//               child: Column(
//                 children: <Widget>[
//                   CustomAppBar(
//                       preferedHeight: Responsive.height(15, context),
//                       title: 'AI Recommondations',
//                       subtitle: '...your next step to mastering the skills...',
//                       textWidth: Responsive.width(45, context),
//                       iconLeft: FontAwesomeIcons.arrowLeft,
//                       onTap1: () {
//                         _navigationService.goBack();
//                       },
//                       iconRight: null),
//                   Container(
//                     width: Responsive.width(100, context),
//                     height: Responsive.height(75, context),
//                     margin: EdgeInsets.fromLTRB(Responsive.width(5, context),
//                         10, Responsive.width(5, context), 0.0),
//                     decoration: BoxDecoration(
//                       color: Colors.transparent,
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(Responsive.width(8, context)),
//                       ),
//                       border: Border.all(
//                         width: Responsive.width(0.3, context),
//                         color: Color(0xff707070),
//                       ),
//                     ),
//                     child: LayoutBuilder(
//                       builder: (context, constraints) {
//                         return Column(
//                           children: <Widget>[
//                             Container(
//                               margin: EdgeInsets.only(
//                                   top: constraints.maxHeight * 0.03),
//                               width: constraints.maxWidth * 1,
//                               height: constraints.maxHeight * 0.09,
//                               //color: Colors.black26,
//                               child: LayoutBuilder(
//                                   builder: (context, constraints) {
//                                 return Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: <Widget>[
//                                     Container(
//                                       alignment: Alignment.topLeft,
//                                       margin: EdgeInsets.fromLTRB(
//                                           constraints.maxWidth * 0.02,
//                                           0,
//                                           constraints.maxWidth * 0.02,
//                                           0.0),
//                                       child: new CustomSwitch_AI(
//                                           notifyParent: refresh,
//                                           onSwitchTap: (currentTabType) {
//                                             this.initializeApi("Loading...");
//                                           }),
//                                     ),
//                                   ],
//                                 );
//                               }),
//                             ),
//                             Container(
//                               width: constraints.maxWidth * 0.99,
//                               height: constraints.maxHeight * 0.86,
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: Align(
//                                         alignment: Alignment.topLeft,
//                                         child: FutureBuilder(builder:
//                                                 (BuildContext context,
//                                                     AsyncSnapshot<String>
//                                                         snapshot) {
//                                           // Future:
//                                           // this.initializeApi("Loading...");
//                                           // if (changingData.length > 0) {
//                                           return ListView.builder(
//                                             //shrinkWrap: true,

//                                             itemBuilder: (BuildContext context,
//                                                     int index) =>
//                                                 new EntryItem(
//                                                     changingData[index]),
//                                             itemCount: changingData.length,
//                                           );
//                                         }
//                                             // },
//                                             )),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   void showLoader(String message) {
//     CustomSpinner.showLoadingDialog(context, _keyLoader, message);
//   }

//   void closeLoader() {
//     try {
//       Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//     } catch (e) {}
//   }

//   List<Entry> generateData(String type, [List<dynamic>? dataSub]) {
//     chdata = chdata.toList();
//     lesson_link = lesson_link.toList();
//     lnkdata = lnkdata.toList();
//     redata = redata.toList();

//     try {
//       if (dataSub != null) {
//         for (dynamic data in dataSub) {
//           // for (var data in datas as ma) {
//           if (data != null) {
//             data.forEach((k, ve) {
//               if (data["booking_data"] != null && k == "booking_data") {
//                 requested_date = ve["requested_date"];
//                 requested_time = ve["requested_time"];
//               } else if (data["recommendation"] != null &&
//                   k == "recommendation") {
//                 //for (int index = 0; index < ve.length; index++) {
//                 ve.forEach((ke, va) {
//                   va.forEach((ke1, va1) {
//                     print("data  :" +
//                         ke +
//                         "  Links:   " +
//                         ke1 +
//                         "  value : " +
//                         va1.toString());
//                     lesson_link = va1;
//                     lesson_Name = ke;
//                     int leng = va1.length;
//                     print(lesson_link.toString());
//                     if (ke1 == "yt_links") {
//                       en_lnk = new Entry('Watch recommomnded video', '', ' ');
//                       lnkdata.add(en_lnk);
//                     }
//                     if (ke1 == "reading_links") {
//                       en_lnk = new Entry('Read recommomnded articles', '', '');
//                       lnkdata.add(en_lnk);
//                     }
//                     int i = 1;
//                     for (dynamic link in lesson_link) {
//                       if (ke1 == "yt_links") {
//                         en_lnk = new Entry(ke1, link as String, '');
//                         // en_lnk = new Entry(link, '', '');
//                       } else if (ke1 == "reading_links") {
//                         en_lnk = new Entry(
//                             'Article ' + i.toString(), link as String, '');
//                         i++;
//                       }
//                       lnkdata.add(en_lnk);
//                     }
//                     en = new Entry(lesson_Name, '', '', lnkdata);
//                   });
//                   redata.add(en);
//                   lnkdata = List.empty();
//                   lnkdata = lnkdata.toList();
//                 });
//                 //}
//                 if (type == "lesson") {
//                   e = new Entry(
//                       "Lesson Date Time : " +
//                           requested_date +
//                           " " +
//                           requested_time,
//                       '',
//                       '',
//                       redata);
//                 }
//                 if (type == "test") {
//                   e = new Entry(
//                       "Test Date Time : " +
//                           requested_date +
//                           " " +
//                           requested_time,
//                       '',
//                       '',
//                       redata);
//                 }

//                 chdata.add(e);
//               }
//               redata = List.empty();
//               redata = redata.toList();
//             });
//           }
//         }

//         return chdata;
//       } else {
//         Entry e = new Entry(' No Data', '');
//         chdata.add(e);
//       }
//       return chdata;
//     } on Exception catch (exception) {
//       print(exception);
//       return chdata;
//     }
//   }
// }

// class Entry {
//   Entry(this.title, this.links,
//       [this.subheading, this.children = const <Entry>[]]);
//   final String title;
//   final String links;
//   final String? subheading;
//   final List<Entry> children;
// }

// // Displays one Entry. If the entry has children then it's displayed
// // with an ExpansionTile.
// class EntryItem extends StatelessWidget {
//   const EntryItem(this.entry);
//   final Entry entry;

//   Widget _buildTiles(BuildContext context, Entry root) {
//     if (root.title == "yt_links")
//       return new ListTile(
//           // title: Text("Watch Video"),
//           subtitle: YoutubePlayer(
//         controller: YoutubePlayerController(
//           initialVideoId:
//               YoutubePlayer.convertUrlToId(root.links)!, //Add videoID.
//           flags: YoutubePlayerFlags(
//             hideControls: false,
//             controlsVisibleAtStart: true,
//             autoPlay: false,
//             mute: false,
//           ),
//         ),
//         // width: 250,
//         showVideoProgressIndicator: true,
//         progressIndicatorColor: Colors.green,
//       ));
//     if (root.children.isEmpty && root.title != "yt_links")
//       // ignore: curly_braces_in_flow_control_structures
//       return new ListTile(
//         title: new Text(root.title),
//         onTap: () => _handleURLButtonPress(context, root.links, root.title),
//       );
//     return new ExpansionTile(
//       key: new PageStorageKey<String>(
//           root.title), // root.title == newerRoot.title is true
//       title: new Text(root.title),
//       subtitle: new Text(root.subheading!),
//       children:
//           root.children.map((link) => _buildTiles(context, link)).toList(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _buildTiles(context, entry);
//   }
// }

// void _handleURLButtonPress(BuildContext context, String url, String title) {
//   if (url != null)
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => WebViewContainer(url, 'AI Recommomdation')));
// }
