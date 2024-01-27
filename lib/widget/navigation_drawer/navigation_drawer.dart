import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/auth.dart';
import '../../services/navigation_service.dart';
import '../navbar_item/navbar_item.dart';
import 'navigatin_drawer_header.dart';
import 'navigation_drawer_footer.dart';

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({Key? key}) : super(key: key);
  final NavigationService _navigationService = locator<NavigationService>();

  late Future<int?> _userType;
  late String _aboutUsUrl;
  late String _pricingUrl;

  Future<int?> getUserType() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    int? userType = storage.getInt('userType');
    return userType;
  }

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
    _userType = getUserType();
    SizeConfig().init(context);
    return FutureBuilder(
      future: _userType,
      builder: (context, snapshot) {
        Object? type = snapshot.data;
        return Container(
          width: Responsive.width(80, context),
          height: Responsive.height(100, context),
          decoration: BoxDecoration(
            color: Colors.red,
            // boxShadow: [
            //   BoxShadow(color: Colors.black12, blurRadius: 16),
            // ],
            gradient: LinearGradient(
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              colors: [
                Color(0xFF79e6c9),
                // Color(0xFF79e6c9),
                // Color(0xFF79e6c9),
                // Color(0xFF38b8cd),
                Color(0xFF38b8cd),
              ],
              stops: [0.0, 1.0],
            ),
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth * 0.88,
              height: constraints.maxHeight,
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      NavigationDrawerHeader(),
                      // BONUS: Combine the UI for this widget with the NavBarItem and make it responsive.
                      // The UI for the current DrawerItem shows when it's in mobile, else it shows the NavBarItem ui.
                      Expanded(
                          // ignore: unnecessary_new
                          child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              color: Colors.white),
                          child: new ListView(
                            padding: EdgeInsets.only(
                                bottom: constraints.maxWidth * .35),
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: [
                              SizedBox(height: constraints.maxHeight * 0.025),
                              NavBarItem('Home', '/home', context,
                                  icon: Icons.space_dashboard_outlined),
                              SizedBox(height: constraints.maxHeight * 0.025),
                              NavBarItem('Profile', '/driver_profile', context,
                                  icon: FontAwesomeIcons.userCircle),
                              SizedBox(height: constraints.maxHeight * 0.025),

                              ///commented by Khushali
                              /* GestureDetector(
                                onTap: () {
                                  _pricingUrl = "$api/pricing";
                                  print(_pricingUrl);
                                  _launchURL(_pricingUrl);
                                },
                                child: Container(
                                  //color: Colors.red,
                                  margin: EdgeInsets.fromLTRB(
                                      constraints.maxWidth * 0.05,
                                      0,
                                      constraints.maxWidth * 0.05,
                                      0),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: constraints.maxWidth * 0.09,
                                        child: LayoutBuilder(
                                            builder: (context, constraints) {
                                          return FittedBox(
                                              fit: BoxFit.contain,
                                              child: Icon(
                                                  FontAwesomeIcons.dollarSign));
                                        }),
                                      ),
                                      SizedBox(
                                        width: constraints.maxWidth * 0.1,
                                      ),
                                      Container(
                                        //width:textWidth,
                                        child: LayoutBuilder(
                                            builder: (context, constraints) {
                                          return FittedBox(
                                            fit: BoxFit.contain,
                                            child: Text(
                                              'Pricing',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          );
                                        }),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: constraints.maxHeight * 0.025,
                              ),*/
                              // NavBarItem(
                              //     'Mock Test Structure', '/testStructure', context,
                              //     icon: FontAwesomeIcons.list),
                              //SizedBox(height: constraints.maxHeight * 0.025),
                              // GestureDetector(
                              //   onTap: () {
                              //     _aboutUsUrl = "$api/static/about-us";
                              //     print(_aboutUsUrl);
                              //     _launchURL(_aboutUsUrl);
                              //   },
                              //   child: Container(
                              //     //color: Colors.red,
                              //     margin: EdgeInsets.fromLTRB(
                              //         constraints.maxWidth * 0.05, 0,
                              //         constraints.maxWidth * 0.05, 0),
                              //     child: Row(
                              //       children: <Widget>[
                              //         Container(
                              //           width: constraints.maxWidth *
                              //               0.09,
                              //           child: LayoutBuilder(
                              //               builder: (context,
                              //                   constraints) {
                              //                 return FittedBox(
                              //                     fit: BoxFit.contain,
                              //                     child: Icon(
                              //                         FontAwesomeIcons
                              //                             .user));
                              //               }),
                              //         ),
                              //         SizedBox(
                              //           width: constraints.maxWidth *
                              //               0.1,
                              //         ),
                              //         Container(
                              //           //width:textWidth,
                              //           child: LayoutBuilder(
                              //               builder: (context,
                              //                   constraints) {
                              //                 return FittedBox(
                              //                   fit: BoxFit.contain,
                              //                   child: Text(
                              //                     'About us',
                              //                     style: TextStyle(
                              //                         fontSize: 18),
                              //                   ),
                              //                 );
                              //               }
                              //           ),
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: constraints.maxHeight * 0.02,
                              // ),

                              Divider(
                                  height: constraints.maxHeight * 0.02,
                                  endIndent: constraints.maxWidth * 0.035,
                                  indent: constraints.maxWidth * 0.035,
                                  color: Colors.grey[350],
                                  thickness: 2.0),
                              SizedBox(height: constraints.maxHeight * 0.015),
                              NavBarItem('Settings', '/setting', context,
                                  icon: Icons.settings),
                              SizedBox(height: constraints.maxHeight * 0.025),
                              NavBarItem('Help', '/help', context,
                                  icon: Icons.help),

                              SizedBox(height: constraints.maxHeight * 0.025),
                              NavBarItem('Contact Us', '/contact', context,
                                  icon: Icons.phone),
                              SizedBox(height: constraints.maxHeight * 0.025),
                              GestureDetector(
                                onTap: () {
                                  // Navigator.pop(context);
                                  LogOut(context);
                                },
                                child: Container(
                                  //color: Colors.red,
                                  margin: EdgeInsets.fromLTRB(
                                      constraints.maxWidth * 0.05,
                                      0,
                                      constraints.maxWidth * 0.05,
                                      0),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: constraints.maxWidth * 0.08,
                                        child: LayoutBuilder(
                                            builder: (context, constraints) {
                                          return FittedBox(
                                              fit: BoxFit.contain,
                                              child: Icon(Icons.logout));
                                        }),
                                      ),
                                      SizedBox(
                                        width: constraints.maxWidth * 0.05,
                                      ),
                                      Container(
                                        //width:textWidth,
                                        child: LayoutBuilder(
                                            builder: (context, constraints) {
                                          return FittedBox(
                                            fit: BoxFit.contain,
                                            child: Text(
                                              'Sign Out',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          );
                                        }),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                    ],
                  ),
                  Positioned(
                      bottom: 0, right: 0, left: 0, child: NavigationFotter())
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Widget? LogOut(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SignOut',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 2.5 * SizeConfig.blockSizeVertical),
                  ),
                  Text(
                    'Are you sure! You want to SignOut?',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 0.58,
                        fontSize: 14),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(
                          "No",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 2.3 * SizeConfig.blockSizeVertical,
                              fontWeight: FontWeight.w500),
                        ),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                      TextButton(
                        child: Text(
                          "Yes",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 2.3 * SizeConfig.blockSizeVertical,
                              fontWeight: FontWeight.w500),
                        ),
                        onPressed: () {
                          Provider.of<AuthProvider>(context, listen: false)
                              .logOut();
                          Navigator.pop(context);
                          _navigationService
                              .navigateToReplacement('/Authorization');
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
    return null;
  }
}
