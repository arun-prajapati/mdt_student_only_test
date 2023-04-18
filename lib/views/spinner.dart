import 'package:flutter/material.dart';

import '../responsive/percentage_mediaquery.dart';

class Spinner {
  static Future<void> showSpinner(BuildContext context, String message) async {
    print("loader");
    return showDialog(
      context: context,
      barrierColor: Colors.black26,
      //barrierDismissible: false,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Padding(
            padding: EdgeInsets.only(
              left: Responsive.width(20, context),
              right: Responsive.width(20, context),
            ),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Container(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.black,
                          ),
                          strokeWidth: 2.0,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          message,
                          style: const TextStyle(color: Colors.black),
                        )
                      ]),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static close(BuildContext context) {
    Navigator.of(context).pop();
  }
}
