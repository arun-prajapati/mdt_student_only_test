
import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:convert';

import '../Constants/app_colors.dart';
import '../responsive/percentage_mediaquery.dart';
import 'logs.dart';

setFocus(BuildContext context, {FocusNode? focusNode}) {
  FocusScope.of(context).requestFocus(focusNode ?? FocusNode());
}

bool isFormValid(key) {
  final form = key.currentState;
  if (form.validate()) {
    form.save();
    appLogs('$key isFormValid:true');
    return true;
  }
  appLogs('$key isFormValid:false');
  return false;
}

String base64Encode(List<int> bytes, String extensions) {
  String prefixFormat = "data:image/" + extensions + ";base64,";
  return prefixFormat + base64.encode(bytes);
}

String getImageExtension(String imagePath) {
  log(imagePath.substring(imagePath.lastIndexOf('.') + 1, imagePath.length));
  return imagePath.substring(imagePath.lastIndexOf('.') + 1, imagePath.length);
}

Future<void> alertToShowAdiNotFound(BuildContext parent_context) async {
  return showDialog<void>(
      context: parent_context,
      barrierDismissible: false,
      barrierColor: Colors.black45,
      builder: (BuildContext context) {
        return new WillPopScope(
            onWillPop: () async => false,
            child: Padding(
                padding: EdgeInsets.only(
                    left: Responsive.width(1, parent_context),
                    right: Responsive.width(1, parent_context)),
                child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(5.0)), //this right here
                  child: Container(
                    height: Responsive.height(45, parent_context),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(children: [
                            Container(
                              width: Responsive.width(90, parent_context),
                              height: Responsive.height(23, parent_context),
                              //color: Colors.black26,
                              child: Image.asset(
                                'assets/no-data.png',
                                //colorBlendMode: BlendMode.colorBurn,
                                // width: 85*SizeConfig.blockSizeHorizontal,
                                // height: 90*SizeConfig.blockSizeVertical,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Text(
                              "We have limited availability in your area. Our customer services representative should be able to help you. Please call us on +44 203 129 7741",
                              style: TextStyle(
                                  color: Color(0xFF797979),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 40,
                              width: 100,
                              alignment: Alignment.bottomCenter,
                              child: Material(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),
                                color: Dark,
                                elevation: 5.0,
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Container(
                                        width: constraints.maxWidth * 0.35,
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(
                                            'Ok',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 40,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1.0),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )
                          ]),
                        )
                      ],
                    ),
                  ),
                )));
      });
}
