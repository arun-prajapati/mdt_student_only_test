import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_app/views/DashboardGridView/TheoryTab.dart';

import '../../Constants/app_colors.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import 'HomeTab.dart';
import 'PracticalTab.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  late TabController tabController;

  void updateId() {
    setState(() {
      tabController.index = 2;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      width: double.infinity,
      height: Responsive.height(100, context),
      //color: Colors.black26,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          print(constraints);
          print(Responsive.height(100, context));
          print(Responsive.height(100, context) - AppBar().preferredSize.height);
          return Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              print(constraints);
              return Column(
                children: [
                  Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.1,
                    color: Light,
                    child: TabBar(
                        controller: tabController,
                        padding: EdgeInsets.fromLTRB(0, 1, 1, 0),
                        indicatorColor: Dark,
                        labelColor: Colors.black,
                        //physics: NeverScrollableScrollPhysics(),
                        indicatorWeight: 5,
                        labelPadding: EdgeInsets.all(0.0),
                        tabs: <Tab>[
                          Tab(
                            text: 'Home',
                            icon: Icon(Icons.home),
                            // height: constraints.maxHeight * 0.1,
                          ),
                          Tab(
                            text: 'Theory',
                            icon: Icon(FontAwesomeIcons.pencilAlt),
                          ),
                          Tab(
                            text: 'Practical',
                            icon: Icon(FontAwesomeIcons.car),
                          ),
                        ]),
                  ),
                  Container(
                    color: Dark,
                    height: constraints.maxHeight * 0.9,
                    child: TabBarView(
                      controller: tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        HomeTab(onDataChanged: (String action) {
                          print("Action : $action");
                          if(action == "course"){
                            updateId();
                          }
                        },),
                        TheoryTab(),
                        PracticalTab(),
                      ],
                    ),
                  ),
                ],
              );
            }

            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }
}
