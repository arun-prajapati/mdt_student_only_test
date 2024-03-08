import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Smart_Theory_Test/Constants/app_colors.dart';
import 'package:Smart_Theory_Test/locater.dart';

import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/navigation_service.dart';
import '../../widget/CustomAppBar.dart';

class AdiFaq extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        body: Container(
          width: Responsive.width(100, context),
          height: Responsive.height(100, context),
          child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              height: constraints.maxHeight,
              child: Column(
                children: <Widget>[
                  CustomAppBar(
                      preferedHeight: Responsive.height(10, context),
                      iconLeft: FontAwesomeIcons.arrowLeft,
                      title: 'FAQ',
                      textWidth: Responsive.width(12, context),
                      onTap1: () {
                        _navigationService.goBack();
                      },
                      iconRight: null),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return new StuffInTiles(listOfTiles[index]);
                      },
                      itemCount: listOfTiles.length,
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class StuffInTiles extends StatelessWidget {
  final MyTile myTile;
  StuffInTiles(this.myTile);

  @override
  Widget build(BuildContext context) {
    return _buildTiles(myTile);
  }

  Widget _buildTiles(MyTile t) {
    return new ExpansionTile(
      key: new PageStorageKey<int>(3),
      initiallyExpanded: true,
      expandedAlignment: Alignment.centerLeft,
      tilePadding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
      childrenPadding: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 0),
      title: new Text(
        t.title,
        style: TextStyle(
            color: Dark,
            fontSize: 2 * SizeConfig.blockSizeVertical,
            fontWeight: FontWeight.w500),
      ),
      children: [
        new Text(
          t.description,
          style: TextStyle(
            color: Colors.black,
            fontSize: 1.5 * SizeConfig.blockSizeVertical,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class MyTile {
  final String title;
  final String description;
  MyTile({required this.title, required this.description});
}

List<MyTile> listOfTiles = <MyTile>[
  new MyTile(
      title: 'Who are we?',
      description:
          'MockDrivingTest.com is a portal that brings ADIs closer to the clients. It gives opportunities to ADIs by providing driving lessons following the DVSA curriculum. It creates further opportunities for taking practical mock tests and pass-assist lessons (specialised lessons focusing on a single skill).'),
  new MyTile(
      title:
          'I can take a mock driving test for my own students, why should I refer you?',
      description:
          "Research shows that Mock Driving test taken by an unknown examiner increases the chances of passing the final driving test by 70%.\n Eg- Mike is very comfortable with his ADI Christy. Our research shows that when Christy hosts Mike's mock test, Mike's performance will be better than what it will be in examination. This is because of the comfort level between Mike and Christy. However, if we request an unknown examiner, let's say Trisha, to take this test, Mike's performance will be closer to what he will do in the final test."),
  new MyTile(
      title: 'I am afraid of losing my business if I refer my students to you?',
      description:
          'We are responsible for protecting the interest and business of ADIs so we make sure before accepting every test, ADI confirms that they will not try to sell their driving lessons to the learner.'),
  new MyTile(
      title: 'Do I need to go to the Test Centre to take the test?',
      description:
          'You can decide to take the test in a DVSA test route from your area that you are comfortable using. However, the route should cover the test centre.'),
  new MyTile(
      title: "Do I take the test in my car or student's car?",
      description:
          'We will ask for your preference at the time of registration.'),
  new MyTile(
      title: 'Who will pay me? Is it the client or MockDrivingTest.com?',
      description:
          'MockDrivingTest.com pays you as soon as you upload the test/ lesson report in the portal. You are advised not to discuss this with students.'),
  new MyTile(
      title: 'How does the payout structure work for the test?',
      description:
          'As soon as the test is completed, you are advised to submit the report to MockDrivingTest.com, post that we will transfer you the payment.'),
  new MyTile(
      title:
          'How does the payout structure work for driving lessons/pass assist classes?',
      description:
          'We will agree with the student for the number of lessons required and will be paying you after every lesson.'),
  new MyTile(
      title: 'What if I find that the student is not fit for the test?',
      description:
          'MockDrivingTest.com team always checks if the student is mentally prepared before every test. However, if you find that the student is mentally/physically not fit for the test OR makes more than 3 serious mistakes in first 10 minutes, you need to report to us immediately and halt the test. We will cancel the test and pay you the fee. '),
  new MyTile(
      title: 'What if I have to cancel the test?',
      description:
          'We request all the ADIs to update us at least 72 hours before the test/ lesson if you are unable to take the test. This enables us to approach another ADI to conduct the test. More than three cancellations within 6 months will lead to a reduction in sending business to you.'),
];
