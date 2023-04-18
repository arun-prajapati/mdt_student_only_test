// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import 'package:provider/provider.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// import '../../locater.dart';
// import '../../responsive/percentage_mediaquery.dart';
// import '../../services/ai_recommendationservice.dart';
// import '../../services/auth.dart';
// import '../../services/navigation_service.dart';
// import '../../widget/CustomAppBar.dart';
// import '../../widget/CustomSpinner.dart';
// import '../WebView.dart';

// class TestRecommendations extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _TestRecommendations();
// }

// class _TestRecommendations extends State<TestRecommendations> {
//   final NavigationService _navigationService = locator<NavigationService>();
//   List<Entry> changingData = List.empty();
//   int? _userId;
//   String? licenceHttpPath = null;
//   final AIRecommondationAPI _aIRecommondationService = AIRecommondationAPI();
//   final GlobalKey<State> _keyLoader = new GlobalKey<State>();

//   List<dynamic>? dataSub;
//   @override
//   void initState() {
//     // changingData = changingData.toList();
//     Future.delayed(Duration.zero, () {
//       this.initializeApi("Loading...");
//     });
//     //super.initState();
//   }

//   initializeApi(String loaderMessage) {
//     checkInternet();
//     showLoader(loaderMessage);
//     getUserDetail().then((user_id) {
//       callApiGetRecommendatedTest().then((datasub) {
//         closeLoader();
//         this.changingData = generateData(dataSub);
//         //closeLoader();
//       });
//     });
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

//   Future<void> callApiGetRecommendatedTest() async {
//     // getUserDetail();
//     if (_userId != null)
//       dataSub = await _aIRecommondationService.getrecommondedtest(_userId!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//           width: Responsive.width(100, context),
//           height: Responsive.height(100, context),
//           child: LayoutBuilder(builder: (context, constraints) {
//             return Container(
//               height: constraints.maxHeight,
//               child: Column(
//                 children: <Widget>[
//                   CustomAppBar(
//                       preferedHeight: Responsive.height(15, context),
//                       title: 'Test Recommendations',
//                       textWidth: Responsive.width(45, context),
//                       iconLeft: FontAwesomeIcons.arrowLeft,
//                       onTap1: () {
//                         _navigationService.goBack();
//                       },
//                       iconRight: null),
//                   Expanded(
//                     child: ListView.builder(
//                       //shrinkWrap: true,
//                       itemBuilder: (BuildContext context, int index) =>
//                           new EntryItem(changingData[index]),
//                       itemCount: changingData.length,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           })),
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
// }

// class Entry {
//   Entry(this.title, this.links,
//       [this.subheading, this.children = const <Entry>[]]);
//   final String title;
//   final String links;
//   final String? subheading;
//   final List<Entry> children;
// }

// class Recommomndation {
//   Recommomndation(this.Recommomndation_Name, this.Links);
//   final String Recommomndation_Name;
//   List<Recommomndation_Link> Links = List.empty();
// }

// class Recommomndation_Link {
//   Recommomndation_Link(this.linkname, this.links);
//   final String linkname;
//   List<String> links = List.empty();
// }

// List<Entry> generateData([List<dynamic>? dataSub]) {
//   List<Entry> chdata = List.empty();
//   chdata = chdata.toList();
//   List<Entry> redata = List.empty();
//   redata = redata.toList();
//   List<Entry> lnkdata = List.empty();
//   lnkdata = lnkdata.toList();
//   String adifname = " ";
//   String adilname = " ";
//   String requested_date = " ";
//   String requested_time = " ";
//   late String lesson_Name;
//   late List<dynamic> lesson_link = List.empty();
//   lesson_link = lesson_link.toList();

//   late Entry entry_title;
//   late Entry entry_lesson;
//   late Entry en_lnk;

//   try {
//     if (dataSub != null) {
//       for (dynamic data in dataSub) {
//         // for (var data in datas as ma) {
//         if (data != null && data.length > 0) {
//           data.forEach((k, ve) {
//             if (data["adi_data"] != null && k == "adi_data") {
//               adifname = ve["first_name"]!;
//               adilname = ve["last_name"];
//             } else if (data["booking_data"] != null && k == "booking_data") {
//               requested_date = ve["requested_date"];
//               requested_time = ve["requested_time"];
//             } else if (data["recommendation"] != null &&
//                 k == "recommendation") {
//               //for (int index = 0; index < ve.length; index++) {
//               ve.forEach((ke, va) {
//                 va.forEach((ke1, va1) {
//                   print("data  :" +
//                       ke +
//                       "  Links:   " +
//                       ke1 +
//                       "  value : " +
//                       va1.toString());
//                   lesson_link = va1;
//                   lesson_Name = ke;
//                   int leng = va1.length;
//                   print(lesson_link.toString());
//                   for (dynamic link in lesson_link) {
//                     if (ke1 == "yt_links") {
//                       en_lnk = new Entry(ke1, link as String, '');
//                     } else if (ke1 == "reading_links") {
//                       en_lnk = new Entry('Read Article', link as String, '');
//                     }
//                     lnkdata.add(en_lnk);
//                   }
//                   entry_lesson = new Entry(lesson_Name, '', '', lnkdata);
//                 });
//                 redata.add(entry_lesson);
//                 lnkdata = List.empty();
//                 lnkdata = lnkdata.toList();
//               });
//               //}

//               entry_title = new Entry(
//                   "ADI Name : " +
//                       adifname +
//                       " " +
//                       adilname +
//                       "\n" +
//                       "Date Time : " +
//                       requested_date +
//                       " " +
//                       requested_time,
//                   '',
//                   '',
//                   redata);
//               chdata.add(entry_title);
//             }
//             redata = List.empty();
//             redata = redata.toList();
//           });
//         }
//       }

//       return chdata;
//     } else {
//       Entry e = new Entry(' No Data', '');
//       chdata.add(e);
//     }
//     return chdata;
//   } on Exception catch (exception) {
//     print(exception);
//     return chdata;
//   }
// }

// // Displays one Entry. If the entry has children then it's displayed
// // with an ExpansionTile.
// class EntryItem extends StatelessWidget {
//   const EntryItem(this.entry);
//   final Entry entry;

//   Widget _buildTiles(BuildContext context, Entry root) {
//     if (root.title == "yt_links")
//       return new ListTile(
//           title: Text("Watch Video"),
//           subtitle: YoutubePlayer(
//             controller: YoutubePlayerController(
//               initialVideoId:
//                   YoutubePlayer.convertUrlToId(root.links)!, //Add videoID.
//               flags: YoutubePlayerFlags(
//                 hideControls: false,
//                 controlsVisibleAtStart: true,
//                 autoPlay: false,
//                 mute: false,
//               ),
//             ),
//             // width: 250,
//             showVideoProgressIndicator: true,
//             progressIndicatorColor: Colors.green,
//           ));
//     if (root.children.isEmpty && root.title != "yt_links") if (root
//         .children.isEmpty)
//       return new ListTile(
//         title: new Text(root.title),
//         onTap: () => _handleURLButtonPress(context, root.links),
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

// void _handleURLButtonPress(BuildContext context, String url) {
//   Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => WebViewContainer(url, 'AI Recommondations')));
// }
