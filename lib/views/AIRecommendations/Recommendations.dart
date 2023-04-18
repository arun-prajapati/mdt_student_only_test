import 'package:flutter/material.dart';
import 'package:student_app/views/AIRecommendations/LessonRecommendation.dart';
import 'package:student_app/views/AIRecommendations/TestRecommendation.dart';

import '../../Constants/app_colors.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';

class Recommendations extends StatelessWidget {
  const Recommendations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'AI Recommendations',
          style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 6,
              fontWeight: FontWeight.w500,
              color: Colors.black
          ),
        ),
        elevation: 0.0,
        flexibleSpace: Container(
          decoration:  BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.0, -1.0),
              end: Alignment(0.0, 1.0),
              colors: [Dark, Light],
              stops: [0.0, 1.0],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: Responsive.height(100, context),
          //color: Colors.red,
          child: DefaultTabController(
            length: 2,
            child: Container(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight * 0.06,
                          color: Light,
                          child: TabBar(
                              padding: EdgeInsets.fromLTRB(0, 1, 1, 0),
                              indicatorColor: Dark,
                              labelColor: Colors.black,
                              physics: NeverScrollableScrollPhysics(),
                              indicatorWeight: 5,
                              labelPadding: EdgeInsets.all(0.0),
                              tabs: <Tab>[
                                Tab(
                                  text: 'Test',
                                  //icon: Icon(Icons.home),
                                  // height: constraints.maxHeight * 0.1,
                                ),
                                Tab(
                                  text: 'Lesson',
                                  //icon: Icon(FontAwesomeIcons.pencilAlt),
                                ),
                              ]),
                        ),
                        Container(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight * 0.94,
                          //color: Colors.red,
                          child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              TestRecommendation(),
                              LessonRecommendation()
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              )
            ),

          ),
        ),
    );
  }
}
