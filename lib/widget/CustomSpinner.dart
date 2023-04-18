import 'package:flutter/material.dart';

import '../responsive/percentage_mediaquery.dart';

class CustomSpinner {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key, String message) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black26,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: Responsive.width(20, context),
                      right: Responsive.width(20, context)),
                  child: Dialog(
                    key: key,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5.0)), //this right here
                    child: Container(
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(children: [
                              CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.black),
                                strokeWidth: 2.0,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                message,
                                style: TextStyle(color: Colors.black),
                              )
                            ]),
                          )
                        ],
                      ),
                    ),
                  )));
        });
  }
}
