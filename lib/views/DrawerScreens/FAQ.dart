import 'package:flutter/material.dart';
import 'package:student_app/Constants/app_colors.dart';
import 'package:student_app/locater.dart';

import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../services/navigation_service.dart';
import '../../widget/CustomAppBar.dart';

class TileApp extends StatelessWidget {
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
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: CustomAppBar(
                        preferedHeight: Responsive.height(10, context),
                        iconLeft: Icons.arrow_back,
                        title: 'FAQ',
                        textWidth: Responsive.width(12, context),
                        onTap1: () {
                          _navigationService.goBack();
                        },
                        iconRight: null),
                  ),
                  Positioned(
                    top: 100,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.88,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: Colors.white),
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 5),
                        itemBuilder: (BuildContext context, int index) {
                          return new StuffInTiles(listOfTiles[index]);
                        },
                        itemCount: listOfTiles.length,
                      ),
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
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: new ExpansionTile(
        key: new PageStorageKey<int>(3),
        initiallyExpanded: true,
        expandedAlignment: Alignment.centerLeft,
        tilePadding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
        childrenPadding:
            EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 0),
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
      ),
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
      title: 'Why should I take a Mock Driving Test?',
      description:
          'When you take your driving test, you did like to make sure that you are 100% ready. A mock driving test is a great way to find this out one way or another. A mock driving test allows you and your instructor to identify any areas of your driving that need improvement before taking the DVSA practical driving test'),
  new MyTile(
      title:
          'I am learning driving from a family member (or a friend). How will mock test help me?',
      description:
          'A practical mock test is absolutely essential for you if you are taught by your family members or friends as they may not have full exposure to the latest DVSA curriculum. A mock-test conducted on the same pattern as DVSA test will help you not only assess your skills but also identify the gaps and arrange focussed driving lessons. '),
  new MyTile(
      title:
          'My driving instructor takes mock-tests. Do I still need mock practical test from arranged by you?',
      description:
          'Under the current curriculum, the ADIs do take mock-tests, but invariably many students who pass in their ADIs mock-test do not pass the practical test first time. This is because of their familiarity with the ADIs which drives better results. A mock-test with an unknown ADI will provide a true assessment of skills acquired during sessions held with your driving instructor.'),
  new MyTile(
      title:
          'How can MockDrivingTest.com help me if I have failed driving test in the past?',
      description:
          'We can help you by creating a customised instruction structure that will increase chances of passing driving test in your next attempt if you have already been unsuccessful in the past. This can include a mock practical test, a refresher course and focussed lessons.'),
  new MyTile(
      title:
          'Is it compulsory to have a Learners license before taking a mock test?',
      description:
          'Yes. DVSA requires you to have a provisional drivers license before taking driving lessons.'),
  new MyTile(
      title:
          'Is it compulsory to have a medical certificate for obtaining a learner\'s license?',
      description:
          'Yes, a medical certificate would be required to be produced, in case of commercial vehicle licenses.'),
  new MyTile(
      title: 'What is the refund policy if I don\'t take the test/ Classes?',
      description:
          'You need to inform us minimum 48 hours in advance if you want to cancel the test with valid reason, post that no money will be refunded.'),
  new MyTile(
      title: 'Can I choose my ADI for driving lesson?',
      description:
          'We will be giving you ADI options as per your postcode with ADI ratings, you can choose accordingly'),
  new MyTile(
      title: 'What happens after completing the Mock driving test?',
      description:
          'After completing the mock driving test the driving test examiner will prepare a detailed report and upload it on the MockDrivingTest.Com website. This report will be made available to you within 24 hours of completing the test.'),
  new MyTile(
      title: 'What is a pass-assist lesson?',
      description:
          'After your practical mock driving test, if the examiner finds that you are week in a particular area, they may advise you to take pass-assist lessons. These lessons provide targeted learning for a specific skill for an hour. For example, the test unveils that you need to improve at parking, you will be eligible to book x number of hours focuses mainly on parking.'),
  new MyTile(
      title: 'What is the typical structure of a mock driving test?',
      description:
          'The typical structure of a mock driving test is available in drawer->Test Structure.'),
  new MyTile(
      title: 'When should I take driving lessons?',
      description:
          'If you have passed the theory test and have a provisional driving license, you can start taking driving lessons.'),
  new MyTile(
      title:
          'I am not from UK. Can I take lessons using my international license?',
      description:
          'You can take driving lessons if you are not from the UK using your international driving permit for up to one year from the date of entry. Although we recommend studying the Highway Code issues by the DVSA to learn about the rules of driving prior to taking lessons.'),
  new MyTile(
      title: 'If I fail a Mock Driving Test, can I still take my driving test?',
      description:
          'If you fail a Mock Driving Test, you can still take your driving test. However, if you fail a mock test it\'s an indication that you need more hours before your practical test, in that case we will recommend you putting your test date back so that you can get more time to prepare for the test.'),
  new MyTile(
      title: 'When should I take mock driving test?',
      description:
          'We recommend you to take the mock driving test at least four weeks before your DVSA final driving test, so that if you find areas for improvement, you will get enough time to improve at them.'),
  new MyTile(
      title: 'How many times can I take the mock driving test?',
      description:
          'You can take the test as many times as you want as it will boost your confidence and enhance your skills.'),
  new MyTile(
      title: 'How to avoid the silly mistakes?',
      description:
          'Pressure or nerves can cause learners to make silly mistakes which could result in them failing a mock test. That\'s why we recommend to take the mock driving test at least 4 weeks before the final driving test. However, it is much better to fail a mock test than to fail the real thing!'),
  new MyTile(
      title: 'When should I take a mock test?',
      description:
          'Whenever you feel you are ready for final test. OR When you have taken >25 hours of driving instructions.'),
];
