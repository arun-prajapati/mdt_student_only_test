import 'package:flutter/foundation.dart';

class VideoIndexProvider extends ChangeNotifier {
  int _indexOfVideo = 0;

  int get indexOfVideo => _indexOfVideo;

  void setIndexOfVideo(int index) {
    _indexOfVideo = index;
    notifyListeners();
  }
}
