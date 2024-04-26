import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../../responsive/percentage_mediaquery.dart';

class ZoomView extends StatelessWidget {
  ZoomView(this.imagePath, this.fileType);

  late final GlobalKey<State> _keyZoomImage = new GlobalKey<State>();
  late final String imagePath;
  late final String fileType; //file/http
  late double scale = 1.0;
  Map<String, String>? headers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _keyZoomImage,
        backgroundColor: Colors.white.withOpacity(0.85),
        // this is the main reason of transparency at next screen. I am ignoring rest implementation but what i have achieved is you can see.
        body: Stack(alignment: Alignment.center, children: <Widget>[
          PhotoView(
              minScale: 0.2,
              imageProvider: fileType == 'http'
                  ? NetworkImage(imagePath) as ImageProvider<Object>?
                  : FileImage(File(imagePath), scale: scale = 1.0)),
          Container(
            transform: Matrix4.translationValues(
                -(Responsive.width(45, context)),
                -(Responsive.height(42, context)),
                0),
            child: IconButton(
              icon: const Icon(Icons.cancel, size: 35, color: Colors.red),
              onPressed: () {
                try {
                  Navigator.of(_keyZoomImage.currentContext!,
                          rootNavigator: true)
                      .pop();
                } catch (e) {}
              },
            ),
          ),
        ]));
  }
}
