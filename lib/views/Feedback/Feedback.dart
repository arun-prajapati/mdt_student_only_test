import 'package:flutter/material.dart';

class Feedback extends StatefulWidget {
  @override
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  var _myColorOne = Colors.grey;
  MaterialColor? _myColorTwo = Colors.grey;
  MaterialColor? _myColorThree = Colors.grey;
  MaterialColor? _myColorFour = Colors.grey;
  MaterialColor? _myColorFive = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          showGeneralDialog(
            barrierLabel: "Label",
            barrierDismissible: true,
            barrierColor: Colors.black.withOpacity(0.5),
            transitionDuration: Duration(milliseconds: 700),
            context: context,
            pageBuilder: (context, anim1, anim2) {
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 600,
                  margin:
                      EdgeInsets.only(bottom: 50, left: 12, right: 12, top: 50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30.0),
                            topLeft: Radius.circular(30.0),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, 1.0),
                            colors: [
                              const Color(0xff0e9bcf),
                              const Color(0xff78e6c8)
                            ],
                            stops: [0.0, 1.0],
                          ),
                        ),
                        child: Text(
                          'Feedback',
                          style: TextStyle(
                            fontFamily: 'Europa',
                            fontSize: 22,
                            color: const Color(0xfcffffff),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 20.0),
                        child: Text(
                          'Q1. How much happy you are?',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            color: const Color(0xad060606),
                            letterSpacing: 0.19799999999999998,
                            height: 1.1666666666666667,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        height: 70.0,
                        width: 500.0,
                        child: Material(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new IconButton(
                                icon: new Icon(Icons.star),
                                onPressed: () => setState(() {
                                  _myColorOne = Colors.orange;
                                  _myColorTwo = null;
                                  _myColorThree = null;
                                  _myColorFour = null;
                                  _myColorFive = null;
                                }),
                                color: _myColorOne,
                              ),
                              new IconButton(
                                icon: new Icon(Icons.star),
                                onPressed: () => setState(() {
                                  _myColorOne = Colors.orange;
                                  _myColorTwo = Colors.orange;
                                  _myColorThree = Colors.grey;
                                  _myColorFour = Colors.grey;
                                  _myColorFive = Colors.grey;
                                }),
                                color: _myColorTwo,
                              ),
                              new IconButton(
                                icon: new Icon(Icons.star),
                                onPressed: () => setState(() {
                                  _myColorOne = Colors.orange;
                                  _myColorTwo = Colors.orange;
                                  _myColorThree = Colors.orange;
                                  _myColorFour = Colors.grey;
                                  _myColorFive = Colors.grey;
                                }),
                                color: _myColorThree,
                              ),
                              new IconButton(
                                icon: new Icon(Icons.star),
                                onPressed: () => setState(() {
                                  _myColorOne = Colors.orange;
                                  _myColorTwo = Colors.orange;
                                  _myColorThree = Colors.orange;
                                  _myColorFour = Colors.orange;
                                  _myColorFive = Colors.grey;
                                }),
                                color: _myColorFour,
                              ),
                              new IconButton(
                                icon: new Icon(Icons.star),
                                onPressed: () => setState(() {
                                  _myColorOne = Colors.orange;
                                  _myColorTwo = Colors.orange;
                                  _myColorThree = Colors.orange;
                                  _myColorFour = Colors.orange;
                                  _myColorFive = Colors.orange;
                                }),
                                color: _myColorFive,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 20.0),
                        child: Text(
                          'Q1. How much Your Skill is Improved',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            color: const Color(0xad060606),
                            letterSpacing: 0.19799999999999998,
                            height: 1.1666666666666667,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            transitionBuilder: (context, anim1, anim2, child) {
              return SlideTransition(
                position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
                    .animate(anim1),
                child: child,
              );
            },
          );
        },
      ),
    );
  }
}
