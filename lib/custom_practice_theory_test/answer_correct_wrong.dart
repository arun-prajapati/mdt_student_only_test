import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/app_colors.dart';
import '../responsive/size_config.dart';

showCorrectAnswerDialog(BuildContext context, String explanation) {
  //print("valid");
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: SizedBox(
            width: SizeConfig.blockSizeHorizontal * 30,
            height: SizeConfig.blockSizeHorizontal * 30,
            child: Image.asset("assets/good_job.png"),
          ),
          actionsAlignment: MainAxisAlignment.center,
          contentPadding: EdgeInsets.fromLTRB(24.0, 15.0, 24.0, 5.0),
          content: Text(
            explanation,
            style: TextStyle(
              fontSize: 2 * SizeConfig.blockSizeVertical,
              color: Colors.black87,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Ok",
                style: TextStyle(color: Dark, fontSize: 18),
              ),
            ),
          ],
        );
      });
}

showWrongAnswerDialog(BuildContext context, String explanation) {
  //print("valid");
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: SizedBox(
            width: SizeConfig.blockSizeHorizontal * 30,
            height: SizeConfig.blockSizeHorizontal * 30,
            child: Image.asset("assets/ohh-no.png", fit: BoxFit.contain),
          ),
          actionsAlignment: MainAxisAlignment.center,
          contentPadding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 5.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ohh no!',
                style: GoogleFonts.caveat(
                    fontSize: 50,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 1,
              ),
              Text(
                explanation,
                style: TextStyle(
                  fontSize: 2 * SizeConfig.blockSizeVertical,
                  color: Colors.black87,
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Ok",
                style: TextStyle(color: Dark, fontSize: 18),
              ),
            ),
          ],
        );
      });
}
