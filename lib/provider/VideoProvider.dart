import 'package:flutter/foundation.dart';

class VideoIndexProvider with ChangeNotifier {
  int _indexOfVideo = 0;
  bool testStarted = false;

  int get indexOfVideo => _indexOfVideo;

  void setIndexOfVideo(int newIndex) {
    _indexOfVideo = newIndex;
    notifyListeners();
  }

  void nextVideo(int totalVideos) {
    if (_indexOfVideo < totalVideos - 1) {
      _indexOfVideo++;
    } else {
      _indexOfVideo = 0;
    }
    notifyListeners();
  }

  void previousVideo(int totalVideos) {
    if (_indexOfVideo > 0) {
      _indexOfVideo--;
    } else {
      _indexOfVideo = totalVideos - 1;
    }
    notifyListeners();
  }

  void startTest(startTest) {
    testStarted = !startTest;
    notifyListeners();
  }

  void resetIndexOfVideo() {
    _indexOfVideo = 0;
    notifyListeners();
  }
}
