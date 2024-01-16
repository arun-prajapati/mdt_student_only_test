import 'package:flutter/material.dart';

import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../views/Login/register.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Container(
        height: Responsive.height(100, context),
        //color: Colors.transparent,
        child: Stack(alignment: Alignment.topCenter, children: <Widget>[
          CustomPaint(
            size: Size(width, height),
            painter: RegisterHeaderPainter(),
          ),
          Positioned(
            top: SizeConfig.blockSizeVertical * 20,
            left: SizeConfig.blockSizeHorizontal * 28,
            child: CircleAvatar(
              radius: SizeConfig.blockSizeHorizontal * 22,
              backgroundColor: Colors.white,
              child: Container(
                child: Image.asset(
                  "assets/stt_s_logo.png",
                  height: SizeConfig.blockSizeVertical * 45,
                  width: SizeConfig.blockSizeHorizontal * 45,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ]));
    //   Stack(
    //   children: <Widget>[
    //     Container(
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.only(
    //           bottomLeft: Radius.circular(constraints.maxHeight * 0.05),
    //           bottomRight:
    //               Radius.circular(constraints.maxHeight * 0.05),
    //         ),
    //         image: DecorationImage(
    //           image: const AssetImage('assets/loginform-bg.jpg'),
    //           fit: BoxFit.fill,
    //         ),
    //       ),
    //     ),
    //     Container(
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.only(
    //           bottomLeft: Radius.circular(constraints.maxHeight * 0.05),
    //           bottomRight:
    //               Radius.circular(constraints.maxHeight * 0.05),
    //         ),
    //         gradient: LinearGradient(
    //             colors: [
    //               const Color.fromRGBO(14, 155, 207, 0.75),
    //               const Color.fromRGBO(120, 230, 200, 0.75),
    //             ],
    //             begin: Alignment.topCenter,
    //             end: Alignment.bottomRight,
    //             stops: [0.65, 1]),
    //       ),
    //     ),
    //     Container(
    //         width: Responsive.width(85, context),
    //         //height: Responsive.width(25, context),
    //         margin: EdgeInsets.fromLTRB(
    //             Responsive.width(7.5, context),
    //             Responsive.height(15, context),
    //             Responsive.width(7.5, context),
    //             0.0),
    //         //color: Colors.black26,
    //         child: LayoutBuilder(builder: (context, constraints) {
    //           return Container();
    //           //   Stack(
    //           //   children: <Widget>[
    //           //     Container(
    //           //       //color: Colors.redAccent,
    //           //       width: constraints.maxWidth * 0.35,
    //           //       //padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
    //           //       child: FittedBox(
    //           //         fit: BoxFit.contain,
    //           //         child: Text(
    //           //           'Mock',
    //           //           style: TextStyle(
    //           //             fontFamily: 'Poppins',
    //           //             fontSize: 52,
    //           //             fontWeight: FontWeight.w700,
    //           //             color: Colors.white,
    //           //           ),
    //           //         ),
    //           //       ),
    //           //     ),
    //           //     Container(
    //           //       //color:Colors.redAccent,
    //           //       width: constraints.maxWidth * 0.73,
    //           //       margin: EdgeInsets.fromLTRB(
    //           //           0.0, constraints.maxWidth * 0.13, 0.0, 0.0),
    //           //       child: FittedBox(
    //           //         fit: BoxFit.contain,
    //           //         child: Text(
    //           //           'Driving Test',
    //           //           style: TextStyle(
    //           //             fontFamily: 'Poppins',
    //           //             fontSize: 52,
    //           //             fontWeight: FontWeight.w700,
    //           //             color: Colors.white,
    //           //           ),
    //           //         ),
    //           //       ),
    //           //     ),
    //           //     Container(
    //           //       height: constraints.maxWidth * 0.015,
    //           //       width: constraints.maxWidth * 0.5,
    //           //       margin: EdgeInsets.only(
    //           //           top: constraints.maxWidth * 0.32, left: 0.0),
    //           //       child: Material(
    //           //         borderRadius: BorderRadius.circular(
    //           //             constraints.maxHeight * 0.5),
    //           //         color: Color.fromRGBO(255, 255, 255, 1.0),
    //           //         child: GestureDetector(
    //           //           onTap: () {},
    //           //           child: Row(
    //           //             children: <Widget>[
    //           //               SizedBox(
    //           //                 height: 10.0,
    //           //               ),
    //           //             ],
    //           //           ),
    //           //         ),
    //           //       ),
    //           //     ),
    //           //   ],
    //           // );
    //         })),
    //   ],
    // );
  }
}
