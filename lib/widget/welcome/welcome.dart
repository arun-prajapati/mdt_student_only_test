import 'package:flutter/material.dart';

import '../../responsive/percentage_mediaquery.dart';

class welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var height = MediaQuery.of(context).size.height;
    //var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/background.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    const Color.fromRGBO(14, 155, 207, 0.75),
                    const Color.fromRGBO(120, 230, 200, 0.75),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  stops: [0.65, 1]),
            ),
          ),
          Container(
            width: Responsive.width(100, context),
            height: Responsive.height(30, context),
            margin: EdgeInsets.fromLTRB(
                Responsive.width(5, context),
                Responsive.height(20, context),
                Responsive.width(5, context),
                0.0),
            //color: Colors.black26,
            child: Stack(
              children: <Widget>[
                LayoutBuilder(builder: (context, constraints) {
                  return Stack(
                    children: <Widget>[
                      Container(
                        //color: Colors.redAccent,
                        width: constraints.maxWidth * 0.4,
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'Mock Driving',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 52,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        //color:Colors.redAccent,
                        width: constraints.maxWidth * 0.89,
                        margin: EdgeInsets.fromLTRB(
                            0.0, constraints.maxWidth * 0.16, 0.0, 0.0),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'Driving Test',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 52,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: constraints.maxWidth * 0.02,
                        width: Responsive.width(70, context),
                        margin: EdgeInsets.only(
                            top: constraints.maxWidth * 0.37, left: 0.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(
                              constraints.maxHeight * 0.5),
                          color: Color.fromRGBO(255, 255, 255, 1.0),
                          child: GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: constraints.maxWidth * 0.9,
                        margin: EdgeInsets.fromLTRB(
                            0.0, constraints.maxWidth * 0.45, 0.0, 0.0),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'Get confident for your driving test',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
